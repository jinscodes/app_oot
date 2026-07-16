import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  static const _min = 140;
  int _selected = 170;
  late final FixedExtentScrollController _controller =
      FixedExtentScrollController(initialItem: _selected - _min);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile basics',
      currentStep: 4,
      totalSteps: 4,
      buttonLabel: 'Continue',
      onContinue: widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Profile details',
            title: 'What’s your height?',
            description: 'We’ll show this on your profile.',
          ),
          SizedBox(height: 34.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('Height'),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 220.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IgnorePointer(
                  child: Container(
                    height: 52.h,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5.w,
                      ),
                    ),
                  ),
                ),
                ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: 40.h,
                  diameterRatio: 2.1,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) =>
                      setState(() => _selected = _min + index),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: 81,
                    builder: (context, index) {
                      final value = _min + index;
                      final distance = (value - _selected).abs();
                      return Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$value',
                                style: GoogleFonts.inter(
                                  color: distance == 0
                                      ? AppColors.textPrimary
                                      : distance == 1
                                      ? AppColors.textSecondary
                                      : const Color(0xFFB2A8A3),
                                  fontSize: distance == 0
                                      ? 28.sp
                                      : distance == 1
                                      ? 18.sp
                                      : 15.sp,
                                  fontWeight: distance == 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (distance == 0)
                                TextSpan(
                                  text: ' cm',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Shown on your profile. You can update it anytime.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
