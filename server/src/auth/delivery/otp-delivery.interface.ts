import { AuthChannel } from '../auth.types';

export const OTP_DELIVERY_SERVICE = Symbol('OTP_DELIVERY_SERVICE');

export interface OtpDeliveryMessage {
  channel: AuthChannel;
  code: string;
  identifier: string;
  expiresInSeconds: number;
}

export interface OtpDeliveryService {
  send(message: OtpDeliveryMessage): Promise<void>;
}
