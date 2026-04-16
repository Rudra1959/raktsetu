import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF1F3FF),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Engineered For Emergency',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: RaktSetuTheme.primaryRed,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          _FeatureBox(
            title: 'Rapid Deploy',
            description: 'Instant activation when every second counts for safety.',
            icon: Icons.flash_on,
          ),
          const SizedBox(height: 24),
          _FeatureBox(
            title: 'Heavy Duty',
            description: 'Built with reinforced materials to withstand extreme impact.',
            icon: Icons.shield,
          ),
          const SizedBox(height: 24),
          _FeatureBox(
            title: '24/7 Support',
            description: 'Our emergency response team is always one call away.',
            icon: Icons.support_agent,
          ),
        ],
      ),
    );
  }
}

class _FeatureBox extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _FeatureBox({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: RaktSetuTheme.primaryRed, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
