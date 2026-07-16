import 'package:flutter/material.dart';

import '../widgets/oot_design_system.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return OotSingleChoiceScreen(
      progressLabel: 'Profile basics',
      currentStep: 3,
      totalSteps: 4,
      eyebrow: 'About you',
      title: 'How do you identify?',
      description: 'Choose the option that best describes you.',
      sectionLabel: 'Select one',
      options: const [OotOptionData('Man'), OotOptionData('Woman')],
      initialSelection: 1,
      showSelectedBadge: true,
      helperText: 'You can update this later in settings.',
      onContinue: onNext,
    );
  }
}
