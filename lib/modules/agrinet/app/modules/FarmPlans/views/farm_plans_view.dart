import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/farm_plans_controller.dart';

class FarmPlansView extends GetView<FarmPlansController> {
  const FarmPlansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F6F3),
      appBar: AgAppbar(
        title: "Farm Plans",
        showSearch: true,
        onSearchChanged: controller.filterPlans,
      ),

      body: Obx(() {
        // ===============================
        // Error State
        // ===============================
        if (controller.hasError.value) {
          return const Center(
            child: Text(
              "Something went wrong. Please try again later.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AgColors.kBlack,
              ),
            ),
          );
        }

        // ===============================
        // Data
        // ===============================
        final plansList =
            controller.filteredPlans().selectAppStatus?.first.agriFramdet;

        Widget content;

        if (plansList == null || plansList.isEmpty) {
          content = const Center(
            child: Text("No plans found", style: TextStyle(fontSize: 16)),
          );
        } else {
          content = ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: plansList.length,
            itemBuilder: (context, index) {
              final plan = plansList[index];
              return _buildPlanCard(plan);
            },
          );
        }

        // ===============================
        // BaseScreen handles loading
        // ===============================
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: content,
        );
      }),
    );
  }

  // ===============================
  // Plan Card Widget
  // ===============================
  Widget _buildPlanCard(dynamic plan) {
    return GestureDetector(
      onTap: () => _goToDashboard(plan),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===============================
            // Header
            // ===============================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Plan / Group Name
                  Text(
                    plan?.planName ?? plan?.groupName ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Status (No tap here)
                  Text(
                    plan?.appStatus ?? '',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ===============================
            // Plan ID
            // ===============================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),

              child: Text(
                plan?.planId ?? '',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // Navigation
  // ===============================
  void _goToDashboard(dynamic plan) {
    if (plan == null) return;

    Get.toNamed(Routes.FARMING_DASHBOARD, arguments: plan);
  }
}
