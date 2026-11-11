import 'package:flutter/material.dart';

class BottomNavScaffold extends StatelessWidget {
  final int currentIndex;
  final VoidCallback? onHomeTap;
  final VoidCallback? onServicesTap;
  final VoidCallback? onAlertsTap;
  final VoidCallback? onProfileTap;

  const BottomNavScaffold({
    super.key,
    this.currentIndex = 0,
    this.onHomeTap,
    this.onServicesTap,
    this.onAlertsTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xff5B3DF5),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined), label: 'Services'),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none), label: 'Alerts'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      onTap: (index) {
        // Simple navigation callbacks – replace with real routing as needed
        switch (index) {
          case 0:
            if (onHomeTap != null) onHomeTap!();
            break;
          case 1:
            if (onServicesTap != null) onServicesTap!();
            break;
          case 2:
            if (onAlertsTap != null) onAlertsTap!();
            break;
          case 3:
            if (onProfileTap != null) onProfileTap!();
            break;
        }
      },
    );
  }
}
