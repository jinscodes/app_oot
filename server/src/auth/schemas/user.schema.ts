import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument } from 'mongoose';

import { UserStatus } from '../auth.types';

export type UserDocument = HydratedDocument<User>;

@Schema({ collection: 'users', timestamps: true })
export class User {
  @Prop({ trim: true })
  phone?: string;

  @Prop({ lowercase: true, trim: true })
  email?: string;

  @Prop()
  phoneVerifiedAt?: Date;

  @Prop()
  emailVerifiedAt?: Date;

  @Prop({ enum: UserStatus, default: UserStatus.Active, required: true })
  status!: UserStatus;

  @Prop({ default: false, required: true })
  onboardingCompleted!: boolean;

  @Prop()
  lastLoginAt?: Date;

  createdAt!: Date;
  updatedAt!: Date;
}

export const UserSchema = SchemaFactory.createForClass(User);

UserSchema.index(
  { phone: 1 },
  {
    unique: true,
    partialFilterExpression: { phone: { $type: 'string' } },
  },
);
UserSchema.index(
  { email: 1 },
  {
    unique: true,
    partialFilterExpression: { email: { $type: 'string' } },
  },
);
