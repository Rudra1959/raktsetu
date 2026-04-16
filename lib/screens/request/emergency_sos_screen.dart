import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

/// One-tap Emergency SOS blood request screen.
class EmergencySOSScreen extends StatefulWidget {
  const EmergencySOSScreen({super.key});

  @override
  State<EmergencySOSScreen> createState() => _EmergencySOSScreenState();
}

class _EmergencySOSScreenState extends State<EmergencySOSScreen> {
  bool _isSending = false;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Emergency SOS'),
      ),
      body: Center(
        child: _sent ? _buildSentState() : _buildSOSButton(),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TAP TO SEND\nEMERGENCY REQUEST',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white54,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: _isSending ? null : _sendSOS,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _isSending ? 160 : 180,
            height: _isSending ? 160 : 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  RaktSetuTheme.emergencyRed,
                  RaktSetuTheme.primaryDark,
                ],
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                  color: RaktSetuTheme.emergencyRed.withOpacity(0.4),
                  blurRadius: 40,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Center(
              child: _isSending
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : Text(
                      'SOS',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
            ),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 1500.ms,
            ),
        const SizedBox(height: 40),
        Text(
          'Uses your saved profile & current location',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white38),
        ),
      ],
    );
  }

  Widget _buildSentState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 80, color: RaktSetuTheme.successGreen)
            .animate()
            .scale(duration: 500.ms, curve: Curves.elasticOut),
        const SizedBox(height: 24),
        Text(
          'SOS Sent!',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Finding nearest donors...\nYou will be notified when a match is found.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.white60),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: RaktSetuTheme.primaryDark,
          ),
          child: const Text('Back to Home'),
        ),
      ],
    );
  }

  Future<void> _sendSOS() async {
    setState(() => _isSending = true);
    // In production: create emergency request with user's profile,
    // current location, and max urgency score
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSending = false;
      _sent = true;
    });
  }
}
