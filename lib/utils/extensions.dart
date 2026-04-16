import 'package:flutter/material.dart';

/// Dart extension methods for RaktSetu.

/// String extensions.
extension StringExtensions on String {
  /// Capitalize first letter.
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Title case: capitalize each word.
  String get titleCase =>
      split(' ').map((w) => w.capitalize).join(' ');
}

/// DateTime extensions.
extension DateTimeExtensions on DateTime {
  /// Whether this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is in the past.
  bool get isPast => isBefore(DateTime.now());
}

/// BuildContext extensions for quick access.
extension ContextExtensions on BuildContext {
  /// Screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Theme data.
  ThemeData get theme => Theme.of(this);

  /// Color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Show snackbar.
  void showSnack(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
