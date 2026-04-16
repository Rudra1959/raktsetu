import 'package:flutter/material.dart';
import '../../widgets/landing/landing_header.dart';
import '../../widgets/landing/landing_hero.dart';
import '../../widgets/landing/landing_features.dart';
import '../../widgets/landing/landing_banner.dart';
import '../../widgets/landing/landing_cta.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: LandingHeader(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LandingHero(),
            LandingFeatures(),
            LandingBanner(),
            CallToAction(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
