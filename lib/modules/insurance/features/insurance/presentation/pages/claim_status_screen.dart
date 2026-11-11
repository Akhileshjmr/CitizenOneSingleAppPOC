import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/atoms.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/claim_status_card.dart';
import 'package:citizenone_app/modules/insurance/features/common/widgets/bottom_nav_scaffold.dart';

class ClaimStatusScreen extends StatelessWidget {
  const ClaimStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Claim Status',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: const BottomNavScaffold(currentIndex: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 12),
              AppButton(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 40,
                text: 'New Claim',
                icon: Icons.add,
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              ClaimStatusCard(
                title: 'Full Bumper Comprehensive',
                policyNumber: 'SafeFuard Life - POL-HLT-9921',
                filedDate: ' 2027-04-10',
                onViewMore: () {},
              ),
              ClaimStatusCard(
                title: 'Full Bumper Comprehensive',
                policyNumber: 'SafeFuard Life - POL-HLT-9921',
                filedDate: ' 2027-04-10',
                onViewMore: () {},
              ),
              ClaimStatusCard(
                title: 'Full Bumper Comprehensive',
                policyNumber: 'SafeFuard Life - POL-HLT-9921',
                filedDate: ' 2027-04-10',
                onViewMore: () {},
              ),
              ClaimStatusCard(
                title: 'Full Bumper Comprehensive',
                policyNumber: 'SafeFuard Life - POL-HLT-9921',
                filedDate: ' 2027-04-10',
                onViewMore: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
