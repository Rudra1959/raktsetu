import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Color-coded urgency badge.
class UrgencyBadge extends StatelessWidget {
  final int score;

  const UrgencyBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _color),
          const SizedBox(width: 4),
          Text(
            _label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }

  Color get _color {
    if (score >= 70) return RaktSetuTheme.emergencyRed;
    if (score >= 40) return RaktSetuTheme.warningOrange;
    return RaktSetuTheme.successGreen;
  }

  String get _label {
    if (score >= 70) return 'Critical';
    if (score >= 40) return 'Urgent';
    return 'Standard';
  }

  IconData get _icon {
    if (score >= 70) return Icons.emergency;
    if (score >= 40) return Icons.warning_amber;
    return Icons.check_circle;
  }
}
