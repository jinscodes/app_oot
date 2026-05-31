import 'dart:math';

import 'package:flutter/foundation.dart';

class VerificationService {
  VerificationService._();

  static String? _pendingCode;
  static String? _pendingPhone;

  static String? get pendingCode => _pendingCode;
  static String? get pendingPhone => _pendingPhone;

  static String sendCode(String phone) {
    final code = (Random().nextInt(900000) + 100000).toString();
    _pendingCode = code;
    _pendingPhone = phone;
    debugPrint('[VerificationService] Mock code for $phone: $code');
    return code;
  }

  static bool verify(String code) {
    if (_pendingCode == null) return false;
    final ok = code == _pendingCode;
    if (ok) _pendingCode = null;
    return ok;
  }
}
