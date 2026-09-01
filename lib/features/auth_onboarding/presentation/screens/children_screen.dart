import 'package:flutter/material.dart';

import '../widgets/oot_design_system.dart';

class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({super.key, this.onNext, this.onSelected});

  final VoidCallback? onNext;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return OotSingleChoiceScreen(
      progressLabel: 'Match preferences',
      currentStep: 6,
      totalSteps: 7,
      eyebrow: 'Family',
      title: 'Do you have children?',
      description: 'Choose what you’re comfortable sharing.',
      sectionLabel: 'Select one',
      options: const [
        OotOptionData('I don’t have children'),
        OotOptionData('I have children'),
        OotOptionData(
          'Prefer not to say',
          caption: 'Keeps this detail private',
        ),
      ],
      showVisibility: true,
      onContinue: onNext,
      onSelectionChanged: (index) => onSelected?.call(
        const [
          'I don’t have children',
          'I have children',
          'Prefer not to say',
        ][index],
      ),
    );
  }
}
