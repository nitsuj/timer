// lib/state/user_profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/user_profile.dart';

/// A StateNotifier that wraps a Hive-backed UserProfile.
/// 
/// - When constructed, it reads the first UserProfile from Hive (if any).
/// - Calling `save(...)` will write to Hive (either add or putAt index 0)
///   and update the in-memory `state`.
class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(_loadFromHive());

  /// Load the existing profile from Hive, or null if none exists.
  static UserProfile? _loadFromHive() {
    final box = Hive.box<UserProfile>('profile');
    if (box.isNotEmpty) {
      return box.getAt(0);
    }
    return null;
  }

  /// Save (or update) a profile:
  ///  • If the box is empty, add it as the first entry.
  ///  • Otherwise, overwrite value at index 0.
  void save(UserProfile profile) {
    final box = Hive.box<UserProfile>('profile');
    if (box.isEmpty) {
      box.add(profile);
    } else {
      box.putAt(0, profile);
    }
    // Update the Riverpod state so any ConsumerWidgets rebuilding
    // will see the new profile immediately.
    state = profile;
  }
}

/// A provider exposing `UserProfile?`.  
/// - If there’s no profile yet, `state` is null.  
/// - Once you call `.save(...)`, `state` becomes that UserProfile object.
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>(
  (ref) => UserProfileNotifier(),
);
