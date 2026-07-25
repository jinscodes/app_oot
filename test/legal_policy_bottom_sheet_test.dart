import 'package:app_oot/features/auth_onboarding/presentation/screens/auth_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('each legal link opens and closes its Figma policy sheet', (
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
          home: AuthLandingScreen(onCreateAccount: () {}, onSignIn: () {}),
        ),
      ),
    );

    const policies = [
      (
        link: 'Terms of Service',
        sheetKey: 'legal-policy-sheet-termsOfService',
        section: 'ACCOUNT & ELIGIBILITY',
      ),
      (
        link: 'Privacy Policy',
        sheetKey: 'legal-policy-sheet-privacyPolicy',
        section: 'INFORMATION WE USE',
      ),
      (
        link: 'Cookies Policy',
        sheetKey: 'legal-policy-sheet-cookiesPolicy',
        section: 'ESSENTIAL',
      ),
    ];

    for (final policy in policies) {
      await _tapTextSpan(tester, policy.link);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(policy.sheetKey)), findsOneWidget);
      expect(find.text(policy.section), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const ValueKey('close-legal-policy-sheet')));
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey(policy.sheetKey)), findsNothing);
    }
  });
}

Future<void> _tapTextSpan(WidgetTester tester, String text) async {
  final richTextFinder = find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.textSpan != null &&
        widget.textSpan!.toPlainText().contains(text),
  );
  final richText = tester.widget<Text>(richTextFinder);
  final paragraph = tester.renderObject<RenderParagraph>(richTextFinder);
  final plainText = richText.textSpan!.toPlainText();
  final start = plainText.indexOf(text);
  final boxes = paragraph.getBoxesForSelection(
    TextSelection(baseOffset: start, extentOffset: start + text.length),
  );

  expect(boxes, isNotEmpty);
  await tester.tapAt(paragraph.localToGlobal(boxes.first.toRect().center));
}
