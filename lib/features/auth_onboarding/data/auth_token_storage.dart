import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_models.dart';

abstract interface class AuthTokenStorage {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

class FlutterSecureAuthTokenStorage implements AuthTokenStorage {
  FlutterSecureAuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'oot.auth.access_token';
  static const _refreshTokenKey = 'oot.auth.refresh_token';
  static const _accessTtlKey = 'oot.auth.access_ttl';
  static const _refreshTtlKey = 'oot.auth.refresh_ttl';

  final FlutterSecureStorage _storage;

  @override
  Future<AuthTokens?> read() async {
    final values = await _storage.readAll();
    final accessToken = values[_accessTokenKey];
    final refreshToken = values[_refreshTokenKey];
    final accessTtl = int.tryParse(values[_accessTtlKey] ?? '');
    final refreshTtl = int.tryParse(values[_refreshTtlKey] ?? '');
    if (accessToken == null ||
        refreshToken == null ||
        accessTtl == null ||
        refreshTtl == null) {
      return null;
    }
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      accessTokenExpiresInSeconds: accessTtl,
      refreshTokenExpiresInSeconds: refreshTtl,
    );
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _storage.write(key: _accessTokenKey, value: tokens.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokens.refreshToken);
    await _storage.write(
      key: _accessTtlKey,
      value: tokens.accessTokenExpiresInSeconds.toString(),
    );
    await _storage.write(
      key: _refreshTtlKey,
      value: tokens.refreshTokenExpiresInSeconds.toString(),
    );
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _accessTtlKey);
    await _storage.delete(key: _refreshTtlKey);
  }
}
