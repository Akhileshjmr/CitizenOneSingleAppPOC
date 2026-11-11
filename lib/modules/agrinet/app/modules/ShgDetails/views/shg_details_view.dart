import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ag_colors.dart';
import '../controllers/shg_details_controller.dart';
import 'ShgMemberCard.dart';

class ShgDetailsView extends GetView<ShgDetailsController> {
  const ShgDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: const AgAppbar(title: "SHG Details"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final members = controller.members.value?.groupDetails ?? [];

        return Column(
          children: [
            const SizedBox(height: 6),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 12),

                    if (members.isEmpty)
                      const Text(
                        'No members available',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      Column(
                        children:
                            members
                                .map((m) => ShgMemberCard(member: m))
                                .toList(),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: AgButton(title: "Close", onTap: controller.onClosePressed),
      ),
    );
  }

  Widget _buildInfoCard() {
    final membersValue = controller.membersDetails.value;
    final options = membersValue?.selectOptionList?.first.options ?? [];

    final groupName =
        controller.selectedGroup.value.isNotEmpty
            ? controller.selectedGroup.value
            : (options.isNotEmpty
                ? options.first.friendlyType ?? "Unnamed Group"
                : "Loading...");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffE6F1F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            title: "Farm Plan Name",
            subtitle: controller.farmPlanNameCtrl.text,
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            title: "Farm Plan Description",
            subtitle: controller.farmPlanDescCtrl.text,
          ),
          const SizedBox(height: 12),

          _buildInfoRow(title: "Group", subtitle: groupName),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle.isEmpty ? "-" : subtitle,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
