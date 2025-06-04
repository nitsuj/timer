// lib/state/timer_provider.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/workout.dart';

enum Phase { idle, work, rest, complete }

class TimerState {
  final Phase phase;
  final int secondsLeft;
  final int round;
  final bool running;
  TimerState({
    required this.phase,
    required this.secondsLeft,
    required this.round,
    required this.running,
  });
}

class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _ticker;
  final Workout workout;
  int _currentRound = 1;
  int _secLeft = 0;
  Phase _phase = Phase.idle;

  TimerNotifier(this.workout)
      : super(TimerState(
          phase: Phase.idle,
          secondsLeft: 0,
          round: 1,
          running: false,
        ));

  void start() {
    _phase = Phase.work;
    _secLeft = workout.workSec;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secLeft > 0) {
        _secLeft--;
      } else {
        if (_phase == Phase.work) {
          if (workout.restSec > 0) {
            _phase = Phase.rest;
            _secLeft = workout.restSec;
          } else {
            _moveToNextRoundOrComplete();
          }
        } else if (_phase == Phase.rest) {
          _moveToNextRoundOrComplete();
        }
      }
      _emitState();
    });
    _emitState();
  }

  void pause() {
    _ticker?.cancel();
    _ticker = null;
    _emitState();
  }

  void reset() {
    _ticker?.cancel();
    _ticker = null;
    _phase = Phase.idle;
    _currentRound = 1;
    _secLeft = 0;
    _emitState();
  }

  void _moveToNextRoundOrComplete() {
    if (_currentRound < workout.rounds) {
      _currentRound++;
      _phase = Phase.work;
      _secLeft = workout.workSec;
    } else {
      _phase = Phase.complete;
      _ticker?.cancel();
      _ticker = null;
    }
  }

  void _emitState() {
    state = TimerState(
      phase: _phase,
      secondsLeft: _secLeft,
      round: _currentRound,
      running: _ticker != null,
    );
  }
}

final timerProvider = StateNotifierProvider.family<TimerNotifier, TimerState, Workout>(
  (ref, workout) => TimerNotifier(workout),
);
