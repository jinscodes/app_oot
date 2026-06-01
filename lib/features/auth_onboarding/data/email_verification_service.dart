import 'dart:math';

import 'package:flutter/foundation.dart';

class EmailVerificationService {
  EmailVerificationService._();

  static String? _pendingCode;
  static String? _pendingEmail;

  static String? get pendingCode => _pendingCode;
  static String? get pendingEmail => _pendingEmail;

  static String sendCode(String email) {
    final code = (Random().nextInt(900000) + 100000).toString();
    _pendingCode = code;
    _pendingEmail = email;
    debugPrint('[EmailVerificationService] Mock code for $email: $code');
    return code;
  }

  static bool verify(String code) {
    if (_pendingCode == null) return false;
    final ok = code == _pendingCode;
    if (ok) _pendingCode = null;
    return ok;
  }
}
