import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_colors.dart';
import '../../home/views/MenuItemModel.dart';
import '../controllers/farming_dashboard_controller.dart';

class FarmingDashboardView extends GetView<FarmingDashboardController> {
  const FarmingDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: "Farming Dashboard"),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Column(
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 8),
              Expanded(child: _buildGrid()),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER (NO Obx) =================

  Widget _buildHeaderCard() {
    final plan = controller.plan;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      color: AgColors.colorPrimaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Farmer Plan ID (Top Row)
          Row(
            children: [
              const SizedBox(
                width: 120,
                child: Text(
                  'Farmer Plan ID',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const Text(
                ': ',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Expanded(
                child: Text(
                  plan.planId ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 Group Name + Status + Button Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SIDE (Group Name + Status)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Group Name
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text(
                            'Group Name',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        const Text(
                          ': ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Expanded(
                          child: Text(
                            plan.groupName ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// Status
                    Row(
                      children: [
                        const SizedBox(
                          width: 120,
                          child: Text(
                            'Status',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        const Text(
                          ': ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Expanded(
                          child: Text(
                            plan.appStatus ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              /// RIGHT SIDE (Button)
              (controller.plan.wfStart ?? false)
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white),
                    ),
                    child: const Text(
                      "Workflow Started",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                  : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: controller.onStartWorkflowTap,
                    child: const Text('Start Workflow'),
                  ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= GRID (Rx → Obx OK) =================

  Widget _buildGrid() {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: controller.menuItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          final MenuItemModel item = controller.menuItems[index];

          return InkWell(
            onTap: () => controller.onMenuTap(item),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 50, height: 50, child: item.image),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: kw600Primary14,
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
