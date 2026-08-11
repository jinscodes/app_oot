import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/device_location_service.dart';
import '../../data/location_search_service.dart';
import '../../data/supported_location_suggestions.dart';
import '../widgets/oot_design_system.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({
    super.key,
    this.onNext,
    this.searchService,
    this.deviceLocationService,
    this.loadMapTiles = true,
  });

  final VoidCallback? onNext;
  final LocationSearchService? searchService;
  final DeviceLocationService? deviceLocationService;
  final bool loadMapTiles;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();
  late final LocationSearchService _searchService;
  late final DeviceLocationService _deviceLocationService;
  late final bool _ownsSearchService;

  List<LocationAddress> _results = const [];
  LocationAddress? _selectedAddress;
  String? _errorMessage;
  String _resultQuery = '';
  bool _loading = false;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _ownsSearchService = widget.searchService == null;
    _searchService = widget.searchService ?? NominatimLocationSearchService();
    _deviceLocationService =
        widget.deviceLocationService ?? const GeolocatorDeviceLocationService();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mapController.dispose();
    if (_ownsSearchService) _searchService.close();
    super.dispose();
  }

  Future<void> _search(String rawQuery) async {
    if (_loading) return;
    final query = rawQuery.trim();
    if (query.length < 2) {
      setState(() {
        _results = const [];
        _errorMessage = 'Enter at least two characters to search.';
      });
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _results = const [];
      _resultQuery = query;
      _errorMessage = null;
    });
    try {
      final results = await _searchService.search(query);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _results = results;
        _errorMessage = results.isEmpty
            ? 'No matching address found in South Korea or Japan.'
            : null;
      });
    } on LocationSearchException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Unable to search right now. Please try again.';
      });
    }
  }

  Future<void> _selectMapPoint(LatLng point) async {
    if (_loading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _results = const [];
      _resultQuery = '';
      _errorMessage = null;
    });
    await _reverseAndSelect(point.latitude, point.longitude);
  }

  Future<void> _useCurrentLocation() async {
    if (_loading) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _results = const [];
      _resultQuery = '';
      _errorMessage = null;
    });
    try {
      final point = await _deviceLocationService.currentCoordinates();
      await _reverseAndSelect(point.latitude, point.longitude);
    } on DeviceLocationException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Unable to get your current location.';
      });
    }
  }

  Future<void> _reverseAndSelect(double latitude, double longitude) async {
    try {
      final result = await _searchService.reverse(
        latitude: latitude,
        longitude: longitude,
      );
      if (!mounted) return;
      if (result == null) {
        setState(() {
          _loading = false;
          _errorMessage = 'Choose a location within South Korea or Japan.';
        });
        return;
      }
      setState(() => _loading = false);
      _selectAddress(result);
    } on LocationSearchException catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = 'Unable to identify that address. Please try again.';
      });
    }
  }

  void _selectAddress(LocationAddress address) {
    _controller.text = address.displayName;
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
    setState(() {
      _selectedAddress = address;
      _results = const [];
      _resultQuery = '';
      _errorMessage = null;
    });
    if (_mapReady) {
      _mapController.move(LatLng(address.latitude, address.longitude), 13.5);
    }
  }

  void _onQueryChanged(String value) {
    final query = value.trim();
    setState(() {
      _selectedAddress = null;
      _results = supportedLocationsMatching(query);
      _resultQuery = query;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OotOnboardingScaffold(
      progressLabel: 'Match preferences',
      currentStep: 1,
      totalSteps: 7,
      buttonLabel: 'Continue',
      onContinue: _selectedAddress == null ? null : widget.onNext,
      body: Column(
        children: [
          const OotHero(
            eyebrow: 'Your world',
            title: 'Where are you from?',
            description:
                'Choose an address in South Korea or Japan that feels like home.',
          ),
          SizedBox(height: 34.h),
          const OotSectionLabel('Your location'),
          SizedBox(height: 10.h),
          _LocationMap(
            controller: _mapController,
            selectedAddress: _selectedAddress,
            loading: _loading,
            loadTiles: widget.loadMapTiles,
            onMapReady: () {
              _mapReady = true;
              final selected = _selectedAddress;
              if (selected != null) {
                _mapController.move(
                  LatLng(selected.latitude, selected.longitude),
                  13.5,
                );
              }
            },
            onMapTap: _selectMapPoint,
            onCurrentLocation: _useCurrentLocation,
          ),
          SizedBox(height: 10.h),
          _SearchField(
            controller: _controller,
            loading: _loading,
            onChanged: _onQueryChanged,
            onSubmitted: _search,
            onSearch: () => _search(_controller.text),
          ),
          if (_results.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _SearchResults(
              results: _results,
              query: _resultQuery,
              onSelected: _selectAddress,
            ),
          ],
          if (_errorMessage != null) ...[
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  color: const Color(0xFFB45F54),
                  fontSize: 11.sp,
                  height: 16 / 11,
                ),
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Search or tap the map · South Korea and Japan only.',
              style: ootHelperStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMap extends StatelessWidget {
  const _LocationMap({
    required this.controller,
    required this.selectedAddress,
    required this.loading,
    required this.loadTiles,
    required this.onMapReady,
    required this.onMapTap,
    required this.onCurrentLocation,
  });

  static const _tileUrl = String.fromEnvironment(
    'OOT_MAP_TILE_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  final MapController controller;
  final LocationAddress? selectedAddress;
  final bool loading;
  final bool loadTiles;
  final VoidCallback onMapReady;
  final ValueChanged<LatLng> onMapTap;
  final VoidCallback onCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final selected = selectedAddress;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: SizedBox(
        height: 184.h,
        child: Stack(
          children: [
            FlutterMap(
              mapController: controller,
              options: MapOptions(
                initialCenter: const LatLng(36.4, 134.7),
                initialZoom: 4.6,
                minZoom: 4,
                maxZoom: 18,
                backgroundColor: const Color(0xFFEEE5DE),
                cameraConstraint: CameraConstraint.containCenter(
                  bounds: LatLngBounds(
                    const LatLng(23.0, 122.0),
                    const LatLng(46.5, 146.5),
                  ),
                ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onTap: (_, point) => onMapTap(point),
                onMapReady: onMapReady,
              ),
              children: [
                if (loadTiles)
                  TileLayer(
                    urlTemplate: _tileUrl,
                    userAgentPackageName: 'com.example.app_oot',
                    maxNativeZoom: 19,
                    panBuffer: 0,
                  ),
                if (selected != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(selected.latitude, selected.longitude),
                        width: 48.w,
                        height: 48.h,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.location_on_rounded,
                          size: 46.sp,
                          color: AppColors.accentStrong,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            Positioned(
              right: 10.w,
              top: 10.h,
              child: Material(
                color: Colors.white.withValues(alpha: .94),
                shape: const CircleBorder(),
                elevation: 2,
                child: IconButton(
                  key: const ValueKey('use-current-location'),
                  tooltip: 'Use current location',
                  onPressed: loading ? null : onCurrentLocation,
                  icon: Icon(
                    Icons.my_location_rounded,
                    color: AppColors.accentStrong,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            if (loading)
              Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(
                    color: Colors.white.withValues(alpha: .24),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 28.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: 6.w,
              bottom: 4.h,
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  color: Colors.white.withValues(alpha: .88),
                  child: Text(
                    '© OpenStreetMap contributors',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 8.sp,
                      height: 10 / 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.loading,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearch,
  });

  final TextEditingController controller;
  final bool loading;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: TextField(
        key: const ValueKey('location-search-field'),
        controller: controller,
        enabled: !loading,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontSize: 14.sp,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search Seoul, Busan, Tokyo, Osaka…',
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF9A8880),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.textMuted,
            size: 20.sp,
          ),
          suffixIcon: IconButton(
            key: const ValueKey('submit-location-search'),
            tooltip: 'Search address',
            onPressed: loading ? null : onSearch,
            icon: Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.accentStrong,
              size: 20.sp,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.results,
    required this.query,
    required this.onSelected,
  });

  final List<LocationAddress> results;
  final String query;
  final ValueChanged<LocationAddress> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderStrong),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < results.length; index++) ...[
            InkWell(
              key: ValueKey('location-result-$index'),
              onTap: () => onSelected(results[index]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.accent,
                      size: 19.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HighlightedText(
                            text: results[index].primaryName,
                            query: query,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              color: AppColors.textPrimary,
                              fontSize: 13.sp,
                              height: 18 / 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          _HighlightedText(
                            text:
                                '${results[index].displayName} · ${results[index].countryName}',
                            query: query,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 10.sp,
                              height: 14 / 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (index < results.length - 1)
              Divider(height: 1.h, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    required this.maxLines,
  });

  final String text;
  final String query;
  final TextStyle style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final matchStart = query.isEmpty
        ? -1
        : text.toLowerCase().indexOf(query.toLowerCase());
    if (matchStart < 0) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final matchEnd = matchStart + query.length;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, matchStart)),
          TextSpan(
            text: text.substring(matchStart, matchEnd),
            style: style.copyWith(
              color: AppColors.accentStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: text.substring(matchEnd)),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
