import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  bool _companyVisible = false;
  bool _jobTitleVisible = false;

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 175.h),
                  Text(
                    'What keeps you busy these\ndays?',
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
                    'Each question is optional, but including this can give others a window into your world.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorant(
                      fontSize: 12.sp,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.0.h,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _FieldCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardHeading('Where do you work?'),
                        SizedBox(height: 16.h),
                        RoundedTextInput(
                          controller: _companyController,
                          hintText: 'In your words',
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: 16.h),
                        _VisibilityToggle(
                          visible: _companyVisible,
                          onTap: () => setState(
                            () => _companyVisible = !_companyVisible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _FieldCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardHeading("What’s your job title?"),
                        SizedBox(height: 6.h),
                        Text(
                          "If you’re student, you’re welcome to mention that instead.",
                          style: GoogleFonts.cormorant(
                            color: AppColors.textPrimary,
                            fontSize: 12.sp,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        RoundedTextInput(
                          controller: _jobTitleController,
                          hintText: 'In your words',
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: 16.h),
                        _VisibilityToggle(
                          visible: _jobTitleVisible,
                          onTap: () => setState(
                            () => _jobTitleVisible = !_jobTitleVisible,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          CircleArrowButton(onPressed: widget.onNext),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _CardHeading extends StatelessWidget {
  const _CardHeading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.cormorant(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.0.h,
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
      ),
      child: child,
    );
  }
}

class _VisibilityToggle extends StatelessWidget {
  const _VisibilityToggle({required this.visible, required this.onTap});
  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: visible ? AppColors.accent : const Color(0xFFD0D0D0),
                width: 1.w,
              ),
            ),
            child: visible
                ? Icon(Icons.check, size: 14.sp, color: AppColors.textPrimary)
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            'Visible on profile',
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.0.h,
            ),
          ),
        ],
      ),
    );
  }
}
