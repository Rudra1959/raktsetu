import 'package:flutter/material.dart';

/// Donor availability toggle screen (On-Duty / Off-Duty / Traveling).
class AvailabilityScreen extends StatelessWidget {
  const AvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Availability')),
      body: const Center(
        child: Text('Availability — Toggle On-Duty / Off-Duty / Traveling'),
      ),
    );
  }
}
