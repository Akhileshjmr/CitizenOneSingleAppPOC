import 'package:flutter/material.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/screens/super_home_screen.dart';

class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, you might compose specific farmer widgets here.
    // For now, it wraps SuperHomeScreen which is role-adaptive.
    return const SuperHomeScreen();
  }
}
