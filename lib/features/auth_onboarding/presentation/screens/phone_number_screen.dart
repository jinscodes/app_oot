import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../widgets/components/phone_number_input.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key, this.onNext});

  final ValueChanged<String>? onNext;

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  bool _isValid = false;
  final TextEditingController _phoneController = TextEditingController();
  Country _country = Country.parse('KR');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final phone = '+${_country.phoneCode} ${_phoneController.text}';
    widget.onNext?.call(phone);
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
              "What's your phone number?",
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
              "We only ask to verify it's you. It won't show up anywhere, including your profile.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            PhoneNumberInput(
              controller: _phoneController,
              onValidityChanged: (valid) {
                if (valid != _isValid) setState(() => _isValid = valid);
              },
              onCountryChanged: (c) => _country = c,
            ),
            const Spacer(),
            CircleArrowButton(onPressed: _isValid ? _handleNext : null),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
