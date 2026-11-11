// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/insurance_service_card.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/models/insurance_plan.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/widgets/comparison_bar.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/widgets/insurance_comparison_dialog.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/widgets/insurance_filter_dialog.dart';

class BuyPolicyPage extends StatelessWidget {
  const BuyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Insurance',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<InsuranceBloc, InsuranceState>(
        builder: (context, state) {
          if (state.count > 1) return const ComparisonBar();
          return BottomNavigationBar(
            currentIndex: 0,
            selectedItemColor: const Color(0xff5B3DF5),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_outlined),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none),
                label: 'Alerts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// FILTER SECTION
            const Row(
              children: [
                Icon(Icons.filter_list, size: 28),
                SizedBox(width: 12),
                Text(
                  'Filter by Company :',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// CHIPS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip(
                    text: 'All',
                    isSelected: true,
                  ),
                  _buildChip(text: 'Safe Guard Life'),
                  _buildChip(text: 'Alliance Motor'),
                  _buildChip(text: 'Alliance'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SEARCH BAR
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'Search Plans, features...',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () {
                    openFilterBottomSheet(context);
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.tune),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// POLICY CARDS
            ...mockInsurancePlans.map((plan) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: BuyPolicyCard(
                  title: plan.title.replaceAll('\n', ' '),
                  planId: plan.id,
                  subtitle: plan.company,
                  price: plan.priceOnly,
                  icon: Icons.account_balance,
                  coverLimit: plan.cover,
                  claimRatio: plan.claim,
                  networkSize: plan.network,
                  onCompareTap: () => openInsuranceComparisonBottomSheet(context),
                  onBuyPlanTap: () => context.push('/policy-details'),
                  onDetailsTap: () => context.push('/policy-details'),
                ),
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  static Widget _buildChip({
    required String text,
    bool isSelected = false,
  }) {
    return Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff5B3DF5) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xff5B3DF5),
          ),
        ),
        child: AppText(
          text,
          style: AppTextStyle.titleSmall,
          color: isSelected ? Colors.white : Colors.black54,
        ));
  }
}
