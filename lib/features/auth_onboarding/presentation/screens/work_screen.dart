import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key, this.onNext, this.onChanged});

  final VoidCallback? onNext;
  final ValueChanged<Map<String, String>>? onChanged;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final TextEditingController _company = TextEditingController();
  final TextEditingController _role = TextEditingController();
  bool _visible = true;

  @override
  void dispose() {
    _company.dispose();
    _role.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Match preferences',
      currentStep: 5,
      totalSteps: 7,
      buttonLabel: 'Continue',
      onContinue: () {
        widget.onChanged?.call({
          'company': _company.text.trim(),
          'jobTitle': _role.text.trim(),
        });
        widget.onNext?.call();
      },
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your day-to-day',
            title: 'What keeps you busy?',
            description: 'Share as much or as little as you like.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Work'),
          SizedBox(height: 10.h),
          Container(
            height: 178.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _workField(
                  _company,
                  Icons.work_outline_rounded,
                  'Where do you work?',
                ),
                SizedBox(height: 10.h),
                _workField(
                  _role,
                  Icons.person_outline_rounded,
                  'What’s your job title?',
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
              'Student? You can add that here too.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _workField(
    TextEditingController controller,
    IconData icon,
    String hintText,
  ) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF9A8880),
            fontSize: 14.sp,
            height: 20 / 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(icon, size: 18.sp, color: AppColors.textMuted),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}
