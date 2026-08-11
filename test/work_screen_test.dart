import 'package:app_oot/features/auth_onboarding/presentation/screens/work_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('work questions are empty field placeholders', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: WorkScreen()),
      ),
    );

    final fields = tester
        .widgetList<TextField>(find.byType(TextField))
        .toList();
    expect(fields, hasLength(2));
    expect(
      fields.map((field) => field.controller?.text),
      everyElement(isEmpty),
    );
    expect(fields.map((field) => field.decoration?.hintText), [
      'Where do you work?',
      'What’s your job title?',
    ]);
    expect(
      fields.map((field) => field.decoration?.hintStyle?.color),
      everyElement(const Color(0xFF9A8880)),
    );
  });
}
