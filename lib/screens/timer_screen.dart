// lib/screens/timer_screen.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Badge;    // ← Hide Flutter’s built-in Badge
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/workout.dart';
import '../models/workout_log.dart';
import '../models/user_profile.dart';
import '../models/badge.dart';                 // ← Your Badge model
import '../state/timer_provider.dart';
import '../state/workout_log_provider.dart';
import '../state/badge_provider.dart';         // ← Your BadgeList notifier
import '../utils/met_calorie_calc.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({Key? key, required this.workout}) : super(key: key);
  final Workout workout;

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  double _calories = 0.0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();

    // 1) Listen for TimerState changes. When it transitions into Phase.complete,
    //    compute calories, log the workout, and award a Badge.
    ref.listen<TimerState>(
      timerProvider(widget.workout),
      (prev, next) {
        if (prev?.phase != Phase.complete && next.phase == Phase.complete) {
          // Compute calories burned for this workout
          _computeCalories();

          // Add a WorkoutLog entry
          ref.read(logProvider.notifier).add(
            WorkoutLog(
              name:               widget.workout.name,
              date:               DateTime.now(),
              workSec:            widget.workout.workSec,
              restSec:            widget.workout.restSec,
              rounds:             widget.workout.rounds,
              totalWorkSeconds:   widget.workout.totalWork,
              caloriesBurned:     _calories,
            ),
          );

          // Award a new Badge when the workout completes:
          final badgeTitle = 'Completed: ${widget.workout.name}';
          final badgeDesc = 'Finished all ${widget.workout.rounds} rounds!';
          final newBadge = Badge(
            title: badgeTitle,
            description: badgeDesc,
          );
          ref.read(badgeProvider.notifier).add(newBadge);
        }
      },
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _computeCalories() {
    final profileBox = Hive.box<UserProfile>('profile');
    if (profileBox.isEmpty) {
      setState(() => _calories = 0.0);
      return;
    }
    final double weightKg = profileBox.getAt(0)!.weight.toDouble();
    const double defaultMet = 9.0;
    final int totalWork = widget.workout.totalWork;

    final double cals = caloriesFromMET(
      metValue: defaultMet,
      weightKg: weightKg,
      durationSeconds: totalWork,
    );
    setState(() => _calories = cals);
  }

  @override
  Widget build(BuildContext ctx) {
    final st   = ref.watch(timerProvider(widget.workout));
    final ctrl = ref.read(timerProvider(widget.workout).notifier);

    final Size sz = MediaQuery.of(ctx).size;
    final bool isLand = sz.width > sz.height;

    Color bg;
    if (st.phase == Phase.complete) {
      bg = Colors.blueGrey;
    } else if (st.phase == Phase.work && st.secondsLeft <= 5) {
      bg = Colors.red;
    } else {
      bg = st.phase == Phase.work
          ? Colors.green
          : st.phase == Phase.rest
              ? Colors.orangeAccent
              : Colors.black;
    }

    final double fontSize =
        isLand ? min(sz.width * 0.30, sz.height * 0.70) : 96;
    final digits = GoogleFonts.oxanium(
      textStyle: Theme.of(ctx).textTheme.displayLarge?.copyWith(fontSize: fontSize),
    );

    return Scaffold(
      backgroundColor: bg,
      appBar: isLand
          ? null
          : AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => ctx.pop(),
              ),
              title: Text(widget.workout.name),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isLand) ...[
              Text(widget.workout.name,
                  style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (st.phase != Phase.complete)
                Text('Round ${st.round}/${widget.workout.rounds}',
                    style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: 16),
            ],

            if (st.phase != Phase.complete)
              Text(st.phase == Phase.work ? 'WORK' : 'REST',
                  style: Theme.of(ctx).textTheme.headlineSmall),
            if (st.phase != Phase.complete) const SizedBox(height: 8),

            Expanded(
              child: Center(child: Text(_fmt(st.secondsLeft), style: digits)),
            ),

            const SizedBox(height: 32),

            if (st.phase == Phase.complete) ...[
              const Text(
                'Workout Complete',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Work: ${_friendly(widget.workout.totalWork)}    '
                'Calories: ${_calories.toStringAsFixed(1)} kcal',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ctrl.reset(),
                child: const Text('RESET'),
              ),
            ] else
              ElevatedButton(
                onPressed: () => setState(
                  () => st.running ? ctrl.pause() : ctrl.start(),
                ),
                child: Text(st.running ? 'STOP' : 'START'),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _fmt(int s) {
    final m   = (s ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return '$m:$sec';
  }
}

String _friendly(int totalSeconds) {
  if (totalSeconds < 60) return '$totalSeconds sec';
  final int m = totalSeconds ~/ 60;
  final int s = totalSeconds % 60;
  return s == 0 ? '$m min' : '$m min $s sec';
}
