import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {
  int? _alcohol;
  int? _smoking;
  bool _showAlcohol = true;
  bool _showSmoking = true;

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 2,
      totalSteps: 5,
      buttonLabel: 'Continue',
      onContinue: _alcohol == null || _smoking == null ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Lifestyle',
            title: 'A little about your lifestyle',
            description:
                'These details help us make more compatible introductions.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Your habits'),
          SizedBox(height: 10.h),
          _HabitCard(
            selectionKey: 'alcohol',
            question: 'Do you drink alcohol?',
            selection: _alcohol,
            visible: _showAlcohol,
            onSelect: (value) => setState(() => _alcohol = value),
            onVisibility: (value) => setState(() => _showAlcohol = value),
          ),
          SizedBox(height: 10.h),
          _HabitCard(
            selectionKey: 'smoking',
            question: 'Do you smoke tobacco or vape?',
            selection: _smoking,
            visible: _showSmoking,
            onSelect: (value) => setState(() => _smoking = value),
            onVisibility: (value) => setState(() => _showSmoking = value),
          ),
        ],
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({
    required this.selectionKey,
    required this.question,
    required this.selection,
    required this.visible,
    required this.onSelect,
    required this.onVisibility,
  });

  final String selectionKey;
  final String question;
  final int? selection;
  final bool visible;
  final ValueChanged<int> onSelect;
  final ValueChanged<bool> onVisibility;

  @override
  Widget build(BuildContext context) {
    const choices = ['Yes', 'Sometimes', 'No'];
    return Container(
      height: 140.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13.sp,
              height: 18 / 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              for (var index = 0; index < choices.length; index++) ...[
                Expanded(
                  child: Semantics(
                    key: ValueKey('$selectionKey-option-$index'),
                    button: true,
                    selected: selection == index,
                    inMutuallyExclusiveGroup: true,
                    child: GestureDetector(
                      onTap: () => onSelect(index),
                      child: Container(
                        height: 36.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selection == index
                              ? AppColors.surfaceSelected
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: selection == index
                                ? AppColors.accent
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          choices[index],
                          style: GoogleFonts.inter(
                            color: selection == index
                                ? AppColors.textPrimary
                                : const Color(0xFF6B5A53),
                            fontSize: 12.sp,
                            height: 18 / 12,
                            fontWeight: selection == index
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (index != choices.length - 1) SizedBox(width: 8.w),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                width: 126.w,
                height: 26.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Text(
                  'Prefer not to say',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7D6961),
                    fontSize: 11.sp,
                    height: 16 / 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Show on profile',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7D6961),
                  fontSize: 11.sp,
                  height: 16 / 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 8.w),
              OotToggle(compact: true, value: visible, onChanged: onVisibility),
            ],
          ),
        ],
      ),
    );
  }
}
