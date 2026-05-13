import 'package:flutter/material.dart';

class ProgramOverviewScreen extends StatelessWidget {
  const ProgramOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Program')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            '6-week protocol overview\n(Milestone 2)',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
