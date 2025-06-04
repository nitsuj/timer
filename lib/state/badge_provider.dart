// lib/state/badge_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/badge.dart';

class BadgeList extends StateNotifier<List<Badge>> {
  BadgeList() : super(_loadBadges());

  /// Load all badges from Hive.
  ///
  /// If reading the box throws (e.g. corrupted data), the box is deleted,
  /// reopened and an empty list is returned so the app can continue running.
  static List<Badge> _loadBadges() {
    try {
      return Hive.box<Badge>('badges').values.toList();
    } catch (_) {
      Hive.deleteBoxFromDisk('badges');
      // Reopen the box so future writes succeed. We intentionally
      // ignore the returned Future here since the constructor is sync.
      Hive.openBox<Badge>('badges');
      return [];
    }
  }

  void add(Badge b) {
    Hive.box<Badge>('badges').add(b);
    state = [b, ...state];
  }

  void remove(int index) {
    Hive.box<Badge>('badges').deleteAt(index);
    final newList = [...state];
    newList.removeAt(index);
    state = newList;
  }
}

final badgeProvider = StateNotifierProvider<BadgeList, List<Badge>>(
  (_) => BadgeList(),
);
