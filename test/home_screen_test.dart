import 'package:app_oot/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    Future<void> Function()? onLogout,
  }) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(home: HomeScreen(onLogout: onLogout)),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders the filter-first profile feed', (tester) async {
    await pumpHome(tester);

    expect(find.byKey(const ValueKey('home-screen')), findsOneWidget);
    expect(find.text('Discover someone'), findsNothing);
    expect(find.text('Signals'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-main-photo')), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-like-main')), findsOneWidget);
    final mainPhotoSize = tester.getSize(
      find.byKey(const ValueKey('home-main-photo')),
    );
    expect(mainPhotoSize.height, greaterThanOrEqualTo(mainPhotoSize.width));
    expect(
      tester
          .widget<Image>(
            find
                .descendant(
                  of: find.byKey(const ValueKey('home-main-photo')),
                  matching: find.byType(Image),
                )
                .first,
          )
          .fit,
      BoxFit.cover,
    );
    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Hana, 29'), findsOneWidget);
    expect(find.byKey(const ValueKey('home-profile-box')), findsOneWidget);
    expect(find.text('At a glance'), findsNothing);
    expect(find.text('FROM PROFILE SETUP'), findsNothing);
    expect(find.text('AGE'), findsOneWidget);
    expect(find.text('HEIGHT'), findsOneWidget);
    expect(find.text('LOCATION'), findsOneWidget);

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
    final momentSize = tester.getSize(
      find.byKey(const ValueKey('home-photo-frame-kyoto')),
    );
    expect(momentSize.width, moreOrLessEquals(momentSize.height));
    expect(
      tester
          .widget<Image>(
            find
                .descendant(
                  of: find.byKey(const ValueKey('home-photo-frame-kyoto')),
                  matching: find.byType(Image),
                )
                .first,
          )
          .fit,
      BoxFit.cover,
    );
    expect(find.byKey(const ValueKey('home-prompt-answer')), findsOneWidget);
    expect(find.text('My ideal Sunday looks like…'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens filters and the compatibility quiz', (tester) async {
    await pumpHome(tester);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-filter-more')),
      240,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('home-filter-row')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('home-filter-more')));
    await tester.pumpAndSettle();
    expect(find.text('Refine introductions'), findsOneWidget);
    expect(find.text('Dating intentions'), findsOneWidget);
    expect(find.text('Active today'), findsOneWidget);
    expect(find.text('New here'), findsOneWidget);
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

  testWidgets('age, height, and dating intention use definition controls', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const ValueKey('home-filter-age')));
    await tester.pumpAndSettle();
    expect(find.text('Define age range'), findsOneWidget);

    final ageSlider = tester.widget<RangeSlider>(
      find.byKey(const ValueKey('age-range-slider')),
    );
    ageSlider.onChanged!(const RangeValues(27, 32));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('apply-age-range')));
    await tester.pumpAndSettle();
    expect(find.text('27–32'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home-filter-height')));
    await tester.pumpAndSettle();
    expect(find.text('Define height range'), findsOneWidget);

    final heightSlider = tester.widget<RangeSlider>(
      find.byKey(const ValueKey('height-range-slider')),
    );
    heightSlider.onChanged!(const RangeValues(160, 185));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('apply-height-range')));
    await tester.pumpAndSettle();
    expect(find.text('160–185 cm'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-filter-dating-intentions')),
      220,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('home-filter-row')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(
      find.byKey(const ValueKey('home-filter-dating-intentions')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Define dating intention'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('apply-dating-intention')),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(
      find.byKey(const ValueKey('dating-intention-long-term-relationship')),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('apply-dating-intention')));
    await tester.pumpAndSettle();
    expect(find.text('Long-term'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-filter-more')),
      260,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('home-filter-row')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('home-filter-more')));
    await tester.pumpAndSettle();
    expect(find.text('27–32'), findsOneWidget);
    expect(find.text('160–185 cm'), findsOneWidget);
    expect(find.text('Long-term relationship'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every photo can send a like with an optional comment', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(const ValueKey('photo-like-main')));
    await tester.pumpAndSettle();
    expect(find.text('SEND A LIKE'), findsOneWidget);
    expect(find.text('Add a comment'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('photo-like-comment')),
      'The Kyoto evening looks beautiful.',
    );
    await tester.tap(find.byKey(const ValueKey('send-photo-like')));
    await tester.pumpAndSettle();
    expect(find.text('Like and comment sent to Hana.'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home-photo-comments')),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('photo-like-kyoto')), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-like-cafe')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom navigation is icon-only and opens every destination', (
    tester,
  ) async {
    await pumpHome(tester);

    Color destinationColor(String key) => tester
        .widget<Material>(
          find
              .descendant(
                of: find.byKey(ValueKey(key)),
                matching: find.byType(Material),
              )
              .first,
        )
        .color!;

    expect(destinationColor('bottom-nav-home'), const Color(0xFFF9EEE9));
    expect(destinationColor('bottom-nav-premium'), Colors.transparent);
    final navigationDecoration =
        tester
                .widget<Container>(
                  find.byKey(const ValueKey('bottom-navigation')),
                )
                .decoration
            as BoxDecoration;
    expect(navigationDecoration.borderRadius, isNull);
    expect(navigationDecoration.boxShadow, isNull);
    expect(
      tester.getBottomRight(find.byKey(const ValueKey('bottom-navigation'))).dy,
      moreOrLessEquals(956),
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('bottom-navigation')),
        matching: find.byType(Text),
      ),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('bottom-nav-premium')));
    await tester.pumpAndSettle();

    expect(destinationColor('bottom-nav-home'), Colors.transparent);
    expect(destinationColor('bottom-nav-premium'), const Color(0xFFF9EEE9));
    expect(find.byKey(const ValueKey('premium-screen')), findsOneWidget);
    expect(find.text('Standout'), findsOneWidget);
    expect(find.text('Featured today'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('standout-profile-serena')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('standout-profile-ren')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-heart')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('heart-screen')), findsOneWidget);
    expect(find.text('They noticed you'), findsOneWidget);
    expect(
      find
          .descendant(
            of: find.byKey(const ValueKey('heart-screen')),
            matching: find.byType(Image),
          )
          .evaluate()
          .map((element) => (element.widget as Image).fit),
      everyElement(BoxFit.cover),
    );

    await tester.tap(find.byKey(const ValueKey('bottom-nav-chat')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('chat-screen')), findsOneWidget);
    expect(find.text('Search conversations'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-profile')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('profile-screen')), findsOneWidget);
    expect(find.text('Jay Han, 29'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile logout delegates to the authenticated app shell', (
    tester,
  ) async {
    var loggedOut = false;
    await pumpHome(tester, onLogout: () async => loggedOut = true);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-profile')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('profile-logout-button')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('profile-logout-button')));
    await tester.pump();

    expect(loggedOut, isTrue);
  });
}
