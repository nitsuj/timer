// lib/main.dart

import 'package:flutter/material.dart' hide Badge;  // ← Hide Flutter’s built-in Badge
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/workout.dart';
import 'models/workout_log.dart';
import 'models/user_profile.dart';
import 'models/badge.dart';            // ← Your Hive-backed Badge model

import 'screens/onboarding_welcome_screen.dart';
import 'screens/onboarding_profile_screen.dart';
import 'screens/onboarding_theme_screen.dart';
import 'screens/main_scaffold.dart';
import 'screens/timer_screen.dart';
import 'screens/create_workout_screen.dart';
import 'screens/stopwatch_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/tabata_builder_screen.dart';
import 'screens/round_builder_screen.dart';
import 'screens/compound_builder_screen.dart';
import 'screens/history_screen.dart';
import 'screens/badges_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── 1) Initialize Hive & register ALL adapters ───────────────────────────────
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutLogAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(BadgeAdapter()); // ← Register the BadgeAdapter

  // ─── 2) Open ALL boxes, wiping "badges" each launch ───────────────────────────
  await Hive.openBox<Workout>('workouts');
  await Hive.openBox<WorkoutLog>('logs');
  await Hive.openBox<UserProfile>('profile');

  // Always delete any existing "badges" data to avoid stale schema errors:
  await Hive.deleteBoxFromDisk('badges');
  try {
    if (await Hive.boxExists('badges')) {
      await Hive.deleteBoxFromDisk('badges');
    }
  } catch (err, st) {
    debugPrint('Failed to delete badges box: $err');
    debugPrint('$st');
  }

  // ─── 3) Decide if we show onboarding or go straight to "/" ────────────────────
  final profileBox = Hive.box<UserProfile>('profile');
  final bool hasProfile = profileBox.isNotEmpty;

  final String themeChoice = hasProfile
      ? profileBox.getAt(0)!.theme
      : 'Sporty';

  final ThemeData themeData = (themeChoice == 'Sporty')
      ? ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.redAccent,
          useMaterial3: true,
        )
      : ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.tealAccent,
          useMaterial3: true,
        );

  // ─── 4) Build GoRouter (all existing routes remain identical) ────────────────
  final router = GoRouter(
    initialLocation: hasProfile ? '/' : '/onboarding/welcome',
    routes: <GoRoute>[
      // Onboarding flows
      GoRoute(
        path: '/onboarding/welcome',
        builder: (_, __) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/profile',
        builder: (_, __) => const OnboardingProfileScreen(),
      ),
      GoRoute(
        path: '/onboarding/theme',
        builder: (_, state) {
          final args = state.extra as Map<String, int>;
          return OnboardingThemeScreen(
            height: args['height']!,
            weight: args['weight']!,
            age: args['age']!,
          );
        },
      ),

      // Edit Profile (after onboarding)
      GoRoute(
        path: '/profile',
        builder: (_, __) => const EditProfileScreen(),
      ),

      // Main scaffold with bottom navigation
      GoRoute(
        path: '/',
        builder: (context, __) {
          // Wrap MainScaffold in a try/catch so build errors show visibly
          try {
            return const MainScaffold();
          } catch (err, st) {
            debugPrint('MAIN SCAFFOLD BUILD ERROR: $err');
            debugPrint('$st');
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(
                  'Error in MainScaffold:\n${err.toString()}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      ),

      // Timer screen (requires a Workout passed via extra)
      GoRoute(
        path: '/timer',
        builder: (_, state) => TimerScreen(workout: state.extra as Workout),
      ),

      // Create Workout
      GoRoute(
        path: '/create',
        builder: (_, __) => const CreateWorkoutScreen(),
      ),

      // Stopwatch
      GoRoute(
        path: '/stopwatch',
        builder: (_, __) => const StopwatchScreen(),
      ),

      // Builder screens
      GoRoute(
        path: '/builder/tabata',
        builder: (_, __) => const TabataBuilderScreen(),
      ),
      GoRoute(
        path: '/builder/round',
        builder: (_, __) => const RoundBuilderScreen(),
      ),
      GoRoute(
        path: '/builder/compound',
        builder: (_, __) => const CompoundBuilderScreen(),
      ),

      // History
      GoRoute(
        path: '/history',
        builder: (_, __) => const HistoryScreen(),
      ),

      // Badges
      GoRoute(
        path: '/badges',
        builder: (_, __) => const BadgesScreen(),
      ),

      // Coming Soon (title passed via extra)
      GoRoute(
        path: '/coming-soon',
        builder: (_, state) {
          final String title = state.extra as String;
          return ComingSoonScreen(title: title);
        },
      ),
    ],
  );

  // ─── 5) Finally, hand off to Flutter ──────────────────────────────────────────
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'HIIT Timer',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        routerConfig: router,
      ),
    ),
  );
}
