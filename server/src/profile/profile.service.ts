import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';

import { User, UserDocument } from '../auth/schemas/user.schema';
import { UpsertProfileDto } from './dto/upsert-profile.dto';
import { Profile, ProfileDocument } from './schemas/profile.schema';

@Injectable()
export class ProfileService {
  constructor(
    @InjectModel(Profile.name)
    private readonly profileModel: Model<ProfileDocument>,
    @InjectModel(User.name) private readonly userModel: Model<UserDocument>,
  ) {}

  async get(userId: string): Promise<ProfileDocument | null> {
    return this.profileModel
      .findOne({ userId: new Types.ObjectId(userId) })
      .exec();
  }

  async upsert(
    userId: string,
    dto: UpsertProfileDto,
  ): Promise<ProfileDocument> {
    const payload = Object.fromEntries(
      Object.entries(dto).filter(([, value]) => value !== undefined),
    );
    if (payload.birthDate)
      payload.birthDate = new Date(payload.birthDate as string);
    const profile = await this.profileModel
      .findOneAndUpdate(
        { userId: new Types.ObjectId(userId) },
        { $set: payload, $setOnInsert: { userId: new Types.ObjectId(userId) } },
        {
          new: true,
          upsert: true,
          runValidators: true,
          setDefaultsOnInsert: true,
        },
      )
      .exec();
    if (!profile) throw new NotFoundException('Profile could not be saved.');
    return profile;
  }

  async complete(userId: string): Promise<void> {
    const profile = await this.get(userId);
    if (!profile)
      throw new NotFoundException(
        'Save the profile before completing onboarding.',
      );
    await this.userModel
      .updateOne(
        { _id: new Types.ObjectId(userId) },
        { $set: { onboardingCompleted: true } },
      )
      .exec();
  }
}
