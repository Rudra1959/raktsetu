import 'package:flutter/material.dart';

/// Screen to organize a new blood camp/drive.
class CreateCampScreen extends StatelessWidget {
  const CreateCampScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organize Blood Camp')),
      body: const Center(
        child: Text('Create Camp — Schedule, location, target units'),
      ),
    );
  }
}
