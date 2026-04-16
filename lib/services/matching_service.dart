import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/request_model.dart';

/// Client-side matching utilities.
/// Primary matching happens in Cloud Functions, but these helpers
/// are used for distance display and local ranking.
class MatchingService {
  /// Earth radius in kilometers.
  static const double _earthRadiusKm = 6371.0;

  /// Haversine formula: calculates distance in km between two GeoPoints.
  /// This is the same algorithm used in the Cloud Functions matching engine.
  static double distanceKm(GeoPoint p1, GeoPoint p2) {
    final dLat = _toRad(p2.latitude - p1.latitude);
    final dLon = _toRad(p2.longitude - p1.longitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(p1.latitude)) *
            cos(_toRad(p2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusKm * c;
  }

  /// Convert degrees to radians.
  static double _toRad(double deg) => deg * pi / 180.0;

  /// Rank donors by distance from a hospital/patient location.
  /// Returns sorted list with distance field populated.
  static List<DonorWithDistance> rankByDistance({
    required GeoPoint origin,
    required List<UserModel> donors,
    double maxRadiusKm = 10.0,
  }) {
    final ranked = donors
        .map((donor) {
          if (donor.location == null) return null;
          final dist = distanceKm(origin, donor.location!);
          return DonorWithDistance(donor: donor, distanceKm: dist);
        })
        .where((d) => d != null && d.distanceKm <= maxRadiusKm)
        .cast<DonorWithDistance>()
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return ranked;
  }

  /// Format distance for display.
  static String formatDistance(double km) {
    if (km < 1) {
      return '${(km * 1000).round()} m';
    } else if (km < 10) {
      return '${km.toStringAsFixed(1)} km';
    } else {
      return '${km.round()} km';
    }
  }

  /// Client-side urgency score preview (mirrors Cloud Function logic).
  static int computeUrgencyPreview(RequestModel request) {
    int score = 0;

    // Condition weight (0-40 pts)
    switch (request.condition) {
      case 'critical':
        score += 40;
        break;
      case 'urgent':
        score += 25;
        break;
      default:
        score += 10;
    }

    // Surgery window (0-30 pts)
    if (request.surgeryTime != null) {
      final hoursLeft =
          request.surgeryTime!.difference(DateTime.now()).inMinutes / 60.0;
      score += (30 - hoursLeft * 3).clamp(0, 30).round();
    }

    // Blood type rarity (0-20 pts)
    const rarityMap = {
      'AB-': 20, 'B-': 15, 'A-': 15, 'O-': 10,
      'AB+': 8, 'B+': 5, 'A+': 5, 'O+': 3,
    };
    score += rarityMap[request.bloodGroup] ?? 5;

    // Units needed (0-10 pts)
    score += (request.units * 2).clamp(0, 10);

    return score.clamp(0, 100);
  }
}

/// A donor paired with their distance from the request location.
class DonorWithDistance {
  final UserModel donor;
  final double distanceKm;

  const DonorWithDistance({
    required this.donor,
    required this.distanceKm,
  });
}
