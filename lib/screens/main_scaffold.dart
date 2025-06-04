// lib/screens/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'history_screen.dart';
import 'badges_screen.dart';
import 'edit_profile_screen.dart';

/// A scaffold with a BottomNavigationBar that switches between
/// Home, History, Badges, and Profile tabs based on GoRouter locations.
class MainScaffold extends StatelessWidget {
  const MainScaffold({Key? key}) : super(key: key);

  // The pages to show for each tab.
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),       // Home tab
    HistoryScreen(),    // History tab
    BadgesScreen(),     // Badges tab
    EditProfileScreen() // Profile tab
  ];

  // These must match your GoRouter route paths exactly.
  static const List<String> _locations = <String>[
    '/',         // Home
    '/history',  // History
    '/badges',   // Badges
    '/profile',  // Profile
  ];

  @override
  Widget build(BuildContext context) {
    // Instead of calling `GoRouter.of(context).location` directly—which
    // may not exist on certain versions—we read the current URL from
    // the RouteInformationProvider.
    final String rawLocation =
        GoRouter.of(context).routeInformationProvider.value.location ?? '/';

    // Determine which index to select based on the current location.
    int selectedIndex = _locations.indexWhere((loc) {
      if (loc == '/') {
        return rawLocation == '/';
      }
      return rawLocation.startsWith(loc);
    });
    if (selectedIndex < 0) selectedIndex = 0;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (int idx) {
          // Navigate to the matching route when a tab is tapped.
          GoRouter.of(context).go(_locations[idx]);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
