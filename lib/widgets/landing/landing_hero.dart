import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/theme.dart';

class LandingHero extends StatefulWidget {
  final VoidCallback onRequestBlood;
  final VoidCallback onBecomeDonor;

  const LandingHero({
    super.key,
    required this.onRequestBlood,
    required this.onBecomeDonor,
  });

  @override
  State<LandingHero> createState() => _LandingHeroState();
}

class _LandingHeroState extends State<LandingHero> with SingleTickerProviderStateMixin {
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final stacked = width < 1040;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, stacked ? 40 : 60, 24, stacked ? 60 : 80),
      decoration: const BoxDecoration(
        color: RaktSetuTheme.paper,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: stacked
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroCopy(
                      onRequestBlood: widget.onRequestBlood,
                      onBecomeDonor: widget.onBecomeDonor,
                    ),
                    const SizedBox(height: 48),
                    _HeroVisualPanel(
                      stacked: true,
                      orbitAnimation: _orbitController,
                    ),
                  ],
                )
              : SizedBox(
                  height: 680,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 40),
                          child: Center(
                            child: _HeroCopy(
                              onRequestBlood: widget.onRequestBlood,
                              onBecomeDonor: widget.onBecomeDonor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: _HeroVisualPanel(
                          stacked: false,
                          orbitAnimation: _orbitController,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final VoidCallback onRequestBlood;
  final VoidCallback onBecomeDonor;

  const _HeroCopy({
    required this.onRequestBlood,
    required this.onBecomeDonor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: RaktSetuTheme.primaryLight,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: RaktSetuTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat()).scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 1.seconds,
                  ).then().scale(
                    begin: const Offset(1.5, 1.5),
                    end: const Offset(1, 1),
                    duration: 1.seconds,
                  ),
              const SizedBox(width: 8),
              Text(
                'LIVE NETWORK • INDIA',
                style: GoogleFonts.manrope(
                  color: RaktSetuTheme.primaryRed,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 32),
        RichText(
          text: TextSpan(
            style: GoogleFonts.cormorantGaramond(
              fontSize: 76,
              height: 0.92,
              fontWeight: FontWeight.w900,
              color: RaktSetuTheme.ink,
            ),
            children: const [
              TextSpan(text: 'Every Drop.\n'),
              TextSpan(
                text: 'Every Life.\n',
                style: TextStyle(color: RaktSetuTheme.primaryRed),
              ),
              TextSpan(text: 'Synchronized.'),
            ],
          ),
        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            'RaktSetu is the orchestration layer for emergency blood coordination. We connect donors, hospitals, and banks into a single, high-fidelity signal.',
            style: GoogleFonts.manrope(
              fontSize: 18,
              height: 1.7,
              color: RaktSetuTheme.textSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              height: 64,
              width: 200,
              child: ElevatedButton(
                onPressed: onRequestBlood,
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  shadowColor: RaktSetuTheme.primaryRed.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('FIND BLOOD NOW'),
              ),
            ),
            SizedBox(
              height: 64,
              width: 200,
              child: OutlinedButton(
                onPressed: onBecomeDonor,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: RaktSetuTheme.line, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('JOIN THE NETWORK'),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
      ],
    );
  }
}

class _HeroVisualPanel extends StatelessWidget {
  final bool stacked;
  final Animation<double> orbitAnimation;

  const _HeroVisualPanel({
    required this.stacked,
    required this.orbitAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: stacked ? 480 : 680),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: RaktSetuTheme.ink,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Premium Background Image
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/hero_premium.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: RaktSetuTheme.primaryDark,
                ),
              ),
            ),
          ),
          
          // Animated Orbit Overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: orbitAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _PremiumOrbitPainter(progress: orbitAnimation.value),
                );
              },
            ),
          ),

          // Glassmorphic Content
          Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.04),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: RaktSetuTheme.primaryRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: RaktSetuTheme.primaryRed.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 40),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                    const SizedBox(height: 32),
                    const _PremiumSignalChip(label: '2,340 Units Available', color: RaktSetuTheme.successGreen),
                    const SizedBox(height: 12),
                    const _PremiumSignalChip(label: '847 Active Donors', color: RaktSetuTheme.infoBlue),
                    const SizedBox(height: 12),
                    const _PremiumSignalChip(label: '92 Fulfilled Today', color: RaktSetuTheme.warningOrange),
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            right: 24,
            bottom: 24,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: RaktSetuTheme.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'SYSTEMS OPTIMAL',
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 1.seconds).scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          curve: Curves.easeOutCubic,
        );
  }
}

class _PremiumSignalChip extends StatelessWidget {
  final String label;
  final Color color;

  const _PremiumSignalChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8, spreadRadius: 2),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumOrbitPainter extends CustomPainter {
  final double progress;

  _PremiumOrbitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    for (var i = 1; i <= 5; i++) {
      final radius = (size.shortestSide * 0.15) * i;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumOrbitPainter oldDelegate) => oldDelegate.progress != progress;
}

