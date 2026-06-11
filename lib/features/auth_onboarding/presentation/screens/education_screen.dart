import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final TextEditingController _schoolController = TextEditingController();
  bool _visibleOnProfile = false;
  Country? _country = Country.parse('KR');

  @override
  void dispose() {
    _schoolController.dispose();
    super.dispose();
  }

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      favorite: const ['KR', 'JP', 'US', 'GB'],
      countryListTheme: CountryListThemeData(
        backgroundColor: AppColors.background,
        bottomSheetHeight: 600.h,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.accent, width: 1.w),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() => _country = country);
      },
    );
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
                    'Your education background',
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
                    "You don’t have to include it, but it might help someone else.",
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
                          'Where did or do you go to school?',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.0.h,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            _CountryPickerBox(
                              country: _country,
                              onTap: _openCountryPicker,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: RoundedTextInput(
                                controller: _schoolController,
                                hintText: 'School',
                                textCapitalization:
                                    TextCapitalization.words,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _ProfileVisibilityToggle(
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
          CircleArrowButton(onPressed: widget.onNext),
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

class _CountryPickerBox extends StatelessWidget {
  const _CountryPickerBox({required this.country, required this.onTap});

  final Country? country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = country;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.accent, width: 1.5.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: c == null
              ? [
                  Text(
                    'N/A',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      letterSpacing: 0.0.h,
                    ),
                  ),
                ]
              : [
                  Text(c.flagEmoji, style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: 6.w),
                  Text(
                    c.countryCode,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      letterSpacing: 0.0.h,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class _ProfileVisibilityToggle extends StatelessWidget {
  const _ProfileVisibilityToggle({required this.visible, required this.onTap});
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
              border: Border.all(color: const Color(0xFFD0D0D0), width: 1.w),
            ),
            child: visible
                ? Icon(Icons.check, size: 14.sp, color: AppColors.textPrimary)
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            'Visible on profile',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              letterSpacing: 0.0.h,
            ),
          ),
        ],
      ),
    );
  }
}
