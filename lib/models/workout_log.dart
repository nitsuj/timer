// lib/models/workout_log.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'workout_log.g.dart';

@HiveType(typeId: 1)
class WorkoutLog extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final int workSec;
  @HiveField(3)
  final int restSec;
  @HiveField(4)
  final int rounds;
  @HiveField(5)
  final int totalWorkSeconds;
  @HiveField(6)
  final double caloriesBurned;

  WorkoutLog({
    required this.name,
    required this.date,
    required this.workSec,
    required this.restSec,
    required this.rounds,
    required this.totalWorkSeconds,
    required this.caloriesBurned,
  });
}
