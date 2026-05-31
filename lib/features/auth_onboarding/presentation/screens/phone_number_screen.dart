import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../widgets/components/phone_number_input.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 175.h),
            Text(
              "What's your phone number?",
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
              "We only ask to verify it's you. It won't show up anywhere, including your profile.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            const PhoneNumberInput(),
            const Spacer(),
            CircleArrowButton(onPressed: onNext),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
