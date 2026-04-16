import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication state provider.
/// Manages the current user session and profile.
class RaktSetuAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _firebaseUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  String? _error;

  // ── Getters ──
  User? get firebaseUser => _firebaseUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSignedIn => _firebaseUser != null;
  bool get isProfileComplete =>
      _userProfile != null && _userProfile!.bloodGroup.isNotEmpty;

  RaktSetuAuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((user) {
      _firebaseUser = user;
      if (user != null) {
        _loadProfile();
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  /// Load user profile from Firestore.
  Future<void> _loadProfile() async {
    try {
      _userProfile = await _authService.getUserProfile();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load profile: $e';
      notifyListeners();
    }
  }

  /// Sign in with Google.
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return credential != null;
    } catch (e) {
      _error = 'Google sign-in failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await _authService.signOut();
    _firebaseUser = null;
    _userProfile = null;
    notifyListeners();
  }

  /// Refresh user profile from Firestore.
  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  /// Clear error.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
