import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class ConsentDisclaimerText extends StatelessWidget {
  const ConsentDisclaimerText({super.key});

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

    return Text.rich(
      const TextSpan(
        children: [
          TextSpan(
            text: "By tapping 'Sign in' / 'Create account', you agree to our ",
          ),
          TextSpan(text: 'Terms of Service', style: linkStyle),
          TextSpan(text: '. Learn how we process your data in our '),
          TextSpan(text: 'Privacy Policy', style: linkStyle),
          TextSpan(text: ' and '),
          TextSpan(text: 'Cookies Policy', style: linkStyle),
          TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 10.sp,
        height: 0.0.h,
        letterSpacing: 0.0,
      ),
    );
  }
}
