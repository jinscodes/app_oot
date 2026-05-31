import 'dart:math';

import 'package:flutter/foundation.dart';

class VerificationService {
  VerificationService._();

  static String? _pendingCode;

  static String? get pendingCode => _pendingCode;

  static String sendCode() {
    final code = (Random().nextInt(900000) + 100000).toString();
    _pendingCode = code;
    debugPrint('[VerificationService] Mock code: $code');
    return code;
  }

  static bool verify(String code) {
    if (_pendingCode == null) return false;
    final ok = code == _pendingCode;
    if (ok) _pendingCode = null;
    return ok;
  }
}
