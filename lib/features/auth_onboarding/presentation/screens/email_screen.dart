import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key, this.onNext});

  final ValueChanged<String>? onNext;

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isValid = false;
  bool _optOutMarketing = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    final valid = _emailController.text.trim().isNotEmpty;
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
              "What's your email?",
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
              "We'll use your email to send you communications, including a verification code. It won't be shared with other daters.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 28.h),
            RoundedTextInput(
              controller: _emailController,
              hintText: 'Email',
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            SizedBox(height: 12.h),
            _MarketingOptOutCard(
              value: _optOutMarketing,
              onChanged: (v) => setState(() => _optOutMarketing = v),
            ),
            const Spacer(),
            CircleArrowButton(
              onPressed: _isValid
                  ? () => widget.onNext?.call(_emailController.text.trim())
                  : null,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _MarketingOptOutCard extends StatelessWidget {
  const _MarketingOptOutCard({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              side: BorderSide(color: AppColors.accent, width: 1.5.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              activeColor: AppColors.accent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'If you do not wish to receive marketing communications about our products services, check this box',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11.sp,
                height: 1.3,
                letterSpacing: 0.0.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
