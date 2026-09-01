import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule, JwtModuleOptions } from '@nestjs/jwt';
import { MongooseModule } from '@nestjs/mongoose';

import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { ConsoleOtpDeliveryService } from './delivery/console-otp-delivery.service';
import { OTP_DELIVERY_SERVICE } from './delivery/otp-delivery.interface';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import {
  OtpChallenge,
  OtpChallengeSchema,
} from './schemas/otp-challenge.schema';
import {
  RefreshSession,
  RefreshSessionSchema,
} from './schemas/refresh-session.schema';
import { User, UserSchema } from './schemas/user.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: OtpChallenge.name, schema: OtpChallengeSchema },
      { name: RefreshSession.name, schema: RefreshSessionSchema },
    ]),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService): JwtModuleOptions => ({
        secret: configService.getOrThrow<string>('JWT_ACCESS_SECRET'),
        signOptions: {
          audience: 'oot-mobile',
          expiresIn: configService.getOrThrow<number>('JWT_ACCESS_TTL_SECONDS'),
          issuer: 'oot-api',
        },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtAuthGuard,
    ConsoleOtpDeliveryService,
    {
      provide: OTP_DELIVERY_SERVICE,
      useExisting: ConsoleOtpDeliveryService,
    },
  ],
  // ProfileModule reuses the configured guard. Export both the guard and the
  // configured JwtModule so Nest can resolve JwtService in that module scope.
  exports: [JwtAuthGuard, JwtModule],
})
export class AuthModule {}
