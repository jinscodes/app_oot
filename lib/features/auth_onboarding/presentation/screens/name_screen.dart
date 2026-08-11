import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/oot_design_system.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _first = TextEditingController();
  final TextEditingController _last = TextEditingController();
  bool _valid = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Profile basics',
      currentStep: 1,
      totalSteps: 4,
      buttonLabel: 'Continue',
      onContinue: _valid ? widget.onNext : null,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Let’s get acquainted',
            title: 'What should we call you?',
            description: 'Use the name you’d like your matches to see.',
          ),
          SizedBox(height: 34.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('First name'),
          ),
          SizedBox(height: 8.h),
          OotTextField(
            controller: _first,
            hintText: 'Ex) Jay',
            autofocus: true,
            focused: true,
            onChanged: (value) =>
                setState(() => _valid = value.trim().isNotEmpty),
          ),
          SizedBox(height: 10.h),
          const Align(
            alignment: Alignment.centerLeft,
            child: OotFieldLabel('Last name · Optional'),
          ),
          SizedBox(height: 8.h),
          OotTextField(controller: _last, hintText: 'EX) Han'),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Use your preferred name. You can update it later.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}
