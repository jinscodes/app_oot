import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: BorderSide(color: AppColors.accent, width: 1.5.w),
        ),
        child: Icon(Icons.chevron_right, size: 22.sp),
      ),
    );
  }
}
