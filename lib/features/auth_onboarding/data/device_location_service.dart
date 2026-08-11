import 'package:geolocator/geolocator.dart';

class DeviceCoordinates {
  const DeviceCoordinates({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

abstract interface class DeviceLocationService {
  Future<DeviceCoordinates> currentCoordinates();
}

class GeolocatorDeviceLocationService implements DeviceLocationService {
  const GeolocatorDeviceLocationService();

  @override
  Future<DeviceCoordinates> currentCoordinates() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const DeviceLocationException(
        'Turn on location services to use your current location.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const DeviceLocationException(
        'Location permission is needed to find your current address.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const DeviceLocationException(
        'Enable location permission for OOT in your device settings.',
      );
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 12),
      ),
    );
    return DeviceCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class DeviceLocationException implements Exception {
  const DeviceLocationException(this.message);

  final String message;

  @override
  String toString() => message;
}
