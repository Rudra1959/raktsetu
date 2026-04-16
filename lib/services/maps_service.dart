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

    final data = json.decode(response.body);
    if (data['status'] != 'OK' || (data['routes'] as List).isEmpty) return null;

    final route = data['routes'][0];
    final leg = route['legs'][0];

    return DirectionsResult(
      distanceText: leg['distance']['text'],
      distanceMeters: leg['distance']['value'],
      durationText: leg['duration_in_traffic']?['text'] ?? leg['duration']['text'],
      durationSeconds: leg['duration_in_traffic']?['value'] ?? leg['duration']['value'],
      encodedPolyline: route['overview_polyline']['points'],
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

    final data = json.decode(response.body);
    if (data['status'] != 'OK' || (data['results'] as List).isEmpty) return null;

    final location = data['results'][0]['geometry']['location'];
    return GeoPoint(location['lat'], location['lng']);
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

    final data = json.decode(response.body);
    if (data['status'] != 'OK') return [];

    final elements = data['rows'][0]['elements'] as List;
    return elements.asMap().entries.map((entry) {
      final element = entry.value;
      if (element['status'] != 'OK') {
        return DistanceEntry(index: entry.key, distanceMeters: -1, durationSeconds: -1);
      }
      return DistanceEntry(
        index: entry.key,
        distanceMeters: element['distance']['value'],
        durationSeconds: element['duration']['value'],
        distanceText: element['distance']['text'],
        durationText: element['duration']['text'],
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
