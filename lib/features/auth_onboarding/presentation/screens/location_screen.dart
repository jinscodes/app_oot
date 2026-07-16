import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'Chicago, IL, United States',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Match preferences',
      currentStep: 1,
      totalSteps: 7,
      buttonLabel: 'Continue',
      onContinue: _controller.text.trim().isEmpty ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your world',
            title: 'Where are you from?',
            description:
                'Share a place that feels like home — it’s completely optional.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Your location'),
          SizedBox(height: 10.h),
          const _NeighborhoodMap(),
          SizedBox(height: 10.h),
          Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14.sp,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppColors.textMuted,
                  size: 20.sp,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Only used to personalize nearby matches.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeighborhoodMap extends StatelessWidget {
  const _NeighborhoodMap();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        height: 184.h,
        color: const Color(0xFFEEE5DE),
        child: Stack(
          children: [
            _block(18, 18, 92, 48, const Color(0xFFE5D7CC)),
            _block(126, 14, 92, 58, const Color(0xFFE9DDD4)),
            _block(254, 18, 118, 68, const Color(0xFFDCE5D6)),
            _block(20, 118, 112, 48, const Color(0xFFE7DAD0)),
            _block(276, 112, 94, 54, const Color(0xFFE4D5CA)),
            Positioned(
              top: 82.h,
              left: 0,
              right: 0,
              child: Container(height: 20.h, color: AppColors.background),
            ),
            Positioned(
              left: 224.w,
              top: 0,
              bottom: 0,
              child: Container(width: 18.w, color: AppColors.background),
            ),
            Positioned(
              left: 211.w,
              top: 50.h,
              child: Icon(
                Icons.location_on_rounded,
                size: 46.sp,
                color: AppColors.accentStrong,
              ),
            ),
            Positioned(
              left: 140.w,
              top: 132.h,
              child: Container(
                width: 112.w,
                height: 32.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .94),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  'Chicago',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _block(
    double left,
    double top,
    double width,
    double height,
    Color color,
  ) {
    return Positioned(
      left: left.w,
      top: top.h,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
