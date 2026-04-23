import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Google Maps Platform service for directions, ETA, and geocoding.
class MapsService {
  // Note: In production, API key should come from environment config
  // and directions should be called via Cloud Functions for key security.
  final String _apiKey;

  MapsService({required String apiKey}) : _apiKey = apiKey;

  /// Get driving directions and ETA between two points.
  /// Returns route polyline and estimated duration.
  Future<DirectionsResult?> getDirections({
    required GeoPoint origin,
    required GeoPoint destination,
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&mode=driving'
      '&departure_time=now'
      '&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final routes = data['routes'] as List<dynamic>? ?? const <dynamic>[];
    if (data['status'] != 'OK' || routes.isEmpty) return null;

    final route = routes.first as Map<String, dynamic>;
    final legs = route['legs'] as List<dynamic>? ?? const <dynamic>[];
    if (legs.isEmpty) return null;
    final leg = legs.first as Map<String, dynamic>;
    final distance = leg['distance'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final duration = leg['duration'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final durationInTraffic =
        leg['duration_in_traffic'] as Map<String, dynamic>?;
    final overviewPolyline =
        route['overview_polyline'] as Map<String, dynamic>? ?? const <String, dynamic>{};

    return DirectionsResult(
      distanceText: distance['text'] as String? ?? '',
      distanceMeters: (distance['value'] as num?)?.toInt() ?? 0,
      durationText:
          durationInTraffic?['text'] as String? ?? duration['text'] as String? ?? '',
      durationSeconds:
          (durationInTraffic?['value'] as num?)?.toInt() ??
          (duration['value'] as num?)?.toInt() ??
          0,
      encodedPolyline: overviewPolyline['points'] as String? ?? '',
    );
  }

  /// Geocode an address string to lat/lng.
  Future<GeoPoint?> geocodeAddress(String address) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json'
      '?address=${Uri.encodeComponent(address)}'
      '&region=in' // India bias
      '&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    final data = json.decode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>? ?? const <dynamic>[];
    if (data['status'] != 'OK' || results.isEmpty) return null;

    final result = results.first as Map<String, dynamic>;
    final geometry = result['geometry'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    final location =
        geometry['location'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return GeoPoint(
      (location['lat'] as num?)?.toDouble() ?? 0,
      (location['lng'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Get distance matrix for batch distance computation.
  /// Used to rank top-N nearest donors efficiently.
  Future<List<DistanceEntry>> getDistanceMatrix({
    required GeoPoint origin,
    required List<GeoPoint> destinations,
  }) async {
    final destStr = destinations
        .map((d) => '${d.latitude},${d.longitude}')
        .join('|');

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/distancematrix/json'
      '?origins=${origin.latitude},${origin.longitude}'
      '&destinations=$destStr'
      '&mode=driving'
      '&key=$_apiKey',
    );

    final response = await http.get(url);
    if (response.statusCode != 200) return [];

    final data = json.decode(response.body) as Map<String, dynamic>;
    if (data['status'] != 'OK') return [];

    final rows = data['rows'] as List<dynamic>? ?? const <dynamic>[];
    if (rows.isEmpty) return [];
    final row = rows.first as Map<String, dynamic>;
    final elements = row['elements'] as List<dynamic>? ?? const <dynamic>[];
    return elements.asMap().entries.map((entry) {
      final element = entry.value as Map<String, dynamic>;
      if (element['status'] != 'OK') {
        return DistanceEntry(index: entry.key, distanceMeters: -1, durationSeconds: -1);
      }
      final distance =
          element['distance'] as Map<String, dynamic>? ?? const <String, dynamic>{};
      final duration =
          element['duration'] as Map<String, dynamic>? ?? const <String, dynamic>{};
      return DistanceEntry(
        index: entry.key,
        distanceMeters: (distance['value'] as num?)?.toInt() ?? -1,
        durationSeconds: (duration['value'] as num?)?.toInt() ?? -1,
        distanceText: distance['text'] as String?,
        durationText: duration['text'] as String?,
      );
    }).toList();
  }
}

/// Result from Directions API call.
class DirectionsResult {
  final String distanceText;
  final int distanceMeters;
  final String durationText;
  final int durationSeconds;
  final String encodedPolyline;

  const DirectionsResult({
    required this.distanceText,
    required this.distanceMeters,
    required this.durationText,
    required this.durationSeconds,
    required this.encodedPolyline,
  });

  /// ETA in minutes.
  int get etaMinutes => (durationSeconds / 60).ceil();
}

/// Single entry in a distance matrix response.
class DistanceEntry {
  final int index;
  final int distanceMeters;
  final int durationSeconds;
  final String? distanceText;
  final String? durationText;

  const DistanceEntry({
    required this.index,
    required this.distanceMeters,
    required this.durationSeconds,
    this.distanceText,
    this.durationText,
  });
}
