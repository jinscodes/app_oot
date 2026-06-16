import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

const List<String> _monthNames = [
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

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final FocusNode _yearFocusNode = FocusNode();
  final FocusNode _monthFocusNode = FocusNode();
  final FocusNode _dayFocusNode = FocusNode();
  bool _isValid = false;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _yearController.addListener(_onYearChanged);
    _monthController.addListener(_onMonthChanged);
    _dayController.addListener(_recheckValidity);
  }

  @override
  void dispose() {
    _yearController.removeListener(_onYearChanged);
    _monthController.removeListener(_onMonthChanged);
    _dayController.removeListener(_recheckValidity);
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _yearFocusNode.dispose();
    _monthFocusNode.dispose();
    _dayFocusNode.dispose();
    super.dispose();
  }

  void _onYearChanged() {
    _recheckValidity();
    if (_yearController.text.length == 4 && _yearFocusNode.hasFocus) {
      _monthFocusNode.requestFocus();
    }
  }

  void _onMonthChanged() {
    _recheckValidity();
    if (_monthController.text.length == 2 && _monthFocusNode.hasFocus) {
      _dayFocusNode.requestFocus();
    }
  }

  int _daysInMonth(int month, int? year) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12:
        return 31;
      case 4:
      case 6:
      case 9:
      case 11:
        return 30;
      case 2:
        final isLeap = year != null &&
            year % 4 == 0 &&
            (year % 100 != 0 || year % 400 == 0);
        return isLeap ? 29 : 28;
      default:
        return 0;
    }
  }

  void _recheckValidity() {
    final y = _year;
    final m = _month;
    final d = _day;
    final valid = y != null &&
        m != null &&
        d != null &&
        m >= 1 &&
        m <= 12 &&
        d >= 1 &&
        d <= _daysInMonth(m, y);
    if (valid != _isValid) setState(() => _isValid = valid);
    if (_showConfirmation) {
      setState(() => _showConfirmation = false);
    }
  }

  int? get _year => int.tryParse(_yearController.text);
  int? get _month => int.tryParse(_monthController.text);
  int? get _day => int.tryParse(_dayController.text);

  int? get _age {
    final y = _year;
    final m = _month;
    final d = _day;
    if (y == null || m == null || d == null) return null;
    final now = DateTime.now();
    var age = now.year - y;
    if (now.month < m || (now.month == m && now.day < d)) age--;
    return age;
  }

  String get _formattedDate {
    final y = _year;
    final m = _month;
    final d = _day;
    if (y == null || m == null || d == null) return '';
    if (m < 1 || m > 12) return '';
    return '${_monthNames[m - 1]} $d, $y';
  }

  void _handleNext() {
    if (!_isValid) return;
    if (!_showConfirmation) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() => _showConfirmation = true);
    } else {
      widget.onNext?.call();
    }
  }

  void _handleEdit() {
    setState(() => _showConfirmation = false);
    _yearController.selection = TextSelection.fromPosition(
      TextPosition(offset: _yearController.text.length),
    );
    _yearFocusNode.requestFocus();
  }

  void _handleConfirm() {
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final showCard = _showConfirmation && _age != null && !keyboardOpen;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 175.h),
            Text(
              'When is your\nbirthday?',
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
              "We'll only show your age on your profile.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            Row(
              children: [
                Expanded(
                  child: RoundedTextInput(
                    controller: _yearController,
                    focusNode: _yearFocusNode,
                    hintText: 'Year',
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RoundedTextInput(
                    controller: _monthController,
                    focusNode: _monthFocusNode,
                    hintText: 'Month',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: RoundedTextInput(
                    controller: _dayController,
                    focusNode: _dayFocusNode,
                    hintText: 'Day',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (showCard) ...[
              _ConfirmationCard(
                age: _age!,
                dateText: _formattedDate,
                onEdit: _handleEdit,
                onConfirm: _handleConfirm,
              ),
              SizedBox(height: 16.h),
            ],
            CircleArrowButton(onPressed: _isValid ? _handleNext : null),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({
    required this.age,
    required this.dateText,
    required this.onEdit,
    required this.onConfirm,
  });

  final int age;
  final String dateText;
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
            "You're $age",
            style: GoogleFonts.cormorant(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.0.h,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Born $dateText',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12.sp,
              letterSpacing: 0.0.h,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Make sure your age is correct before moving on. It keeps OOT real for everyone.',
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
