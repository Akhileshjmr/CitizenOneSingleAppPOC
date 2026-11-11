import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/payment_history_card.dart';
import 'package:citizenone_app/modules/insurance/features/common/widgets/bottom_nav_scaffold.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            title: const Text(
              'Payment History',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            centerTitle: false,
          ),
          bottomNavigationBar: const BottomNavScaffold(currentIndex: 0),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                PaymentHistoryCard(
                  title: 'Family Health Care Plan',
                  paymentMethod: 'Receipt : IN-99281- Paid Via Debit Card',
                  paidDate: '2027-04-10',
                  onDownload: () {},
                  onShare: () {},
                  onViewMore: () {},
                  dueAmount: 'ZMW 2,900',
                ),
                PaymentHistoryCard(
                  title: 'Family Health Care Plan',
                  paymentMethod: 'Receipt : IN-99281- Paid Via Debit Card',
                  paidDate: '2027-04-10',
                  onDownload: () {},
                  onShare: () {},
                  onViewMore: () {},
                  dueAmount: 'ZMW 2,900',
                ),
                PaymentHistoryCard(
                  title: 'Family Health Care Plan',
                  paymentMethod: 'Receipt : IN-99281- Paid Via Debit Card',
                  paidDate: '2027-04-10',
                  onDownload: () {},
                  onShare: () {},
                  onViewMore: () {},
                  dueAmount: 'ZMW 2,900',
                ),
                PaymentHistoryCard(
                  title: 'Family Health Care Plan',
                  paymentMethod: 'Receipt : IN-99281- Paid Via Debit Card',
                  paidDate: '2027-04-10',
                  onDownload: () {},
                  onShare: () {},
                  onViewMore: () {},
                  dueAmount: 'ZMW 2,900',
                ),
                PaymentHistoryCard(
                  title: 'Family Health Care Plan',
                  paymentMethod: 'Receipt : IN-99281- Paid Via Debit Card',
                  paidDate: '2027-04-10',
                  onDownload: () {},
                  onShare: () {},
                  onViewMore: () {},
                  dueAmount: 'ZMW 2,900',
                )
              ],
            ),
          ),
        ));
  }
}
