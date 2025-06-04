// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/workout_list_provider.dart';
import '../state/workout_log_provider.dart';
import '../models/workout.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final List<Workout> wks = ref.watch(workoutProvider);
    final logs = ref.watch(logProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HIIT Timer'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => c.push('/create'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1) Show the last workout if any:
          if (logs.isNotEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.redAccent),
                title: Text(logs.first.name),
                subtitle: Text(
                  'Last workout • ${logs.first.totalWorkSeconds ~/ 60} min',
                ),
              ),
            ),

          const SizedBox(height: 16),

          // 2) Quick‐builder chips:
          const Text(
            'Build Timer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('Tabata'),
                backgroundColor: Colors.grey[800],
                onPressed: () => c.push('/builder/tabata'),
              ),
              ActionChip(
                label: const Text('Round'),
                backgroundColor: Colors.grey[800],
                onPressed: () => c.push('/builder/round'),
              ),
              ActionChip(
                label: const Text('Compound'),
                backgroundColor: Colors.grey[800],
                onPressed: () => c.push('/builder/compound'),
              ),
              ActionChip(
                label: const Text('Custom'),
                backgroundColor: Colors.grey[800],
                onPressed: () => c.push('/create'),
              ),
            ],
          ),

          const Divider(height: 32),
          const SizedBox(height: 16),

          // 3) If no saved workouts, show an empty‐state message:
          if (wks.isEmpty)
            Center(
              child: Text(
                'No saved workouts yet.\nTap + to create one.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            )
          else
            // 4) Otherwise, list all saved workouts:
            ...wks.asMap().entries.map((entry) {
              final int i = entry.key;
              final Workout w = entry.value;
              return Dismissible(
                key: ValueKey('${w.name}-$i'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) =>
                    ref.read(workoutProvider.notifier).remove(i),
                child: ListTile(
                  title: Text(w.name),
                  subtitle:
                      Text('${w.rounds}×${w.workSec}s / ${w.restSec}s'),
                  onTap: () => c.push('/timer', extra: w),
                ),
              );
            }).toList(),

          const SizedBox(height: 24),

          // 5) Stopwatch button (always visible, even if no workouts yet):
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => c.push('/stopwatch'),
              child: const Text(
                'Stopwatch',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
