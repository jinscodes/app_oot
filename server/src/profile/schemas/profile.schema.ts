import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { HydratedDocument, Schema as MongooseSchema, Types } from 'mongoose';

export type ProfileDocument = HydratedDocument<Profile>;

@Schema({ _id: false })
export class ProfileLocation {
  @Prop({ trim: true }) countryCode?: string;
  @Prop({ trim: true }) city?: string;
  @Prop({ trim: true }) displayName?: string;
  @Prop() latitude?: number;
  @Prop() longitude?: number;
}

@Schema({ _id: false })
export class ProfilePhoto {
  @Prop({ required: true, min: 0, max: 5 }) slot!: number;
  @Prop({ trim: true, maxlength: 1000 }) comment?: string;
  @Prop({ trim: true }) storageKey?: string;
  @Prop({ trim: true }) url?: string;
}

@Schema({ collection: 'profiles', timestamps: true })
export class Profile {
  @Prop({
    type: MongooseSchema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
  })
  userId!: Types.ObjectId;

  @Prop({ trim: true, lowercase: true, maxlength: 320 }) email?: string;
  @Prop({ trim: true, maxlength: 80 }) firstName?: string;
  @Prop({ trim: true, maxlength: 80 }) lastName?: string;
  @Prop({ trim: true, maxlength: 40 }) gender?: string;
  @Prop() birthDate?: Date;
  @Prop({ min: 50, max: 250 }) heightCm?: number;
  @Prop({ type: ProfileLocation }) location?: ProfileLocation;
  @Prop({ trim: true, maxlength: 80 }) connectionType?: string;
  @Prop({ trim: true, maxlength: 160 }) university?: string;
  @Prop({ trim: true, maxlength: 4 }) educationCountry?: string;
  @Prop({ trim: true, maxlength: 80 }) educationLevel?: string;
  @Prop({ trim: true, maxlength: 160 }) company?: string;
  @Prop({ trim: true, maxlength: 160 }) jobTitle?: string;
  @Prop({ trim: true, maxlength: 80 }) children?: string;
  @Prop({ trim: true, maxlength: 80 }) wantsChildren?: string;
  @Prop({ trim: true, maxlength: 80 }) religion?: string;
  @Prop({ trim: true, maxlength: 80 }) alcohol?: string;
  @Prop({ trim: true, maxlength: 80 }) smoking?: string;
  @Prop({ type: [ProfilePhoto], default: [] }) photos!: ProfilePhoto[];

  createdAt!: Date;
  updatedAt!: Date;
}

export const ProfileSchema = SchemaFactory.createForClass(Profile);
ProfileSchema.index({ userId: 1 }, { unique: true });
