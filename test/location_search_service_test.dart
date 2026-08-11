import 'package:app_oot/features/auth_onboarding/data/location_search_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'search limits results to South Korea and Japan and caches queries',
    () async {
      var requestCount = 0;
      final client = MockClient((request) async {
        requestCount++;
        expect(request.url.path, '/search');
        expect(request.url.queryParameters['countrycodes'], 'kr,jp');
        expect(request.headers['User-Agent'], contains('OOT/1.0'));
      return http.Response('''
        [
          {
            "name": "서울특별시",
            "display_name": "서울특별시, 대한민국",
            "lat": "37.5665",
            "lon": "126.9780",
            "address": {"city": "서울특별시", "country_code": "kr"}
          },
          {
            "name": "Chicago",
            "display_name": "Chicago, United States",
            "lat": "41.8781",
            "lon": "-87.6298",
            "address": {"city": "Chicago", "country_code": "us"}
          }
        ]
      ''', 200, headers: {'content-type': 'application/json'});
      });
      final service = NominatimLocationSearchService(
        client: client,
        baseUri: Uri.parse('https://geocoding.example.test'),
        minimumRequestInterval: Duration.zero,
      );
      addTearDown(service.close);

      final first = await service.search('Seoul');
      final second = await service.search('seoul');

      expect(first, hasLength(1));
      expect(first.single.countryCode, 'kr');
      expect(first.single.primaryName, '서울특별시');
      expect(second.single.displayName, first.single.displayName);
      expect(requestCount, 1);
    },
  );

  test(
    'reverse lookup rejects addresses outside the target countries',
    () async {
      final client = MockClient(
      (_) async => http.Response('''
        {
          "name": "Chicago",
          "display_name": "Chicago, United States",
          "lat": "41.8781",
          "lon": "-87.6298",
          "address": {"city": "Chicago", "country_code": "us"}
        }
      ''', 200, headers: {'content-type': 'application/json'}),
      );
      final service = NominatimLocationSearchService(
        client: client,
        baseUri: Uri.parse('https://geocoding.example.test'),
        minimumRequestInterval: Duration.zero,
      );
      addTearDown(service.close);

      final result = await service.reverse(
        latitude: 41.8781,
        longitude: -87.6298,
      );

      expect(result, isNull);
    },
  );
}
