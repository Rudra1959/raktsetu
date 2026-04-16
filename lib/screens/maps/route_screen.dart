import 'package:flutter/material.dart';

/// Navigation route screen showing directions to hospital.
class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route')),
      body: const Center(
        child: Text('Route — Turn-by-turn navigation to hospital'),
      ),
    );
  }
}
