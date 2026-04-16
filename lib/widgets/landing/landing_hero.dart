import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class LandingHero extends StatelessWidget {
  const LandingHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF9F9FF),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.1,
              ),
              children: const [
                TextSpan(text: 'Connecting Donors.\n'),
                TextSpan(
                  text: 'Saving Lives.',
                  style: TextStyle(color: RaktSetuTheme.primaryRed),
                ),
                TextSpan(text: '\nInstantly'),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          Text(
            'RaktSetu is a real-time blood matching and emergency distribution system, ensuring that life saving bloods reaches those in need without delay',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          const SizedBox(height: 40),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/heroimg.png',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
        ],
      ),
    );
  }
}
