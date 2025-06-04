// lib/state/badge_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/badge.dart';

class BadgeList extends StateNotifier<List<Badge>> {
  BadgeList() : super(Hive.box<Badge>('badges').values.toList());

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
