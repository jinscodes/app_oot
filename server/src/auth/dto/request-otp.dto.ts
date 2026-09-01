import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString, MaxLength, MinLength } from 'class-validator';

import { AuthChannel } from '../auth.types';

export class RequestOtpDto {
  @ApiProperty({ enum: AuthChannel, example: AuthChannel.Phone })
  @IsEnum(AuthChannel)
  channel!: AuthChannel;

  @ApiProperty({ example: '+821012345678' })
  @IsString()
  @MinLength(3)
  @MaxLength(254)
  identifier!: string;
}
