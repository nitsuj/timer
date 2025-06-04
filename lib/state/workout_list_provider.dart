// lib/state/workout_list_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout.dart';

class WorkoutList extends StateNotifier<List<Workout>> {
  WorkoutList() : super(Hive.box<Workout>('workouts').values.toList());

  void add(Workout w) {
    Hive.box<Workout>('workouts').add(w);
    state = [w, ...state];
  }

  void remove(int index) {
    Hive.box<Workout>('workouts').deleteAt(index);
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }
}

final workoutProvider = StateNotifierProvider<WorkoutList, List<Workout>>(
  (_) => WorkoutList(),
);
