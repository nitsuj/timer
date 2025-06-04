// lib/screens/tabata_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout.dart';

class TabataBuilderScreen extends StatefulWidget {
  const TabataBuilderScreen({Key? key}) : super(key: key);

  @override
  State<TabataBuilderScreen> createState() => _TabataBuilderScreenState();
}

class _TabataBuilderScreenState extends State<TabataBuilderScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _workCtrl  = TextEditingController(text: '20');
  final _restCtrl  = TextEditingController(text: '10');
  final _roundCtrl = TextEditingController(text: '8');

  @override
  void dispose() {
    _workCtrl.dispose();
    _restCtrl.dispose();
    _roundCtrl.dispose();
    super.dispose();
  }

  void _startCustom() {
    if (_formKey.currentState!.validate()) {
      final work   = int.parse(_workCtrl.text);
      final rest   = int.parse(_restCtrl.text);
      final rounds = int.parse(_roundCtrl.text);
      final workout = Workout(
        name:    'Custom Tabata',
        workSec: work,
        restSec: rest,
        rounds:  rounds,
      );
      context.push('/timer', extra: workout);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tabata Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Presets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Standard Tabata'),
              subtitle: const Text('20s work / 10s rest × 8 rounds'),
              onTap: () {
                final workout = Workout(
                  name:    'Standard Tabata',
                  workSec: 20,
                  restSec: 10,
                  rounds:  8,
                );
                context.push('/timer', extra: workout);
              },
            ),
            const Divider(height: 32),
            const Text(
              'Build Your Own',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _workCtrl,
                    decoration: const InputDecoration(labelText: 'Work seconds'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return (n == null || n <= 0) ? 'Invalid' : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _restCtrl,
                    decoration: const InputDecoration(labelText: 'Rest seconds'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      return (n == null || n < 0) ? 'Invalid' : null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _roundCtrl,
                    decoration: const InputDecoration(labelText: 'Rounds'),
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
