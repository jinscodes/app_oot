import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class SelectableOptionPill extends StatelessWidget {
  const SelectableOptionPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.height,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.accent : const Color(0xFFD0D0D0);
    final borderWidth = selected ? 2.w : 1.5.w;
    final textColor = selected
        ? AppColors.textPrimary
        : const Color(0xFFBDBDBD);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height ?? 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            letterSpacing: 0.0.h,
          ),
        ),
      ),
    );
  }
}
