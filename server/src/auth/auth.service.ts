import {
  BadRequestException,
  ForbiddenException,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { InjectModel } from '@nestjs/mongoose';
import { isEmail } from 'class-validator';
import {
  createHmac,
  randomBytes,
  randomInt,
  timingSafeEqual,
} from 'node:crypto';
import { Model, Types } from 'mongoose';

import {
  OTP_DELIVERY_SERVICE,
  OtpDeliveryService,
} from './delivery/otp-delivery.interface';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import {
  AuthenticationResponse,
  PublicUserResponse,
  RequestOtpResponse,
  TokenPairResponse,
} from './auth.responses';
import { AccessTokenPayload, AuthChannel, UserStatus } from './auth.types';
import {
  OtpChallenge,
  OtpChallengeDocument,
} from './schemas/otp-challenge.schema';
import { RefreshSession } from './schemas/refresh-session.schema';
import { User, UserDocument } from './schemas/user.schema';

@Injectable()
export class AuthService {
  constructor(
    @InjectModel(User.name) private readonly userModel: Model<User>,
    @InjectModel(OtpChallenge.name)
    private readonly otpChallengeModel: Model<OtpChallenge>,
    @InjectModel(RefreshSession.name)
    private readonly refreshSessionModel: Model<RefreshSession>,
    @Inject(OTP_DELIVERY_SERVICE)
    private readonly otpDeliveryService: OtpDeliveryService,
    private readonly configService: ConfigService,
    private readonly jwtService: JwtService,
  ) {}

  async requestOtp(dto: RequestOtpDto): Promise<RequestOtpResponse> {
    const identifier = this.normalizeIdentifier(dto.channel, dto.identifier);
    const identifierHash = this.hashOtpValue(identifier);
    const now = new Date();
    const resendAfterSeconds =
      this.configService.getOrThrow<number>('OTP_RESEND_SECONDS');
    const hourlyLimit = this.configService.getOrThrow<number>(
      'OTP_MAX_REQUESTS_PER_HOUR',
    );
    const oneHourAgo = new Date(now.getTime() - 60 * 60 * 1_000);

    const latestChallenge = await this.otpChallengeModel
      .findOne({ identifierHash })
      .sort({ createdAt: -1 })
      .lean()
      .exec();
    if (
      latestChallenge?.createdAt &&
      latestChallenge.createdAt.getTime() + resendAfterSeconds * 1_000 >
        now.getTime()
    ) {
      throw new HttpException(
        'Please wait before requesting another verification code.',
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    const recentRequestCount = await this.otpChallengeModel
      .countDocuments({ identifierHash, createdAt: { $gte: oneHourAgo } })
      .exec();
    if (recentRequestCount >= hourlyLimit) {
      throw new HttpException(
        'Too many verification requests. Please try again later.',
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    await this.otpChallengeModel
      .updateMany(
        { identifierHash, consumedAt: null },
        { $set: { consumedAt: now } },
      )
      .exec();

    const expiresInSeconds =
      this.configService.getOrThrow<number>('OTP_TTL_SECONDS');
    const code = randomInt(0, 1_000_000).toString().padStart(6, '0');
    const challenge = new this.otpChallengeModel({
      attempts: 0,
      channel: dto.channel,
      codeHash: 'pending',
      expiresAt: new Date(now.getTime() + expiresInSeconds * 1_000),
      identifier,
      identifierHash,
      maxAttempts: this.configService.getOrThrow<number>('OTP_MAX_ATTEMPTS'),
    });
    challenge.codeHash = this.hashOtpValue(`${challenge.id}:${code}`);
    await challenge.save();

    try {
      await this.otpDeliveryService.send({
        channel: dto.channel,
        code,
        expiresInSeconds,
        identifier,
      });
    } catch (error) {
      await this.otpChallengeModel.deleteOne({ _id: challenge._id }).exec();
      throw error;
    }

    return {
      challengeId: challenge.id,
      expiresInSeconds,
      resendAfterSeconds,
    };
  }

  async verifyOtp(dto: VerifyOtpDto): Promise<AuthenticationResponse> {
    const challenge = await this.otpChallengeModel
      .findById(dto.challengeId)
      .exec();
    const now = new Date();

    if (!this.isChallengeUsable(challenge, now)) {
      throw this.invalidOtp();
    }

    const suppliedHash = this.hashOtpValue(`${challenge.id}:${dto.code}`);
    if (!this.secureHashEquals(challenge.codeHash, suppliedHash)) {
      await this.otpChallengeModel
        .updateOne(
          { _id: challenge._id, consumedAt: null },
          { $inc: { attempts: 1 } },
        )
        .exec();
      throw this.invalidOtp();
    }

    const consumed = await this.otpChallengeModel
      .findOneAndUpdate(
        {
          _id: challenge._id,
          attempts: { $lt: challenge.maxAttempts },
          consumedAt: null,
          expiresAt: { $gt: now },
        },
        { $set: { consumedAt: now } },
        { new: true },
      )
      .exec();
    if (!consumed) throw this.invalidOtp();

    const user = await this.findOrCreateVerifiedUser(challenge, now);
    if (user.status !== UserStatus.Active) {
      throw new ForbiddenException('This account is not available.');
    }

    const tokens = await this.issueSession(user, dto.deviceId, dto.deviceName);
    return {
      ...this.withoutSessionId(tokens),
      user: this.toPublicUser(user),
    };
  }

  async refresh(dto: RefreshTokenDto): Promise<TokenPairResponse> {
    const now = new Date();
    const oldSession = await this.refreshSessionModel
      .findOneAndUpdate(
        {
          expiresAt: { $gt: now },
          revokedAt: null,
          tokenHash: this.hashRefreshToken(dto.refreshToken),
        },
        { $set: { lastUsedAt: now, revokedAt: now } },
        { new: true },
      )
      .exec();
    if (!oldSession) throw this.invalidRefreshToken();

    const user = await this.userModel.findById(oldSession.userId).exec();
    if (!user || user.status !== UserStatus.Active) {
      throw this.invalidRefreshToken();
    }

    const tokens = await this.issueSession(
      user,
      dto.deviceId ?? oldSession.deviceId,
      dto.deviceName ?? oldSession.deviceName,
    );
    await this.refreshSessionModel
      .updateOne(
        { _id: oldSession._id },
        { $set: { replacedBySessionId: new Types.ObjectId(tokens.sessionId) } },
      )
      .exec();

    return this.withoutSessionId(tokens);
  }

  async logout(refreshToken: string): Promise<void> {
    await this.refreshSessionModel
      .updateOne(
        {
          revokedAt: null,
          tokenHash: this.hashRefreshToken(refreshToken),
        },
        { $set: { revokedAt: new Date() } },
      )
      .exec();
  }

  async getCurrentUser(userId: string): Promise<PublicUserResponse> {
    const user = await this.userModel.findById(userId).exec();
    if (!user || user.status !== UserStatus.Active) {
      throw new UnauthorizedException('The user is not available.');
    }
    return this.toPublicUser(user);
  }

  private normalizeIdentifier(channel: AuthChannel, rawValue: string): string {
    const value = rawValue.trim();
    if (channel === AuthChannel.Email) {
      const email = value.toLowerCase();
      if (!isEmail(email)) throw new BadRequestException('Invalid email.');
      return email;
    }

    const phone = value.replace(/[\s()-]/g, '');
    if (!/^\+[1-9]\d{7,14}$/.test(phone)) {
      throw new BadRequestException(
        'Phone number must use E.164 format, for example +821012345678.',
      );
    }
    return phone;
  }

  private isChallengeUsable(
    challenge: OtpChallengeDocument | null,
    now: Date,
  ): challenge is OtpChallengeDocument {
    return Boolean(
      challenge &&
      !challenge.consumedAt &&
      challenge.expiresAt > now &&
      challenge.attempts < challenge.maxAttempts,
    );
  }

  private async findOrCreateVerifiedUser(
    challenge: OtpChallengeDocument,
    now: Date,
  ): Promise<UserDocument> {
    const isPhone = challenge.channel === AuthChannel.Phone;
    const identifierField = isPhone ? 'phone' : 'email';
    const verifiedAtField = isPhone ? 'phoneVerifiedAt' : 'emailVerifiedAt';

    const user = await this.userModel
      .findOneAndUpdate(
        { [identifierField]: challenge.identifier },
        {
          $set: { [verifiedAtField]: now, lastLoginAt: now },
          $setOnInsert: {
            [identifierField]: challenge.identifier,
            onboardingCompleted: false,
            status: UserStatus.Active,
          },
        },
        {
          new: true,
          runValidators: true,
          setDefaultsOnInsert: true,
          upsert: true,
        },
      )
      .exec();

    if (!user) {
      throw new UnauthorizedException('Unable to create the user account.');
    }
    return user;
  }

  private async issueSession(
    user: UserDocument,
    deviceId?: string,
    deviceName?: string,
  ): Promise<TokenPairResponse & { sessionId: string }> {
    const refreshToken = randomBytes(48).toString('base64url');
    const refreshTokenExpiresInSeconds = this.configService.getOrThrow<number>(
      'REFRESH_TOKEN_TTL_SECONDS',
    );
    const session = await this.refreshSessionModel.create({
      deviceId,
      deviceName,
      expiresAt: new Date(Date.now() + refreshTokenExpiresInSeconds * 1_000),
      tokenHash: this.hashRefreshToken(refreshToken),
      userId: user._id,
    });
    const accessTokenExpiresInSeconds = this.configService.getOrThrow<number>(
      'JWT_ACCESS_TTL_SECONDS',
    );
    const payload: AccessTokenPayload = {
      sid: session.id,
      sub: user.id,
      typ: 'access',
    };
    const accessToken = await this.jwtService.signAsync(payload);

    return {
      accessToken,
      accessTokenExpiresInSeconds,
      refreshToken,
      refreshTokenExpiresInSeconds,
      sessionId: session.id,
      tokenType: 'Bearer',
    };
  }

  private withoutSessionId(
    tokens: TokenPairResponse & { sessionId: string },
  ): TokenPairResponse {
    return {
      accessToken: tokens.accessToken,
      accessTokenExpiresInSeconds: tokens.accessTokenExpiresInSeconds,
      refreshToken: tokens.refreshToken,
      refreshTokenExpiresInSeconds: tokens.refreshTokenExpiresInSeconds,
      tokenType: tokens.tokenType,
    };
  }

  private toPublicUser(user: UserDocument): PublicUserResponse {
    return {
      id: user.id,
      phone: user.phone,
      email: user.email,
      status: user.status,
      onboardingCompleted: user.onboardingCompleted,
      createdAt: user.createdAt,
    };
  }

  private hashOtpValue(value: string): string {
    return this.hmac(
      this.configService.getOrThrow<string>('OTP_HASH_SECRET'),
      value,
    );
  }

  private hashRefreshToken(value: string): string {
    return this.hmac(
      this.configService.getOrThrow<string>('AUTH_TOKEN_HASH_SECRET'),
      value,
    );
  }

  private hmac(secret: string, value: string): string {
    return createHmac('sha256', secret).update(value).digest('hex');
  }

  private secureHashEquals(expected: string, supplied: string): boolean {
    const expectedBuffer = Buffer.from(expected, 'hex');
    const suppliedBuffer = Buffer.from(supplied, 'hex');
    return (
      expectedBuffer.length === suppliedBuffer.length &&
      timingSafeEqual(expectedBuffer, suppliedBuffer)
    );
  }

  private invalidOtp(): UnauthorizedException {
    return new UnauthorizedException('Invalid or expired verification code.');
  }

  private invalidRefreshToken(): UnauthorizedException {
    return new UnauthorizedException('Invalid or expired refresh token.');
  }
}
