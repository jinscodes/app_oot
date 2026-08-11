import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  static const _countries = <String, String>{
    'KR': '🇰🇷',
    'JP': '🇯🇵',
    'US': '🇺🇸',
  };

  final TextEditingController _school = TextEditingController();
  String _countryCode = 'KR';
  bool _visible = true;

  @override
  void dispose() {
    _school.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Match preferences',
      currentStep: 3,
      totalSteps: 7,
      buttonLabel: 'Continue',
      onContinue: widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your story',
            title: 'Where did you study?',
            description:
                'Optional, but it can be an easy conversation starter.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('School'),
          SizedBox(height: 10.h),
          Container(
            height: 188.h,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where did or do you go to school?',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      key: const ValueKey('education-country-selector'),
                      initialValue: _countryCode,
                      tooltip: 'Select school country',
                      offset: Offset(0, 52.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      onSelected: (countryCode) =>
                          setState(() => _countryCode = countryCode),
                      itemBuilder: (context) => _countries.entries
                          .map(
                            (country) => PopupMenuItem<String>(
                              value: country.key,
                              child: Text(
                                '${country.value}  ${country.key}',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      child: Container(
                        width: 100.w,
                        height: 52.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F3EF),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${_countries[_countryCode]}  $_countryCode',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18.sp,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.borderStrong),
                        ),
                        child: TextField(
                          controller: _school,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 13.sp,
                            height: 20 / 13,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ex) Seoul National University',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF9A8880),
                              fontSize: 13.sp,
                              height: 20 / 13,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.school_outlined,
                              size: 18.sp,
                              color: AppColors.textMuted,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 16.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Show on profile',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B5A53),
                          fontSize: 12.sp,
                          height: 18 / 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OotToggle(
                      value: _visible,
                      onChanged: (value) => setState(() => _visible = value),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'You can add or update schools anytime.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
