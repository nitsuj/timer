// lib/screens/badges_screen.dart

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/badge_provider.dart';
import '../models/badge.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Badge> badges = ref.watch(badgeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
      ),
      body: badges.isEmpty
          ? const Center(
              child: Text(
                'No badges earned yet.\nComplete a workout to unlock badges.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                final badge = badges[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading:
                          const Icon(Icons.emoji_events, color: Colors.redAccent),
                      title: Text(badge.title),
                      subtitle: Text(badge.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          ref.read(badgeProvider.notifier).remove(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
