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
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          Positioned(
            left: 163.w,
            top: 277.h,
            child: Image.asset(
              'assets/images/talking_logo.png',
              width: 110.w,
              height: 110.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 264.w,
            top: 223.h,
            child: Container(
              width: 76.w,
              height: 54.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(27.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1C6E4C40),
                    blurRadius: 10,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Text(
                'Hi!',
                style: GoogleFonts.cormorant(
                  color: const Color(0xFF3B2924),
                  fontSize: 25.sp,
                  height: 30 / 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 392.h,
            child: Text(
              'Only One Touch',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                color: AppColors.accent,
                fontSize: 30.sp,
                height: 36 / 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const _ConsentCard(),
          _CreateAccountButton(onPressed: onCreateAccount),
          Positioned(
            left: 170.w,
            right: 170.w,
            top: 867.h,
            height: 45.h,
            child: TextButton(
              onPressed: onSignIn,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accent,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Sign in',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  height: 15 / 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20.w,
      top: 666.h,
      child: Container(
        width: 400.w,
        height: 123.h,
        decoration: BoxDecoration(
          color: AppColors.termsBackground,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20.w,
              top: 23.h,
              child: Icon(
                Icons.gpp_good_outlined,
                color: const Color(0xFFEE8D7B),
                size: 24.sp,
              ),
            ),
            Positioned(
              left: 64.w,
              top: 19.h,
              width: 322.w,
              child: const _ConsentText(
                prefix:
                    'By tapping ‘Sign in’ / ‘Create account’, you agree to our ',
                firstLink: 'Terms of Service',
                suffix: '.',
              ),
            ),
            Positioned(
              left: 20.w,
              top: 72.h,
              child: Icon(
                Icons.lock_outline,
                color: const Color(0xFFEE8D7B),
                size: 24.sp,
              ),
            ),
            Positioned(
              left: 64.w,
              top: 68.h,
              width: 322.w,
              child: const _ConsentText(
                prefix: 'Learn how we process your data in our ',
                firstLink: 'Privacy Policy',
                betweenLinks: ' and ',
                secondLink: 'Cookies Policy',
                suffix: '.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentText extends StatelessWidget {
  const _ConsentText({
    required this.prefix,
    required this.firstLink,
    required this.suffix,
    this.betweenLinks,
    this.secondLink,
  });

  final String prefix;
  final String firstLink;
  final String suffix;
  final String? betweenLinks;
  final String? secondLink;

  @override
  Widget build(BuildContext context) {
    final regularStyle = GoogleFonts.inter(
      color: Colors.black,
      fontSize: 12.sp,
      height: 15 / 12,
      fontWeight: FontWeight.w400,
    );
    final linkStyle = regularStyle.copyWith(
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: Colors.black,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: prefix, style: regularStyle),
          TextSpan(text: firstLink, style: linkStyle),
          if (secondLink != null) ...[
            TextSpan(text: betweenLinks, style: regularStyle),
            TextSpan(text: secondLink, style: linkStyle),
          ],
          TextSpan(text: suffix, style: regularStyle),
        ],
      ),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20.w,
      top: 802.h,
      child: Material(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18.r),
          child: Container(
            width: 400.w,
            height: 58.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2E6B4B43),
                  blurRadius: 24,
                  spreadRadius: -4,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              'Create account',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
