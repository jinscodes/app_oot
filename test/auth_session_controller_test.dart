import 'package:app_oot/features/auth_onboarding/data/auth_api_client.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_models.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_session_controller.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_token_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'restores an expired access token by rotating the refresh token',
    () async {
      final storage = _MemoryStorage()..tokens = _expiredTokens;
      final gateway = _RefreshGateway();
      final controller = AuthSessionController(
        gateway: gateway,
        storage: storage,
      );

      expect(await controller.restoreSession(), isTrue);
      expect(gateway.refreshCalls, 1);
      expect(storage.tokens?.refreshToken, 'new-refresh-token');
      expect(controller.user?.phone, '+821012345678');
    },
  );

  test('logout revokes the refresh token and clears device storage', () async {
    final storage = _MemoryStorage();
    final gateway = _RefreshGateway();
    final controller = AuthSessionController(
      gateway: gateway,
      storage: storage,
    );
    await controller.verifyPhoneOtp(
      challengeId: '507f1f77bcf86cd799439011',
      code: '123456',
    );

    await controller.logout();

    expect(gateway.loggedOutToken, 'new-refresh-token');
    expect(storage.tokens, isNull);
    expect(controller.isAuthenticated, isFalse);
  });
}

class _RefreshGateway implements AuthGateway {
  var refreshCalls = 0;
  String? loggedOutToken;

  @override
  Future<void> completeOnboarding(String accessToken) async {}

  @override
  Future<Map<String, dynamic>> saveProfile(
    String accessToken,
    Map<String, dynamic> profile,
  ) async => profile;

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    if (accessToken == _expiredTokens.accessToken) {
      throw const AuthApiException('Expired', statusCode: 401);
    }
    return _user;
  }

  @override
  Future<void> logout(String refreshToken) async {
    loggedOutToken = refreshToken;
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    refreshCalls++;
    expect(refreshToken, _expiredTokens.refreshToken);
    return _newTokens;
  }

  @override
  Future<OtpChallenge> requestPhoneOtp(String phone) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> verifyPhoneOtp({
    required String challengeId,
    required String code,
  }) async {
    return AuthSession(tokens: _newTokens, user: _user);
  }
}

class _MemoryStorage implements AuthTokenStorage {
  AuthTokens? tokens;

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens tokens) async => this.tokens = tokens;
}

const _expiredTokens = AuthTokens(
  accessToken: 'expired-access-token',
  refreshToken: 'old-refresh-token',
  accessTokenExpiresInSeconds: 900,
  refreshTokenExpiresInSeconds: 2592000,
);

const _newTokens = AuthTokens(
  accessToken: 'new-access-token',
  refreshToken: 'new-refresh-token',
  accessTokenExpiresInSeconds: 900,
  refreshTokenExpiresInSeconds: 2592000,
);

final _user = AuthUser(
  id: '507f1f77bcf86cd799439012',
  phone: '+821012345678',
  status: 'active',
  onboardingCompleted: true,
  createdAt: DateTime.utc(2026),
);
