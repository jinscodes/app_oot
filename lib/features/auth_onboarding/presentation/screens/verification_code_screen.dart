import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../widgets/components/verification_code_input.dart';

const int _resendCountdownSeconds = 30;

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({
    super.key,
    required this.sentTo,
    required this.initialCode,
    required this.onVerify,
    required this.onResend,
    this.onNext,
  });

  final String sentTo;
  final String? initialCode;
  final bool Function(String code) onVerify;
  final String? Function() onResend;
  final VoidCallback? onNext;

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  bool _isValid = false;
  bool _hasError = false;
  final TextEditingController _codeController = TextEditingController();
  Timer? _timer;
  int _secondsRemaining = _resendCountdownSeconds;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _showDevCodeSnackBar(widget.initialCode);
    _codeController.addListener(_clearErrorOnEdit);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.removeListener(_clearErrorOnEdit);
    _codeController.dispose();
    super.dispose();
  }

  void _clearErrorOnEdit() {
    if (_hasError) setState(() => _hasError = false);
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsRemaining = _resendCountdownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsRemaining--);
      if (_secondsRemaining <= 0) t.cancel();
    });
  }

  void _showDevCodeSnackBar(String? code) {
    if (code == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dev mock code: $code'),
          duration: const Duration(seconds: 10),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Fill',
            onPressed: () => _fillCode(code),
          ),
        ),
      );
    });
  }

  void _fillCode(String code) {
    _codeController.value = TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );
  }

  void _handleNext() {
    final ok = widget.onVerify(_codeController.text);
    if (!mounted) return;
    if (ok) {
      widget.onNext?.call();
    } else {
      setState(() => _hasError = true);
      HapticFeedback.heavyImpact();
    }
  }

  void _handleResend() {
    final code = widget.onResend();
    if (code == null) return;
    _startCountdown();
    _showDevCodeSnackBar(code);
  }

  @override
  Widget build(BuildContext context) {
    final infoStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.0.h,
    );
    final linkStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      letterSpacing: 0.0.h,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 310.w,
                height: 80.h,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/bubble2.png',
                      width: 310.w,
                      height: 80.h,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 22.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          'Enter your verification code',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorant(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 210.h,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/talking_logo.png',
                width: 80.w,
                height: 80.w,
              ),
            ),
          ),
          Positioned(
            top: 330.h,
            left: 20.w,
            right: 20.w,
            child: VerificationCodeInput(
              controller: _codeController,
              hasError: _hasError,
              onValidityChanged: (valid) {
                if (valid != _isValid) setState(() => _isValid = valid);
              },
            ),
          ),
          Positioned(
            top: 390.h,
            left: 20.w,
            right: 20.w,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Code sent to ${widget.sentTo}', style: infoStyle),
                  SizedBox(height: 4.h),
                  if (_secondsRemaining > 0)
                    Text(
                      'For resending: ${_secondsRemaining}s',
                      style: infoStyle,
                    )
                  else
                    GestureDetector(
                      onTap: _handleResend,
                      child: Text('Resend code', style: linkStyle),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 32.h,
            left: 0,
            right: 0,
            child: Center(
              child: CircleArrowButton(
                onPressed: _isValid ? _handleNext : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
