import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';

enum LegalPolicy {
  termsOfService(
    title: 'Terms of Service',
    introduction: 'A clear agreement for using OOT respectfully and safely.',
    sections: [
      LegalPolicySection(
        title: 'ACCOUNT & ELIGIBILITY',
        description:
            'Keep your profile accurate, be at least 18, and protect your '
            'sign-in details.',
      ),
      LegalPolicySection(
        title: 'RESPECT & SAFETY',
        description:
            'Treat people with care. Harassment, impersonation, and harmful '
            'content are not allowed.',
      ),
      LegalPolicySection(
        title: 'ENDING ACCESS',
        description:
            'You can leave anytime. OOT may restrict accounts that put the '
            'community at risk.',
      ),
    ],
  ),
  privacyPolicy(
    title: 'Privacy Policy',
    introduction:
        'How your information helps us create safer, more relevant connections.',
    sections: [
      LegalPolicySection(
        title: 'INFORMATION WE USE',
        description:
            'Profile details, preferences, activity, and safety signals you '
            'choose to share.',
      ),
      LegalPolicySection(
        title: 'WHY WE USE IT',
        description:
            'To personalize recommendations, run the service, prevent misuse, '
            'and support you.',
      ),
      LegalPolicySection(
        title: 'YOUR CHOICES',
        description:
            'Edit your profile, manage permissions, request your data, or '
            'delete your account.',
      ),
    ],
  ),
  cookiesPolicy(
    title: 'Cookies Policy',
    introduction:
        'Small files that keep sign-in secure and remember the choices you make.',
    sections: [
      LegalPolicySection(
        title: 'ESSENTIAL',
        description:
            'Required for authentication, fraud prevention, and core app '
            'functionality.',
      ),
      LegalPolicySection(
        title: 'PREFERENCES',
        description:
            'Remember settings such as language and the way you like to use '
            'OOT.',
      ),
      LegalPolicySection(
        title: 'YOUR CONTROL',
        description:
            'Non-essential cookies can be managed from privacy settings at '
            'any time.',
      ),
    ],
  );

  const LegalPolicy({
    required this.title,
    required this.introduction,
    required this.sections,
  });

  final String title;
  final String introduction;
  final List<LegalPolicySection> sections;
}

class LegalPolicySection {
  const LegalPolicySection({required this.title, required this.description});

  final String title;
  final String description;
}

Future<void> showLegalPolicyBottomSheet({
  required BuildContext context,
  required LegalPolicy policy,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x4D2D1E1A),
    useSafeArea: false,
    builder: (sheetContext) => _LegalPolicySheet(policy: policy),
  );
}

class _LegalPolicySheet extends StatelessWidget {
  const _LegalPolicySheet({required this.policy});

  final LegalPolicy policy;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final sheetHeight = math.min(646.h, screenHeight).toDouble();
    final bottomPadding = math.max(28.h, bottomInset).toDouble();

    return Container(
      key: ValueKey('legal-policy-sheet-${policy.name}'),
      height: sheetHeight,
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, bottomPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E2D1E1A),
            blurRadius: 16,
            offset: Offset(0, -12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9CBC5),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 46.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      policy.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorant(
                        color: AppColors.textPrimary,
                        fontSize: 30.sp,
                        height: 36 / 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  _CloseButton(policyTitle: policy.title),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              height: 44.h,
              child: Text(
                policy.introduction,
                style: GoogleFonts.inter(
                  color: const Color(0xFF766761),
                  fontSize: 13.sp,
                  height: 20 / 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Container(height: 1.h, color: const Color(0xFFEDE3DF)),
            SizedBox(height: 14.h),
            for (var index = 0; index < policy.sections.length; index++) ...[
              _PolicySection(section: policy.sections[index]),
              if (index < policy.sections.length - 1) SizedBox(height: 14.h),
            ],
            SizedBox(height: 14.h),
            SizedBox(
              height: 30.h,
              child: Text(
                'Last updated July 2026 · Full policy opens in the released app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9A8881),
                  fontSize: 10.sp,
                  height: 15 / 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.policyTitle});

  final String policyTitle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Close $policyTitle',
      child: Material(
        color: const Color(0xFFF6ECE8),
        shape: const CircleBorder(side: BorderSide(color: Color(0xFFEADBD5))),
        child: InkWell(
          key: const ValueKey('close-legal-policy-sheet'),
          onTap: () => Navigator.of(context).pop(),
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 40.w,
            child: Center(
              child: Text(
                '×',
                style: GoogleFonts.inter(
                  color: const Color(0xFF6B4B40),
                  fontSize: 22.sp,
                  height: 24 / 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.section});

  final LegalPolicySection section;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 14.h,
            child: Text(
              section.title,
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: 11.sp,
                height: 14 / 11,
                fontWeight: FontWeight.w600,
                letterSpacing: .66.w,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            section.description,
            style: GoogleFonts.inter(
              color: const Color(0xFF665954),
              fontSize: 12.sp,
              height: 18 / 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
