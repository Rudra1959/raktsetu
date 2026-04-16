import 'dart:math';

/// Haversine formula for calculating great-circle distance
/// between two points on Earth's surface.
class Haversine {
  static const double _earthRadiusKm = 6371.0;

  /// Distance in kilometers between two lat/lng pairs.
  static double distanceKm(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  /// Distance in meters.
  static double distanceMeters(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return distanceKm(lat1, lon1, lat2, lon2) * 1000;
  }

  static double _toRadians(double degrees) => degrees * pi / 180.0;

  /// Bounding box for a given center point and radius.
  /// Useful for pre-filtering Firestore queries before Haversine.
  static ({double minLat, double maxLat, double minLng, double maxLng})
      boundingBox(double lat, double lng, double radiusKm) {
    final latDelta = radiusKm / 111.32;
    final lngDelta = radiusKm / (111.32 * cos(_toRadians(lat)));
    return (
      minLat: lat - latDelta,
      maxLat: lat + latDelta,
      minLng: lng - lngDelta,
      maxLng: lng + lngDelta,
    );
  }
}
