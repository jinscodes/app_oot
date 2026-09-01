import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

import { AuthChannel } from '../auth.types';

export type OtpChallengeDocument = HydratedDocument<OtpChallenge>;

@Schema({ collection: 'otp_challenges', timestamps: true })
export class OtpChallenge {
  @Prop({ enum: AuthChannel, required: true })
  channel!: AuthChannel;

  @Prop({ required: true })
  identifier!: string;

  @Prop({ index: true, required: true })
  identifierHash!: string;

  @Prop({ required: true })
  codeHash!: string;

  @Prop({ default: 0, min: 0, required: true })
  attempts!: number;

  @Prop({ min: 1, required: true })
  maxAttempts!: number;

  @Prop({ required: true })
  expiresAt!: Date;

  @Prop()
  consumedAt?: Date;

  createdAt!: Date;
  updatedAt!: Date;
}

export const OtpChallengeSchema = SchemaFactory.createForClass(OtpChallenge);

OtpChallengeSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
OtpChallengeSchema.index({ identifierHash: 1, createdAt: -1 });
