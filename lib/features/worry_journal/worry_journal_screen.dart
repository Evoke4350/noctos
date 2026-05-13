import 'package:flutter/material.dart';

class WorryJournalScreen extends StatelessWidget {
  const WorryJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worry journal')),
      body: const Center(child: Text('Worry journal (Milestone 3)')),
    );
  }
}
