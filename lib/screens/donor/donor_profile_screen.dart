import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class DonorProfileScreen extends StatelessWidget {
  const DonorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<RaktSetuAuthProvider>(context);
    final user = auth.userProfile;

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            stretch: true,
            backgroundColor: RaktSetuTheme.ink,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Animated Organic Mesh Background
                  Container(color: RaktSetuTheme.ink),
                  Positioned(
                    top: -100,
                    right: -100,
                    child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.4), size: 400),
                  ),
                  Positioned(
                    bottom: -50,
                    left: -50,
                    child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.25), size: 350),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                  
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'profile_avatar',
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                child: Text(
                                  (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'U',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 80, 
                                    fontWeight: FontWeight.w900, 
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          user?.name ?? 'Unknown User',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 48, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          child: Text(
                            user?.role.toUpperCase() ?? 'DONOR',
                            style: GoogleFonts.manrope(
                              fontSize: 11, 
                              fontWeight: FontWeight.w900, 
                              color: Colors.white.withValues(alpha: 0.9), 
                              letterSpacing: 2.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                decoration: const BoxDecoration(
                  color: RaktSetuTheme.paper,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(56), 
                    topRight: Radius.circular(56),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsRow(user?.bloodGroup ?? 'N/A', user?.canDonate == true ? 'READY' : 'COOLDOWN'),
                    const SizedBox(height: 56),
                    _buildSectionHeader('Verification Profile'),
                    const SizedBox(height: 28),
                    _buildPremiumTile(Icons.alternate_email_rounded, 'Authentication ID', user?.email ?? 'Unlinked Account', 0),
                    _buildPremiumTile(Icons.phone_iphone_rounded, 'Emergency Contact', user?.phone ?? 'Not Configured', 1),
                    _buildPremiumTile(Icons.location_on_rounded, 'Operational Sector', user?.city ?? 'Global Grid', 2),
                    
                    const SizedBox(height: 56),
                    _buildSectionHeader('Contribution Impact'),
                    const SizedBox(height: 28),
                    _ImpactCard().animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),
                    
                    const SizedBox(height: 64),
                    SizedBox(
                      width: double.infinity,
                      height: 72,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.4), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: () => auth.signOut(),
                        child: Text(
                          'SECURE SIGN OUT', 
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 12,
                            color: RaktSetuTheme.primaryRed,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(String bloodGroup, String status) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('BLOOD TYPE', bloodGroup, RaktSetuTheme.primaryRed, 0)),
        const SizedBox(width: 20),
        Expanded(child: _buildStatCard('READINESS', status, status == 'READY' ? RaktSetuTheme.successGreen : RaktSetuTheme.warningOrange, 1)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color, int index) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 25, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: GoogleFonts.manrope(
              fontSize: 10, 
              color: RaktSetuTheme.textSoft, 
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value, 
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40, 
              fontWeight: FontWeight.w900, 
              color: color,
              height: 1,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 18, 
        fontWeight: FontWeight.w900, 
        color: RaktSetuTheme.ink,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildPremiumTile(IconData icon, String label, String value, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: RaktSetuTheme.primaryLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: RaktSetuTheme.primaryRed, size: 24),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(), 
                    style: GoogleFonts.manrope(
                      fontSize: 10, 
                      color: RaktSetuTheme.textSoft, 
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value, 
                    style: GoogleFonts.manrope(
                      fontSize: 17, 
                      fontWeight: FontWeight.w900, 
                      color: RaktSetuTheme.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (300 + index * 100).ms).slideX(begin: 0.05, end: 0),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 35, offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: RaktSetuTheme.primaryRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 48, color: RaktSetuTheme.primaryRed),
          ),
          const SizedBox(height: 28),
          Text(
            'Operational Journey',
            style: GoogleFonts.manrope(
              fontSize: 22, 
              fontWeight: FontWeight.w900, 
              color: RaktSetuTheme.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your biometric data and life-saving contributions will be automatically encrypted and tracked here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 15, 
              color: RaktSetuTheme.textSoft, 
              fontWeight: FontWeight.w700,
              height: 1.7,
            ),
          ),
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.rotate(
        angle: _controller.value * 2 * 3.14159,
        child: Container(
          width: widget.size,
          height: widget.size * 1.2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [widget.color, Colors.transparent], stops: const [0.4, 1.0]),
          ),
        ),
      ),
    );
  }
}
