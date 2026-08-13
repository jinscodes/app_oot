import 'dart:convert';

import 'package:app_oot/features/auth_onboarding/presentation/screens/photo_screen.dart';
import 'package:app_oot/features/auth_onboarding/presentation/widgets/oot_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  testWidgets('finish setup requires a main photo', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: PhotoScreen(
            onNext: () {},
            multiPhotoPicker: (_) async => [
              XFile.fromData(
                _transparentPng,
                mimeType: 'image/png',
                name: 'profile.png',
              ),
            ],
          ),
        ),
      ),
    );

    expect(_finishButton(tester).onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('photo-slot-3')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('photo-image-3')), findsOneWidget);
    expect(_finishButton(tester).onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('photo-image-0')), findsOneWidget);
    expect(_finishButton(tester).onPressed, isNotNull);
  });

  testWidgets('empty photo boxes pick and display multiple gallery photos', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var multiGalleryRequests = 0;
    var replacementRequests = 0;
    final requestedLimits = <int>[];
    XFile photo(String name) {
      return XFile.fromData(_transparentPng, mimeType: 'image/png', name: name);
    }

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: PhotoScreen(
            multiPhotoPicker: (limit) async {
              multiGalleryRequests++;
              requestedLimits.add(limit);
              return List.generate(
                3,
                (index) => photo('gallery-$multiGalleryRequests-$index.png'),
              );
            },
            photoPicker: () async {
              replacementRequests++;
              return photo('replacement.png');
            },
          ),
        ),
      ),
    );

    expect(find.text('0 / 6'), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-image-0')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();

    expect(multiGalleryRequests, 1);
    expect(requestedLimits, [6]);
    expect(find.byKey(const ValueKey('photo-image-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-image-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-image-2')), findsOneWidget);
    expect(find.text('Main photo'), findsOneWidget);
    expect(find.text('3 / 6'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('photo-slot-4')));
    await tester.pumpAndSettle();

    expect(multiGalleryRequests, 2);
    expect(requestedLimits, [6, 3]);
    for (var index = 0; index < 6; index++) {
      expect(find.byKey(ValueKey('photo-image-$index')), findsOneWidget);
    }
    expect(find.text('6 / 6'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('replace-photo-1')));
    await tester.pumpAndSettle();

    expect(replacementRequests, 1);
    expect(multiGalleryRequests, 2);
    expect(find.text('6 / 6'), findsOneWidget);
  });

  testWidgets('selected photos support optional comments', (tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var replacementRequests = 0;
    XFile photo(String name) {
      return XFile.fromData(_transparentPng, mimeType: 'image/png', name: name);
    }

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: PhotoScreen(
            multiPhotoPicker: (_) async => [photo('profile.png')],
            photoPicker: () async {
              replacementRequests++;
              return photo('replacement.png');
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();

    expect(find.text('Add a photo comment'), findsOneWidget);
    expect(find.text('Optional · 120 characters maximum'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('photo-comment-field')),
      'Sunset walk in Busan',
    );
    await tester.tap(find.byKey(const ValueKey('save-photo-comment')));
    await tester.pumpAndSettle();

    expect(find.text('Sunset walk in Busan'), findsOneWidget);
    expect(find.byKey(const ValueKey('photo-comment-0')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();
    final commentField = tester.widget<TextField>(
      find.byKey(const ValueKey('photo-comment-field')),
    );
    expect(commentField.controller?.text, 'Sunset walk in Busan');
    await tester.enterText(
      find.byKey(const ValueKey('photo-comment-field')),
      '',
    );
    await tester.tap(find.byKey(const ValueKey('save-photo-comment')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('photo-comment-0')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('replace-photo-0')));
    await tester.pumpAndSettle();
    expect(replacementRequests, 1);
  });

  testWidgets('photo permission denial offers to open app settings', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var openedSettings = false;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(440, 956),
        builder: (_, _) => MaterialApp(
          home: PhotoScreen(
            multiPhotoPicker: (_) =>
                throw PlatformException(code: 'photo_access_denied'),
            openAppSettings: () async => openedSettings = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('photo-slot-0')));
    await tester.pumpAndSettle();

    expect(find.text('Allow photo access'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);

    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();
    expect(openedSettings, isTrue);
  });
}

final Uint8List _transparentPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

OotFooterButton _finishButton(WidgetTester tester) {
  return tester.widget<OotFooterButton>(find.byType(OotFooterButton));
}
