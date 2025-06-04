// lib/state/workout_log_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout_log.dart';

class LogList extends StateNotifier<List<WorkoutLog>> {
  LogList() : super(Hive.box<WorkoutLog>('logs').values.toList());

  void add(WorkoutLog l) {
    Hive.box<WorkoutLog>('logs').add(l);
    state = [l, ...state];
  }

  void remove(int index) {
    Hive.box<WorkoutLog>('logs').deleteAt(index);
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }
}

final logProvider = StateNotifierProvider<LogList, List<WorkoutLog>>(
  (_) => LogList(),
);
