// lib/models/user_profile.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  final int height;
  @HiveField(1)
  final int weight;
  @HiveField(2)
  final int age;
  @HiveField(3)
  final String theme;

  UserProfile({
    required this.height,
    required this.weight,
    required this.age,
    required this.theme,
  });
}
