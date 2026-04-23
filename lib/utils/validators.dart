/// Form validation helpers for RaktSetu.
class Validators {
  Validators._();

  /// Validate phone number (Indian format).
  static String? phone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (!RegExp(r'^(\+91)?[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid Indian phone number';
    }
    return null;
  }

  /// Validate name.
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 2) return 'Name too short';
    return null;
  }

  /// Validate email.
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null; // Optional
    if (!RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  /// Validate blood units (1-10).
  static String? units(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final n = int.tryParse(value);
    if (n == null || n < 1 || n > 10) return 'Enter 1-10 units';
    return null;
  }

  /// Validate hemoglobin level.
  static String? hemoglobin(String? value, {bool isMale = true}) {
    if (value == null || value.isEmpty) return 'Required';
    final hb = double.tryParse(value);
    if (hb == null) return 'Enter a valid number';
    final min = isMale ? 13.0 : 12.5;
    if (hb < min) return 'Minimum $min g/dL required';
    return null;
  }

  /// Generic required field validator.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
