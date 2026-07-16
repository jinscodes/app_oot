import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/oot_design_system.dart';

class ReligiousScreen extends StatefulWidget {
  const ReligiousScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<ReligiousScreen> createState() => _ReligiousScreenState();
}

class _ReligiousScreenState extends State<ReligiousScreen> {
  static const _options = [
    'Agnostic',
    'Atheist',
    'Buddhist',
    'Catholic',
    'Christian',
    'Hindu',
    'Jewish',
    'Muslim',
    'Sikh',
  ];
  int _selected = 0;
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile details',
      currentStep: 1,
      totalSteps: 5,
      buttonLabel: 'Continue',
      onContinue: widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Beliefs',
            title: 'What are your beliefs?',
            description: 'Choose what feels closest — or keep this private.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Select one'),
          SizedBox(height: 8.h),
          for (var row = 0; row < 5; row++) ...[
            Row(
              children: [
                Expanded(child: _option(row * 2)),
                if (row * 2 + 1 < _options.length) ...[
                  SizedBox(width: 8.w),
                  Expanded(child: _option(row * 2 + 1)),
                ],
              ],
            ),
            if (row != 4) SizedBox(height: 8.h),
          ],
          SizedBox(height: 8.h),
          OotVisibilityRow(
            compact: true,
            value: _visible,
            onChanged: (value) => setState(() => _visible = value),
          ),
        ],
      ),
    );
  }

  Widget _option(int index) => OotSelectOption(
    option: OotOptionData(_options[index]),
    selected: _selected == index,
    onTap: () => setState(() => _selected = index),
    height: 42,
    compact: true,
    showControl: _selected == index,
  );
}
