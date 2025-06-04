// lib/screens/onboarding_theme_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_profile.dart';

class OnboardingThemeScreen extends ConsumerStatefulWidget {
  final int height;
  final int weight;
  final int age;

  const OnboardingThemeScreen({
    Key? key,
    required this.height,
    required this.weight,
    required this.age,
  }) : super(key: key);

  @override
  ConsumerState<OnboardingThemeScreen> createState() =>
      _OnboardingThemeScreenState();
}

class _OnboardingThemeScreenState extends ConsumerState<OnboardingThemeScreen> {
  String _selectedTheme = 'Sporty';

  void _finishOnboarding() {
    final box = Hive.box<UserProfile>('profile');
    if (box.isNotEmpty) {
      final existing = box.getAt(0)!;
      final updated = UserProfile(
        height: existing.height,
        weight: existing.weight,
        age: existing.age,
        theme: _selectedTheme,
      );
      box.putAt(0, updated);
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Theme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadioListTile<String>(
              title: const Text('Sporty (red accents)'),
              value: 'Sporty',
              groupValue: _selectedTheme,
              onChanged: (v) => setState(() => _selectedTheme = v!),
            ),
            RadioListTile<String>(
              title: const Text('Tropical (teal accents)'),
              value: 'Tropical',
              groupValue: _selectedTheme,
              onChanged: (v) => setState(() => _selectedTheme = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _finishOnboarding,
              child: const Text('FINISH'),
            ),
          ],
        ),
      ),
    );
  }
}
