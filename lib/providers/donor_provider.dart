import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../config/constants.dart';

/// Donor-specific state provider.
/// Manages availability toggle, profile, and donation stats.
class DonorProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  UserModel? _donor;
  List<UserModel> _leaderboard = [];
  bool _isLoading = false;

  // ── Getters ──
  UserModel? get donor => _donor;
  List<UserModel> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  bool get isAvailable => _donor?.isAvailable ?? false;
  bool get canDonate => _donor?.canDonate ?? false;
  int get daysUntilEligible => _donor?.daysUntilEligible ?? 0;
  int get totalDonations => _donor?.totalDonations ?? 0;
  List<String> get badges => _donor?.badges ?? [];

  /// Load donor profile.
  Future<void> loadDonor(String uid) async {
    _isLoading = true;
    notifyListeners();

    _donor = await _firestoreService.getUser(uid);
    _isLoading = false;
    notifyListeners();
  }

  /// Toggle donor availability.
  Future<void> toggleAvailability(String uid) async {
    if (_donor == null) return;
    final newState = !_donor!.isAvailable;

    await _firestoreService.updateUser(uid, {'isAvailable': newState});
    _donor = _donor!.copyWith(isAvailable: newState);
    notifyListeners();
  }

  /// Set availability mode.
  Future<void> setMode(String uid, String mode) async {
    final bool available = mode == AppConstants.modeOnDuty;
    await _firestoreService.updateUser(uid, {
      'availabilityMode': mode,
      'isAvailable': available,
    });
    _donor = _donor!.copyWith(
      availabilityMode: mode,
      isAvailable: available,
    );
    notifyListeners();
  }

  /// Update preferred donation radius.
  Future<void> updateRadius(String uid, double radiusKm) async {
    await _firestoreService.updateUser(uid, {'preferredRadiusKm': radiusKm});
    _donor = _donor!.copyWith(preferredRadiusKm: radiusKm);
    notifyListeners();
  }

  /// Load leaderboard.
  Future<void> loadLeaderboard() async {
    _leaderboard = await _firestoreService.getLeaderboard();
    notifyListeners();
  }

  /// Get the next badge the donor can earn.
  String? get nextBadge {
    final donations = totalDonations;
    for (final entry in AppConstants.donationBadges.entries) {
      if (donations < entry.key) return entry.value;
    }
    return null;
  }

  /// How many more donations until the next badge.
  int get donationsToNextBadge {
    final donations = totalDonations;
    for (final threshold in AppConstants.donationBadges.keys) {
      if (donations < threshold) return threshold - donations;
    }
    return 0;
  }
}
