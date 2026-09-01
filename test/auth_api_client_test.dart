import 'dart:convert';

import 'package:app_oot/features/auth_onboarding/data/auth_api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests and verifies a phone OTP with the server contract', () async {
    final client = MockClient((request) async {
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      if (request.url.path.endsWith('/auth/otp/request')) {
        expect(body, {'channel': 'phone', 'identifier': '+821012345678'});
        return http.Response(
          jsonEncode({
            'challengeId': '507f1f77bcf86cd799439011',
            'expiresInSeconds': 300,
            'resendAfterSeconds': 60,
          }),
          202,
        );
      }

      expect(request.url.path, endsWith('/auth/otp/verify'));
      expect(body, {
        'challengeId': '507f1f77bcf86cd799439011',
        'code': '123456',
      });
      return http.Response(
        jsonEncode({
          'accessToken': 'access-token',
          'refreshToken': 'refresh-token',
          'accessTokenExpiresInSeconds': 900,
          'refreshTokenExpiresInSeconds': 2592000,
          'tokenType': 'Bearer',
          'user': {
            'id': '507f1f77bcf86cd799439012',
            'phone': '+821012345678',
            'status': 'active',
            'onboardingCompleted': false,
            'createdAt': '2026-08-19T00:00:00.000Z',
          },
        }),
        200,
      );
    });
    final api = AuthApiClient(
      baseUrl: 'http://localhost:3000/api/v1',
      client: client,
    );

    final challenge = await api.requestPhoneOtp('+821012345678');
    final session = await api.verifyPhoneOtp(
      challengeId: challenge.id,
      code: '123456',
    );

    expect(challenge.resendAfterSeconds, 60);
    expect(session.user.phone, '+821012345678');
    expect(session.tokens.refreshToken, 'refresh-token');
  });

  test('surfaces the API error message', () async {
    final api = AuthApiClient(
      baseUrl: 'http://localhost:3000/api/v1',
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'message': 'Please wait before requesting another code.',
          }),
          429,
        ),
      ),
    );

    await expectLater(
      api.requestPhoneOtp('+821012345678'),
      throwsA(
        isA<AuthApiException>()
            .having((error) => error.statusCode, 'statusCode', 429)
            .having(
              (error) => error.message,
              'message',
              'Please wait before requesting another code.',
            ),
      ),
    );
  });
}
