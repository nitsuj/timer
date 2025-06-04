// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/workout_log_provider.dart';
import '../models/workout_log.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WorkoutLog> logs = ref.watch(logProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text(
                'No completed workouts yet.\nFinish a timer to see history.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Colors.redAccent),
                      title: Text(log.name),
                      subtitle: Text(
                        '${_friendlyTime(log.totalWorkSeconds)} • '
                        '${log.caloriesBurned.toStringAsFixed(1)} kcal\n'
                        '${log.date.toLocal().toString().split('.').first}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _friendlyTime(int totalSeconds) {
    if (totalSeconds < 60) return '$totalSeconds sec';
    final int m = totalSeconds ~/ 60;
    final int s = totalSeconds % 60;
    return s == 0 ? '$m min' : '$m min $s sec';
  }
}
