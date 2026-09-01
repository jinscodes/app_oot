import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';

import { AppModule } from './app.module';
import { configureApp } from './bootstrap/configure-app';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  configureApp(app);

  const configService = app.get(ConfigService);
  const port = configService.getOrThrow<number>('PORT');

  await app.listen(port);

  const logger = new Logger('Bootstrap');
  logger.log(`OOT API listening at ${await app.getUrl()}/api/v1`);
  logger.log(`API documentation available at ${await app.getUrl()}/docs`);
}

void bootstrap();
