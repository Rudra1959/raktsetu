import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/location_service.dart';

/// Location state provider.
/// Manages current position and live location streaming.
class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? _currentPosition;
  StreamSubscription<Position>? _positionSub;
  bool _isTracking = false;
  bool _hasPermission = false;

  // ── Getters ──
  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  bool get hasPermission => _hasPermission;
  GeoPoint? get currentGeoPoint => _currentPosition != null
      ? GeoPoint(_currentPosition!.latitude, _currentPosition!.longitude)
      : null;

  /// Initialize: check permissions and get current position.
  Future<void> initialize() async {
    _hasPermission = await _locationService.checkPermissions();
    if (_hasPermission) {
      _currentPosition = await _locationService.getCurrentPosition();
    }
    notifyListeners();
  }

  /// Start streaming location updates.
  void startTracking() {
    if (!_hasPermission || _isTracking) return;

    _isTracking = true;
    _positionSub = _locationService.getPositionStream().listen((position) {
      _currentPosition = position;
      notifyListeners();
    });
    notifyListeners();
  }

  /// Stop streaming.
  void stopTracking() {
    _positionSub?.cancel();
    _isTracking = false;
    notifyListeners();
  }

  /// Refresh current position.
  Future<void> refreshPosition() async {
    _currentPosition = await _locationService.getCurrentPosition();
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }
}
