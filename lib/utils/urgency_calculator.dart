import '../config/constants.dart';

/// Client-side urgency score calculator.
/// Mirrors the Cloud Function `computeUrgency` logic for preview.
class UrgencyCalculator {
  /// Compute urgency score (0-100) based on request parameters.
  static int compute({
    required String condition,
    required String bloodGroup,
    required int units,
    DateTime? surgeryTime,
  }) {
    int score = 0;

    // Condition weight (0-40 pts)
    switch (condition) {
      case 'critical':
        score += 40;
        break;
      case 'urgent':
        score += 25;
        break;
      default:
        score += 10;
    }

    // Surgery window (0-30 pts)
    if (surgeryTime != null) {
      final hoursLeft = surgeryTime.difference(DateTime.now()).inMinutes / 60.0;
      score += (30 - hoursLeft * 3).clamp(0, 30).round();
    }

    // Blood type rarity (0-20 pts)
    score += AppConstants.bloodGroupRarity[bloodGroup] ?? 5;

    // Units needed (0-10 pts)
    score += (units * 2).clamp(0, 10);

    return score.clamp(0, 100);
  }

  /// Human-readable urgency label.
  static String label(int score) {
    if (score >= 70) return 'Critical';
    if (score >= 40) return 'Urgent';
    return 'Standard';
  }

  /// Whether this score qualifies as emergency priority.
  static bool isEmergency(int score) => score >= 70;
}
