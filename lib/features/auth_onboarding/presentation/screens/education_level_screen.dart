import 'package:flutter/material.dart';

import '../widgets/oot_design_system.dart';

class EducationLevelScreen extends StatelessWidget {
  const EducationLevelScreen({super.key, this.onNext, this.onSelected});

  final VoidCallback? onNext;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return OotSingleChoiceScreen(
      progressLabel: 'Match preferences',
      currentStep: 4,
      totalSteps: 7,
      eyebrow: 'Education',
      title: 'What’s your education level?',
      description: 'Share the highest level you’ve completed, if you’d like.',
      sectionLabel: 'Select one',
      options: const [
        OotOptionData('High school'),
        OotOptionData('College degree'),
        OotOptionData('Graduate degree'),
        OotOptionData('Prefer not to say'),
      ],
      optionHeight: 42,
      compactOptions: true,
      showVisibility: true,
      onContinue: onNext,
      onSelectionChanged: (index) => onSelected?.call(
        const [
          'High school',
          'College degree',
          'Graduate degree',
          'Prefer not to say',
        ][index],
      ),
    );
  }
}
