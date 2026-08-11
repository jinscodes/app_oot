import 'package:app_oot/features/auth_onboarding/presentation/screens/name_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/widgets/oot_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('name fields use the requested example placeholders', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: NameScreen()),
      ),
    );

    final fields = tester
        .widgetList<OotTextField>(find.byType(OotTextField))
        .toList();
    expect(fields, hasLength(2));
    expect(fields.map((field) => field.controller.text), everyElement(isEmpty));
    expect(fields.map((field) => field.hintText), ['Ex) Jay', 'EX) Han']);
  });
}
