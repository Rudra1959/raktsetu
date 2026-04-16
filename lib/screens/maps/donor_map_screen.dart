import 'package:flutter/material.dart';

/// Google Maps screen showing nearby donors with pins.
class DonorMapScreen extends StatelessWidget {
  const DonorMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Donors')),
      body: const Center(
        child: Text('Donor Map — Google Maps with donor location pins'),
      ),
    );
  }
}
