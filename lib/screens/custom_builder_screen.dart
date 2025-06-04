// lib/screens/custom_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout.dart';

/// Custom Timer Builder: user supplies any work/rest/rounds via sliders.
class CustomBuilderScreen extends StatefulWidget {
  const CustomBuilderScreen({super.key});

  @override
  State<CustomBuilderScreen> createState() => _CustomBuilderScreenState();
}

class _CustomBuilderScreenState extends State<CustomBuilderScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'New Custom Timer');
  double _work = 30;
  double _rest = 15;
  double _rounds = 5;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startCustom() {
    final nameText = _nameController.text.trim();
    if (nameText.isEmpty) {
      // Optionally show a SnackBar or dialog to prompt for a non-empty name
      return;
    }
    final workout = Workout(
      name:    nameText,
      workSec: _work.toInt(),
      restSec: _rest.toInt(),
      rounds:  _rounds.toInt(),
    );
    context.push('/timer', extra: workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Timer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Build Your Custom Timer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
              onTap: () {
                if (_nameController.text == 'New Custom Timer') {
                  _nameController.clear();
                }
              },
            ),
            const SizedBox(height: 24),

            // Work slider
            Text('Work Seconds: ${_work.toInt()}'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.green,      // was kWorkColor 
                inactiveTrackColor: Colors.grey.shade700,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: Colors.redAccent,       // was kAccentColor
                overlayColor: Colors.redAccent.withOpacity(0.2),
              ),
              child: Slider(
                min: 5,
                max: 300,
                divisions: 295,
                value: _work,
                label: _work.toInt().toString(),
                onChanged: (val) => setState(() => _work = val),
              ),
            ),
            const SizedBox(height: 24),

            // Rest slider
            Text('Rest Seconds: ${_rest.toInt()}'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.orangeAccent, // was kRestColor 
                inactiveTrackColor: Colors.grey.shade700,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: Colors.redAccent,          // was kAccentColor
                overlayColor: Colors.redAccent.withOpacity(0.2),
              ),
              child: Slider(
                min: 0,
                max: 300,
                divisions: 300,
                value: _rest,
                label: _rest.toInt().toString(),
                onChanged: (val) => setState(() => _rest = val),
              ),
            ),
            const SizedBox(height: 24),

            // Rounds slider
            Text('Rounds: ${_rounds.toInt()}'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.blueAccent,   // custom choice 
                inactiveTrackColor: Colors.grey.shade700,
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                thumbColor: Colors.redAccent,
                overlayColor: Colors.redAccent.withOpacity(0.2),
              ),
              child: Slider(
                min: 1,
                max: 20,
                divisions: 19,
                value: _rounds,
                label: _rounds.toInt().toString(),
                onChanged: (val) => setState(() => _rounds = val),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _startCustom,
              child: const Text('START'),
            ),
          ],
        ),
      ),
    );
  }
}
