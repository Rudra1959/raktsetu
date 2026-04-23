import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

class DonorMapScreen extends StatelessWidget {
  const DonorMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const donors = [
      ('Aarav Mehta', 'O+ • 1.4 km away', 'Available now'),
      ('Priya Shah', 'A+ • 2.1 km away', 'Available in 20 min'),
      ('Nikhil Verma', 'B+ • 3.0 km away', 'Available now'),
      ('Ananya Das', 'O- • 4.6 km away', 'Available now'),
    ];

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'RADAR DISPATCH',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 2,
            color: RaktSetuTheme.ink,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Atmosphere
          Positioned(top: -100, right: -100, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.08), size: 500)),
          Positioned(bottom: -150, left: -50, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.06), size: 600)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      const _MockNetworkMap(),
                      // Floating Search Bar
                      Positioned(
                        top: 20,
                        left: 24,
                        right: 24,
                        child: _buildSearchBar(),
                      ),
                    ],
                  ),
                ),
                _buildDonorList(donors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: RaktSetuTheme.primaryRed, size: 20),
          const SizedBox(width: 12),
          Text(
            'Search for donors or blood groups...',
            style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft, fontWeight: FontWeight.w700, fontSize: 14),
          ),
          const Spacer(),
          const Icon(Icons.tune_rounded, color: RaktSetuTheme.textSoft, size: 20),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildDonorList(List<(String, String, String)> donors) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, -10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nearby Assets',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 18, color: RaktSetuTheme.ink),
              ),
              Text(
                '${donors.length} ONLINE',
                style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 11, color: RaktSetuTheme.successGreen, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: donors.length,
              itemBuilder: (context, index) => _buildDonorTile(donors[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorTile((String, String, String) donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: RaktSetuTheme.paper,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: RaktSetuTheme.primaryLight,
            child: Text(
              donor.$1[0],
              style: GoogleFonts.manrope(color: RaktSetuTheme.primaryRed, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  donor.$1, 
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 16, color: RaktSetuTheme.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  donor.$2, 
                  style: GoogleFonts.manrope(color: RaktSetuTheme.textSoft, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: RaktSetuTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              donor.$3,
              style: GoogleFonts.manrope(color: RaktSetuTheme.successGreen, fontWeight: FontWeight.w900, fontSize: 10),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05, end: 0);
  }
}

class _MockNetworkMap extends StatelessWidget {
  const _MockNetworkMap();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MapPainter(),
          ),
        ),
        const Positioned(top: 80, left: 180, child: _Pin(color: RaktSetuTheme.primaryRed)),
        const Positioned(top: 130, left: 260, child: _Pin(color: RaktSetuTheme.infoBlue)),
        const Positioned(top: 180, left: 350, child: _Pin(color: RaktSetuTheme.successGreen)),
        const Positioned(top: 220, left: 200, child: _Pin(color: RaktSetuTheme.primaryRed)),
        const Positioned(top: 140, left: 450, child: _Pin(color: RaktSetuTheme.infoBlue)),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RaktSetuTheme.ink.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    for (var i = 0; i < size.width; i += 50) {
      path.moveTo(i.toDouble(), 0);
      path.lineTo(i.toDouble(), size.height);
    }
    for (var i = 0; i < size.height; i += 50) {
      path.moveTo(0, i.toDouble());
      path.lineTo(size.width, i.toDouble());
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Pin extends StatelessWidget {
  final Color color;
  const _Pin({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds);
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
