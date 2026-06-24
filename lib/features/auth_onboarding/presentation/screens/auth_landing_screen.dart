import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'assets/images/talking_logo.png',
                          width: 110.w,
                          height: 110.w,
                        ),
                        Positioned(
                          top: -50.h,
                          right: -80.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/bubble1.png',
                                width: 120.w,
                              ),
                              Positioned(
                                top: 22.h,
                                child: Text(
                                  'Hi',
                                  style: GoogleFonts.cormorant(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Only One Touch',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorant(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        letterSpacing: 0.0.h,
                      ),
                    ),
                  ],
                ),
              ),
              _TermsContainer(),
              SizedBox(height: 32.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCreateAccount,
                    borderRadius: BorderRadius.circular(24.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Center(
                        child: Text(
                          'Create account',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onSignIn,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0.h,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(16.w),
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.termsBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _TermsRow(
            icon: Icons.favorite_outline,
            text: "By tapping 'Sign in' / 'Create account', you agree to our ",
            linkText: 'Terms of Service',
            onLinkTap: () {},
          ),
          SizedBox(height: 12.h),
          _TermsRow(
            icon: Icons.lock_outline,
            text: 'Learn how we process your data in our ',
            linkText: 'Privacy Policy',
            secondLinkText: 'Cookies Policy',
            onLinkTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  const _TermsRow({
    required this.icon,
    required this.text,
    required this.linkText,
    this.secondLinkText,
    required this.onLinkTap,
  });

  final IconData icon;
  final String text;
  final String linkText;
  final String? secondLinkText;
  final VoidCallback onLinkTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.primary, size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11.sp,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: linkText,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                if (secondLinkText != null) ...[
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11.sp,
                    ),
                  ),
                  TextSpan(
                    text: secondLinkText,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
