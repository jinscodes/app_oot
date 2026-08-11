import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _supportedCountryCodes = {'kr', 'jp'};

class LocationAddress {
  const LocationAddress({
    required this.displayName,
    required this.primaryName,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  final String displayName;
  final String primaryName;
  final String countryCode;
  final double latitude;
  final double longitude;

  String get countryName => countryCode == 'kr' ? 'South Korea' : 'Japan';
}

abstract interface class LocationSearchService {
  Future<List<LocationAddress>> search(String query);

  Future<LocationAddress?> reverse({
    required double latitude,
    required double longitude,
  });

  void close();
}

class LocationSearchException implements Exception {
  const LocationSearchException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NominatimLocationSearchService implements LocationSearchService {
  NominatimLocationSearchService({
    http.Client? client,
    Uri? baseUri,
    this.minimumRequestInterval = const Duration(seconds: 1),
  }) : _client = client ?? http.Client(),
       _ownsClient = client == null,
       _baseUri = baseUri ?? Uri.parse(_defaultBaseUrl);

  static const _defaultBaseUrl = String.fromEnvironment(
    'OOT_GEOCODING_BASE_URL',
    defaultValue: 'https://nominatim.openstreetmap.org',
  );
  static const _userAgent = 'OOT/1.0 (com.example.app_oot)';

  final http.Client _client;
  final bool _ownsClient;
  final Uri _baseUri;
  final Duration minimumRequestInterval;
  final Map<String, List<LocationAddress>> _searchCache = {};
  final Map<String, LocationAddress?> _reverseCache = {};
  DateTime? _lastRequestAt;

  @override
  Future<List<LocationAddress>> search(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) return const [];

    final cacheKey = normalizedQuery.toLowerCase();
    final cached = _searchCache[cacheKey];
    if (cached != null) return cached;

    final response = await _get(
      _endpoint('search').replace(
        queryParameters: {
          'q': normalizedQuery,
          'format': 'jsonv2',
          'addressdetails': '1',
          'limit': '5',
          'dedupe': '1',
          'countrycodes': 'kr,jp',
          'accept-language': _preferredLanguages(normalizedQuery),
        },
      ),
    );
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const LocationSearchException(
        'The address service returned an unexpected response.',
      );
    }

    final results = decoded
        .whereType<Map>()
        .map((item) => _parseAddress(Map<String, dynamic>.from(item)))
        .whereType<LocationAddress>()
        .where(
          (address) => _supportedCountryCodes.contains(address.countryCode),
        )
        .toList(growable: false);
    _searchCache[cacheKey] = results;
    return results;
  }

  @override
  Future<LocationAddress?> reverse({
    required double latitude,
    required double longitude,
  }) async {
    final cacheKey =
        '${latitude.toStringAsFixed(5)},${longitude.toStringAsFixed(5)}';
    if (_reverseCache.containsKey(cacheKey)) return _reverseCache[cacheKey];

    final response = await _get(
      _endpoint('reverse').replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'jsonv2',
          'addressdetails': '1',
          'zoom': '18',
          'accept-language': 'ko,ja,en',
        },
      ),
    );
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const LocationSearchException(
        'The address service returned an unexpected response.',
      );
    }

    final result = _parseAddress(Map<String, dynamic>.from(decoded));
    final supported =
        result != null && _supportedCountryCodes.contains(result.countryCode)
        ? result
        : null;
    _reverseCache[cacheKey] = supported;
    return supported;
  }

  Uri _endpoint(String path) {
    final basePath = _baseUri.path.endsWith('/')
        ? _baseUri.path.substring(0, _baseUri.path.length - 1)
        : _baseUri.path;
    return _baseUri.replace(path: '$basePath/$path');
  }

  Future<http.Response> _get(Uri uri) async {
    await _respectRateLimit();
    late final http.Response response;
    try {
      response = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'Accept-Language': 'ko,ja,en;q=0.8',
              if (!kIsWeb) 'User-Agent': _userAgent,
            },
          )
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw const LocationSearchException(
        'The address search took too long. Please try again.',
      );
    } on http.ClientException {
      throw const LocationSearchException(
        'Unable to reach the address service. Check your connection.',
      );
    }

    if (response.statusCode != 200) {
      throw const LocationSearchException(
        'Address search is temporarily unavailable. Please try again.',
      );
    }
    return response;
  }

  Future<void> _respectRateLimit() async {
    final previousRequest = _lastRequestAt;
    if (previousRequest != null) {
      final remaining =
          minimumRequestInterval - DateTime.now().difference(previousRequest);
      if (remaining > Duration.zero) await Future<void>.delayed(remaining);
    }
    _lastRequestAt = DateTime.now();
  }

  LocationAddress? _parseAddress(Map<String, dynamic> item) {
    final latitude = double.tryParse(item['lat']?.toString() ?? '');
    final longitude = double.tryParse(item['lon']?.toString() ?? '');
    final displayName = item['display_name']?.toString().trim() ?? '';
    final rawAddress = item['address'];
    final address = rawAddress is Map
        ? Map<String, dynamic>.from(rawAddress)
        : const <String, dynamic>{};
    final countryCode = address['country_code']?.toString().toLowerCase() ?? '';
    if (latitude == null || longitude == null || displayName.isEmpty) {
      return null;
    }

    final primaryName = _firstNonEmpty([
      item['name'],
      address['neighbourhood'],
      address['suburb'],
      address['quarter'],
      address['city_district'],
      address['city'],
      address['town'],
      address['village'],
      address['municipality'],
      address['county'],
    ]);
    return LocationAddress(
      displayName: displayName,
      primaryName: primaryName ?? displayName.split(',').first.trim(),
      countryCode: countryCode,
      latitude: latitude,
      longitude: longitude,
    );
  }

  String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return null;
  }

  String _preferredLanguages(String query) {
    if (RegExp(r'[\u3040-\u30ff]').hasMatch(query)) return 'ja,en,ko';
    if (RegExp(r'[\uac00-\ud7af]').hasMatch(query)) return 'ko,en,ja';
    return 'en,ko,ja';
  }

  @override
  void close() {
    if (_ownsClient) _client.close();
  }
}
