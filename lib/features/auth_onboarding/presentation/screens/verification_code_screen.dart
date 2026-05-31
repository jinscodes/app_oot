import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../data/verification_service.dart';
import '../widgets/components/verification_code_input.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key, this.onNext, this.onResend});

  final VoidCallback? onNext;
  final VoidCallback? onResend;

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  bool _isValid = false;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final code = VerificationService.pendingCode;
    if (code != null) {
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
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final ok = VerificationService.verify(_codeController.text);
    if (!mounted) return;
    if (ok) {
      widget.onNext?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code, please try again'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onValidityChanged: (valid) {
                if (valid != _isValid) setState(() => _isValid = valid);
              },
            ),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: widget.onResend,
                child: Text(
                  "Didn't get a code?",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    letterSpacing: 0.0.h,
                  ),
                ),
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
