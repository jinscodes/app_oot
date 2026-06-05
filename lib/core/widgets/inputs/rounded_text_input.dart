import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_colors.dart';

class RoundedTextInput extends StatelessWidget {
  const RoundedTextInput({
    super.key,
    required this.hintText,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
  });

  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: AppColors.accent, width: 1.5.w);
    final radius = BorderRadius.circular(16.r);

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.fromBorderSide(borderSide),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        autofillHints: autofillHints,
        textAlign: textAlign,
        inputFormatters: inputFormatters,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          letterSpacing: 0.0.h,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFFBDBDBD),
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
    );
  }
}
