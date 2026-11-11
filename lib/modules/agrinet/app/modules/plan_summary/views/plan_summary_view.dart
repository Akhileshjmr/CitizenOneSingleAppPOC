import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/plan_summary/views/plan_summary_detail.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/plan_summary/plan_summary_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/plan_summary_controller.dart';

class PlanSummaryView extends GetView<PlanSummaryController> {
  const PlanSummaryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Plan Summary"),
      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: ListView.builder(
            itemCount: controller.planList.length,
            itemBuilder: (_, index) {
              final plan = controller.planList[index];

              return ListTile(
                title: Text(
                  plan.plan?.name ?? "No Name",
                  style: kw600Primary16,
                ),
                subtitle: Text("Created: ${plan.plan?.createdDate}"),
                trailing: Text(
                  "${AgConstants.currency} ${plan.plan?.budgetVal ?? 'Not Available'}",
                  style: kw500Green14,
                ),

                onTap: () {
                  Get.to(() => PlanSummaryDetail(plan));
                },

                onLongPress: () {
                  if (plan.expense?.isNotEmpty ?? false) {
                    showExpensePopup(plan.expense!);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }

  void showExpensePopup(List<Expense> expenseList) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              expenseList
                  .where(
                    (e) =>
                        (e.type != null && e.type!.isNotEmpty) ||
                        (e.expenseDate != null && e.expenseDate!.isNotEmpty),
                  )
                  .map((e) {
                    return ListTile(
                      title:
                          e.type != null && e.type!.isNotEmpty
                              ? Text(e.type!)
                              : null,
                      subtitle:
                          e.expenseDate != null && e.expenseDate!.isNotEmpty
                              ? Text(e.expenseDate!)
                              : null,
                    );
                  })
                  .toList(),
        ),
      ),
    );
  }
}
