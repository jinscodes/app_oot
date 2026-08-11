import 'package:app_oot/features/auth_onboarding/presentation/screens/education_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('education level omits the MS or PhD option', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => const MaterialApp(home: EducationLevelScreen()),
      ),
    );

    expect(find.text('MS or PhD'), findsNothing);
    expect(find.text('High school'), findsOneWidget);
    expect(find.text('College degree'), findsOneWidget);
    expect(find.text('Graduate degree'), findsOneWidget);
    expect(find.text('Prefer not to say'), findsOneWidget);
  });
}
