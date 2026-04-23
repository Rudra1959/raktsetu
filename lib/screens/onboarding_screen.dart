import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/routes.dart';
import '../config/theme.dart';

import 'dart:ui';

/// Elite Onboarding experience with 'Pro Max' design standards.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: Icons.water_drop_rounded,
      title: 'Precision\nMatching',
      description: 'Connect with donors in under 500ms using our neural coordination engine.',
      color: RaktSetuTheme.primaryRed,
    ),
    _OnboardingPageData(
      icon: Icons.emergency_rounded,
      title: 'Emergency\nProtocol',
      description: 'Critical cases jump the queue automatically via AI-powered triage.',
      color: RaktSetuTheme.warningOrange,
    ),
    _OnboardingPageData(
      icon: Icons.location_on_rounded,
      title: 'Real-time\nTelemetry',
      description: 'Track donor progress with millimetric precision on the global grid.',
      color: RaktSetuTheme.successGreen,
    ),
    _OnboardingPageData(
      icon: Icons.auto_awesome_rounded,
      title: 'Gemini\nIntelligence',
      description: 'Multi-lingual AI predicts demand 14 days ahead for maximum readiness.',
      color: RaktSetuTheme.infoBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Dynamic Mesh Background
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            top: _currentPage % 2 == 0 ? -100 : 200,
            right: _currentPage % 2 == 0 ? -100 : 100,
            child: _AnimatedOrb(color: _pages[_currentPage].color.withValues(alpha: 0.08), size: 600),
          ),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RAKTSETU V2',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 3, color: RaktSetuTheme.ink.withValues(alpha: 0.5)),
          ),
          TextButton(
            onPressed: _goToLogin,
            child: Text(
              'SKIP',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1, color: RaktSetuTheme.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Row(
        children: [
          // Indicators
          ...List.generate(_pages.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              margin: const EdgeInsets.only(right: 8),
              width: _currentPage == i ? 32 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == i ? RaktSetuTheme.ink : RaktSetuTheme.line,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
          const Spacer(),
          // Next Button
          GestureDetector(
            onTap: _currentPage == _pages.length - 1 ? _goToLogin : _nextPage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: RaktSetuTheme.ink,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: RaktSetuTheme.ink.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Icon(
                _currentPage == _pages.length - 1 ? Icons.check_rounded : Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: data.color.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, 20))],
            ),
            child: Icon(data.icon, size: 64, color: data.color),
          ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
          const SizedBox(height: 64),
          Text(
            data.title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 64, 
              fontWeight: FontWeight.w900, 
              color: RaktSetuTheme.ink, 
              height: 0.9,
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          Text(
            data.description,
            style: GoogleFonts.manrope(
              fontSize: 18, 
              color: RaktSetuTheme.textSoft, 
              fontWeight: FontWeight.w600, 
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _OnboardingPageData({required this.icon, required this.title, required this.description, required this.color});
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

