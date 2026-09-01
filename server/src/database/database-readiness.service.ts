import { Injectable, ServiceUnavailableException } from '@nestjs/common';
import { InjectConnection } from '@nestjs/mongoose';
import { Connection, ConnectionStates } from 'mongoose';

export interface DatabaseReadinessResponse {
  status: 'ready';
  database: 'connected';
}

@Injectable()
export class DatabaseReadinessService {
  constructor(@InjectConnection() private readonly connection: Connection) {}

  async check(): Promise<DatabaseReadinessResponse> {
    const database = this.connection.db;

    if (
      this.connection.readyState !== ConnectionStates.connected ||
      !database
    ) {
      throw this.unavailable();
    }

    try {
      await database.admin().ping();
    } catch {
      throw this.unavailable();
    }

    return { status: 'ready', database: 'connected' };
  }

  private unavailable(): ServiceUnavailableException {
    return new ServiceUnavailableException({
      status: 'unavailable',
      database: 'disconnected',
    });
  }
}
