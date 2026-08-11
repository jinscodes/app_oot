import 'package:app_oot/features/auth_onboarding/presentation/screens/birthday_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('birthday date placeholders use the muted hint style', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: BirthdayScreen()),
      ),
    );

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();

    expect(fields, hasLength(3));
    expect(fields.map((field) => field.decoration?.hintText), [
      'YYYY',
      'MM',
      'DD',
    ]);
    expect(
      fields.map((field) => field.decoration?.hintStyle?.color),
      everyElement(const Color(0xFF9A8880)),
    );
    expect(
      fields.map((field) => field.controller?.text),
      everyElement(isEmpty),
    );
  });

  testWidgets('birthday confirmation appears before continuing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var continued = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) =>
            MaterialApp(home: BirthdayScreen(onNext: () => continued = true)),
      ),
    );

    expect(find.text('Looks right?'), findsNothing);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '1997');
    await tester.enterText(fields.at(1), '02');
    await tester.enterText(fields.at(2), '15');
    await tester.pump();
    expect(tester.testTextInput.isVisible, isTrue);

    await tester.tap(find.text('Continue'));
    await tester.pump();

    expect(tester.testTextInput.isVisible, isFalse);
    expect(
      tester
          .widgetList<TextField>(fields)
          .every((field) => field.focusNode?.hasFocus == false),
      isTrue,
    );
    expect(find.text('Looks right?'), findsOneWidget);
    expect(find.text('February 15, 1997'), findsOneWidget);
    expect(find.text('Age ${_ageOn(DateTime(1997, 2, 15))}'), findsOneWidget);
    expect(continued, isFalse);

    await tester.tap(find.text('Continue'));
    expect(continued, isTrue);

    await tester.enterText(fields.at(2), '16');
    await tester.pump();
    expect(find.text('Looks right?'), findsNothing);
  });

  testWidgets('birthday fields advance focus after each complete segment', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: BirthdayScreen()),
      ),
    );
    await tester.pump();

    final fields = find.byType(TextField);
    final year = tester.widget<TextField>(fields.at(0));
    final month = tester.widget<TextField>(fields.at(1));
    final day = tester.widget<TextField>(fields.at(2));

    expect(year.focusNode?.hasFocus, isTrue);

    await tester.enterText(fields.at(0), '1997');
    await tester.pump();
    expect(month.focusNode?.hasFocus, isTrue);

    await tester.enterText(fields.at(1), '02');
    await tester.pump();
    expect(day.focusNode?.hasFocus, isTrue);
  });
}

int _ageOn(DateTime birthday) {
  final now = DateTime.now();
  var age = now.year - birthday.year;
  if (now.month < birthday.month ||
      (now.month == birthday.month && now.day < birthday.day)) {
    age--;
  }
  return age;
}
