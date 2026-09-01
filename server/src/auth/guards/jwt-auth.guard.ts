import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';

import { AccessTokenPayload, AuthenticatedPrincipal } from '../auth.types';

export interface AuthenticatedRequest extends Request {
  auth?: AuthenticatedPrincipal;
}

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const [scheme, token] = request.headers.authorization?.split(' ') ?? [];
    if (scheme !== 'Bearer' || !token) throw this.unauthorized();

    try {
      const payload = await this.jwtService.verifyAsync<AccessTokenPayload>(
        token,
        { audience: 'oot-mobile', issuer: 'oot-api' },
      );
      if (
        payload.typ !== 'access' ||
        typeof payload.sub !== 'string' ||
        typeof payload.sid !== 'string'
      ) {
        throw this.unauthorized();
      }
      request.auth = { userId: payload.sub, sessionId: payload.sid };
      return true;
    } catch {
      throw this.unauthorized();
    }
  }

  private unauthorized(): UnauthorizedException {
    return new UnauthorizedException('A valid access token is required.');
  }
}
