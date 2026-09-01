import 'package:app_oot/features/home/presentation/screens/edit_profile_screen.dart';
import 'package:app_oot/features/home/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(home: screen),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders the Figma sections and edits choice fields', (
    tester,
  ) async {
    EditProfileData? saved;
    await pumpScreen(
      tester,
      EditProfileScreen(onSaved: (value) => saved = value),
    );

    expect(find.byKey(const ValueKey('edit-profile-screen')), findsOneWidget);
    expect(find.text('YOUR PHOTOS'), findsOneWidget);
    expect(find.text('PERSONAL DETAILS'), findsOneWidget);
    expect(find.byKey(const ValueKey('edit-profile-photo-0')), findsOneWidget);
    expect(find.text('Long-term relationship'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('edit-profile-gender')));
    await tester.pumpAndSettle();
    expect(find.text('Edit gender'), findsOneWidget);
    await tester.tap(find.text('Woman'));
    await tester.pumpAndSettle();
    expect(find.text('Woman'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('edit-profile-save-button')),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('edit-profile-save-button')));
    await tester.pump();

    expect(saved?.gender, 'Woman');
    expect(saved?.heightCm, 178);
    expect(tester.takeException(), isNull);
  });

  testWidgets('profile edit action opens the new page', (tester) async {
    await pumpScreen(tester, const Scaffold(body: ProfileScreen()));

    await tester.tap(find.byKey(const ValueKey('profile-edit-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('edit-profile-screen')), findsOneWidget);
    expect(find.text('Edit profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
