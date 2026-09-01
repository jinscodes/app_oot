class OtpChallenge {
  const OtpChallenge({
    required this.id,
    required this.expiresInSeconds,
    required this.resendAfterSeconds,
  });

  factory OtpChallenge.fromJson(Map<String, dynamic> json) {
    return OtpChallenge(
      id: json['challengeId'] as String,
      expiresInSeconds: json['expiresInSeconds'] as int,
      resendAfterSeconds: json['resendAfterSeconds'] as int,
    );
  }

  final String id;
  final int expiresInSeconds;
  final int resendAfterSeconds;
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.status,
    required this.onboardingCompleted,
    required this.createdAt,
    this.phone,
    this.email,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String,
      onboardingCompleted: json['onboardingCompleted'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  final String id;
  final String? phone;
  final String? email;
  final String status;
  final bool onboardingCompleted;
  final DateTime createdAt;
}

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresInSeconds,
    required this.refreshTokenExpiresInSeconds,
    this.tokenType = 'Bearer',
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpiresInSeconds: json['accessTokenExpiresInSeconds'] as int,
      refreshTokenExpiresInSeconds: json['refreshTokenExpiresInSeconds'] as int,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }

  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresInSeconds;
  final int refreshTokenExpiresInSeconds;
  final String tokenType;
}

class AuthSession {
  const AuthSession({required this.tokens, required this.user});

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      tokens: AuthTokens.fromJson(json),
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final AuthTokens tokens;
  final AuthUser user;
}
