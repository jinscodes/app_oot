import 'package:app_oot/features/auth_onboarding/data/auth_api_client.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_models.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_session_controller.dart';
import 'package:app_oot/features/auth_onboarding/data/auth_token_storage.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/all_set_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/birthday_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/children_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/connection_type_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/education_level_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/education_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/email_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/gender_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/height_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/lifestyle_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/location_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/name_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/onboarding_prompt_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/photo_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/phone_number_screen.dart';
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

  testWidgets('verified sign in opens Home without retaining landing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final gateway = _FakeAuthGateway();
    final storage = _MemoryAuthTokenStorage();
    await tester.pumpWidget(
      MyApp(
        authController: AuthSessionController(
          gateway: gateway,
          storage: storage,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('What’s your number?'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '01012345678');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(gateway.requestedPhone, '+821012345678');
    expect(find.text('Enter your code'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '123456');
    await tester.pump();
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
    expect(storage.tokens?.refreshToken, 'refresh-token');
    expect(
      Navigator.of(
        tester.element(find.byKey(const ValueKey('home-screen'))),
      ).canPop(),
      isFalse,
    );

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
    expect(find.text('Create account'), findsNothing);
  });

  testWidgets('restores a secure session directly into Home', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = _MemoryAuthTokenStorage()
      ..tokens = _FakeAuthGateway._tokens;
    await tester.pumpWidget(
      MyApp(
        authController: AuthSessionController(
          gateway: _FakeAuthGateway(),
          storage: storage,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
    expect(find.text('Create account'), findsNothing);
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

    String? submittedPhone;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: PhoneNumberScreen(onNext: (phone) => submittedPhone = phone),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('What’s your number?'), findsOneWidget);
    expect(find.text('YOUR NUMBER'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Search'), findsNothing);
    expect(find.text('Japan'), findsOneWidget);
    expect(find.text('South Korea'), findsOneWidget);
    expect(find.text('United States'), findsOneWidget);
    expect(find.text('Canada'), findsNothing);

    await tester.tap(find.text('United States'));
    await tester.pumpAndSettle();
    expect(find.text('+1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '2025550123');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    expect(submittedPhone, '+12025550123');
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
      const LocationScreen(loadMapTiles: false),
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
      const PhotoScreen(),
      const AllSetScreen(),
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

class _FakeAuthGateway implements AuthGateway {
  String? requestedPhone;

  @override
  Future<void> completeOnboarding(String accessToken) async {}

  @override
  Future<Map<String, dynamic>> saveProfile(
    String accessToken,
    Map<String, dynamic> profile,
  ) async => profile;

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async => _user;

  @override
  Future<void> logout(String refreshToken) async {}

  @override
  Future<AuthTokens> refresh(String refreshToken) async => _tokens;

  @override
  Future<OtpChallenge> requestPhoneOtp(String phone) async {
    requestedPhone = phone;
    return const OtpChallenge(
      id: '507f1f77bcf86cd799439011',
      expiresInSeconds: 300,
      resendAfterSeconds: 60,
    );
  }

  @override
  Future<AuthSession> verifyPhoneOtp({
    required String challengeId,
    required String code,
  }) async {
    return AuthSession(tokens: _tokens, user: _user);
  }

  static final _user = AuthUser(
    id: '507f1f77bcf86cd799439012',
    phone: '+821012345678',
    status: 'active',
    onboardingCompleted: true,
    createdAt: DateTime.utc(2026),
  );

  static const _tokens = AuthTokens(
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    accessTokenExpiresInSeconds: 900,
    refreshTokenExpiresInSeconds: 2592000,
  );
}

class _MemoryAuthTokenStorage implements AuthTokenStorage {
  AuthTokens? tokens;

  @override
  Future<void> clear() async => tokens = null;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens tokens) async => this.tokens = tokens;
}
