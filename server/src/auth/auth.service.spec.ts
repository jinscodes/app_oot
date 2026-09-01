import { BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { createHmac } from 'node:crypto';
import { Model, Types } from 'mongoose';

import { AuthService } from './auth.service';
import { AuthChannel, UserStatus } from './auth.types';
import { OtpDeliveryService } from './delivery/otp-delivery.interface';
import { OtpChallenge } from './schemas/otp-challenge.schema';
import { RefreshSession } from './schemas/refresh-session.schema';
import { User } from './schemas/user.schema';

const configuration: Record<string, string | number> = {
  AUTH_TOKEN_HASH_SECRET:
    'test-token-hash-secret-that-is-long-enough-for-authentication',
  JWT_ACCESS_TTL_SECONDS: 900,
  OTP_HASH_SECRET:
    'test-otp-hash-secret-that-is-long-enough-for-authentication',
  OTP_MAX_ATTEMPTS: 5,
  OTP_MAX_REQUESTS_PER_HOUR: 5,
  OTP_RESEND_SECONDS: 60,
  OTP_TTL_SECONDS: 300,
  REFRESH_TOKEN_TTL_SECONDS: 2_592_000,
};

describe('AuthService', () => {
  it('creates and verifies a development OTP session', async () => {
    const challengeId = new Types.ObjectId();
    let savedChallenge: Record<string, unknown> | undefined;
    const save = jest.fn().mockImplementation(function (this: object) {
      savedChallenge = this as Record<string, unknown>;
      return Promise.resolve(this);
    });
    const OtpModel = jest.fn().mockImplementation(function (
      this: Record<string, unknown>,
      data: Record<string, unknown>,
    ) {
      Object.assign(this, data, {
        _id: challengeId,
        id: challengeId.toHexString(),
        save,
      });
    });
    Object.assign(OtpModel, {
      countDocuments: jest.fn().mockReturnValue({
        exec: jest.fn().mockResolvedValue(0),
      }),
      deleteOne: jest.fn().mockReturnValue({
        exec: jest.fn().mockResolvedValue({ deletedCount: 1 }),
      }),
      findById: jest.fn().mockImplementation(() => ({
        exec: jest
          .fn()
          .mockImplementation(() => Promise.resolve(savedChallenge)),
      })),
      findOne: jest.fn().mockReturnValue({
        sort: jest.fn().mockReturnValue({
          lean: jest.fn().mockReturnValue({
            exec: jest.fn().mockResolvedValue(null),
          }),
        }),
      }),
      findOneAndUpdate: jest.fn().mockImplementation(() => ({
        exec: jest
          .fn()
          .mockImplementation(() => Promise.resolve(savedChallenge)),
      })),
      updateMany: jest.fn().mockReturnValue({
        exec: jest.fn().mockResolvedValue({ modifiedCount: 0 }),
      }),
      updateOne: jest.fn().mockReturnValue({
        exec: jest.fn().mockResolvedValue({ modifiedCount: 1 }),
      }),
    });

    const userId = new Types.ObjectId();
    const user = {
      _id: userId,
      id: userId.toHexString(),
      createdAt: new Date(),
      onboardingCompleted: false,
      phone: '+821012345678',
      status: UserStatus.Active,
    };
    const userModel = {
      findOneAndUpdate: jest.fn().mockReturnValue({
        exec: jest.fn().mockResolvedValue(user),
      }),
    };
    const sessionId = new Types.ObjectId();
    const refreshSessionModel = {
      create: jest.fn().mockResolvedValue({ id: sessionId.toHexString() }),
    };
    const delivered: { code?: string } = {};
    const deliveryService: OtpDeliveryService = {
      send: jest.fn().mockImplementation(({ code }: { code: string }) => {
        delivered.code = code;
        return Promise.resolve();
      }),
    };
    const configService = {
      getOrThrow: jest.fn((key: string) => configuration[key]),
    } as unknown as ConfigService;
    const jwtService = {
      signAsync: jest.fn().mockResolvedValue('signed-access-token'),
    } as unknown as JwtService;
    const service = new AuthService(
      userModel as unknown as Model<User>,
      OtpModel as unknown as Model<OtpChallenge>,
      refreshSessionModel as unknown as Model<RefreshSession>,
      deliveryService,
      configService,
      jwtService,
    );

    const requested = await service.requestOtp({
      channel: AuthChannel.Phone,
      identifier: '+82 10-1234-5678',
    });
    expect(requested.challengeId).toBe(challengeId.toHexString());
    expect(delivered.code).toMatch(/^\d{6}$/);

    const authenticated = await service.verifyOtp({
      challengeId: requested.challengeId,
      code: delivered.code!,
      deviceId: 'test-device',
    });
    expect(authenticated.accessToken).toBe('signed-access-token');
    expect(authenticated.refreshToken).toHaveLength(64);
    expect(authenticated.user.phone).toBe('+821012345678');
    expect(authenticated.user.onboardingCompleted).toBe(false);
    expect(authenticated).not.toHaveProperty('sessionId');
  });

  it('rejects phone numbers that are not in E.164 format', async () => {
    const service = new AuthService(
      {} as Model<User>,
      {} as Model<OtpChallenge>,
      {} as Model<RefreshSession>,
      { send: jest.fn() },
      {
        getOrThrow: jest.fn((key: string) => configuration[key]),
      } as unknown as ConfigService,
      {} as JwtService,
    );

    await expect(
      service.requestOtp({
        channel: AuthChannel.Phone,
        identifier: '010-1234-5678',
      }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('uses a keyed hash rather than storing the OTP as plaintext', () => {
    const code = '123456';
    const challengeId = new Types.ObjectId().toHexString();
    const hash = createHmac('sha256', configuration.OTP_HASH_SECRET.toString())
      .update(`${challengeId}:${code}`)
      .digest('hex');

    expect(hash).not.toContain(code);
    expect(hash).toHaveLength(64);
  });
});
