import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'blood_group_chip.dart';
import 'urgency_badge.dart';

/// Blood request summary card.
class RequestCard extends StatelessWidget {
  final String patientName;
  final String bloodGroup;
  final int units;
  final int urgencyScore;
  final String status;
  final String hospital;
  final VoidCallback? onTap;

  const RequestCard({
    super.key,
    required this.patientName,
    required this.bloodGroup,
    required this.units,
    required this.urgencyScore,
    required this.status,
    required this.hospital,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(patientName, style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.w600,
                    ),),
                  ),
                  UrgencyBadge(score: urgencyScore),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  BloodGroupChip(bloodGroup: bloodGroup),
                  const SizedBox(width: 8),
                  Text('$units unit${units > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.grey.shade600),),
                  const Spacer(),
                  Icon(Icons.local_hospital, size: 16,
                      color: Colors.grey.shade400,),
                  const SizedBox(width: 4),
                  Text(hospital, style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade600,
                  ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
