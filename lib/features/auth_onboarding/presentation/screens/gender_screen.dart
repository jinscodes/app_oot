import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/buttons/selectable_option_pill.dart';

enum Gender { man, woman }

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  Gender? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 175.h),
            Text(
              'Which gender best\ndescribes you?',
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
              'Choose what describes you best. Gender choice will be automatically linked to nationality soon.\nMan - Korea\nWoman -Japan',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 32.h),
            SelectableOptionPill(
              label: 'Man',
              selected: _selected == Gender.man,
              onTap: () => setState(() => _selected = Gender.man),
            ),
            SizedBox(height: 12.h),
            SelectableOptionPill(
              label: 'Woman',
              selected: _selected == Gender.woman,
              onTap: () => setState(() => _selected = Gender.woman),
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
