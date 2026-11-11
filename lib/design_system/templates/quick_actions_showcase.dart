import 'package:flutter/material.dart';
import 'package:citizenone_app/design_system/models/quick_action_item.dart';
import 'package:citizenone_app/design_system/organisms/quick_actions_widget.dart';

/// A showcase screen demonstrating the different usage styles of the
/// [QuickActionsWidget] component based on Figma requirements.
class QuickActionsShowcase extends StatelessWidget {
  const QuickActionsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Actions Showcase'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Standard usage with Section Title & View All
            QuickActionsWidget(
              sectionTitle: 'My Services',
              subtitle: 'Frequently used actions',
              viewAllText: 'View All',
              onViewAllTap: () {
                // Handle View All
              },
              items: [
                QuickActionItem(
                  title: 'Pay Bills',
                  icon: Icons.receipt_long,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                  iconColor: Colors.blue,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Transfer',
                  icon: Icons.swap_horiz,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                  iconColor: Colors.purple,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Top Up',
                  icon: Icons.add_circle_outline,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  iconColor: Colors.green,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Scan QR',
                  icon: Icons.qr_code_scanner,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                  iconColor: Colors.orange,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'More',
                  icon: Icons.more_horiz,
                  iconBackgroundColor: Colors.grey.withValues(alpha: 0.1),
                  iconColor: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),

            const Divider(height: 32),

            // Example 2: With "Add New" feature and badges
            QuickActionsWidget(
              sectionTitle: 'Beneficiaries',
              showAddNew: true,
              addIcon: Icons.person_add,
              addNewTitle: 'Add New',
              addNewBackgroundColor: Colors.blue.withValues(alpha: 0.05),
              addNewIconBackgroundColor: Colors.blue.withValues(alpha: 0.2),
              onAddNewTap: () {
                // Handle Add New
              },
              items: [
                QuickActionItem(
                  title: 'John Doe',
                  icon: Icons.person,
                  iconBackgroundColor: Colors.teal.withValues(alpha: 0.1),
                  iconColor: Colors.teal,
                  badgeCount: 2, // Example badge
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Jane Smith',
                  icon: Icons.person,
                  iconBackgroundColor: Colors.indigo.withValues(alpha: 0.1),
                  iconColor: Colors.indigo,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Company X',
                  icon: Icons.business,
                  iconBackgroundColor: Colors.brown.withValues(alpha: 0.1),
                  iconColor: Colors.brown,
                  isDisabled: true, // Example disabled state
                  onTap: () {},
                ),
              ],
            ),

            const Divider(height: 32),

            // Example 3: Minimalist without header, SVG Support Simulation
            QuickActionsWidget(
              // No section title provided
              sectionPadding: const EdgeInsets.all(16.0),
              elevation: 0.0, // Flat design
              defaultItemBackgroundColor: Colors.grey.shade100,
              items: [
                QuickActionItem(
                  title: 'Market',
                  icon: Icons.storefront, // Can be SVG path if flutter_svg is used
                  iconBackgroundColor: Colors.white,
                  iconColor: Colors.orange,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Weather',
                  icon: Icons.cloud_outlined,
                  iconBackgroundColor: Colors.white,
                  iconColor: Colors.lightBlue,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Support',
                  icon: Icons.headset_mic,
                  iconBackgroundColor: Colors.white,
                  iconColor: Colors.redAccent,
                  onTap: () {},
                ),
                QuickActionItem(
                  title: 'Loans',
                  icon: Icons.account_balance,
                  iconBackgroundColor: Colors.white,
                  iconColor: Colors.green,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
