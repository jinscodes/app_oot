import { Type } from 'class-transformer';
import {
  IsArray,
  IsDateString,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

export class ProfileLocationDto {
  @IsOptional() @IsString() @MaxLength(4) countryCode?: string;
  @IsOptional() @IsString() @MaxLength(120) city?: string;
  @IsOptional() @IsString() @MaxLength(300) displayName?: string;
  @IsOptional() @IsNumber() @IsLatitude() latitude?: number;
  @IsOptional() @IsNumber() @IsLongitude() longitude?: number;
}

export class ProfilePhotoDto {
  @IsInt() @Min(0) @Max(5) slot!: number;
  @IsOptional() @IsString() @MaxLength(1000) comment?: string;
  @IsOptional() @IsString() @MaxLength(500) storageKey?: string;
  @IsOptional() @IsString() @MaxLength(2000) url?: string;
}

export class UpsertProfileDto {
  @IsOptional() @IsString() @MaxLength(320) email?: string;
  @IsOptional() @IsString() @MaxLength(80) firstName?: string;
  @IsOptional() @IsString() @MaxLength(80) lastName?: string;
  @IsOptional() @IsString() @MaxLength(40) gender?: string;
  @IsOptional() @IsDateString() birthDate?: string;
  @IsOptional() @IsInt() @Min(50) @Max(250) heightCm?: number;
  @IsOptional()
  @ValidateNested()
  @Type(() => ProfileLocationDto)
  location?: ProfileLocationDto;
  @IsOptional() @IsString() @MaxLength(80) connectionType?: string;
  @IsOptional() @IsString() @MaxLength(160) university?: string;
  @IsOptional() @IsString() @MaxLength(4) educationCountry?: string;
  @IsOptional() @IsString() @MaxLength(80) educationLevel?: string;
  @IsOptional() @IsString() @MaxLength(160) company?: string;
  @IsOptional() @IsString() @MaxLength(160) jobTitle?: string;
  @IsOptional() @IsString() @MaxLength(80) children?: string;
  @IsOptional() @IsString() @MaxLength(80) wantsChildren?: string;
  @IsOptional() @IsString() @MaxLength(80) religion?: string;
  @IsOptional() @IsString() @MaxLength(80) alcohol?: string;
  @IsOptional() @IsString() @MaxLength(80) smoking?: string;
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ProfilePhotoDto)
  photos?: ProfilePhotoDto[];
}
