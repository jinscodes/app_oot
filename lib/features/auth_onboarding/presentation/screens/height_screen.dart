import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';

const int _minHeightCm = 140;
const int _maxHeightCm = 220;
const int _defaultHeightCm = 170;

class HeightScreen extends StatefulWidget {
  const HeightScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  int _selectedHeight = _defaultHeightCm;
  late final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(
        initialItem: _defaultHeightCm - _minHeightCm,
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 175.h),
                Text(
                  "What's your height?",
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
                  "Choose your height. We'll show your height on your profile.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cormorant(
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.0.h,
                  ),
                ),
                const Spacer(),
                CircleArrowButton(onPressed: widget.onNext),
                SizedBox(height: 32.h),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 220.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CupertinoPicker(
                  itemExtent: 44.h,
                  scrollController: _scrollController,
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedHeight = _minHeightCm + index);
                  },
                  selectionOverlay: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.accent,
                          width: 1.5.w,
                        ),
                        bottom: BorderSide(
                          color: AppColors.accent,
                          width: 1.5.w,
                        ),
                      ),
                    ),
                  ),
                  children: [
                    for (var h = _minHeightCm; h <= _maxHeightCm; h++)
                      Center(
                        child: Text(
                          '$h cm',
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: h == _selectedHeight
                                ? AppColors.textPrimary
                                : AppColors.textPrimary.withValues(alpha: 0.4),
                            letterSpacing: 0.0.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
