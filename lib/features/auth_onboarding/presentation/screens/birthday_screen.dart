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
  final TextEditingController _year = TextEditingController();
  final TextEditingController _month = TextEditingController();
  final TextEditingController _day = TextEditingController();
  final FocusNode _yearFocus = FocusNode();
  final FocusNode _monthFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();
  bool _showConfirmation = false;

  DateTime? get _birthDate {
    if (_year.text.length != 4 ||
        _month.text.length != 2 ||
        _day.text.length != 2) {
      return null;
    }

    final year = int.tryParse(_year.text);
    final month = int.tryParse(_month.text);
    final day = int.tryParse(_day.text);
    if (year == null || month == null || day == null || year < 1) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  bool get _valid => _birthDate?.isBefore(DateTime.now()) ?? false;

  int get _age {
    final birth = _birthDate;
    if (birth == null) return 0;
    final now = DateTime.now();
    var age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  String get _formattedBirthday {
    final birth = _birthDate;
    if (birth == null) return '';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[birth.month - 1]} ${birth.day}, ${birth.year}';
  }

  void _onDateChanged() {
    setState(() => _showConfirmation = false);
  }

  void _onContinue() {
    if (!_valid) return;
    if (!_showConfirmation) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _showConfirmation = true);
      return;
    }
    widget.onNext?.call();
  }

  @override
  void dispose() {
    _year.dispose();
    _month.dispose();
    _day.dispose();
    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile basics',
      currentStep: 2,
      totalSteps: 4,
      buttonLabel: 'Continue',
      onContinue: _valid ? _onContinue : null,
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
                  focusNode: _yearFocus,
                  nextFocusNode: _monthFocus,
                  hintText: 'YYYY',
                  length: 4,
                  autofocus: true,
                  onChanged: _onDateChanged,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 110,
                child: _DateField(
                  controller: _month,
                  focusNode: _monthFocus,
                  nextFocusNode: _dayFocus,
                  hintText: 'MM',
                  length: 2,
                  onChanged: _onDateChanged,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 110,
                child: _DateField(
                  controller: _day,
                  focusNode: _dayFocus,
                  hintText: 'DD',
                  length: 2,
                  onChanged: _onDateChanged,
                ),
              ),
            ],
          ),
          if (_showConfirmation) ...[
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
                          _formattedBirthday,
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
          ],
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
    required this.focusNode,
    required this.hintText,
    required this.length,
    required this.onChanged,
    this.nextFocusNode,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String hintText;
  final int length;
  final VoidCallback onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      textInputAction: nextFocusNode == null
          ? TextInputAction.done
          : TextInputAction.next,
      textAlign: TextAlign.center,
      maxLength: length,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) {
        onChanged();
        if (value.length == length) nextFocusNode?.requestFocus();
      },
      onSubmitted: (_) => nextFocusNode?.requestFocus(),
      style: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 15.sp,
        height: 20 / 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF9A8880),
          fontSize: 15.sp,
          height: 20 / 15,
          fontWeight: FontWeight.w500,
        ),
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.borderStrong, width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
      ),
    );
  }
}
