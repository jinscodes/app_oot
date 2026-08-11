import 'location_search_service.dart';

class SupportedLocationSuggestion {
  const SupportedLocationSuggestion({
    required this.address,
    required this.searchTerms,
  });

  final LocationAddress address;
  final List<String> searchTerms;
}

const supportedLocationSuggestions = <SupportedLocationSuggestion>[
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Seoul · 서울특별시, South Korea',
      primaryName: 'Seoul · 서울',
      countryCode: 'kr',
      latitude: 37.5665,
      longitude: 126.9780,
    ),
    searchTerms: ['seoul', '서울', '서울특별시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Busan · 부산광역시, South Korea',
      primaryName: 'Busan · 부산',
      countryCode: 'kr',
      latitude: 35.1796,
      longitude: 129.0756,
    ),
    searchTerms: ['busan', '부산', '부산광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Incheon · 인천광역시, South Korea',
      primaryName: 'Incheon · 인천',
      countryCode: 'kr',
      latitude: 37.4563,
      longitude: 126.7052,
    ),
    searchTerms: ['incheon', '인천', '인천광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Daegu · 대구광역시, South Korea',
      primaryName: 'Daegu · 대구',
      countryCode: 'kr',
      latitude: 35.8714,
      longitude: 128.6014,
    ),
    searchTerms: ['daegu', '대구', '대구광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Daejeon · 대전광역시, South Korea',
      primaryName: 'Daejeon · 대전',
      countryCode: 'kr',
      latitude: 36.3504,
      longitude: 127.3845,
    ),
    searchTerms: ['daejeon', '대전', '대전광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Gwangju · 광주광역시, South Korea',
      primaryName: 'Gwangju · 광주',
      countryCode: 'kr',
      latitude: 35.1595,
      longitude: 126.8526,
    ),
    searchTerms: ['gwangju', '광주', '광주광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Ulsan · 울산광역시, South Korea',
      primaryName: 'Ulsan · 울산',
      countryCode: 'kr',
      latitude: 35.5384,
      longitude: 129.3114,
    ),
    searchTerms: ['ulsan', '울산', '울산광역시'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Jeju · 제주특별자치도, South Korea',
      primaryName: 'Jeju · 제주',
      countryCode: 'kr',
      latitude: 33.4996,
      longitude: 126.5312,
    ),
    searchTerms: ['jeju', '제주', '제주도', '제주특별자치도'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Tokyo · 東京都, Japan',
      primaryName: 'Tokyo · 東京',
      countryCode: 'jp',
      latitude: 35.6762,
      longitude: 139.6503,
    ),
    searchTerms: ['tokyo', '東京', '東京都', 'とうきょう'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Osaka · 大阪府, Japan',
      primaryName: 'Osaka · 大阪',
      countryCode: 'jp',
      latitude: 34.6937,
      longitude: 135.5023,
    ),
    searchTerms: ['osaka', '大阪', '大阪府', 'おおさか'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Kyoto · 京都府, Japan',
      primaryName: 'Kyoto · 京都',
      countryCode: 'jp',
      latitude: 35.0116,
      longitude: 135.7681,
    ),
    searchTerms: ['kyoto', '京都', '京都府', 'きょうと'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Yokohama · 横浜市, Japan',
      primaryName: 'Yokohama · 横浜',
      countryCode: 'jp',
      latitude: 35.4437,
      longitude: 139.6380,
    ),
    searchTerms: ['yokohama', '横浜', '横浜市', 'よこはま'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Nagoya · 名古屋市, Japan',
      primaryName: 'Nagoya · 名古屋',
      countryCode: 'jp',
      latitude: 35.1815,
      longitude: 136.9066,
    ),
    searchTerms: ['nagoya', '名古屋', '名古屋市', 'なごや'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Sapporo · 札幌市, Japan',
      primaryName: 'Sapporo · 札幌',
      countryCode: 'jp',
      latitude: 43.0618,
      longitude: 141.3545,
    ),
    searchTerms: ['sapporo', '札幌', '札幌市', 'さっぽろ'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Fukuoka · 福岡市, Japan',
      primaryName: 'Fukuoka · 福岡',
      countryCode: 'jp',
      latitude: 33.5904,
      longitude: 130.4017,
    ),
    searchTerms: ['fukuoka', '福岡', '福岡市', 'ふくおか'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Kobe · 神戸市, Japan',
      primaryName: 'Kobe · 神戸',
      countryCode: 'jp',
      latitude: 34.6901,
      longitude: 135.1955,
    ),
    searchTerms: ['kobe', '神戸', '神戸市', 'こうべ'],
  ),
  SupportedLocationSuggestion(
    address: LocationAddress(
      displayName: 'Hiroshima · 広島市, Japan',
      primaryName: 'Hiroshima · 広島',
      countryCode: 'jp',
      latitude: 34.3853,
      longitude: 132.4553,
    ),
    searchTerms: ['hiroshima', '広島', '広島市', 'ひろしま'],
  ),
];

List<LocationAddress> supportedLocationsMatching(
  String query, {
  int limit = 5,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  if (normalizedQuery.isEmpty) return const [];

  return supportedLocationSuggestions
      .where(
        (suggestion) => suggestion.searchTerms.any(
          (term) => term.toLowerCase().contains(normalizedQuery),
        ),
      )
      .take(limit)
      .map((suggestion) => suggestion.address)
      .toList(growable: false);
}
