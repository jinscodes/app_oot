import { UserStatus } from './auth.types';

export interface PublicUserResponse {
  id: string;
  phone?: string;
  email?: string;
  status: UserStatus;
  onboardingCompleted: boolean;
  createdAt: Date;
}

export interface TokenPairResponse {
  tokenType: 'Bearer';
  accessToken: string;
  accessTokenExpiresInSeconds: number;
  refreshToken: string;
  refreshTokenExpiresInSeconds: number;
}

export interface AuthenticationResponse extends TokenPairResponse {
  user: PublicUserResponse;
}

export interface RequestOtpResponse {
  challengeId: string;
  expiresInSeconds: number;
  resendAfterSeconds: number;
}
