import 'package:citizenone_app/modules/agency_banking/theme/app_gradients.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final String userType;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    required this.userType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMerchantOrRC = userType == 'RC' || userType == 'MER';

    return Container(
      decoration: const BoxDecoration(
        gradient: AppBackgrounds.topBottomToolbarBackground,
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconSize: 35,
        selectedLabelStyle: const TextStyle(color: AppColors.darkGray),
        unselectedLabelStyle: const TextStyle(color: AppColors.darkGray),
        selectedItemColor: AppColors.iconsBackground,
        unselectedItemColor: AppColors.iconsBackground,
        currentIndex: selectedIndex,
        onTap: onTap,
        items: isMerchantOrRC
            ? const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ]
            : const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
