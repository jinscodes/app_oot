import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class CircleArrowButton extends StatelessWidget {
  const CircleArrowButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final color = enabled ? AppColors.accent : const Color(0xFFBDBDBD);
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          disabledForegroundColor: color,
          padding: EdgeInsets.zero,
          shape: const CircleBorder(),
          side: BorderSide(color: color, width: 2.w),
        ),
        child: Icon(Icons.chevron_right, size: 22.sp),
      ),
    );
  }
}
