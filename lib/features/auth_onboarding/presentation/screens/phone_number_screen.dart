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
      body: Stack(
        children: [
          Positioned(
            top: 120.h,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 310.w,
                height: 80.h,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/bubble2.png',
                      width: 310.w,
                      height: 80.h,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 22.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "What's your phone number?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorant(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 210.h,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/talking_logo.png',
                width: 80.w,
                height: 80.w,
              ),
            ),
          ),
          Positioned(
            top: 330.h,
            left: 20.w,
            right: 20.w,
            child: PhoneNumberInput(
              controller: _phoneController,
              onValidityChanged: (valid) {
                if (valid != _isValid) setState(() => _isValid = valid);
              },
              onCountryChanged: (c) => _country = c,
            ),
          ),
          Positioned(
            bottom: 32.h,
            left: 0,
            right: 0,
            child: Center(
              child: CircleArrowButton(
                onPressed: _isValid ? _handleNext : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
