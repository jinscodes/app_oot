import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/primary_outline_button.dart';
import '../widgets/components/consent_disclaimer_text.dart';

class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({
    super.key,
    required this.onCreateAccount,
    required this.onSignIn,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png', width: 80.w),
                      Text(
                        'Only One Touch',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ConsentDisclaimerText(),
              SizedBox(height: 24.h),
              PrimaryOutlineButton(
                label: 'Create account',
                onPressed: onCreateAccount,
              ),
              SizedBox(height: 4.h),
              TextButton(
                onPressed: onSignIn,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  textStyle: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.0.h,
                  ),
                ),
                child: const Text('Sign in'),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
