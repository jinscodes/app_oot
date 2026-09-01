import { Controller, Get } from '@nestjs/common';
import {
  ApiOkResponse,
  ApiServiceUnavailableResponse,
  ApiTags,
} from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';

import {
  DatabaseReadinessResponse,
  DatabaseReadinessService,
} from '../database/database-readiness.service';

@ApiTags('Health')
@SkipThrottle()
@Controller('ready')
export class ReadinessController {
  constructor(
    private readonly databaseReadinessService: DatabaseReadinessService,
  ) {}

  @Get()
  @ApiOkResponse({
    description: 'The API and database are ready to receive traffic.',
    schema: {
      example: { status: 'ready', database: 'connected' },
      properties: {
        status: { example: 'ready', type: 'string' },
        database: { example: 'connected', type: 'string' },
      },
      required: ['status', 'database'],
      type: 'object',
    },
  })
  @ApiServiceUnavailableResponse({
    description: 'The database is unavailable.',
  })
  getReadiness(): Promise<DatabaseReadinessResponse> {
    return this.databaseReadinessService.check();
  }
}
