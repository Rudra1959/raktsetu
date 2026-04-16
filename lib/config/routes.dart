import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/request/create_request_screen.dart';
import '../screens/request/request_status_screen.dart';
import '../screens/request/emergency_sos_screen.dart';
import '../screens/donor/donor_profile_screen.dart';
import '../screens/donor/availability_screen.dart';
import '../screens/donor/donation_history_screen.dart';
import '../screens/maps/donor_map_screen.dart';
import '../screens/blood_bank/blood_bank_list_screen.dart';
import '../screens/blood_bank/inventory_screen.dart';
import '../screens/camps/camp_list_screen.dart';
import '../screens/camps/create_camp_screen.dart';
import '../screens/analytics/dashboard_screen.dart';
import '../screens/chatbot/eligibility_chat_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Centralized route definitions for RaktSetu.
class AppRoutes {
  AppRoutes._();

  // ── Route Names ──
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createRequest = '/request/create';
  static const String requestStatus = '/request/status';
  static const String emergencySOS = '/request/sos';
  static const String donorProfile = '/donor/profile';
  static const String donorAvailability = '/donor/availability';
  static const String donationHistory = '/donor/history';
  static const String donorMap = '/maps/donors';
  static const String bloodBankList = '/blood-banks';
  static const String bloodBankInventory = '/blood-banks/inventory';
  static const String campList = '/camps';
  static const String createCamp = '/camps/create';
  static const String analytics = '/analytics';
  static const String eligibilityChat = '/chatbot';
  static const String settings = '/settings';

  // ── Route Map ──
  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const HomeScreen(),
    createRequest: (_) => const CreateRequestScreen(),
    requestStatus: (_) => const RequestStatusScreen(),
    emergencySOS: (_) => const EmergencySOSScreen(),
    donorProfile: (_) => const DonorProfileScreen(),
    donorAvailability: (_) => const AvailabilityScreen(),
    donationHistory: (_) => const DonationHistoryScreen(),
    donorMap: (_) => const DonorMapScreen(),
    bloodBankList: (_) => const BloodBankListScreen(),
    bloodBankInventory: (_) => const InventoryScreen(),
    campList: (_) => const CampListScreen(),
    createCamp: (_) => const CreateCampScreen(),
    analytics: (_) => const DashboardScreen(),
    eligibilityChat: (_) => const EligibilityChatScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
