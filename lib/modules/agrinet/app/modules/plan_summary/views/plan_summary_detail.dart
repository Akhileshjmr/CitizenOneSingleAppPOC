import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';

import '../../../data/model/plan_summary/plan_summary_model.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_constants.dart';

class PlanSummaryDetail extends StatelessWidget {
  final FarmPlan plan;

  const PlanSummaryDetail(this.plan, {super.key});

  String safeValue(dynamic value, {String fallback = "Not Available"}) {
    if (value == null) return fallback;
    if (value is String && value.trim().isEmpty) return fallback;
    return value.toString();
  }

  /// 🔹 Reusable row with equal left-right spacing
  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text(label, style: kw600Primary14)),
          Expanded(flex: 2, child: Text(value, style: kw500Primary14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: plan.plan?.name ?? "Plan Summary"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 TOP SECTION (DETAILS)
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    infoRow("Plan ID:", safeValue(plan.plan?.planId)),
                    infoRow("Status:", safeValue(plan.plan?.status)),
                    infoRow(
                      "Budget:",
                      "${AgConstants.currency} ${safeValue(plan.plan?.budgetVal)}",
                    ),

                    const SizedBox(height: 10),

                    infoRow("Farmer Group:", safeValue(plan.farmerGroup?.name)),
                    infoRow(
                      "Farmers:",
                      safeValue(plan.farmerGroup?.noOfFarmers),
                    ),
                    infoRow(
                      "Area:",
                      "${safeValue(plan.farmerGroup?.totalLandArea)} Acres",
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Expenses",
                            style: kw600Primary14.copyWith(fontSize: 16),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 BOTTOM SECTION (EXPENSE LIST)
            Expanded(
              flex: 2,
              child:
                  (plan.expense == null || plan.expense!.isEmpty)
                      ? Center(
                        child: Text(
                          "No expenses available",
                          style: kw500Primary14.copyWith(color: Colors.grey),
                        ),
                      )
                      : ListView(
                        children:
                            plan.expense!
                                // 🔹 Filter: remove empty or unavailable items
                                .where(
                                  (e) =>
                                      e.type != null &&
                                      e.type!.trim().isNotEmpty &&
                                      e.type != "Not Available",
                                )
                                .map(
                                  (e) => ListTile(
                                    title: Text(
                                      safeValue(e.type),
                                      style: kw600Primary14,
                                    ),
                                    subtitle:
                                        (e.expenseDate == null ||
                                                e.expenseDate!.trim().isEmpty ||
                                                e.expenseDate ==
                                                    "Not Available")
                                            ? null
                                            : Text(
                                              safeValue(e.expenseDate),
                                              style: kw500Primary14,
                                            ),
                                  ),
                                )
                                .toList(),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
