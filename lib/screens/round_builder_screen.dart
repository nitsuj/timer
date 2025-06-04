// lib/screens/round_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout.dart';

class RoundBuilderScreen extends StatefulWidget {
  const RoundBuilderScreen({Key? key}) : super(key: key);

  @override
  State<RoundBuilderScreen> createState() => _RoundBuilderScreenState();
}

class _RoundBuilderScreenState extends State<RoundBuilderScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _workCtrl  = TextEditingController(text: '60');
  final _roundCtrl = TextEditingController(text: '5');

  @override
  void dispose() {
    _workCtrl.dispose();
    _roundCtrl.dispose();
    super.dispose();
  }

  void _startCustom() {
    if (_formKey.currentState!.validate()) {
      final work   = int.parse(_workCtrl.text);
      final rounds = int.parse(_roundCtrl.text);
      final workout = Workout(
        name:    'Round Timer',
        workSec: work,
        restSec: 0,
        rounds:  rounds,
      );
      context.push('/timer', extra: workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Round Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _workCtrl,
                    decoration: const InputDecoration(labelText: 'Round seconds'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return (n == null || n <= 0) ? 'Invalid' : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _roundCtrl,
                    decoration: const InputDecoration(labelText: 'Number of rounds'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return (n == null || n <= 0) ? 'Invalid' : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _startCustom,
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
