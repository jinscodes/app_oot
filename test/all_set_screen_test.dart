import 'package:app_oot/features/auth_onboarding/presentation/screens/all_set_screen.dart';
import 'package:app_oot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders completion details and starts exploring', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var startedExploring = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: AllSetScreen(onStartExploring: () => startedExploring = true),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('PROFILE COMPLETE'), findsOneWidget);
    expect(find.text('You’re all set'), findsOneWidget);
    expect(find.byKey(const ValueKey('ready-status-card')), findsOneWidget);
    expect(find.text('Start exploring'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Start exploring'));
    expect(startedExploring, isTrue);
  });

  testWidgets('start exploring opens home and clears onboarding history', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: Builder(
            builder: (navigationContext) => AllSetScreen(
              onStartExploring: () =>
                  Navigator.of(navigationContext).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.text('Start exploring'));
    await tester.pumpAndSettle();

    final home = find.byKey(const ValueKey('home-screen'));
    expect(home, findsOneWidget);
    expect(find.byType(AllSetScreen), findsNothing);
    expect(Navigator.of(tester.element(home)).canPop(), isFalse);
  });
}
