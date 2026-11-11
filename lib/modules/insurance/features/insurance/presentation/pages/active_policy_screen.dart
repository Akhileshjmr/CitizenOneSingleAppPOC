import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/active_policy_card.dart';
import 'package:citizenone_app/modules/insurance/features/common/widgets/bottom_nav_scaffold.dart';

class MyActivePolicyScreen extends StatelessWidget {
  const MyActivePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'My Active Policy',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: const BottomNavScaffold(currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            ActivePolicyCard(
              title: 'Family Health Care Plan',
              policyNumber: 'SafeFuard Life - POL-HLT-9921',
              expiryDate: '2027-04-10',
              onDownload: () {},
              onShare: () {},
              onViewMore: () {},
            ),
            ActivePolicyCard(
              title: 'Family Health Care Plan',
              policyNumber: 'SafeFuard Life - POL-HLT-9921',
              expiryDate: '2027-04-10',
              onDownload: () {},
              onShare: () {},
              onViewMore: () {},
              status: 'Expired',
            ),
            ActivePolicyCard(
              title: 'Family Health Care Plan',
              policyNumber: 'SafeFuard Life - POL-HLT-9921',
              expiryDate: '2027-04-10',
              onDownload: () {},
              onShare: () {},
              onViewMore: () {},
            ),
            ActivePolicyCard(
              title: 'Family Health Care Plan',
              policyNumber: 'SafeFuard Life - POL-HLT-9921',
              expiryDate: '2027-04-10',
              onDownload: () {},
              onShare: () {},
              onViewMore: () {},
            ),
            ActivePolicyCard(
              title: 'Family Health Care Plan',
              policyNumber: 'SafeFuard Life - POL-HLT-9921',
              expiryDate: '2027-04-10',
              onDownload: () {},
              onShare: () {},
              onViewMore: () {},
            )
          ],
        ),
      ),
    );
  }
}
