import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LandingBanner extends StatelessWidget {
  final VoidCallback onRequestBlood;
  final VoidCallback onBecomeDonor;

  const LandingBanner({
    super.key,
    required this.onRequestBlood,
    required this.onBecomeDonor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 58),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            RaktSetuTheme.primaryRed,
            RaktSetuTheme.primaryDark,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            children: [
              Text(
                'Join RaktSetu',
                style: GoogleFonts.manrope(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Be the bridge\nsomeone is waiting for.',
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  color: Colors.white,
                  fontSize: 58,
                  height: 0.96,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'Every registration, every donation, and every hour of availability moves India closer to a system where blood reaches patients before panic does.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    height: 1.65,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: onRequestBlood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: RaktSetuTheme.primaryRed,
                      ),
                      child: const Text('Donate Blood'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: OutlinedButton(
                      onPressed: onBecomeDonor,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.28)),
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text('Register Your Facility'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
