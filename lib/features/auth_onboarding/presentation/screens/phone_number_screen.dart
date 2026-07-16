import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/oot_design_system.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key, this.onNext});

  final ValueChanged<String>? onNext;

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _controller = TextEditingController();
  Country _country = Country.parse('KR');
  bool _valid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final valid = digits.length >= 8;
    if (valid != _valid) setState(() => _valid = valid);
  }

  void _pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (country) => setState(() => _country = country),
    );
  }

  void _continue() {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    widget.onNext?.call('+${_country.phoneCode}$digits');
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Your number',
      currentStep: 2,
      totalSteps: 6,
      buttonLabel: 'Continue',
      onContinue: _valid ? _continue : null,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Secure sign-up',
            title: 'What’s your number?',
            description:
                'We’ll send a one-time code to make sure it’s really you.',
          ),
          SizedBox(height: 34.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('Mobile number'),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 58.h,
            padding: EdgeInsets.only(left: 14.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.primary, width: 1.5.w),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x146B4B43),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _pickCountry,
                  child: Row(
                    children: [
                      Text(
                        _country.flagEmoji,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '+${_country.phoneCode}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF46352F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textMuted,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 24.h,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  color: const Color(0xFFE6DBD5),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                    ],
                    onChanged: _onChanged,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      height: 22 / 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '010 1234 5678',
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textPrimary.withValues(alpha: .45),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14.sp,
                color: AppColors.textMuted,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Text(
                  'Used only for verification — never shown on your profile.',
                  style: ootHelperStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
