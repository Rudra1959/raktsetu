import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class BloodBankListScreen extends StatelessWidget {
  const BloodBankListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const banks = [
      ('Rotary Alpha Center', 'Open now • 2.3 km away', '24 units O+ available', true),
      ('AIIMS Bio-Bank', 'Open 24/7 • 4.0 km away', '18 units mixed inventory', true),
      ('Red Cross Network', 'Open till 8 PM • 5.2 km away', '12 units A+ available', false),
      ('Lions Global Reserve', 'Open now • 7.8 km away', '8 units O- available', true),
    ];

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Background Atmosphere
          Positioned(top: -150, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.successGreen.withValues(alpha: 0.06), size: 500)),
          Positioned(bottom: -100, right: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.04), size: 450)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                centerTitle: true,
                title: Text(
                  'GLOBAL RESERVES', 
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w900, 
                    color: RaktSetuTheme.ink, 
                    fontSize: 11, 
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blood Banks',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          color: RaktSetuTheme.ink, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Identify verified medical centers with active inventory protocols.',
                        style: GoogleFonts.manrope(
                          fontSize: 18, 
                          color: RaktSetuTheme.textSoft, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 56),

                      ...banks.map((bank) => _buildPremiumBankTile(bank)),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBankTile((String, String, String, bool) bank) {
    final isVerified = bank.$4;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: RaktSetuTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.local_hospital_rounded, color: RaktSetuTheme.successGreen, size: 28),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      bank.$1, 
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 18, color: RaktSetuTheme.ink, letterSpacing: -0.5),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.verified_rounded, color: RaktSetuTheme.infoBlue, size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  bank.$2, 
                  style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft, fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: RaktSetuTheme.primaryRed.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bank.$3, 
                    style: GoogleFonts.manrope(
                      color: RaktSetuTheme.primaryRed, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: RaktSetuTheme.line),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }
}

class _AnimatedOrb extends StatefulWidget {
  final Color color;
  final double size;
  const _AnimatedOrb({required this.color, required this.size});

  @override
  State<_AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<_AnimatedOrb> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14,
        child: Container(
          width: widget.size, height: widget.size * 1.1,
          decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [widget.color, Colors.transparent])),
        ),
      ),
    );
  }
}

