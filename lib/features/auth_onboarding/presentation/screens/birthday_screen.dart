import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _year = TextEditingController(text: '1997');
  final TextEditingController _month = TextEditingController(text: '02');
  final TextEditingController _day = TextEditingController(text: '15');

  bool get _valid {
    final date = DateTime.tryParse(
      '${_year.text.padLeft(4, '0')}-${_month.text.padLeft(2, '0')}-${_day.text.padLeft(2, '0')}',
    );
    return date != null && date.isBefore(DateTime.now());
  }

  int get _age {
    final birth = DateTime.tryParse(
      '${_year.text}-${_month.text}-${_day.text}',
    );
    if (birth == null) return 0;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  @override
  void dispose() {
    _year.dispose();
    _month.dispose();
    _day.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile basics',
      currentStep: 2,
      totalSteps: 4,
      buttonLabel: 'Continue',
      onContinue: _valid ? widget.onNext : null,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your birthday',
            title: 'When were you born?',
            description: 'We’ll show only your age — never your full birthday.',
          ),
          SizedBox(height: 34.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('Date of birth'),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                flex: 148,
                child: _DateField(
                  controller: _year,
                  length: 4,
                  focused: true,
                  onChanged: () => setState(() {}),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 110,
                child: _DateField(
                  controller: _month,
                  length: 2,
                  onChanged: () => setState(() {}),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 110,
                child: _DateField(
                  controller: _day,
                  length: 2,
                  onChanged: () => setState(() {}),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            height: 88.h,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Looks right?',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 13.sp,
                          height: 18 / 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'February 15, 1997',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 32.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'Age $_age',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: 11.sp,
                      height: 15 / 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Only your age appears on your profile.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.length,
    required this.onChanged,
    this.focused = false,
  });

  final TextEditingController controller;
  final int length;
  final VoidCallback onChanged;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: length,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) => onChanged(),
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 15.sp,
        height: 20 / 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: focused ? AppColors.primary : AppColors.borderStrong,
            width: focused ? 1.5.w : 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
      ),
    );
  }
}
