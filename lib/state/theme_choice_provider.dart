import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_profile.dart';

/// Holds the current theme choice ("Sporty" or "Tropical").
final themeChoiceProvider = StateProvider<String>((ref) {
  final box = Hive.box<UserProfile>('profile');
  return box.isNotEmpty ? box.getAt(0)!.theme : 'Sporty';
});
