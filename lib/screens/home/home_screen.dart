import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/request_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<RaktSetuAuthProvider>(context);
    final requestProvider = Provider.of<RequestProvider>(context);
    final user = auth.userProfile;
    final firstName = (user?.name.isNotEmpty ?? false)
        ? user!.name.split(' ').first
        : 'there';

    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GREETINGS, $firstName',
              style: GoogleFonts.manrope(
                fontSize: 10,
                color: RaktSetuTheme.textSoft,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'RaktSetu',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: RaktSetuTheme.ink,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RaktSetuTheme.primaryRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PRO',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1, end: 0),
        actions: [
          _buildActionButton(
            context: context,
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildActionButton(
            context: context,
            icon: Icons.settings_rounded,
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: [
          // High-Fidelity Mesh Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF8F9FF)),
            ),
          ),
          Positioned(
            top: -150,
            left: -100,
            child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.15), size: 500),
          ),
          Positioned(
            top: 250,
            right: -150,
            child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.12), size: 450),
          ),
          Positioned(
            bottom: -100,
            left: 100,
            child: _AnimatedOrb(color: RaktSetuTheme.successGreen.withValues(alpha: 0.1), size: 400),
          ),
          
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // High Intensity SOS Card
                  _EmergencyCard(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.emergencySOS),
                  ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 40),

                  // Vibrant Action Grid
                  const _SectionHeader(title: 'Life-Saving Services'),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: isWide ? 4 : 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.95,
                        children: [
                          _ActionTile(
                            icon: Icons.water_drop_rounded,
                            title: 'Request',
                            subtitle: 'Initiate Dispatch',
                            color: RaktSetuTheme.primaryRed,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.createRequest),
                          ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
                          _ActionTile(
                            icon: Icons.explore_rounded,
                            title: 'Explore',
                            subtitle: 'Find Elite Donors',
                            color: RaktSetuTheme.infoBlue,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.donorMap),
                          ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
                          _ActionTile(
                            icon: Icons.local_hospital_rounded,
                            title: 'Centres',
                            subtitle: 'Blood Logistics',
                            color: RaktSetuTheme.successGreen,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.bloodBankList),
                          ).animate().scale(delay: 600.ms, curve: Curves.easeOutBack),
                          _ActionTile(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Analytics',
                            subtitle: 'Impact Dashboard',
                            color: RaktSetuTheme.warningOrange,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.analytics),
                          ).animate().scale(delay: 700.ms, curve: Curves.easeOutBack),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Real-time Intelligence
                  const _SectionHeader(title: 'Operational Status'),
                  const SizedBox(height: 20),
                  _IntelligenceCard(
                    title: 'Fulfillment Engine',
                    value: requestProvider.activeRequest?.status.toUpperCase() ?? 'IDLE SYSTEM',
                    description: requestProvider.activeRequest != null 
                        ? 'Precision matching active for ${requestProvider.activeRequest!.bloodGroup}.'
                        : 'No active blood requisitions in your immediate sector.',
                    icon: Icons.radar_rounded,
                    color: RaktSetuTheme.primaryRed,
                    onTap: () => Navigator.pushNamed(
                      context, 
                      requestProvider.activeRequest != null ? AppRoutes.requestStatus : AppRoutes.createRequest,
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2, end: 0),
                  
                  const SizedBox(height: 20),
                  
                  _IntelligenceCard(
                    title: 'Personal Readiness',
                    value: user?.canDonate == true ? 'READY FOR SERVICE' : 'RECOVERY MODE',
                    description: user?.canDonate == true
                        ? 'Biometric profile optimal. Your contribution is highly requested.'
                        : 'Recovery protocols active. Eligibility restored in ${user?.daysUntilEligible ?? 0} days.',
                    icon: Icons.shield_rounded,
                    color: RaktSetuTheme.successGreen,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.donorProfile),
                  ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _PremiumNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, AppRoutes.donorMap);
          if (index == 2) Navigator.pushNamed(context, AppRoutes.analytics);
          if (index == 3) Navigator.pushNamed(context, AppRoutes.donorProfile);
        },
      ),
    );
  }

  Widget _buildActionButton({required BuildContext context, required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: RaktSetuTheme.ink, size: 22),
        onPressed: onTap,
      ),
    ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: RaktSetuTheme.ink,
        letterSpacing: 1.5,
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
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
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
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * 3.14159,
          child: Container(
            width: widget.size,
            height: widget.size * 1.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [widget.color, Colors.transparent], stops: const [0.3, 1.0]),
            ),
          ),
        );
      },
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final VoidCallback onTap;
  const _EmergencyCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: RaktSetuTheme.primaryRed,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: RaktSetuTheme.primaryRed.withValues(alpha: 0.4),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              // Abstract Design Elements
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(Icons.bolt_rounded, size: 200, color: Colors.white.withValues(alpha: 0.08)),
              ),
              Padding(
                padding: const EdgeInsets.all(36),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'LEVEL 1 PRIORITY',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'SOS\nEMERGENCY',
                            style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 36,
                              height: 0.9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20),
                        ],
                      ),
                      child: const Icon(Icons.emergency_share_rounded, color: RaktSetuTheme.primaryRed, size: 32),
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds, color: RaktSetuTheme.primaryRed.withValues(alpha: 0.1)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 30, offset: const Offset(0, 15)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w900, 
                fontSize: 17, 
                color: RaktSetuTheme.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: RaktSetuTheme.textSoft, 
                fontSize: 11, 
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntelligenceCard extends StatelessWidget {
  final String title;
  final String value;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IntelligenceCard({
    required this.title,
    required this.value,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 25, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 10),
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.manrope(
                    color: color, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 11, 
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_outward_rounded, size: 16, color: RaktSetuTheme.textSoft),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 32, 
                fontWeight: FontWeight.w900, 
                color: RaktSetuTheme.ink, 
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.manrope(
                color: RaktSetuTheme.textSoft, 
                fontSize: 14, 
                fontWeight: FontWeight.w700, 
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  const _PremiumNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: RaktSetuTheme.ink,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(icon: Icons.grid_view_rounded, isSelected: selectedIndex == 0, onTap: () => onTap(0), label: 'Core'),
          _NavBarItem(icon: Icons.explore_rounded, isSelected: selectedIndex == 1, onTap: () => onTap(1), label: 'Radar'),
          _NavBarItem(icon: Icons.analytics_rounded, isSelected: selectedIndex == 2, onTap: () => onTap(2), label: 'Stats'),
          _NavBarItem(icon: Icons.person_rounded, isSelected: selectedIndex == 3, onTap: () => onTap(3), label: 'ID'),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  const _NavBarItem({required this.icon, required this.isSelected, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? RaktSetuTheme.primaryRed : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3), 
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
