import { createParamDecorator, ExecutionContext } from '@nestjs/common';

import { AuthenticatedPrincipal } from '../auth.types';
import { AuthenticatedRequest } from '../guards/jwt-auth.guard';

export const CurrentAuth = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AuthenticatedPrincipal => {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    if (!request.auth) {
      throw new Error('CurrentAuth requires JwtAuthGuard.');
    }
    return request.auth;
  },
);
