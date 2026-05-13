import 'package:flutter/material.dart';

class WeekDetailScreen extends StatelessWidget {
  final int weekIndex;
  const WeekDetailScreen({super.key, required this.weekIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Week ${weekIndex + 1}')),
      body: const Center(child: Text('Week detail (Milestone 2)')),
    );
  }
}
