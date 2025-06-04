// lib/screens/compound_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout.dart';

class CompoundBuilderScreen extends StatefulWidget {
  const CompoundBuilderScreen({Key? key}) : super(key: key);

  @override
  State<CompoundBuilderScreen> createState() => _CompoundBuilderScreenState();
}

class _CompoundBuilderScreenState extends State<CompoundBuilderScreen> {
  // For now, we’ll just let “Compound” be a fixed example:
  void _startExample() {
    final workout = Workout(
      name:    'Compound Timer',
      workSec: 45,
      restSec: 15,
      rounds:  6,
    );
    context.push('/timer', extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compound Timer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Compound Timer\n(Example: 45s work / 15s rest × 6 rounds)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _startExample,
              child: const Text('Start Example'),
            ),
          ],
        ),
      ),
    );
  }
}
