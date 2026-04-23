import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ... other imports remain exactly the same
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/request_provider.dart';
import 'providers/donor_provider.dart';
import 'providers/location_provider.dart';

/// RaktSetu — Smart Blood Allocation Platform
/// Entry point: initializes Firebase, sets up providers, launches app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Connect to local emulators in debug mode
  if (kDebugMode) {
    try {
      final String host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      print('Connected to Firebase Emulators ($host)');
    } catch (e) {
      print('Failed to setup emulators: $e');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RaktSetuAuthProvider()),
        ChangeNotifierProvider(create: (_) => RequestProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const RaktSetuApp(),
    ),
  );
}
