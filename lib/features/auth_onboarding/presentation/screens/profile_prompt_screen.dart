import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class ProfilePromptScreen extends StatefulWidget {
  const ProfilePromptScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<ProfilePromptScreen> createState() => _ProfilePromptScreenState();
}

class _ProfilePromptScreenState extends State<ProfilePromptScreen> {
  final TextEditingController _answer = TextEditingController(
    text:
        'Coffee, a long walk by the lake, and cooking something new with friends.',
  );

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 4,
      totalSteps: 5,
      buttonLabel: 'Save & continue',
      onContinue: _answer.text.trim().isEmpty ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your voice',
            title: 'Give them a reason to say hi',
            description:
                'A thoughtful answer makes starting a real conversation easier.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Profile prompt'),
          SizedBox(height: 10.h),
          Container(
            height: 64.h,
            padding: EdgeInsets.only(left: 16.w, right: 14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECTED PROMPT',
                        style: GoogleFonts.inter(
                          color: AppColors.accent,
                          fontSize: 10.sp,
                          height: 14 / 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'My ideal Sunday looks like…',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14.sp,
                          height: 20 / 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 22.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              OotTextField(
                controller: _answer,
                maxLength: 160,
                maxLines: 5,
                focused: true,
                onChanged: (_) => setState(() {}),
              ),
              Positioned(
                left: 16.w,
                top: 12.h,
                child: Text(
                  'YOUR ANSWER',
                  style: GoogleFonts.inter(
                    color: AppColors.label,
                    fontSize: 11.sp,
                    height: 16 / 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                right: 16.w,
                top: 12.h,
                child: Text(
                  '${_answer.text.length} / 160',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF9A8880),
                    fontSize: 11.sp,
                    height: 16 / 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 20.sp,
                  color: AppColors.accent,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    'Small, specific details are easier to remember.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7D6961),
                      fontSize: 12.sp,
                      height: 18 / 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
