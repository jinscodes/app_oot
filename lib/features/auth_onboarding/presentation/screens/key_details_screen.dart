import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class KeyDetailsScreen extends StatefulWidget {
  const KeyDetailsScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<KeyDetailsScreen> createState() => _KeyDetailsScreenState();
}

class _KeyDetailsScreenState extends State<KeyDetailsScreen> {
  static const _options = [
    'Name & age',
    'Gender & nationality',
    'Location',
    'Connection type',
    'School',
    'Job title',
  ];
  final Set<int> _selected = {0, 2, 3};

  void _toggle(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else if (_selected.length < 3) {
        _selected.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 3,
      totalSteps: 5,
      buttonLabel: 'Continue',
      onContinue: _selected.isEmpty ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Profile highlights',
            title: 'What should stand out?',
            description: 'Choose up to three details people see first.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Choose up to 3'),
          SizedBox(height: 10.h),
          for (var row = 0; row < 3; row++) ...[
            Row(
              children: [
                Expanded(child: _option(row * 2)),
                SizedBox(width: 10.w),
                Expanded(child: _option(row * 2 + 1)),
              ],
            ),
            if (row != 2) SizedBox(height: 10.h),
          ],
          SizedBox(height: 10.h),
          Container(
            height: 38.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selected.length} of 3 selected',
                  style: GoogleFonts.inter(
                    color: AppColors.label,
                    fontSize: 12.sp,
                    height: 18 / 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Change anytime',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 11.sp,
                    height: 16 / 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _option(int index) => OotSelectOption(
    option: OotOptionData(_options[index]),
    selected: _selected.contains(index),
    onTap: () => _toggle(index),
    height: 62,
    compact: false,
  );
}
