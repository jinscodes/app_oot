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
  bool _showConfirmation = false;

  void _select(Gender gender) {
    setState(() {
      _selected = gender;
      _showConfirmation = false;
    });
  }

  void _handleNext() {
    if (_selected == null) return;
    if (!_showConfirmation) {
      setState(() => _showConfirmation = true);
    } else {
      widget.onNext?.call();
    }
  }

  void _handleEdit() {
    setState(() => _showConfirmation = false);
  }

  void _handleConfirm() {
    widget.onNext?.call();
  }

  String get _nationality => _selected == Gender.woman ? 'Japanese' : 'Korean';
  String get _genderWord => _selected == Gender.woman ? 'woman' : 'man';

  @override
  Widget build(BuildContext context) {
    final showCard = _showConfirmation && _selected != null;
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
              onTap: () => _select(Gender.man),
            ),
            SizedBox(height: 12.h),
            SelectableOptionPill(
              label: 'Woman',
              selected: _selected == Gender.woman,
              onTap: () => _select(Gender.woman),
            ),
            const Spacer(),
            if (showCard) ...[
              _ConfirmationCard(
                nationality: _nationality,
                genderWord: _genderWord,
                onEdit: _handleEdit,
                onConfirm: _handleConfirm,
              ),
              SizedBox(height: 16.h),
            ],
            CircleArrowButton(
              onPressed: _selected != null ? _handleNext : null,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({
    required this.nationality,
    required this.genderWord,
    required this.onEdit,
    required this.onConfirm,
  });

  final String nationality;
  final String genderWord;
  final VoidCallback onEdit;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You're $nationality $genderWord",
            style: GoogleFonts.cormorant(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.0.h,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Make sure your nationality is correct before moving on. It keeps OOT real for everyone.',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11.sp,
              height: 1.4,
              letterSpacing: 0.0.h,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _EditButton(onPressed: onEdit),
              SizedBox(width: 10.w),
              _ConfirmButton(onPressed: onConfirm),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        backgroundColor: Colors.white,
        side: BorderSide(color: const Color(0xFFE5E5E5), width: 1.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        textStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0.h,
        ),
        minimumSize: Size.zero,
      ),
      child: const Text('Edit'),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        textStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.0.h,
        ),
        elevation: 0,
        minimumSize: Size.zero,
      ),
      child: const Text('Confirm'),
    );
  }
}
