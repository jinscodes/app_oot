import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'auth_models.dart';

abstract interface class AuthGateway {
  Future<OtpChallenge> requestPhoneOtp(String phone);

  Future<AuthSession> verifyPhoneOtp({
    required String challengeId,
    required String code,
  });

  Future<AuthTokens> refresh(String refreshToken);

  Future<AuthUser> getCurrentUser(String accessToken);

  Future<void> logout(String refreshToken);

  Future<Map<String, dynamic>> saveProfile(
    String accessToken,
    Map<String, dynamic> profile,
  );
  Future<void> completeOnboarding(String accessToken);
}

class AuthApiException implements Exception {
  const AuthApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}

class AuthApiClient implements AuthGateway {
  AuthApiClient({required String baseUrl, http.Client? client})
    : baseUrl = baseUrl.replaceFirst(RegExp(r'/$'), ''),
      _client = client ?? http.Client();

  factory AuthApiClient.development({http.Client? client}) {
    const configuredUrl = String.fromEnvironment('OOT_API_BASE_URL');
    final host = defaultTargetPlatform == TargetPlatform.android
        ? '10.0.2.2'
        : 'localhost';
    return AuthApiClient(
      baseUrl: configuredUrl.isEmpty
          ? 'http://$host:3000/api/v1'
          : configuredUrl,
      client: client,
    );
  }

  final String baseUrl;
  final http.Client _client;

  @override
  Future<OtpChallenge> requestPhoneOtp(String phone) async {
    final json = await _requestJson(
      'POST',
      '/auth/otp/request',
      body: {'channel': 'phone', 'identifier': phone},
      expectedStatuses: const {202},
    );
    return OtpChallenge.fromJson(json);
  }

  @override
  Future<AuthSession> verifyPhoneOtp({
    required String challengeId,
    required String code,
  }) async {
    final json = await _requestJson(
      'POST',
      '/auth/otp/verify',
      body: {'challengeId': challengeId, 'code': code},
      expectedStatuses: const {200},
    );
    return AuthSession.fromJson(json);
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    final json = await _requestJson(
      'POST',
      '/auth/refresh',
      body: {'refreshToken': refreshToken},
      expectedStatuses: const {200},
    );
    return AuthTokens.fromJson(json);
  }

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    final json = await _requestJson(
      'GET',
      '/auth/me',
      accessToken: accessToken,
      expectedStatuses: const {200},
    );
    return AuthUser.fromJson(json);
  }

  @override
  Future<void> logout(String refreshToken) async {
    await _requestJson(
      'POST',
      '/auth/logout',
      body: {'refreshToken': refreshToken},
      expectedStatuses: const {204},
    );
  }

  @override
  Future<Map<String, dynamic>> saveProfile(
    String accessToken,
    Map<String, dynamic> profile,
  ) {
    return _requestJson(
      'PATCH',
      '/profile',
      accessToken: accessToken,
      body: profile,
      expectedStatuses: const {200},
    );
  }

  @override
  Future<void> completeOnboarding(String accessToken) async {
    await _requestJson(
      'POST',
      '/profile/complete',
      accessToken: accessToken,
      expectedStatuses: const {204},
    );
  }

  void close() => _client.close();

  Future<Map<String, dynamic>> _requestJson(
    String method,
    String path, {
    Map<String, dynamic>? body,
    String? accessToken,
    required Set<int> expectedStatuses,
  }) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
    late http.Response response;

    try {
      final uri = Uri.parse('$baseUrl$path');
      response = switch (method) {
        'GET' => await _client.get(uri, headers: headers),
        'POST' => await _client.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        ),
        'PATCH' => await _client.patch(
          uri,
          headers: headers,
          body: jsonEncode(body),
        ),
        _ => throw ArgumentError.value(method, 'method'),
      };
    } on http.ClientException {
      throw const AuthApiException(
        'Unable to reach the server. Check that it is running and try again.',
      );
    }

    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;
    if (!expectedStatuses.contains(response.statusCode)) {
      throw AuthApiException(
        _errorMessage(decoded),
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }

  String _errorMessage(Map<String, dynamic> body) {
    final message = body['message'];
    if (message is List) return message.join('\n');
    if (message is String && message.isNotEmpty) return message;
    return 'Something went wrong. Please try again.';
  }
}
