import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({
    super.key,
    required this.sentTo,
    required this.initialCode,
    required this.onVerify,
    required this.onResend,
    this.resendAfterSeconds = 30,
    this.onNext,
  });

  final String sentTo;
  final String? initialCode;
  final FutureOr<bool> Function(String code) onVerify;
  final FutureOr<String?> Function() onResend;
  final int resendAfterSeconds;
  final VoidCallback? onNext;

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;
  int _seconds = 30;
  bool _hasError = false;
  bool _submitting = false;
  bool _resending = false;

  bool get _isEmail => widget.sentTo.contains('@');
  bool get _isComplete => _controller.text.length == 6;
  String get _countdown {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _showDevCode(widget.initialCode);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = widget.resendAfterSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _seconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _seconds--);
    });
  }

  void _showDevCode(String? code) {
    if (code == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dev mock code: $code'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Fill',
            onPressed: () => setState(() => _controller.text = code),
          ),
        ),
      );
    });
  }

  Future<void> _verify() async {
    if (_submitting) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _submitting = true);
    try {
      if (await widget.onVerify(_controller.text)) {
        widget.onNext?.call();
        return;
      }
      HapticFeedback.heavyImpact();
      setState(() => _hasError = true);
    } catch (error) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() => _hasError = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    try {
      final code = await widget.onResend();
      if (code == null) return;
      _startTimer();
      _showDevCode(code.isEmpty ? null : code);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.sentTo.isEmpty
        ? (_isEmail ? 'hello@example.com' : '+82 10 1234 5678')
        : widget.sentTo;
    return OotOnboardingScaffold(
      progressLabel: _isEmail ? 'Verify email' : 'Verify number',
      currentStep: _isEmail ? 5 : 3,
      totalSteps: 6,
      buttonLabel: _submitting
          ? 'Verifying...'
          : _isEmail
          ? 'Verify email'
          : 'Verify',
      onContinue: _isComplete && !_submitting ? _verify : null,
      body: Column(
        children: [
          OotHero(
            eyebrow: _isEmail ? 'Email verification' : 'Phone verification',
            title: _isEmail ? 'Check your inbox' : 'Enter your code',
            description: _isEmail
                ? 'Enter the 6-digit code we sent to $target.'
                : 'We sent a 6-digit code to $target.',
          ),
          SizedBox(height: 34.h),
          Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel(
              _isEmail ? 'Email verification code' : 'Verification code',
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => _focusNode.requestFocus(),
            child: Stack(
              children: [
                Opacity(
                  opacity: .01,
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() => _hasError = false),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var index = 0; index < 6; index++)
                      _DigitBox(
                        value: index < _controller.text.length
                            ? _controller.text[index]
                            : '',
                        active: index == _controller.text.length.clamp(0, 5),
                        error: _hasError,
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_isEmail ? 'Code expires' : 'Code sent'} · $_countdown',
                style: ootHelperStyle(),
              ),
              GestureDetector(
                onTap: _seconds == 0 && !_resending ? _resend : null,
                child: Text(
                  _resending ? 'Sending...' : 'Resend code',
                  style: GoogleFonts.inter(
                    color: _seconds == 0
                        ? AppColors.accent
                        : AppColors.accent.withValues(alpha: .65),
                    fontSize: 12.sp,
                    height: 16 / 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const _DigitBox({
    required this.value,
    required this.active,
    required this.error,
  });

  final String value;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 57.w,
      height: 58.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: error
              ? Colors.redAccent
              : active
              ? AppColors.primary
              : const Color(0xFFE6DBD5),
          width: active || error ? 1.5.w : 1.w,
        ),
      ),
      child: Text(
        value,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          height: 22 / 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
