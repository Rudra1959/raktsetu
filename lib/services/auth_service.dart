import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../config/constants.dart';
import '../models/user_model.dart';

/// Authentication service wrapping Firebase Auth.
/// Supports Google Sign-In and Phone OTP verification.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn? _googleSignIn;

  static const String _webGoogleClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '218865648511-dmp2b9abrbhkkrhvta1qn6gaq0vmianu.apps.googleusercontent.com',
  );

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool get isSignedIn => currentUser != null;
  bool get canUseGoogleSignInOnWeb => true;

  GoogleSignIn _getGoogleSignIn() {
    if (_googleSignIn != null) return _googleSignIn!;

    if (kIsWeb) {
      if (_webGoogleClientId.isEmpty) {
        throw StateError(
          'Google web sign-in is not configured. Run with '
          '--dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID',
        );
      }
      _googleSignIn = GoogleSignIn(clientId: _webGoogleClientId);
      return _googleSignIn!;
    }

    _googleSignIn = GoogleSignIn();
    return _googleSignIn!;
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (kIsWeb) {
      // Use Firebase Auth's built-in web popup for Google Sign-in
      // This avoids redirect_uri_mismatch errors on local dynamic ports
      final googleProvider = GoogleAuthProvider();
      // Optional: you can add scopes here if needed
      final userCredential = await _auth.signInWithPopup(googleProvider);
      
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _createUserDocument(userCredential.user!);
      }
      return userCredential;
    }

    // Mobile fallback using google_sign_in package
    final googleUser = await _getGoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await _createUserDocument(userCredential.user!);
    }

    return userCredential;
  }


  Future<void> _createUserDocument(User user) async {
    final userModel = UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      phone: user.phoneNumber ?? '',
      email: user.email ?? '',
      role: 'patient',
      bloodGroup: 'O+',
      profileCompleted: false,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toFirestore(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile() async {
    if (currentUser == null) return null;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(currentUser!.uid)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> completeProfile({
    required String name,
    required String role,
    required String bloodGroup,
    String? city,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw StateError('No signed-in user found.');
    }

    try {
      await user.updateDisplayName(name).timeout(const Duration(seconds: 8));
    } catch (_) {}

    await _firestore.collection(AppConstants.usersCollection).doc(user.uid).set({
      'name': name,
      'role': role,
      'bloodGroup': bloodGroup,
      'city': city,
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'profileCompleted': true,
    }, SetOptions(merge: true),).timeout(const Duration(seconds: 12), onTimeout: () {
      throw Exception('Network timeout. Please check your connection and try again.');
    },);
  }

  Future<void> signOut() async {
    if (!kIsWeb && _googleSignIn != null) {
      try {
        await _googleSignIn!.signOut();
      } catch (_) {}
    }
    await _auth.signOut();
  }
}
