// lib/models/badge.dart

import 'package:hive_flutter/hive_flutter.dart';

part 'badge.g.dart';

@HiveType(typeId: 2)
class Badge extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;

  Badge({
    required this.title,
    required this.description,
  });
}
