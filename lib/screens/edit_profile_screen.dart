// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/user_profile.dart';
import '../state/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _ageCtrl    = TextEditingController();
  String _theme = 'Sporty';

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserProfile>('profile');
    if (box.isNotEmpty) {
      final existing = box.getAt(0)!;
      _heightCtrl.text = existing.height.toString();
      _weightCtrl.text = existing.weight.toString();
      _ageCtrl.text    = existing.age.toString();
      _theme = existing.theme;
    }
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box<UserProfile>('profile');
      final profile = UserProfile(
        height: int.parse(_heightCtrl.text),
        weight: int.parse(_weightCtrl.text),
        age:    int.parse(_ageCtrl.text),
        theme:  _theme,
      );
      if (box.isEmpty) {
        box.add(profile);
      } else {
        box.putAt(0, profile);
      }
      // After saving, go back to main scaffold
      GoRouter.of(context).go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _heightCtrl,
                decoration: const InputDecoration(labelText: 'Height (cm)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ageCtrl,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Invalid' : null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _theme,
                decoration: const InputDecoration(labelText: 'Theme'),
                items: const [
                  DropdownMenuItem(value: 'Sporty', child: Text('Sporty')),
                  DropdownMenuItem(value: 'Tropical', child: Text('Tropical')),
                ],
                onChanged: (val) => setState(() => _theme = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('SAVE PROFILE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
