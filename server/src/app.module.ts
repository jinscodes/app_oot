import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import * as Joi from 'joi';

import { AuthModule } from './auth/auth.module';
import { DatabaseModule } from './database/database.module';
import { HealthModule } from './health/health.module';
import { ProfileModule } from './profile/profile.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      cache: true,
      isGlobal: true,
      validationSchema: Joi.object({
        NODE_ENV: Joi.string()
          .valid('development', 'test', 'production')
          .default('development'),
        PORT: Joi.number().port().default(3000),
        CORS_ORIGINS: Joi.string().default(
          'http://localhost:8080,http://localhost:3000',
        ),
        MONGODB_URI: Joi.string()
          .pattern(/^mongodb(?:\+srv)?:\/\/.+/)
          .when('NODE_ENV', {
            is: 'test',
            then: Joi.string().default('mongodb://127.0.0.1:27017/oot-test'),
            otherwise: Joi.required(),
          }),
        MONGODB_DATABASE: Joi.string()
          .pattern(/^[A-Za-z0-9_-]+$/)
          .default('oot'),
        JWT_ACCESS_SECRET: Joi.string()
          .min(32)
          .when('NODE_ENV', {
            is: 'production',
            then: Joi.required(),
            otherwise: Joi.string().default(
              'development-jwt-access-secret-change-before-production',
            ),
          }),
        AUTH_TOKEN_HASH_SECRET: Joi.string()
          .min(32)
          .when('NODE_ENV', {
            is: 'production',
            then: Joi.required(),
            otherwise: Joi.string().default(
              'development-token-hash-secret-change-before-production',
            ),
          }),
        OTP_HASH_SECRET: Joi.string()
          .min(32)
          .when('NODE_ENV', {
            is: 'production',
            then: Joi.required(),
            otherwise: Joi.string().default(
              'development-otp-hash-secret-change-before-production',
            ),
          }),
        JWT_ACCESS_TTL_SECONDS: Joi.number().integer().min(60).default(900),
        REFRESH_TOKEN_TTL_SECONDS: Joi.number()
          .integer()
          .min(3_600)
          .default(2_592_000),
        OTP_TTL_SECONDS: Joi.number().integer().min(60).max(900).default(300),
        OTP_RESEND_SECONDS: Joi.number().integer().min(30).max(300).default(60),
        OTP_MAX_ATTEMPTS: Joi.number().integer().min(1).max(10).default(5),
        OTP_MAX_REQUESTS_PER_HOUR: Joi.number()
          .integer()
          .min(1)
          .max(20)
          .default(5),
      }),
      validationOptions: {
        abortEarly: false,
        allowUnknown: true,
      },
    }),
    ThrottlerModule.forRoot([
      {
        name: 'default',
        limit: 120,
        ttl: 60_000,
      },
    ]),
    DatabaseModule,
    HealthModule,
    AuthModule,
    ProfileModule,
  ],
  providers: [{ provide: APP_GUARD, useClass: ThrottlerGuard }],
})
export class AppModule {}
