import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/oot_design_system.dart';

class ConnectionTypeScreen extends StatefulWidget {
  const ConnectionTypeScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<ConnectionTypeScreen> createState() => _ConnectionTypeScreenState();
}

class _ConnectionTypeScreenState extends State<ConnectionTypeScreen> {
  final Set<int> _selected = {1};
  static const _options = [
    OotOptionData('Life partner'),
    OotOptionData('Long-term relationship'),
    OotOptionData('Long-term, open to short'),
    OotOptionData('Short-term, open to long'),
    OotOptionData('Short-term'),
    OotOptionData('Figuring out my dating goals'),
  ];

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Match preferences',
      currentStep: 2,
      totalSteps: 7,
      buttonLabel: 'Continue',
      onContinue: _selected.isEmpty ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'What you’re looking for',
            title: 'What kind of connection?',
            description: 'Choose all that feel right for you today.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Choose all that apply'),
          SizedBox(height: 8.h),
          for (var index = 0; index < _options.length; index++) ...[
            OotSelectOption(
              option: _options[index],
              selected: _selected.contains(index),
              onTap: () => setState(() {
                if (!_selected.add(index)) _selected.remove(index);
              }),
              height: 42,
              compact: true,
            ),
            if (index != _options.length - 1) SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}
