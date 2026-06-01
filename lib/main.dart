import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'features/auth_onboarding/data/verification_service.dart';
import 'features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'features/auth_onboarding/presentation/screens/name_screen.dart';
import 'features/auth_onboarding/presentation/screens/phone_number_screen.dart';
import 'features/auth_onboarding/presentation/screens/profile_onboarding_intro_screen.dart';
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
          onNext: () => _openProfileOnboarding(context),
        ),
      ),
    );
  }

  void _openProfileOnboarding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (innerContext) => ProfileOnboardingIntroScreen(
          onNext: () => _openName(innerContext),
        ),
      ),
      (route) => false,
    );
  }

  void _openName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NameScreen(onNext: () => _openHome(context)),
      ),
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
