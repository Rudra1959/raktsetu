import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Styled blood group badge chip.
class BloodGroupChip extends StatelessWidget {
  final String bloodGroup;
  final bool large;

  const BloodGroupChip({
    super.key,
    required this.bloodGroup,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = RaktSetuTheme.bloodGroupColors[bloodGroup] ??
        RaktSetuTheme.primaryRed;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 10,
        vertical: large ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(large ? 12 : 8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        bloodGroup,
        style: GoogleFonts.inter(
          fontSize: large ? 20 : 14,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
