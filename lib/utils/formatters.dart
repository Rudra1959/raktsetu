import 'package:intl/intl.dart';

/// Formatting utilities for dates, distances, and display values.
class Formatters {
  Formatters._();

  /// Format distance for display.
  static String distance(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    if (km < 10) return '${km.toStringAsFixed(1)} km';
    return '${km.round()} km';
  }

  /// Format ETA for display.
  static String eta(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  /// Format date as "12 Apr 2025".
  static String date(DateTime dt) => DateFormat('d MMM yyyy').format(dt);

  /// Format date as "12 Apr at 2:30 PM".
  static String dateTime(DateTime dt) =>
      DateFormat('d MMM \'at\' h:mm a').format(dt);

  /// Format time as "2:30 PM".
  static String time(DateTime dt) => DateFormat('h:mm a').format(dt);

  /// Relative time ago: "2 min ago", "3h ago", "Yesterday".
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return date(dt);
  }

  /// Format donation count with impact message.
  static String donationImpact(int donations) {
    final livesImpacted = donations * 3; // Each unit helps ~3 people
    return 'You saved $donations lives, $livesImpacted people were impacted';
  }

  /// Format phone number as +91 XXXXX XXXXX.
  static String phone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) {
      return '+91 ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return phone;
  }
}
