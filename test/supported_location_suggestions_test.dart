import 'package:app_oot/features/auth_onboarding/data/supported_location_suggestions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'matches Korean and Japanese locations in local and English scripts',
    () {
      expect(supportedLocationsMatching('Seo').single.countryCode, 'kr');
      expect(
        supportedLocationsMatching('부산').single.primaryName,
        contains('Busan'),
      );
      expect(supportedLocationsMatching('Tok').single.countryCode, 'jp');
      expect(
        supportedLocationsMatching('大阪').single.primaryName,
        contains('Osaka'),
      );
    },
  );

  test('does not suggest locations outside South Korea and Japan', () {
    expect(supportedLocationsMatching('Chicago'), isEmpty);
  });
}
