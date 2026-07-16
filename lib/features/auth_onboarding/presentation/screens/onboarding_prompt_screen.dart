import 'package:flutter/material.dart';

import '../widgets/oot_design_system.dart';

class OnboardingPromptScreen extends StatelessWidget {
  const OnboardingPromptScreen({
    super.key,
    required this.imageAsset,
    required this.title,
    this.onNext,
  });

  final String imageAsset;
  final String title;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    if (imageAsset.endsWith('profile_onboarding2.png')) {
      return OotStoryIntroScreen(
        progressLabel: 'Discovery',
        currentStep: 1,
        totalSteps: 5,
        imageAsset: imageAsset,
        imageAlignment: const Alignment(0, -.32),
        pill: 'Find your place',
        eyebrow: 'Discovery',
        title: 'Where should we look?',
        description: 'Tell us where you’d like to meet someone special.',
        benefits: const [
          ('Nearby', 'Close to home'),
          ('Travel', 'Open to explore'),
          ('Flexible', 'You decide'),
        ],
        buttonLabel: 'Set preferences',
        onContinue: onNext,
      );
    }

    if (imageAsset.endsWith('profile_onboarding3.png')) {
      return OotStoryIntroScreen(
        progressLabel: 'Values',
        currentStep: 1,
        totalSteps: 1,
        imageAsset: imageAsset,
        imageAlignment: const Alignment(0, -.05),
        pill: 'What matters',
        eyebrow: 'Values',
        title: 'A little about your values',
        description:
            'The things that matter to you can shape a more meaningful connection.',
        benefits: const [
          ('Honesty', 'Be yourself'),
          ('Kindness', 'Lead with care'),
          ('Growth', 'Build together'),
        ],
        buttonLabel: 'Finish profile',
        onContinue: onNext,
      );
    }

    return OotStoryIntroScreen(
      progressLabel: 'Your profile',
      currentStep: 6,
      totalSteps: 6,
      imageAsset: imageAsset,
      imageAlignment: const Alignment(0, .65),
      pill: 'A little about you',
      eyebrow: 'Profile setup',
      title: 'Tell me about yourself',
      description:
          'A few thoughtful details help us introduce you to the right people.',
      benefits: const [
        ('2 min', 'Quick start'),
        ('Private', 'You control it'),
        ('Guided', 'Step by step'),
      ],
      buttonLabel: 'Build my profile',
      onContinue: onNext,
    );
  }
}
