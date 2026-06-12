import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/buttons/selectable_option_pill.dart';

enum EducationLevel {
  highSchool,
  collegeDegree,
  graduateDegree,
  msOrPhd,
  preferNotToSay,
}

extension on EducationLevel {
  String get label {
    switch (this) {
      case EducationLevel.highSchool:
        return 'High school';
      case EducationLevel.collegeDegree:
        return 'College degree';
      case EducationLevel.graduateDegree:
        return 'Graduate degree';
      case EducationLevel.msOrPhd:
        return 'MS or PhD';
      case EducationLevel.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

class EducationLevelScreen extends StatefulWidget {
  const EducationLevelScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<EducationLevelScreen> createState() => _EducationLevelScreenState();
}

class _EducationLevelScreenState extends State<EducationLevelScreen> {
  EducationLevel? _selected;
  bool _visibleOnProfile = false;

  void _select(EducationLevel level) {
    setState(() => _selected = level);
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
                    'A little bit more about\nyour education',
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
                    "You don’t have to include it, but it might spark something familiar for someone else.",
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
                        Text(
                          "What’s the highest level of education\nyou've completed?",
                          style: GoogleFonts.cormorant(
                            color: AppColors.textPrimary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        for (final level in EducationLevel.values) ...[
                          SelectableOptionPill(
                            label: level.label,
                            selected: _selected == level,
                            onTap: () => _select(level),
                            height: 40.h,
                          ),
                          SizedBox(height: 10.h),
                        ],
                        SizedBox(height: 4.h),
                        _VisibilityToggle(
                          visible: _visibleOnProfile,
                          onTap: () => setState(
                            () => _visibleOnProfile = !_visibleOnProfile,
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
          CircleArrowButton(
            onPressed: _selected != null ? widget.onNext : null,
          ),
          SizedBox(height: 32.h),
        ],
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
            visible ? 'Hidden on profile' : 'Visible on profile',
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
