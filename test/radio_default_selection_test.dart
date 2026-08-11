import 'package:app_oot/features/auth_onboarding/presentation/screens/children_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/education_level_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/gender_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/lifestyle_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/religious_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/want_children_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/widgets/oot_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('single-choice screens start without a selected option', (
    tester,
  ) async {
    _configureView(tester);

    final screens = <Widget>[
      GenderScreen(onNext: () {}),
      EducationLevelScreen(onNext: () {}),
      ChildrenScreen(onNext: () {}),
      WantChildrenScreen(onNext: () {}),
      ReligiousScreen(onNext: () {}),
    ];

    for (final screen in screens) {
      await _pumpScreen(tester, screen);

      final options = tester.widgetList<OotSelectOption>(
        find.byType(OotSelectOption),
      );
      expect(
        options.every((option) => !option.selected),
        isTrue,
        reason: '${screen.runtimeType} should not preselect an option',
      );
      expect(
        tester.widget<OotFooterButton>(find.byType(OotFooterButton)).onPressed,
        isNull,
        reason: '${screen.runtimeType} should require a selection',
      );
    }
  });

  testWidgets('lifestyle radio groups start without selected options', (
    tester,
  ) async {
    _configureView(tester);
    await _pumpScreen(tester, LifestyleScreen(onNext: () {}));

    for (final group in ['alcohol', 'smoking']) {
      for (var index = 0; index < 3; index++) {
        final option = tester.widget<Semantics>(
          find.byKey(ValueKey('$group-option-$index')),
        );
        expect(option.properties.selected, isFalse);
      }
    }

    expect(
      tester.widget<OotFooterButton>(find.byType(OotFooterButton)).onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('alcohol-option-0')));
    await tester.tap(find.byKey(const ValueKey('smoking-option-2')));
    await tester.pump();

    expect(
      tester.widget<OotFooterButton>(find.byType(OotFooterButton)).onPressed,
      isNotNull,
    );
  });
}

void _configureView(WidgetTester tester) {
  tester.view.physicalSize = const Size(440, 956);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen) {
  return tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(440, 956),
      builder: (_, _) => MaterialApp(home: screen),
    ),
  );
}
