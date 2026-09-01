import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'features/auth_onboarding/data/auth_models.dart';
import 'features/auth_onboarding/data/auth_session_controller.dart';
import 'features/auth_onboarding/data/onboarding_profile_draft.dart';
import 'features/auth_onboarding/data/email_verification_service.dart';
import 'features/auth_onboarding/presentation/screens/all_set_screen.dart';
import 'features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'features/auth_onboarding/presentation/screens/birthday_screen.dart';
import 'features/auth_onboarding/presentation/screens/children_screen.dart';
import 'features/auth_onboarding/presentation/screens/connection_type_screen.dart';
import 'features/auth_onboarding/presentation/screens/education_level_screen.dart';
import 'features/auth_onboarding/presentation/screens/education_screen.dart';
import 'features/auth_onboarding/presentation/screens/email_screen.dart';
import 'features/auth_onboarding/presentation/screens/gender_screen.dart';
import 'features/auth_onboarding/presentation/screens/height_screen.dart';
import 'features/auth_onboarding/presentation/screens/location_screen.dart';
import 'features/auth_onboarding/presentation/screens/lifestyle_screen.dart';
import 'features/auth_onboarding/presentation/screens/name_screen.dart';
import 'features/auth_onboarding/presentation/screens/onboarding_prompt_screen.dart';
import 'features/auth_onboarding/presentation/screens/photo_screen.dart';
import 'features/auth_onboarding/presentation/screens/phone_number_screen.dart';
import 'features/auth_onboarding/presentation/screens/religious_screen.dart';
import 'features/auth_onboarding/presentation/screens/splash_screen.dart';
import 'features/auth_onboarding/presentation/screens/verification_code_screen.dart';
import 'features/auth_onboarding/presentation/screens/want_children_screen.dart';
import 'features/auth_onboarding/presentation/screens/work_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

