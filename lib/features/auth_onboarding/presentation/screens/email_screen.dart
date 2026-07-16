import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key, this.onNext});

  final ValueChanged<String>? onNext;

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _updates = false;
  bool _valid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final valid = RegExp(r'^\S+@\S+\.\S+$').hasMatch(value.trim());
    if (valid != _valid) setState(() => _valid = valid);
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Your email',
      currentStep: 4,
      totalSteps: 6,
      buttonLabel: 'Continue',
      onContinue: _valid
          ? () => widget.onNext?.call(_controller.text.trim())
          : null,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Stay connected',
            title: 'What’s your email?',
            description:
                'We’ll use it for sign-in and important account updates.',
          ),
          SizedBox(height: 34.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('Email address'),
          ),
          SizedBox(height: 10.h),
          OotTextField(
            controller: _controller,
            hintText: 'hello@example.com',
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            focused: true,
            onChanged: _onChanged,
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => setState(() => _updates = !_updates),
            child: Container(
              height: 74.h,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      color: _updates ? AppColors.accent : Colors.white,
                      borderRadius: BorderRadius.circular(5.r),
                      border: Border.all(color: AppColors.accent, width: 1.5.w),
                    ),
                    child: _updates
                        ? Icon(Icons.check, size: 15.sp, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 330.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send me occasional updates',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontSize: 12.sp,
                                height: 17 / 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'Product news and dating tips. Optional.',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 11.sp,
                                height: 16 / 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14.sp,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'Never shown on your profile. You’re always in control.',
                  style: ootHelperStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
