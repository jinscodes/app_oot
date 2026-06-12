import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/buttons/selectable_option_pill.dart';

enum ConnectionType {
  lifePartner,
  longTerm,
  longTermOpenToShort,
  shortTermOpenToLong,
  shortTerm,
  figuringOut,
}

extension on ConnectionType {
  String get label {
    switch (this) {
      case ConnectionType.lifePartner:
        return 'Life partner';
      case ConnectionType.longTerm:
        return 'Long-term relationship';
      case ConnectionType.longTermOpenToShort:
        return 'Long-term, open to short';
      case ConnectionType.shortTermOpenToLong:
        return 'Short-term, open to long';
      case ConnectionType.shortTerm:
        return 'Short-term';
      case ConnectionType.figuringOut:
        return 'Figuring out my dating goals';
    }
  }
}

class ConnectionTypeScreen extends StatefulWidget {
  const ConnectionTypeScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<ConnectionTypeScreen> createState() => _ConnectionTypeScreenState();
}

class _ConnectionTypeScreenState extends State<ConnectionTypeScreen> {
  ConnectionType? _selected;

  void _select(ConnectionType type) {
    setState(() => _selected = type);
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
              'What kind of connection\nare you open to?',
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
              'Select one.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 32.h),
            for (final type in ConnectionType.values) ...[
              SelectableOptionPill(
                label: type.label,
                selected: _selected == type,
                onTap: () => _select(type),
              ),
              SizedBox(height: 12.h),
            ],
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
