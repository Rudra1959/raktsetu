import 'package:flutter/material.dart';

/// List of upcoming blood camps/drives.
class CampListScreen extends StatelessWidget {
  const CampListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Camps')),
      body: const Center(
        child: Text('Blood Camps — Upcoming drives with RSVP'),
      ),
    );
  }
}