export 'features/home/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.authController});

  final AuthSessionController? authController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthSessionController _authController;
  final _draft = OnboardingProfileDraft();

  @override
  void initState() {
    super.initState();
    _authController =
        widget.authController ?? AuthSessionController.development();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp(
        title: 'Oot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.interTextTheme(),
        ),
        builder: (context, child) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        ),
        home: Builder(
          builder: (context) =>
              SplashScreen(onComplete: () => _restoreSessionAndOpen(context)),
        ),
      ),
    );
  }

  Future<void> _restoreSessionAndOpen(BuildContext context) async {
    final restored = await _authController.restoreSession();
    if (!context.mounted) return;
    if (restored) {
      _openHome(context);
    } else {
      _openLanding(context);
    }
  }

  void _openLanding(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (innerContext) => AuthLandingScreen(
          onCreateAccount: () =>
              _openPhoneNumber(innerContext, isSignIn: false),
          onSignIn: () => _openPhoneNumber(innerContext, isSignIn: true),
        ),
      ),
    );
  }

  void _openHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (homeContext) =>
            HomeScreen(onLogout: () => _logout(homeContext)),
      ),
      (route) => false,
    );
  }

  Future<void> _logout(BuildContext context) async {
    await _authController.logout();
    if (!context.mounted) return;
    _openLanding(context);
  }

  void _openPhoneNumber(BuildContext context, {required bool isSignIn}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (phoneContext) => PhoneNumberScreen(
          onNext: (phone) async {
            final challenge = await _authController.requestPhoneOtp(phone);
            if (!phoneContext.mounted) return;
            _openVerification(
              phoneContext,
              phone: phone,
              challenge: challenge,
              isSignIn: isSignIn,
            );
          },
        ),
      ),
    );
  }

  void _openVerification(
    BuildContext context, {
    required String phone,
    required OtpChallenge challenge,
    required bool isSignIn,
  }) {
    var currentChallenge = challenge;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (verificationContext) => VerificationCodeScreen(
          sentTo: phone,
          initialCode: null,
          resendAfterSeconds: challenge.resendAfterSeconds,
          onVerify: (code) async {
            await _authController.verifyPhoneOtp(
              challengeId: currentChallenge.id,
              code: code,
            );
            return true;
          },
          onResend: () async {
            currentChallenge = await _authController.requestPhoneOtp(phone);
            return '';
          },
          onNext: () {
            if (isSignIn) {
              _openHome(verificationContext);
            } else {
              _openEmailAfterAuthentication(verificationContext);
            }
          },
        ),
      ),
    );
  }

  void _openEmailAfterAuthentication(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (emailContext) => EmailScreen(
          onNext: (email) {
            _draft.email = email;
            EmailVerificationService.sendCode(email);
            _openEmailVerification(emailContext);
          },
        ),
      ),
      (route) => false,
    );
  }

  void _openProfileOnboarding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (innerContext) => OnboardingPromptScreen(
          imageAsset: 'assets/images/profile_onboarding.png',
          title: 'Tell me about\nyourself',
          onNext: () => _openName(innerContext),
        ),
      ),
      (route) => false,
    );
  }

  void _openName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NameScreen(
          onChanged: (value) {
            _draft.firstName = value['firstName'];
            _draft.lastName = value['lastName'];
          },
          onNext: () => _openBirthday(context),
        ),
      ),
    );
  }

  void _openEmailVerification(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerificationCodeScreen(
          sentTo: EmailVerificationService.pendingEmail ?? '',
          initialCode: EmailVerificationService.pendingCode,
          onVerify: EmailVerificationService.verify,
          onResend: () {
            final email = EmailVerificationService.pendingEmail;
            if (email == null) return null;
            return EmailVerificationService.sendCode(email);
          },
          onNext: () => _openProfileOnboarding(context),
        ),
      ),
    );
  }

  void _openBirthday(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BirthdayScreen(
          onChanged: (value) => _draft.birthDate = value,
          onNext: () => _openGender(context),
        ),
      ),
    );
  }

  void _openMeetPrompt(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (innerContext) => OnboardingPromptScreen(
          imageAsset: 'assets/images/profile_onboarding2.png',
          title: 'Where should I meet\nsomeone special?',
          onNext: () => _openLocation(innerContext),
        ),
      ),
      (route) => false,
    );
  }

  void _openLocation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationScreen(
          onSelected: (value) {
            _draft.countryCode = value.countryCode.toUpperCase();
            _draft.locationName = value.displayName;
            _draft.city = value.primaryName;
            _draft.latitude = value.latitude;
            _draft.longitude = value.longitude;
          },
          onNext: () => _openConnectionType(context),
        ),
      ),
    );
  }

  void _openGender(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GenderScreen(
          onSelected: (value) => _draft.gender = value,
          onNext: () => _openHeight(context),
        ),
      ),
    );
  }

  void _openHeight(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HeightScreen(
          onChanged: (value) => _draft.heightCm = value,
          onNext: () => _openMeetPrompt(context),
        ),
      ),
    );
  }

  void _openConnectionType(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConnectionTypeScreen(
          onSelected: (value) => _draft.connectionType = value,
          onNext: () => _openEducation(context),
        ),
      ),
    );
  }

  void _openEducation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EducationScreen(
          onChanged: (value) {
            _draft.educationCountry = value['countryCode'];
            _draft.university = value['university'];
          },
          onNext: () => _openEducationLevel(context),
        ),
      ),
    );
  }

  void _openEducationLevel(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EducationLevelScreen(
          onSelected: (value) => _draft.educationLevel = value,
          onNext: () => _openWork(context),
        ),
      ),
    );
  }

  void _openWork(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WorkScreen(
          onChanged: (value) {
            _draft.company = value['company'];
            _draft.jobTitle = value['jobTitle'];
          },
          onNext: () => _openChildren(context),
        ),
      ),
    );
  }

  void _openChildren(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChildrenScreen(
          onSelected: (value) => _draft.children = value,
          onNext: () => _openWantChildren(context),
        ),
      ),
    );
  }

  void _openWantChildren(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WantChildrenScreen(
          onSelected: (value) => _draft.wantsChildren = value,
          onNext: () => _openValuesPrompt(context),
        ),
      ),
    );
  }

  void _openValuesPrompt(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (innerContext) => OnboardingPromptScreen(
          imageAsset: 'assets/images/profile_onboarding3.png',
          title: 'A little about\nyour values',
          onNext: () => _openReligious(innerContext),
        ),
      ),
      (route) => false,
    );
  }

  void _openReligious(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReligiousScreen(
          onSelected: (value) => _draft.religion = value,
          onNext: () => _openLifestyle(context),
        ),
      ),
    );
  }

  void _openLifestyle(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LifestyleScreen(
          onChanged: (value) {
            _draft.alcohol = value['alcohol'];
            _draft.smoking = value['smoking'];
          },
          onNext: () => _openPhotos(context),
        ),
      ),
    );
  }

  void _openPhotos(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (innerContext) => PhotoScreen(
          onChanged: (value) => _draft.photos = value,
          onNext: () => _openAllSet(innerContext),
        ),
      ),
    );
  }

  void _openAllSet(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (innerContext) => AllSetScreen(
          onStartExploring: () => _completeProfileAndOpenHome(innerContext),
        ),
      ),
    );
  }

  void _openHomeAndClear(BuildContext context) {
    _openHome(context);
  }

  Future<void> _completeProfileAndOpenHome(BuildContext context) async {
    await _authController.saveProfile(_draft.toJson());
    await _authController.completeOnboarding();
    if (context.mounted) _openHomeAndClear(context);
  }
}
