import 'auth_api_client.dart';
import 'auth_models.dart';
import 'auth_token_storage.dart';

class AuthSessionController {
  AuthSessionController({
    required AuthGateway gateway,
    required AuthTokenStorage storage,
  }) : _gateway = gateway,
       _storage = storage;

  factory AuthSessionController.development() {
    return AuthSessionController(
      gateway: AuthApiClient.development(),
      storage: FlutterSecureAuthTokenStorage(),
    );
  }

  final AuthGateway _gateway;
  final AuthTokenStorage _storage;

  AuthTokens? _tokens;
  AuthUser? _user;

  AuthUser? get user => _user;
  bool get isAuthenticated => _tokens != null;

  Future<bool> restoreSession() async {
    try {
      final storedTokens = await _storage.read();
      if (storedTokens == null) return false;
      _tokens = storedTokens;

      try {
        _user = await _gateway.getCurrentUser(storedTokens.accessToken);
      } on AuthApiException catch (error) {
        if (!error.isUnauthorized) rethrow;
        final refreshedTokens = await _gateway.refresh(
          storedTokens.refreshToken,
        );
        await _storeTokens(refreshedTokens);
        _user = await _gateway.getCurrentUser(refreshedTokens.accessToken);
      }
      return true;
    } on AuthApiException catch (error) {
      if (error.isUnauthorized) await _clearLocalSession();
      return false;
    } catch (_) {
      return _tokens != null;
    }
  }

  Future<OtpChallenge> requestPhoneOtp(String phone) {
    return _gateway.requestPhoneOtp(phone);
  }

  Future<void> verifyPhoneOtp({
    required String challengeId,
    required String code,
  }) async {
    final session = await _gateway.verifyPhoneOtp(
      challengeId: challengeId,
      code: code,
    );
    _user = session.user;
    await _storeTokens(session.tokens);
  }

  Future<void> logout() async {
    final refreshToken = _tokens?.refreshToken;
    if (refreshToken != null) {
      try {
        await _gateway.logout(refreshToken);
      } catch (_) {
        // Local logout must still succeed if the session was already revoked
        // or the development server is temporarily unreachable.
      }
    }
    await _clearLocalSession();
  }

  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final token = _tokens?.accessToken;
    if (token == null) throw const AuthApiException('You are not signed in.');
    await _gateway.saveProfile(token, profile);
  }

  Future<void> completeOnboarding() async {
    final token = _tokens?.accessToken;
    if (token == null) throw const AuthApiException('You are not signed in.');
    await _gateway.completeOnboarding(token);
  }

  Future<void> _storeTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await _storage.write(tokens);
  }

  Future<void> _clearLocalSession() async {
    _tokens = null;
    _user = null;
    try {
      await _storage.clear();
    } catch (_) {
      // Tests and unsupported platforms may not provide a storage plugin.
    }
  }
}
