import 'package:flutter/material.dart';

/// Analytics dashboard with blood supply heatmap and charts.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: const Center(
        child: Text('Analytics — Blood supply/demand heatmap and forecasts'),
      ),
    );
  }
}
