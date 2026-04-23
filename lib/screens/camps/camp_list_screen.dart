import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

/// List of upcoming blood camps/drives with premium 'Pro Max' design.
class CampListScreen extends StatelessWidget {
  const CampListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const camps = [
      ('Mega Donation Drive', 'Connaught Place, Delhi', '24 Oct • 09:00 AM', 156),
      ('Corporate Health Camp', 'Cyber City, Gurugram', '28 Oct • 10:30 AM', 89),
      ('University Life Drive', 'North Campus, DU', '02 Nov • 11:00 AM', 240),
    ];

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Background Atmosphere
          Positioned(top: -100, right: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.05), size: 400)),
          Positioned(bottom: -150, left: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.04), size: 500)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                centerTitle: true,
                title: Text(
                  'UPCOMING DRIVES', 
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
                        'Blood Camps',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          color: RaktSetuTheme.ink, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Join community-driven donation events and save multiple lives.',
                        style: GoogleFonts.manrope(
                          fontSize: 18, 
                          color: RaktSetuTheme.textSoft, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 56),

                      ...camps.map((camp) => _buildPremiumCampCard(camp)),
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

  Widget _buildPremiumCampCard((String, String, String, int) camp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: RaktSetuTheme.ink,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [RaktSetuTheme.ink, RaktSetuTheme.primaryRed.withValues(alpha: 0.8)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20, top: -20,
                  child: Icon(Icons.water_drop_rounded, size: 150, color: Colors.white.withValues(alpha: 0.05)),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          camp.$3.split(' • ').first, 
                          style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        camp.$1, 
                        style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded, size: 16, color: RaktSetuTheme.textSoft),
                          const SizedBox(width: 8),
                          Text(
                            camp.$2, 
                            style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft, fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, size: 16, color: RaktSetuTheme.primaryRed),
                          const SizedBox(width: 8),
                          Text(
                            '${camp.$4} Donors Responded', 
                            style: GoogleFonts.manrope(color: RaktSetuTheme.primaryRed, fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: RaktSetuTheme.ink,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'RSVP', 
                    style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
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

