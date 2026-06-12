import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';

enum ChildrenStatus { none, hasChildren, preferNotToSay }

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  ChildrenStatus? _selected;
  bool _visibleOnProfile = false;

  void _select(ChildrenStatus status) {
    setState(() => _selected = status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 175.h),
            Text(
              'Do you have children?',
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
            _ChildrenOptionTile(
              label: "I don't have children",
              selected: _selected == ChildrenStatus.none,
              onTap: () => _select(ChildrenStatus.none),
            ),
            SizedBox(height: 12.h),
            _ChildrenOptionTile(
              label: 'I have children',
              selected: _selected == ChildrenStatus.hasChildren,
              onTap: () => _select(ChildrenStatus.hasChildren),
            ),
            SizedBox(height: 12.h),
            _ChildrenOptionTile(
              label: 'Prefer not to say',
              selected: _selected == ChildrenStatus.preferNotToSay,
              onTap: () => _select(ChildrenStatus.preferNotToSay),
            ),
            SizedBox(height: 16.h),
            Align(
              alignment: Alignment.centerLeft,
              child: _VisibilityToggle(
                visible: _visibleOnProfile,
                onTap: () =>
                    setState(() => _visibleOnProfile = !_visibleOnProfile),
              ),
            ),
            const Spacer(),
            CircleArrowButton(
              onPressed: _selected != null ? widget.onNext : null,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _ChildrenOptionTile extends StatelessWidget {
  const _ChildrenOptionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.accent : const Color(0xFFD0D0D0);
    final borderWidth = selected ? 2.w : 1.5.w;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            letterSpacing: 0.0.h,
          ),
        ),
      ),
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
        mainAxisSize: MainAxisSize.min,
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
