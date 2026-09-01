import { INestApplication } from '@nestjs/common';
import { getConnectionToken } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import type { Server } from 'node:http';
import * as request from 'supertest';

import { AppModule } from '../src/app.module';
import { configureApp } from '../src/bootstrap/configure-app';

describe('Health endpoint', () => {
  let app: INestApplication;
  const ping = jest.fn().mockResolvedValue({ ok: 1 });

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    })
      .overrideProvider(getConnectionToken())
      .useValue({
        close: jest.fn().mockResolvedValue(undefined),
        db: { admin: () => ({ ping }) },
        model: jest.fn().mockReturnValue({}),
        models: {},
        readyState: 1,
      })
      .compile();

    app = moduleFixture.createNestApplication();
    configureApp(app);
    await app.init();
  });

  afterAll(async () => {
    if (app) await app.close();
  });

  it('GET /api/v1/health', async () => {
    await request(app.getHttpServer() as Server)
      .get('/api/v1/health')
      .expect(200)
      .expect({ status: 'ok' });
  });

  it('GET /api/v1/ready', async () => {
    await request(app.getHttpServer() as Server)
      .get('/api/v1/ready')
      .expect(200)
      .expect({ status: 'ready', database: 'connected' });
  });

  it('POST /api/v1/auth/otp/request validates the request body', async () => {
    await request(app.getHttpServer() as Server)
      .post('/api/v1/auth/otp/request')
      .send({})
      .expect(400);
  });
});
