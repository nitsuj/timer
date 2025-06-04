// lib/screens/create_workout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/workout_list_provider.dart';
import '../models/workout.dart';

class CreateWorkoutScreen extends ConsumerStatefulWidget {
  const CreateWorkoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends ConsumerState<CreateWorkoutScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _workCtrl  = TextEditingController();
  final _restCtrl  = TextEditingController();
  final _roundCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _workCtrl.dispose();
    _restCtrl.dispose();
    _roundCtrl.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      final w = Workout(
        name:   _nameCtrl.text.trim(),
        workSec:  int.parse(_workCtrl.text),
        restSec:  int.parse(_restCtrl.text),
        rounds:   int.parse(_roundCtrl.text),
      );
      ref.read(workoutProvider.notifier).add(w);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _workCtrl,
                decoration: const InputDecoration(labelText: 'Work seconds'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _restCtrl,
                decoration: const InputDecoration(labelText: 'Rest seconds'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n < 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roundCtrl,
                decoration: const InputDecoration(labelText: 'Rounds'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
