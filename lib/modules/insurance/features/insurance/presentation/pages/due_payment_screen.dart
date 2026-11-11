import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/due_payment_card.dart';
import 'package:citizenone_app/modules/insurance/features/common/widgets/bottom_nav_scaffold.dart';

class DuePaymentScreen extends StatelessWidget {
  const DuePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Due Payment',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: const BottomNavScaffold(currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            DuePaymentCard(
              title: 'Full Bumper Comprehensive',
              policyProduct: 'Alliance Motor',
              dueType: 'Premium Due',
              dueAmount: 'ZMW 2,500',
              onPayPremiumTap: () {},
              onViewMore: () {},
            ),
            DuePaymentCard(
              title: 'Full Bumper Comprehensive',
              policyProduct: 'Alliance Motor',
              dueType: 'Premium Due',
              dueAmount: 'ZMW 2,500',
              onPayPremiumTap: () {},
              onViewMore: () {},
            ),
            DuePaymentCard(
              title: 'Full Bumper Comprehensive',
              policyProduct: 'Alliance Motor',
              dueType: 'Premium Due',
              dueAmount: 'ZMW 2,500',
              onPayPremiumTap: () {},
              onViewMore: () {},
            ),
            DuePaymentCard(
              title: 'Full Bumper Comprehensive',
              policyProduct: 'Alliance Motor',
              dueType: 'Premium Due',
              dueAmount: 'ZMW 2,500',
              onPayPremiumTap: () {},
              onViewMore: () {},
            ),
          ],
        ),
      ),
    );
  }
}
