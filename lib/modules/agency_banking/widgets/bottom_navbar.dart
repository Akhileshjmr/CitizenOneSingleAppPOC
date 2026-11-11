import 'package:flutter/material.dart';

import '../theme/colors/Appcolors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.k613AF5,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.security),
          label: "Insurance",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: "Transfers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: "Payment",
        ),
      ],
    );
  }
}
