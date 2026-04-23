import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<RaktSetuAuthProvider>(context);

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Animated Background Orbs
          Positioned(top: -150, right: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.08), size: 500)),
          Positioned(bottom: -100, left: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.05), size: 450)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container(color: Colors.transparent))),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: RaktSetuTheme.ink, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                centerTitle: true,
                title: Text(
                  'SYSTEM CONFIG', 
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w900, 
                    color: RaktSetuTheme.ink, 
                    fontSize: 11, 
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preferences',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          color: RaktSetuTheme.ink, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Customize your interface and security protocols.',
                        style: GoogleFonts.manrope(
                          fontSize: 18, 
                          color: RaktSetuTheme.textSoft, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 56),

                      _buildSectionHeader('SECURITY OPS'),
                      _buildPremiumSettingTile(Icons.person_rounded, 'Biological Identity', 'Manage encrypted profile data', () {}),
                      _buildPremiumSettingTile(Icons.security_rounded, 'Security Protocol', 'Biometric & session management', () {}),
                      const SizedBox(height: 48),

                      _buildSectionHeader('COMMUNICATIONS'),
                      _buildPremiumSettingTile(
                        Icons.notifications_active_rounded, 
                        'High-Priority Alerts', 
                        'Critical emergency broadcast signals', 
                        () {}, 
                        trailing: _buildPremiumSwitch(true, (v) {}),
                      ),
                      const SizedBox(height: 48),

                      _buildSectionHeader('INTERFACE'),
                      _buildPremiumSettingTile(Icons.translate_rounded, 'System Language', 'English (Global Grid)', () {}),
                      _buildPremiumSettingTile(
                        Icons.auto_awesome_rounded, 
                        'Pro Max Experience', 
                        'Advanced visual telemetry', 
                        () {}, 
                        trailing: _buildPremiumSwitch(true, (v) {}),
                      ),
                      const SizedBox(height: 48),

                      _buildSectionHeader('RESOURCE CENTER'),
                      _buildPremiumSettingTile(Icons.help_center_rounded, 'Technical Intel', 'Documentation & field guides', () {}),
                      _buildPremiumSettingTile(Icons.info_rounded, 'System Intel', 'RaktSetu Pro Max v2.0', () {}),
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
                            'SECURE TERMINAL LOGOUT',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w900, 
                              color: RaktSetuTheme.primaryRed,
                              letterSpacing: 2,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms).scale(),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 20),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 11, 
          fontWeight: FontWeight.w900, 
          color: RaktSetuTheme.textSoft, 
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPremiumSettingTile(IconData icon, String title, String subtitle, VoidCallback onTap, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        leading: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: RaktSetuTheme.primaryLight, 
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: RaktSetuTheme.primaryRed, size: 24),
        ),
        title: Text(
          title, 
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w900, 
            fontSize: 17, 
            color: RaktSetuTheme.ink,
            letterSpacing: -0.5,
          ),
        ),
        subtitle: Text(
          subtitle, 
          style: GoogleFonts.manrope(
            fontSize: 13, 
            color: RaktSetuTheme.textSoft, 
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: RaktSetuTheme.line, size: 24),
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }

  Widget _buildPremiumSwitch(bool value, void Function(bool) onChanged) {
    return Switch.adaptive(
      value: value, 
      onChanged: onChanged,
      activeTrackColor: RaktSetuTheme.successGreen,
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
          width: widget.size, 
          height: widget.size * 1.1, 
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            gradient: RadialGradient(colors: [widget.color, Colors.transparent]),
          ),
        ),
      ),
    );
  }
}

