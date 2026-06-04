import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/buttons/circle_arrow_button.dart';

class OnboardingPromptScreen extends StatelessWidget {
  const OnboardingPromptScreen({
    super.key,
    required this.imageAsset,
    required this.title,
    this.onNext,
  });

  final String imageAsset;
  final String title;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(imageAsset, fit: BoxFit.cover)),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.7)],
                  stops: [0.45, 1.0],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cormorant(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: 0.0.h,
                      ),
                    ),
                    CircleArrowButton(color: Colors.white, onPressed: onNext),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
