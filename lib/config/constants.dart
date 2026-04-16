/// RaktSetu — Application Constants
/// Centralized configuration values used across the app.
class AppConstants {
  AppConstants._();

  // ── App Info ──
  static const String appName = 'RaktSetu';
  static const String appTagline = 'Smart Blood Allocation Platform';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Connecting blood donors with patients in real-time using '
      'intelligent matching and AI-powered demand forecasting.';

  // ── Matching Configuration ──
  static const double defaultSearchRadiusKm = 5.0;
  static const double maxSearchRadiusKm = 100.0;
  static const double radiusExpandStepKm = 5.0;
  static const int maxCandidateDonors = 5;

  // ── Donation Rules ──
  static const int donationCooldownDays = 56;
  static const double minHemoglobinMale = 13.0; // g/dL
  static const double minHemoglobinFemale = 12.5; // g/dL
  static const int minDonorAge = 18;
  static const int maxDonorAge = 65;

  // ── Escalation ──
  static const int escalationTimeoutMinutes = 30;
  static const int maxEscalationLevel = 2;

  // ── Blood Groups ──
  static const List<String> bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',
  ];

  /// Compatible donor blood groups for each patient blood group.
  /// Key = patient blood group, Value = list of compatible donor groups.
  static const Map<String, List<String>> compatibilityChart = {
    'A+': ['A+', 'A-', 'O+', 'O-'],
    'A-': ['A-', 'O-'],
    'B+': ['B+', 'B-', 'O+', 'O-'],
    'B-': ['B-', 'O-'],
    'O+': ['O+', 'O-'],
    'O-': ['O-'],
    'AB+': ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
    'AB-': ['A-', 'B-', 'O-', 'AB-'],
  };

  /// Rarity score for urgency calculation (higher = rarer).
  static const Map<String, int> bloodGroupRarity = {
    'AB-': 20,
    'B-': 15,
    'A-': 15,
    'O-': 10,
    'AB+': 8,
    'B+': 5,
    'A+': 5,
    'O+': 3,
  };

  // ── Request Status Flow ──
  static const List<String> requestStatusSteps = [
    'pending',
    'matching',
    'matched',
    'en_route',
    'fulfilled',
  ];

  static const Map<String, String> statusLabels = {
    'pending': 'Request Sent',
    'matching': 'Finding Donors',
    'matched': 'Donor Found',
    'en_route': 'Donor En Route',
    'fulfilled': 'Confirmed',
    'no_match': 'No Match Found',
    'cancelled': 'Cancelled',
  };

  // ── Firestore Collections ──
  static const String usersCollection = 'users';
  static const String requestsCollection = 'requests';
  static const String bloodBanksCollection = 'bloodBanks';
  static const String campsCollection = 'camps';
  static const String notificationsCollection = 'notifications';
  static const String forecastsCollection = 'forecasts';
  static const String leaderboardCollection = 'leaderboard';

  // ── Donor Modes ──
  static const String modeOnDuty = 'on_duty';
  static const String modeOffDuty = 'off_duty';
  static const String modeTraveling = 'traveling';

  // ── Gamification ──
  static const Map<int, String> donationBadges = {
    1: 'First Drop',
    3: 'Life Saver',
    5: 'Blood Hero',
    10: 'Crimson Champion',
    25: 'Platinum Donor',
    50: 'Legend of Life',
  };

  // ── API Endpoints ──
  static const String geminiModel = 'gemini-2.0-flash-exp';
  static const String gcpRegion = 'asia-south1';
}
