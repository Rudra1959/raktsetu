import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/landing/landing_banner.dart';
import '../../widgets/landing/landing_cta.dart';
import '../../widgets/landing/landing_features.dart';
import '../../widgets/landing/landing_header.dart';
import '../../widgets/landing/landing_hero.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _processKey = GlobalKey();
  final _facilitiesKey = GlobalKey();
  final _problemKey = GlobalKey();
  final _donorKey = GlobalKey();

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;

    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
      alignment: 0.06,
    );
  }

  void _handleRequestFlow() {
    final auth = context.read<RaktSetuAuthProvider>();
    if (auth.isSignedIn && auth.isProfileComplete) {
      Navigator.pushNamed(context, AppRoutes.createRequest);
      return;
    }
    Navigator.pushNamed(context, AppRoutes.login);
  }

  void _handleDonorFlow() {
    final auth = context.read<RaktSetuAuthProvider>();
    if (auth.isSignedIn && !auth.isProfileComplete) {
      Navigator.pushNamed(context, AppRoutes.register);
      return;
    }

    Navigator.pushNamed(
      context,
      auth.isSignedIn ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      appBar: LandingHeader(
        onNavigate: (section) {
          switch (section) {
            case LandingSection.hero:
              _scrollTo(_heroKey);
              break;
            case LandingSection.process:
              _scrollTo(_processKey);
              break;
            case LandingSection.facilities:
              _scrollTo(_facilitiesKey);
              break;
            case LandingSection.problem:
              _scrollTo(_problemKey);
              break;
            case LandingSection.donate:
              _scrollTo(_donorKey);
              break;
          }
        },
        onRequestBlood: _handleRequestFlow,
        onBecomeDonor: _handleDonorFlow,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              key: _heroKey,
              child: LandingHero(
                onRequestBlood: _handleRequestFlow,
                onBecomeDonor: _handleDonorFlow,
              ),
            ),
            LandingFeatures(
              processKey: _processKey,
              facilitiesKey: _facilitiesKey,
              problemKey: _problemKey,
              donorKey: _donorKey,
              onRequestBlood: _handleRequestFlow,
              onBecomeDonor: _handleDonorFlow,
            ),
            LandingBanner(
              onRequestBlood: _handleRequestFlow,
              onBecomeDonor: _handleDonorFlow,
            ),
            LandingFooter(
              onOpenLogin: () => Navigator.pushNamed(context, AppRoutes.login),
              onOpenRegister: _handleDonorFlow,
              onOpenRequest: _handleRequestFlow,
            ),
          ],
        ),
      ),
    );
  }
}
