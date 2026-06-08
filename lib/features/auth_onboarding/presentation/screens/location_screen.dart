import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/buttons/circle_arrow_button.dart';
import '../../../../core/widgets/inputs/rounded_text_input.dart';

const LatLng _defaultCenter = LatLng(41.8781, -87.6298);
const double _initialZoom = 12;
const double _addressZoom = 14;
const Duration _searchDebounce = Duration(milliseconds: 400);
const int _minQueryLength = 3;
const int _maxSuggestions = 5;
const String _userAgent = 'com.example.app_oot/1.0';
const Distance _distance = Distance();

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _addressController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng _markerPosition = _defaultCenter;
  LatLng? _userLocation;
  bool _hasSelection = false;

  Timer? _debounceTimer;
  List<_AddressSuggestion> _suggestions = [];
  bool _programmaticUpdate = false;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_onAddressChanged);
    _requestUserLocation();
  }

  @override
  void dispose() {
    _addressController.removeListener(_onAddressChanged);
    _addressController.dispose();
    _mapController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _requestUserLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.lowest,
        ),
      );
      if (!mounted) return;
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (_) {
      // silent fallback — suggestions just won't be distance-sorted
    }
  }

  void _setText(String text) {
    _programmaticUpdate = true;
    _addressController.text = text;
    _programmaticUpdate = false;
  }

  void _onAddressChanged() {
    if (_programmaticUpdate) return;
    _debounceTimer?.cancel();
    final query = _addressController.text.trim();
    if (query.length < _minQueryLength) {
      if (_suggestions.isNotEmpty) {
        setState(() => _suggestions = []);
      }
      return;
    }
    _debounceTimer = Timer(_searchDebounce, () => _searchAddresses(query));
  }

  Future<void> _searchAddresses(String query) async {
    _lastQuery = query;
    try {
      final url = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'json',
        'limit': '$_maxSuggestions',
        'addressdetails': '1',
      });
      final response = await http.get(
        url,
        headers: const {'User-Agent': _userAgent},
      );
      if (!mounted || _lastQuery != query) return;
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as List<dynamic>;
      final suggestions = data
          .map((item) => _AddressSuggestion.fromJson(item as Map<String, dynamic>))
          .toList();
      _sortByDistance(suggestions);
      setState(() => _suggestions = suggestions);
    } catch (_) {
      // silent
    }
  }

  void _sortByDistance(List<_AddressSuggestion> list) {
    final origin = _userLocation;
    if (origin == null) return;
    list.sort((a, b) {
      final da = _distance.distance(origin, LatLng(a.lat, a.lon));
      final db = _distance.distance(origin, LatLng(b.lat, b.lon));
      return da.compareTo(db);
    });
  }

  void _handleSuggestionTap(_AddressSuggestion suggestion) {
    FocusManager.instance.primaryFocus?.unfocus();
    final position = LatLng(suggestion.lat, suggestion.lon);
    _mapController.move(position, _addressZoom);
    _setText(suggestion.displayName);
    setState(() {
      _markerPosition = position;
      _hasSelection = true;
      _suggestions = [];
    });
  }

  void _handleMapTap(TapPosition position, LatLng point) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _markerPosition = point;
      _hasSelection = true;
      _suggestions = [];
    });
    _setText('');
    _reverseGeocode(point);
  }

  Future<void> _reverseGeocode(LatLng point) async {
    debugPrint(
      '[LocationScreen] Map tapped at '
      '(${point.latitude.toStringAsFixed(5)}, '
      '${point.longitude.toStringAsFixed(5)})',
    );
    try {
      final placemarks = await placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (!mounted || placemarks.isEmpty) {
        debugPrint('[LocationScreen] No placemarks resolved for tap');
        return;
      }
      final p = placemarks.first;
      final stateZip = [p.administrativeArea, p.postalCode]
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .join(' ');
      final parts = <String>[
        if (p.street != null && p.street!.isNotEmpty) p.street!,
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
        if (stateZip.isNotEmpty) stateZip,
        if (p.country != null && p.country!.isNotEmpty) p.country!,
      ];
      if (parts.isEmpty) {
        debugPrint('[LocationScreen] Placemark had no readable fields');
        return;
      }
      final address = parts.join(', ');
      debugPrint('[LocationScreen] Resolved address: $address');
      _setText(address);
    } catch (e) {
      debugPrint('[LocationScreen] Reverse geocode failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Text(
              'Where are you from?',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 26.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Totally optional, though people often connect over where someone's from.",
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorant(
                fontSize: 12.sp,
                color: AppColors.textPrimary,
                letterSpacing: 0.0.h,
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              height: 220.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.accent,
                  width: 1.5.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _markerPosition,
                    initialZoom: _initialZoom,
                    onTap: _handleMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: _userAgent,
                    ),
                    if (_hasSelection)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _markerPosition,
                            width: 40.w,
                            height: 40.w,
                            alignment: Alignment.topCenter,
                            child: Icon(
                              Icons.location_pin,
                              color: AppColors.accent,
                              size: 40.sp,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            RoundedTextInput(
              controller: _addressController,
              hintText: 'Enter your address, neighborhood, or ZIP',
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.search,
              onSubmitted: (q) => _searchAddresses(q.trim()),
            ),
            if (_suggestions.isNotEmpty) ...[
              SizedBox(height: 6.h),
              _SuggestionsDropdown(
                suggestions: _suggestions,
                onTap: _handleSuggestionTap,
              ),
            ],
            const Spacer(),
            CircleArrowButton(
              onPressed: _hasSelection ? widget.onNext : null,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

class _AddressSuggestion {
  _AddressSuggestion({
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  final String displayName;
  final double lat;
  final double lon;

  factory _AddressSuggestion.fromJson(Map<String, dynamic> json) {
    return _AddressSuggestion(
      displayName: json['display_name'] as String,
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
    );
  }
}

class _SuggestionsDropdown extends StatelessWidget {
  const _SuggestionsDropdown({
    required this.suggestions,
    required this.onTap,
  });

  final List<_AddressSuggestion> suggestions;
  final ValueChanged<_AddressSuggestion> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 180.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.w),
      ),
      clipBehavior: Clip.hardEdge,
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: suggestions.length,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          thickness: 1,
          color: const Color(0xFFF0F0F0),
          indent: 16.w,
          endIndent: 16.w,
        ),
        itemBuilder: (context, i) {
          final s = suggestions[i];
          return InkWell(
            onTap: () => onTap(s),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              child: Text(
                s.displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12.sp,
                  height: 1.3,
                  letterSpacing: 0.0.h,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
