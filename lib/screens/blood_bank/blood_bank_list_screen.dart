import 'package:flutter/material.dart';

/// List of nearby blood banks with search.
class BloodBankListScreen extends StatelessWidget {
  const BloodBankListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Banks')),
      body: const Center(
        child: Text('Blood Banks — Nearby verified blood banks with inventory'),
      ),
    );
  }
}
