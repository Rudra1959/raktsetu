import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import 'blood_group_chip.dart';

/// Donor information card with blood group, distance, and status.
class DonorCard extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final String distance;
  final bool isAvailable;
  final VoidCallback? onTap;

  const DonorCard({
    super.key,
    required this.name,
    required this.bloodGroup,
    required this.distance,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: RaktSetuTheme.primaryRed.withOpacity(0.1),
                child: const Icon(Icons.person, color: RaktSetuTheme.primaryRed),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14,
                            color: Colors.grey.shade500),
                        const SizedBox(width: 2),
                        Text(distance, style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600,
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              BloodGroupChip(bloodGroup: bloodGroup),
            ],
          ),
        ),
      ),
    );
  }
}
