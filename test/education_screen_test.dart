import 'package:app_oot/features/auth_onboarding/presentation/screens/education_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('school supports KR, JP, and US country selection', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: EducationScreen()),
      ),
    );

    final schoolField = tester.widget<TextField>(find.byType(TextField));
    expect(schoolField.controller?.text, isEmpty);
    expect(schoolField.decoration?.hintText, 'Ex) Seoul National University');
    expect(schoolField.decoration?.hintStyle?.color, const Color(0xFF9A8880));

    final countrySelector = find.byKey(
      const ValueKey('education-country-selector'),
    );
    expect(find.text('🇰🇷  KR'), findsOneWidget);

    await tester.tap(countrySelector);
    await tester.pumpAndSettle();
    expect(find.text('🇯🇵  JP'), findsOneWidget);
    expect(find.text('🇺🇸  US'), findsOneWidget);

    await tester.tap(find.text('🇯🇵  JP'));
    await tester.pumpAndSettle();
    expect(find.text('🇯🇵  JP'), findsOneWidget);
    expect(find.text('🇰🇷  KR'), findsNothing);

    await tester.tap(countrySelector);
    await tester.pumpAndSettle();
    await tester.tap(find.text('🇺🇸  US'));
    await tester.pumpAndSettle();
    expect(find.text('🇺🇸  US'), findsOneWidget);
  });
}
