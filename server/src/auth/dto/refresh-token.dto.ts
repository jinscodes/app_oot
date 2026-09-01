import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export class RefreshTokenDto {
  @ApiProperty({ description: 'Opaque refresh token returned at sign-in.' })
  @IsString()
  @MinLength(32)
  refreshToken!: string;

  @ApiPropertyOptional({ example: 'device-installation-id' })
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceId?: string;

  @ApiPropertyOptional({ example: "Jay's iPhone" })
  @IsOptional()
  @IsString()
  @MaxLength(128)
  deviceName?: string;
}
