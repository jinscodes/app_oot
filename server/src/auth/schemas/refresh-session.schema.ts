import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Types } from 'mongoose';

import { User } from './user.schema';

export type RefreshSessionDocument = HydratedDocument<RefreshSession>;

@Schema({ collection: 'refresh_sessions', timestamps: true })
export class RefreshSession {
  @Prop({ type: Types.ObjectId, ref: User.name, index: true, required: true })
  userId!: Types.ObjectId;

  @Prop({ unique: true, required: true })
  tokenHash!: string;

  @Prop({ trim: true })
  deviceId?: string;

  @Prop({ trim: true })
  deviceName?: string;

  @Prop({ required: true })
  expiresAt!: Date;

  @Prop()
  lastUsedAt?: Date;

  @Prop()
  revokedAt?: Date;

  @Prop({ type: Types.ObjectId })
  replacedBySessionId?: Types.ObjectId;

  createdAt!: Date;
  updatedAt!: Date;
}

export const RefreshSessionSchema =
  SchemaFactory.createForClass(RefreshSession);

RefreshSessionSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
RefreshSessionSchema.index({ userId: 1, revokedAt: 1, expiresAt: 1 });
