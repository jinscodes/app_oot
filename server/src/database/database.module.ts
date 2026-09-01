import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MongooseModule, MongooseModuleOptions } from '@nestjs/mongoose';

import { DatabaseReadinessService } from './database-readiness.service';

@Global()
@Module({
  imports: [
    MongooseModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService): MongooseModuleOptions => ({
        autoIndex:
          configService.getOrThrow<string>('NODE_ENV') !== 'production',
        connectTimeoutMS: 10_000,
        dbName: configService.getOrThrow<string>('MONGODB_DATABASE'),
        maxPoolSize: 10,
        minPoolSize: 0,
        retryAttempts: 3,
        retryDelay: 1_000,
        serverSelectionTimeoutMS: 5_000,
        uri: configService.getOrThrow<string>('MONGODB_URI'),
      }),
    }),
  ],
  providers: [DatabaseReadinessService],
  exports: [DatabaseReadinessService],
})
export class DatabaseModule {}
