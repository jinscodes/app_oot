import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_onFirstNameChanged);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_onFirstNameChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onFirstNameChanged() {
    final valid = _firstNameController.text.trim().isNotEmpty;
    if (valid != _isValid) setState(() => _isValid = valid);
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
              "What's your Name",
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
              "We doesn’t verify your name or run background checks.We count on daters to be real with each other.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            RoundedTextInput(
              controller: _firstNameController,
              hintText: 'First Name',
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.givenName],
            ),
            SizedBox(height: 12.h),
            RoundedTextInput(
              controller: _lastNameController,
              hintText: 'Last Name (Optional)',
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.familyName],
            ),
            const Spacer(),
            CircleArrowButton(onPressed: _isValid ? widget.onNext : null),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
