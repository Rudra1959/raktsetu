import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/theme.dart';

/// Pro Max Analytics Dashboard
/// High-fidelity visualization of blood supply, demand, and system health.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RaktSetuTheme.paper,
      body: Stack(
        children: [
          // Background Telemetry
          Positioned(top: -100, left: -100, child: _AnimatedOrb(color: RaktSetuTheme.primaryRed.withValues(alpha: 0.06), size: 500)),
          Positioned(bottom: -150, right: -50, child: _AnimatedOrb(color: RaktSetuTheme.infoBlue.withValues(alpha: 0.04), size: 600)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: Container(color: Colors.transparent))),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                centerTitle: true,
                title: Text(
                  'SYSTEM TELEMETRY', 
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w900, 
                    color: RaktSetuTheme.ink, 
                    fontSize: 11, 
                    letterSpacing: 2.5,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Dashboard',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 64, 
                          fontWeight: FontWeight.w900, 
                          color: RaktSetuTheme.ink, 
                          height: 0.9,
                        ),
                      ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),
                      Text(
                        'Real-time visualization of global blood supply and demand metrics.',
                        style: GoogleFonts.manrope(
                          fontSize: 18, 
                          color: RaktSetuTheme.textSoft, 
                          fontWeight: FontWeight.w600,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 56),

                      _buildMetricGrid(),
                      const SizedBox(height: 48),

                      _buildSectionHeader('GEOSPATIAL DENSITY'),
                      const SizedBox(height: 20),
                      _buildSupplyHeatmap(),
                      const SizedBox(height: 48),

                      _buildSectionHeader('PREDICTIVE ANALYTICS'),
                      const SizedBox(height: 20),
                      _buildDemandChart(),
                      const SizedBox(height: 48),

                      _buildSystemHealthCard(),
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
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11, 
        fontWeight: FontWeight.w900, 
        color: RaktSetuTheme.textSoft, 
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildMetricGrid() {
    return const Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'LIVE SIGNALS', 
            value: '142', 
            color: RaktSetuTheme.primaryRed, 
            icon: Icons.radar_rounded, 
            index: 0,
            trend: '+12% vs last 24h',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _MetricCard(
            title: 'ACTIVE ASSETS', 
            value: '3.1K', 
            color: RaktSetuTheme.successGreen, 
            icon: Icons.people_rounded, 
            index: 1,
            trend: '+402 this week',
          ),
        ),
      ],
    );
  }

  Widget _buildSupplyHeatmap() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.03),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REGIONAL NODES', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 13, color: RaktSetuTheme.ink)),
                        Text('Active heatmap distribution', style: GoogleFonts.manrope(fontSize: 12, color: RaktSetuTheme.textSoft, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const _StatusIndicator(color: RaktSetuTheme.successGreen),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Icon(Icons.map_rounded, size: 100, color: RaktSetuTheme.primaryRed.withValues(alpha: 0.1)),
                ),
                const Spacer(),
                const Row(
                  children: [
                    _HeatmapLegendItem(color: RaktSetuTheme.primaryRed, label: 'Critical Lack'),
                    SizedBox(width: 24),
                    _HeatmapLegendItem(color: RaktSetuTheme.successGreen, label: 'Optimized'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDemandChart() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: RaktSetuTheme.ink,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('7-DAY PROJECTION', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white, letterSpacing: 1)),
                  Text('Demand forecasting engine', style: GoogleFonts.manrope(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w600)),
                ],
              ),
              const Icon(Icons.auto_awesome_rounded, color: Colors.white24),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final heights = [40, 70, 45, 90, 60, 85, 55];
              return Container(
                width: 36,
                height: heights[i].toDouble() * 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      RaktSetuTheme.primaryRed.withValues(alpha: 0.9),
                      RaktSetuTheme.primaryRed.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => Text(d, style: GoogleFonts.manrope(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.w800)))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSystemHealthCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: RaktSetuTheme.ink,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SYSTEM INTEGRITY', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Optimal latency across all nodes.', style: GoogleFonts.manrope(fontSize: 12, color: Colors.white38, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text('99.9%', style: GoogleFonts.manrope(fontWeight: FontWeight.w900, fontSize: 24, color: RaktSetuTheme.successGreen)),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms);
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  final int index;
  final String trend;

  const _MetricCard({required this.title, required this.value, required this.color, required this.icon, required this.index, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 40, offset: const Offset(0, 20)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 24),
          Text(value, style: GoogleFonts.cormorantGaramond(fontSize: 48, fontWeight: FontWeight.w900, color: RaktSetuTheme.ink, height: 1)),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w900, color: RaktSetuTheme.textSoft, letterSpacing: 1.5)),
          const SizedBox(height: 12),
          Text(trend, style: GoogleFonts.manrope(fontSize: 10, color: color, fontWeight: FontWeight.w800)),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).scale(curve: Curves.easeOutBack);
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  const _StatusIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('LIVE', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}

class _HeatmapLegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _HeatmapLegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w800, color: RaktSetuTheme.ink)),
      ],
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
        angle: _controller.value * 2 * 3.14159,
        child: Container(width: widget.size, height: widget.size * 1.1, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [widget.color, Colors.transparent]))),
      ),
    );
  }
}

