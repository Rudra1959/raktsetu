import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
    // Auto-redirect if already signed in and profile is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<RaktSetuAuthProvider>();
      if (auth.isSignedIn && auth.isProfileComplete) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  Future<void> _continueAfterAuth(RaktSetuAuthProvider authProvider) async {
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      authProvider.isProfileComplete ? AppRoutes.home : AppRoutes.register,
    );
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<RaktSetuAuthProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 960;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Mesh Gradient or Orbs
          Positioned(
            top: -100,
            left: -100,
            child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.08), size: 500),
          ),
          Positioned(
            bottom: -150,
            right: -50,
            child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.06), size: 600),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isDesktop
                      ? Row(
                          children: [
                            const Expanded(child: _LoginHero()),
                            const SizedBox(width: 60),
                            Expanded(child: _buildLoginCard(authProvider)),
                          ],
                        )
                      : Column(
                          children: [
                            const _LoginHero(),
                            const SizedBox(height: 40),
                            _buildLoginCard(authProvider),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(RaktSetuAuthProvider authProvider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 40, offset: const Offset(0, 20)),
            ],
          ),
          child: _LoginCardContent(
            authProvider: authProvider,
            onGoogle: () async {
              final success = await authProvider.signInWithGoogle();
              if (success && mounted) {
                // Brief pause to ensure Firestore data is fully synced before checking profile status
                await Future<void>.delayed(const Duration(milliseconds: 400));
                if (mounted) _continueAfterAuth(authProvider);
              }
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, end: 0);
  }

  @override
  void dispose() {
    super.dispose();
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
        return Transform.translate(
          offset: Offset(
            20 * (1.0 * (0.5 + 0.5 * (6.28 * _controller.value).toDouble())), 
            20 * (1.0 * (0.5 + 0.5 * (3.14 * _controller.value).toDouble())),
          ),
          child: Transform.scale(
            scale: 1.0 + 0.1 * (0.5 + 0.5 * (6.28 * _controller.value).toDouble()),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [widget.color, Colors.transparent],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: RaktSetuTheme.primaryLight,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user_rounded, size: 14, color: RaktSetuTheme.primaryRed),
              const SizedBox(width: 8),
              Text(
                'SECURE ACCESS V2',
                style: GoogleFonts.manrope(
                  color: RaktSetuTheme.primaryRed,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: 32),
        Text(
          'Join the elite\nnetwork of\ndonors.',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 84,
            fontWeight: FontWeight.w900,
            height: 0.9,
            color: RaktSetuTheme.ink,
            letterSpacing: -2,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideX(begin: -0.05, end: 0),
        const SizedBox(height: 32),
        Text(
          'RaktSetu provides a premium orchestration layer for\nemergency blood coordination. Fast, reliable, and\nlife-saving.',
          style: GoogleFonts.manrope(
            fontSize: 20,
            color: RaktSetuTheme.textSoft,
            height: 1.7,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideX(begin: -0.05, end: 0),
      ],
    );
  }
}

class _LoginCardContent extends StatelessWidget {
  final RaktSetuAuthProvider authProvider;
  final VoidCallback onGoogle;

  const _LoginCardContent({
    required this.authProvider,
    required this.onGoogle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 48, 
            fontWeight: FontWeight.w900, 
            color: RaktSetuTheme.ink,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Identify yourself to access the platform.',
          style: GoogleFonts.manrope(
            color: RaktSetuTheme.textSoft, 
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 48),
        
        // Premium Google Button
        GestureDetector(
          onTap: authProvider.isLoading || !authProvider.canUseGoogleSignInOnWeb ? null : onGoogle,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: RaktSetuTheme.line.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), 
                    blurRadius: 20, 
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  authProvider.isLoading 
                      ? const SizedBox(
                          width: 20, 
                          height: 20, 
                          child: CircularProgressIndicator(strokeWidth: 2.5, color: RaktSetuTheme.primaryRed),
                        )
                      : Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/588px-Google_%22G%22_Logo.svg.png',
                          width: 24,
                          height: 24,
                        ),
                  const SizedBox(width: 16),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: RaktSetuTheme.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 48),
        Center(
          child: Text(
            'Secure authentication powered by Google.',
            style: GoogleFonts.manrope(
              color: RaktSetuTheme.textSoft,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.landing),
            child: Text(
              'Return to Welcome Screen', 
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w900, 
                color: RaktSetuTheme.textSoft,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
