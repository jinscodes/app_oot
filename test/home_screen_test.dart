import 'package:app_oot/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders the discovery profile requirements', (tester) async {
    await pumpHome(tester);

    expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
    expect(find.text('Discover someone'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-main-photo')), findsOneWidget);
    expect(find.text('Hana, 29'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-profile-box')), findsOneWidget);
    expect(find.text('At a glance'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-quiz-button')),
      280,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('How well do you know Hana?'), findsOneWidget);
    expect(find.text('Start her quiz'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-prompt-answer')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('More moments'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-photo-comments')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-prompt-answer')), findsOneWidget);
    expect(find.text('My ideal Sunday looks like…'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens filters and the compatibility quiz', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const ValueKey('home-filter-button')));
    await tester.pumpAndSettle();
    expect(find.text('Refine introductions'), findsOneWidget);
    await tester.tap(find.text('Show introductions'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-quiz-button')),
      280,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-quiz-button')));
    await tester.pumpAndSettle();
    expect(find.text("Hana's compatibility quiz"), findsOneWidget);
    expect(find.text('Submit answers'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
