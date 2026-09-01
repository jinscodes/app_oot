import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiTags,
} from '@nestjs/swagger';

import { CurrentAuth } from '../auth/decorators/current-auth.decorator';
import { AuthenticatedPrincipal } from '../auth/auth.types';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { UpsertProfileDto } from './dto/upsert-profile.dto';
import { ProfileService } from './profile.service';

@ApiTags('Profile')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get()
  @ApiOkResponse({ description: 'The authenticated user profile.' })
  get(@CurrentAuth() auth: AuthenticatedPrincipal) {
    return this.profileService.get(auth.userId);
  }

  @Patch()
  @ApiOkResponse({ description: 'Profile saved.' })
  save(
    @CurrentAuth() auth: AuthenticatedPrincipal,
    @Body() dto: UpsertProfileDto,
  ) {
    return this.profileService.upsert(auth.userId, dto);
  }

  @Post('complete')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse({ description: 'Onboarding marked complete.' })
  async complete(@CurrentAuth() auth: AuthenticatedPrincipal): Promise<void> {
    await this.profileService.complete(auth.userId);
  }
}
