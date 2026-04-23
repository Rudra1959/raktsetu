import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

/// Elite Animated splash screen with 'Pro Max' branding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    final auth = context.read<RaktSetuAuthProvider>();
    final stopwatch = Stopwatch()..start();
    
    // Wait for auth to initialize if it hasn't yet (max 5 seconds)
    int attempts = 0;
    while (!auth.isInitialized && attempts < 50) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    // Ensure splash screen stays for at least 2.5 seconds
    final remaining = 2500 - stopwatch.elapsedMilliseconds;
    if (remaining > 0) {
      await Future<void>.delayed(Duration(milliseconds: remaining));
    }

    if (!mounted) return;

    if (auth.isSignedIn && auth.isProfileComplete) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    if (auth.isSignedIn && !auth.isProfileComplete) {
      Navigator.pushReplacementNamed(context, AppRoutes.register);
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.landing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Background Atmosphere
          Positioned(top: -100, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.1), size: 500)),
          Positioned(bottom: -150, right: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.08), size: 600)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: RaktSetuTheme.ink,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: RaktSetuTheme.ink.withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 20)),
                    ],
                  ),
                  child: const Icon(
                    Icons.water_drop_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ).animate().scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 1000.ms,
                      curve: Curves.easeOutBack,
                    ).shimmer(delay: 1200.ms, duration: 2000.ms),
                const SizedBox(height: 48),
                Text(
                  'RAKTSETU',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    color: RaktSetuTheme.ink,
                    letterSpacing: -1,
                    height: 1,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 12),
                Text(
                  'B L O O D • B R I D G E',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    letterSpacing: 6,
                    color: RaktSetuTheme.textSoft,
                    fontWeight: FontWeight.w900,
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
              ],
            ),
          ),
          
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(RaktSetuTheme.ink.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ).animate(delay: 1000.ms).fadeIn(),
        ],
      ),
    );
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

