import {
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

import {
  OtpDeliveryMessage,
  OtpDeliveryService,
} from './otp-delivery.interface';

@Injectable()
export class ConsoleOtpDeliveryService implements OtpDeliveryService {
  private readonly logger = new Logger(ConsoleOtpDeliveryService.name);

  constructor(private readonly configService: ConfigService) {}

  send(message: OtpDeliveryMessage): Promise<void> {
    if (this.configService.getOrThrow<string>('NODE_ENV') === 'production') {
      throw new InternalServerErrorException(
        'A production OTP provider has not been configured.',
      );
    }

    this.logger.warn(
      `[DEVELOPMENT ONLY] ${message.channel} OTP for ${this.mask(message.identifier)}: ${message.code} (expires in ${message.expiresInSeconds}s)`,
    );
    return Promise.resolve();
  }

  private mask(identifier: string): string {
    if (identifier.length <= 4) return '****';
    return `${identifier.slice(0, 2)}***${identifier.slice(-2)}`;
  }
}
