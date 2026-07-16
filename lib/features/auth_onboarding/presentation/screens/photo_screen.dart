import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final Set<int> _added = {};

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 5,
      totalSteps: 5,
      buttonLabel: 'Finish setup',
      onContinue: widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your profile',
            title: 'Add your best moments',
            description:
                'Start with 3–6 clear photos. You can update them anytime.',
          ),
          SizedBox(height: 34.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const OotSectionLabel('Your photos'),
              Text(
                '${_added.length} / 6',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 12.sp,
                  height: 18 / 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          for (var row = 0; row < 3; row++) ...[
            Row(
              children: [
                Expanded(child: _slot(row * 2)),
                SizedBox(width: 10.w),
                Expanded(child: _slot(row * 2 + 1)),
              ],
            ),
            if (row != 2) SizedBox(height: 10.h),
          ],
        ],
      ),
    );
  }

  Widget _slot(int index) {
    final main = index == 0;
    final added = _added.contains(index);
    return GestureDetector(
      onTap: () => setState(() {
        if (!_added.add(index)) _added.remove(index);
      }),
      child: Container(
        height: 112.h,
        decoration: BoxDecoration(
          color: main ? AppColors.surfaceSelected : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: main ? AppColors.accent : const Color(0xFFDCCEC7),
            style: main ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              added
                  ? Icons.check_circle_rounded
                  : main
                  ? Icons.camera_alt_outlined
                  : Icons.add_rounded,
              size: main ? 28.sp : 24.sp,
              color: AppColors.accent,
            ),
            SizedBox(height: main ? 4.h : 8.h),
            Text(
              added
                  ? 'Photo added'
                  : main
                  ? 'Add main photo'
                  : 'Add photo',
              style: GoogleFonts.inter(
                color: main ? AppColors.label : AppColors.textMuted,
                fontSize: 12.sp,
                height: 18 / 12,
                fontWeight: main ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (main) ...[
              SizedBox(height: 4.h),
              Text(
                'Required',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: 10.sp,
                  height: 14 / 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
