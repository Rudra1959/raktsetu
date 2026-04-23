import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Authentication state provider.
/// Manages the current user session and profile.
class RaktSetuAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _firebaseUser;
  UserModel? _userProfile;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isSignedIn => _firebaseUser != null;
  bool get canUseGoogleSignInOnWeb => _authService.canUseGoogleSignInOnWeb;
  bool get isProfileComplete =>
      _userProfile != null && _userProfile!.profileCompleted;

  RaktSetuAuthProvider() {
    _authService.authStateChanges.listen((user) async {
      _firebaseUser = user;
      if (user != null) {
        await _loadProfile();
      } else {
        _userProfile = null;
      }
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> _loadProfile() async {
    try {
      _userProfile = await _authService.getUserProfile();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load profile: $e';
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _authService.signInWithGoogle();
      await _loadProfile();
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


  Future<bool> completeProfile({
    required String name,
    required String role,
    required String bloodGroup,
    String? city,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.completeProfile(
        name: name,
        role: role,
        bloodGroup: bloodGroup,
        city: city,
      );
      await _loadProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to save profile: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _firebaseUser = null;
    _userProfile = null;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    await _loadProfile();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
