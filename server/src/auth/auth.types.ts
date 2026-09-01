export enum AuthChannel {
  Email = 'email',
  Phone = 'phone',
}

export enum UserStatus {
  Active = 'active',
  Deleted = 'deleted',
  Suspended = 'suspended',
}

export interface AuthenticatedPrincipal {
  userId: string;
  sessionId: string;
}

export interface AccessTokenPayload {
  sub: string;
  sid: string;
  typ: 'access';
}
