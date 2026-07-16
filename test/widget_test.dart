import 'package:app_oot/features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/birthday_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/children_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/connection_type_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/education_level_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/education_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/email_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/gender_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/height_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/key_details_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/lifestyle_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/location_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/name_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/onboarding_prompt_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/photo_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/phone_number_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/profile_prompt_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/religious_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/verification_code_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/want_children_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/work_screen.dart';
import 'package:app_oot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the branded splash screen', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    expect(find.text('Only One Touch'), findsOneWidget);
  });

  testWidgets('renders the original landing and onboarding shell', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var createAccountTapped = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: AuthLandingScreen(
            onCreateAccount: () => createAccountTapped = true,
            onSignIn: () {},
          ),
        ),
      ),
    );

    expect(find.text('Only One Touch'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    await tester.tap(find.text('Create account'));
    expect(createAccountTapped, isTrue);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: PhoneNumberScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('What’s your number?'), findsOneWidget);
    expect(find.text('YOUR NUMBER'), findsOneWidget);
  });

  testWidgets('all Figma onboarding frames render without layout errors', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final screens = <Widget>[
      const PhoneNumberScreen(),
      VerificationCodeScreen(
        sentTo: '+82 10 1234 5678',
        initialCode: null,
        onVerify: (_) => true,
        onResend: () => null,
      ),
      const EmailScreen(),
      VerificationCodeScreen(
        sentTo: 'hello@example.com',
        initialCode: null,
        onVerify: (_) => true,
        onResend: () => null,
      ),
      const OnboardingPromptScreen(
        imageAsset: 'assets/images/profile_onboarding.png',
        title: 'Tell me about yourself',
      ),
      const NameScreen(),
      const BirthdayScreen(),
      const GenderScreen(),
      const HeightScreen(),
      const OnboardingPromptScreen(
        imageAsset: 'assets/images/profile_onboarding2.png',
        title: 'Where should we look?',
      ),
      const LocationScreen(),
      const ConnectionTypeScreen(),
      const EducationScreen(),
      const EducationLevelScreen(),
      const WorkScreen(),
      const ChildrenScreen(),
      const WantChildrenScreen(),
      const OnboardingPromptScreen(
        imageAsset: 'assets/images/profile_onboarding3.png',
        title: 'A little about your values',
      ),
      const ReligiousScreen(),
      const LifestyleScreen(),
      const KeyDetailsScreen(),
      const ProfilePromptScreen(),
      const PhotoScreen(),
    ];

    final currentScreen = ValueNotifier<Widget>(screens.first);
    addTearDown(currentScreen.dispose);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => ValueListenableBuilder<Widget>(
          valueListenable: currentScreen,
          builder: (_, screen, _) => MaterialApp(home: screen),
        ),
      ),
    );

    for (final screen in screens) {
      currentScreen.value = screen;
      await tester.pump();
      expect(
        tester.takeException(),
        isNull,
        reason: screen.runtimeType.toString(),
      );
    }
  });
}
