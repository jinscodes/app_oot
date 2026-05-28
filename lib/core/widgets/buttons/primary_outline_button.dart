import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class PrimaryOutlineButton extends StatelessWidget {
  const PrimaryOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accent,
        minimumSize: Size.fromHeight(42.h),
        side: BorderSide(color: AppColors.accent, width: 3.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        textStyle: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.0,
        ),
      ),
      child: Text(label),
    );
  }
}
