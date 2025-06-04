// lib/models/workout.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int workSec;
  @HiveField(2)
  final int restSec;
  @HiveField(3)
  final int rounds;

  Workout({
    required this.name,
    required this.workSec,
    required this.restSec,
    required this.rounds,
  });

  /// Total work in seconds (workSec × rounds)
  int get totalWork => workSec * rounds;
}
