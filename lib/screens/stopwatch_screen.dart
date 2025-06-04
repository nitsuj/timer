// lib/screens/stopwatch_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class StopwatchScreen extends ConsumerStatefulWidget {
  const StopwatchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends ConsumerState<StopwatchScreen> {
  Timer? _timer;
  int _elapsedHundredths = 0;

  bool get _running => _timer != null;

  void _toggle() {
    if (_running) {
      _timer!.cancel();
      _timer = null;
    } else {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
        setState(() => _elapsedHundredths++);
      });
    }
    setState(() {}); // rebuild so button text changes
  }

  void _reset() {
    _timer?.cancel();
    _timer = null;
    setState(() => _elapsedHundredths = 0);
  }

  String _fmt(int hundredths) {
    final secs = (hundredths ~/ 100).toString().padLeft(2, '0');
    final hundredPart = (hundredths % 100).toString().padLeft(2, '0');
    return '$secs.$hundredPart';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Stopwatch'),
        elevation: 2,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _fmt(_elapsedHundredths),
              style: GoogleFonts.oxanium(
                textStyle: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 96,
                      color: Colors.redAccent,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
                elevation: 0,
              ),
              onPressed: _toggle,
              child: Text(_running ? 'STOP' : 'START'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: Colors.redAccent),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 18),
                elevation: 0,
              ),
              onPressed: _reset,
              child: const Text('RESET'),
            ),
          ],
        ),
      ),
    );
  }
}
