import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';

export interface HealthResponse {
  status: 'ok';
}

@ApiTags('Health')
@SkipThrottle()
@Controller('health')
export class HealthController {
  @Get()
  @ApiOkResponse({
    description: 'The API is running.',
    schema: {
      example: { status: 'ok' },
      properties: { status: { example: 'ok', type: 'string' } },
      required: ['status'],
      type: 'object',
    },
  })
  getHealth(): HealthResponse {
    return { status: 'ok' };
  }
}
