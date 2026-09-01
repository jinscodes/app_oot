import { Test, TestingModule } from '@nestjs/testing';

import { DatabaseReadinessService } from '../database/database-readiness.service';
import { ReadinessController } from './readiness.controller';

describe('ReadinessController', () => {
  let controller: ReadinessController;
  const check = jest.fn();

  beforeEach(async () => {
    check.mockReset();
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ReadinessController],
      providers: [
        {
          provide: DatabaseReadinessService,
          useValue: { check },
        },
      ],
    }).compile();

    controller = module.get(ReadinessController);
  });

  it('returns the database readiness result', async () => {
    check.mockResolvedValue({ status: 'ready', database: 'connected' });

    await expect(controller.getReadiness()).resolves.toEqual({
      status: 'ready',
      database: 'connected',
    });
  });
});
