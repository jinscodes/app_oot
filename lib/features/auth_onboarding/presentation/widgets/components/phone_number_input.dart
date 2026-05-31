import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class PhoneNumberInput extends StatelessWidget {
  const PhoneNumberInput({
    super.key,
    this.countryFlag = '🇰🇷',
    this.dialCode = '+82',
    this.controller,
  });

  final String countryFlag;
  final String dialCode;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: AppColors.accent, width: 1.5.w);
    final radius = BorderRadius.circular(16.r);
    final height = 48.h;

    final valueStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14.sp,
      letterSpacing: 0.0.h,
    );

    return Row(
      children: [
        Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: radius,
            border: Border.fromBorderSide(borderSide),
          ),
          child: Row(
            children: [
              Text(countryFlag, style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 10.w),
              Text(dialCode, style: valueStyle),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: radius,
              border: Border.fromBorderSide(borderSide),
            ),
            alignment: Alignment.centerLeft,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: valueStyle,
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  letterSpacing: 0.0.h,
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
