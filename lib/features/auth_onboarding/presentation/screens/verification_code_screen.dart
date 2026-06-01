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
        ),
      );
    });
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 175.h),
            Text(
              'Enter your\nverification code',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 26.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "We only ask to verify it's you. It won't show up anywhere, including your profile.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            VerificationCodeInput(
              controller: _codeController,
              hasError: _hasError,
              onValidityChanged: (valid) {
                if (valid != _isValid) setState(() => _isValid = valid);
              },
            ),
            SizedBox(height: 10.h),
            Align(
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
            const Spacer(),
            CircleArrowButton(onPressed: _isValid ? _handleNext : null),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
