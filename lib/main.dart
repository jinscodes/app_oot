import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'features/auth_onboarding/data/email_verification_service.dart';
import 'features/auth_onboarding/data/verification_service.dart';
import 'features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'features/auth_onboarding/presentation/screens/email_screen.dart';
import 'features/auth_onboarding/presentation/screens/name_screen.dart';
import 'features/auth_onboarding/presentation/screens/phone_number_screen.dart';
import 'features/auth_onboarding/presentation/screens/onboarding_prompt_screen.dart';
import 'features/auth_onboarding/presentation/screens/verification_code_screen.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  await Future.delayed(const Duration(milliseconds: 1500));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
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
          builder: (context) => AuthLandingScreen(
            onCreateAccount: () => _openPhoneNumber(context),
            onSignIn: () => _openHome(context),
          ),
        ),
      ),
    );
  }

  void _openHome(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _openPhoneNumber(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhoneNumberScreen(
          onNext: (phone) {
            VerificationService.sendCode(phone);
            _openVerification(context);
          },
        ),
      ),
    );
  }

  void _openVerification(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerificationCodeScreen(
          sentTo: VerificationService.pendingPhone ?? '',
          initialCode: VerificationService.pendingCode,
          onVerify: VerificationService.verify,
          onResend: () {
            final phone = VerificationService.pendingPhone;
            if (phone == null) return null;
            return VerificationService.sendCode(phone);
          },
          onNext: () => _openProfileOnboarding(context),
        ),
      ),
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
        builder: (_) => NameScreen(onNext: () => _openEmail(context)),
      ),
    );
  }

  void _openEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EmailScreen(
          onNext: (email) {
            EmailVerificationService.sendCode(email);
            _openEmailVerification(context);
          },
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
          onNext: () => _openMeetPrompt(context),
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
          onNext: () => _openHome(innerContext),
        ),
      ),
      (route) => false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
