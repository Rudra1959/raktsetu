import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Location service wrapping Geolocator for GPS access.
class LocationService {
  /// Check and request location permissions.
  Future<bool> checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Get current device position.
  Future<Position?> getCurrentPosition() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Minimum 10m change
      ),
    );
  }

  /// Convert Position to Firestore GeoPoint.
  GeoPoint? positionToGeoPoint(Position? position) {
    if (position == null) return null;
    return GeoPoint(position.latitude, position.longitude);
  }

  /// Stream continuous location updates.
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // Update every 50m
      ),
    );
  }

  /// Open device location settings.
  Future<bool> openSettings() async {
    return Geolocator.openLocationSettings();
  }
}
