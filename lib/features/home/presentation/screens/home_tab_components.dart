import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class OotTabPage extends StatelessWidget {
  const OotTabPage({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 32.h),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eyebrow.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: AppColors.accent,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      title,
                      style: GoogleFonts.cormorant(
                        color: AppColors.textPrimary,
                        fontSize: 38.sp,
                        height: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12.sp,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[SizedBox(width: 12.w), trailing!],
            ],
          ),
          SizedBox(height: 24.h),
          ...children,
        ],
      ),
    );
  }
}

class OotSectionTitle extends StatelessWidget {
  const OotSectionTitle(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.cormorant(
              color: AppColors.textPrimary,
              fontSize: 26.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ?action,
      ],
    );
  }
}

class OotSurfaceCard extends StatelessWidget {
  const OotSurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.color = AppColors.surface,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
