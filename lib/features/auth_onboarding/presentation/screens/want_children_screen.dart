import 'package:flutter/material.dart';

import '../widgets/oot_design_system.dart';

class WantChildrenScreen extends StatelessWidget {
  const WantChildrenScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return OotSingleChoiceScreen(
      progressLabel: 'Match preferences',
      currentStep: 7,
      totalSteps: 7,
      eyebrow: 'Looking ahead',
      title: 'Do you want children?',
      description: 'This helps us introduce you to compatible people.',
      sectionLabel: 'Select one',
      options: const [
        OotOptionData('I don’t want children'),
        OotOptionData('I want children'),
        OotOptionData(
          'Prefer not to say',
          caption: 'May narrow compatible match suggestions',
        ),
      ],
      showVisibility: true,
      onContinue: onNext,
    );
  }
}
