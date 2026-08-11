import 'package:app_oot/features/auth_onboarding/data/device_location_service.dart';
import 'package:app_oot/features/auth_onboarding/data/location_search_service.dart';
import 'package:app_oot/features/auth_onboarding/presentation/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('typing shows matching suggestions without calling the API', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final searchService = _FakeLocationSearchService();
    await _pumpLocationScreen(tester, searchService: searchService);

    await tester.enterText(
      find.byKey(const ValueKey('location-search-field')),
      'Seo',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('location-result-0')), findsOneWidget);
    expect(find.textContaining('Seoul', findRichText: true), findsWidgets);
    expect(searchService.lastQuery, isNull);
  });

  testWidgets('search selects a South Korean address before continuing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final searchService = _FakeLocationSearchService(
      searchResults: const [_seoul],
    );
    var continued = false;
    await _pumpLocationScreen(
      tester,
      searchService: searchService,
      onNext: () => continued = true,
    );

    await tester.enterText(
      find.byKey(const ValueKey('location-search-field')),
      'Seoul',
    );
    await tester.tap(find.byKey(const ValueKey('submit-location-search')));
    await tester.pumpAndSettle();

    expect(searchService.lastQuery, 'Seoul');
    expect(find.text('서울특별시'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('location-result-0')));
    await tester.pump();
    expect(find.text('서울특별시, 대한민국'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    expect(continued, isTrue);
  });

  testWidgets('current location reverse geocodes a Japanese address', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final searchService = _FakeLocationSearchService(reverseResult: _tokyo);
    await _pumpLocationScreen(
      tester,
      searchService: searchService,
      deviceLocationService: const _FakeDeviceLocationService(),
    );

    await tester.tap(find.byKey(const ValueKey('use-current-location')));
    await tester.pumpAndSettle();

    expect(searchService.lastReverseLatitude, 35.6762);
    expect(find.text('東京都, 日本'), findsOneWidget);
    expect(
      find.text('Choose a location within South Korea or Japan.'),
      findsNothing,
    );
  });
}

const _seoul = LocationAddress(
  displayName: '서울특별시, 대한민국',
  primaryName: '서울특별시',
  countryCode: 'kr',
  latitude: 37.5665,
  longitude: 126.9780,
);

const _tokyo = LocationAddress(
  displayName: '東京都, 日本',
  primaryName: '東京都',
  countryCode: 'jp',
  latitude: 35.6762,
  longitude: 139.6503,
);

Future<void> _pumpLocationScreen(
  WidgetTester tester, {
  required LocationSearchService searchService,
  DeviceLocationService? deviceLocationService,
  VoidCallback? onNext,
}) {
  return tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(440, 956),
      builder: (_, _) => MaterialApp(
        home: LocationScreen(
          searchService: searchService,
          deviceLocationService:
              deviceLocationService ?? const _FakeDeviceLocationService(),
          loadMapTiles: false,
          onNext: onNext,
        ),
      ),
    ),
  );
}

class _FakeLocationSearchService implements LocationSearchService {
  _FakeLocationSearchService({
    this.searchResults = const [],
    this.reverseResult,
  });

  final List<LocationAddress> searchResults;
  final LocationAddress? reverseResult;
  String? lastQuery;
  double? lastReverseLatitude;

  @override
  Future<List<LocationAddress>> search(String query) async {
    lastQuery = query;
    return searchResults;
  }

  @override
  Future<LocationAddress?> reverse({
    required double latitude,
    required double longitude,
  }) async {
    lastReverseLatitude = latitude;
    return reverseResult;
  }

  @override
  void close() {}
}

class _FakeDeviceLocationService implements DeviceLocationService {
  const _FakeDeviceLocationService();

  @override
  Future<DeviceCoordinates> currentCoordinates() async {
    return const DeviceCoordinates(latitude: 35.6762, longitude: 139.6503);
  }
}
