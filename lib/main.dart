import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'config/firebase_options.dart';
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
