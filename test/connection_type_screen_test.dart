import 'package:app_oot/features/auth_onboarding/presentation/screens/connection_type_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/widgets/oot_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('connection type allows exactly one selected option', (
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
          home: ConnectionTypeScreen(onNext: () {}),
        ),
      ),
    );

    expect(_selectedOptions(tester), isEmpty);
    expect(
      tester.widget<OotFooterButton>(find.byType(OotFooterButton)).onPressed,
      isNull,
    );

    await tester.tap(find.text('Life partner'));
    await tester.pump();
    expect(_selectedOptions(tester), ['Life partner']);
    expect(
      tester.widget<OotFooterButton>(find.byType(OotFooterButton)).onPressed,
      isNotNull,
    );

    await tester.tap(find.text('Short-term'));
    await tester.pump();
    expect(_selectedOptions(tester), ['Short-term']);
    expect(find.text('CHOOSE ONE'), findsOneWidget);
  });
}

List<String> _selectedOptions(WidgetTester tester) {
  return tester
      .widgetList<OotSelectOption>(find.byType(OotSelectOption))
      .where((option) => option.selected)
      .map((option) => option.option.label)
      .toList();
}
