import 'package:flutter/material.dart';

class CaffeineLogScreen extends StatelessWidget {
  const CaffeineLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caffeine')),
      body: const Center(child: Text('Caffeine log (Milestone 3)')),
    );
  }
}
