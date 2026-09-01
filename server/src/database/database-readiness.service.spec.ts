import { ServiceUnavailableException } from '@nestjs/common';
import { Connection } from 'mongoose';

import { DatabaseReadinessService } from './database-readiness.service';

describe('DatabaseReadinessService', () => {
  it('reports ready when MongoDB responds to a ping', async () => {
    const ping = jest.fn().mockResolvedValue({ ok: 1 });
    const connection = {
      db: { admin: () => ({ ping }) },
      readyState: 1,
    } as unknown as Connection;
    const service = new DatabaseReadinessService(connection);

    await expect(service.check()).resolves.toEqual({
      status: 'ready',
      database: 'connected',
    });
    expect(ping).toHaveBeenCalledTimes(1);
  });

  it('reports unavailable when MongoDB is disconnected', async () => {
    const connection = {
      db: undefined,
      readyState: 0,
    } as unknown as Connection;
    const service = new DatabaseReadinessService(connection);

    await expect(service.check()).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
  });

  it('reports unavailable when the database ping fails', async () => {
    const connection = {
      db: {
        admin: () => ({ ping: jest.fn().mockRejectedValue(new Error('down')) }),
      },
      readyState: 1,
    } as unknown as Connection;
    const service = new DatabaseReadinessService(connection);

    await expect(service.check()).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
  });
});
