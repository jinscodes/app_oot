import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  UseGuards,
} from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';

import { CurrentAuth } from './decorators/current-auth.decorator';
import { LogoutDto } from './dto/logout.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import {
  AuthenticationResponse,
  PublicUserResponse,
  RequestOtpResponse,
  TokenPairResponse,
} from './auth.responses';
import { AuthService } from './auth.service';
import { AuthenticatedPrincipal } from './auth.types';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('otp/request')
  @HttpCode(HttpStatus.ACCEPTED)
  @Throttle({ default: { limit: 5, ttl: 60_000 } })
  @ApiOperation({ summary: 'Request a phone or email verification code' })
  @ApiAcceptedResponse({ description: 'Verification challenge created.' })
  requestOtp(@Body() dto: RequestOtpDto): Promise<RequestOtpResponse> {
    return this.authService.requestOtp(dto);
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @ApiOperation({ summary: 'Verify a code and create a signed-in session' })
  @ApiOkResponse({ description: 'Signed in successfully.' })
  verifyOtp(@Body() dto: VerifyOtpDto): Promise<AuthenticationResponse> {
    return this.authService.verifyOtp(dto);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @ApiOperation({ summary: 'Rotate a refresh token and issue new tokens' })
  @ApiOkResponse({ description: 'Tokens rotated successfully.' })
  refresh(@Body() dto: RefreshTokenDto): Promise<TokenPairResponse> {
    return this.authService.refresh(dto);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Revoke a refresh session' })
  @ApiNoContentResponse({ description: 'Session revoked.' })
  logout(@Body() dto: LogoutDto): Promise<void> {
    return this.authService.logout(dto.refreshToken);
  }

  @Get('me')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get the currently authenticated user' })
  @ApiOkResponse({ description: 'Current user returned.' })
  getMe(
    @CurrentAuth() principal: AuthenticatedPrincipal,
  ): Promise<PublicUserResponse> {
    return this.authService.getCurrentUser(principal.userId);
  }
}
