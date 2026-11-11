import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_assets.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_environment.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../data/model/profitability/profitability_response.dart';
import '../controllers/profitability_controller.dart';

class ProfitabilityView extends GetView<ProfitabilityController> {
  const ProfitabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Profitability"),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEFF7F5), // top
              Color(0xFFF7FBF9), // bottom
            ],
          ),
        ),
        child: Obx(() {
          final data = controller.profitability.value;

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data == null || data.farmPlanProfit == null) {
            return const Center(child: Text("No profitability data found"));
          }

          final plan = data.farmPlanProfit!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildHeaderTable(plan),
                const SizedBox(height: 12),
                _buildSummaryCards(plan),
                const SizedBox(height: 16),
                _buildEarningButtons(),
                const SizedBox(height: 12),

                /// SHOW NOTHING UNTIL USER CLICKS
                Obx(() {
                  if (!controller.showAnySection.value) {
                    return const SizedBox();
                  }

                  return controller.showGroupEarnings.value
                      ? _groupEarnings(plan.farmerGroupProfit)
                      : _farmerEarnings(plan.farmerGroupProfit.farmerDetails);
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER TABLE
  // ---------------------------------------------------------------------------
  Widget _buildHeaderTable(FarmPlanProfit plan) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFD7C2A4), // exact header color
          ),
          children: const [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Properties", style: kw400Primary14),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Estimated", style: kw400Primary14),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Actual", style: kw400Primary14),
            ),
          ],
        ),

        _row("Cost of Project", plan.estCost, plan.actCost),
        _row("Yield (kg/acre)", plan.estYield, plan.actYield),
        _row("Yield Value", plan.estYieldValue, plan.actYieldValue),
      ],
    );
  }

  static TableRow _row(String name, String est, String act) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(name, style: kw400Secondary14),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(est, style: kw400Primary14),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(act, style: kw400Primary14),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY CARDS
  // ---------------------------------------------------------------------------
  Widget _buildSummaryCards(FarmPlanProfit plan) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _summaryCard("Sale Value", plan.saleValue),
        _summaryCard("Profit/Loss", plan.profitOrLoss),
        _summaryCard("Total Harvest", plan.estYield),
      ],
    );
  }

  Widget _summaryCard(String title, String value) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF355E3B),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(title, style: kw400White14),
          const SizedBox(height: 6),
          Text(value, textAlign: TextAlign.center, style: kw700White14),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EARNING BUTTONS
  // ---------------------------------------------------------------------------
  Widget _buildEarningButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _earningButton(
          imgPath: AgAssets.farmerGroupProfitability,
          title: "Farmer Group Earnings",
          isSelected:
              controller.showAnySection.value &&
              controller.showGroupEarnings.value,
          onTap: () => controller.switchTab(true),
        ),
        _earningButton(
          imgPath: AgAssets.farmerProfitability,
          title: "Farmer Earnings",
          isSelected:
              controller.showAnySection.value &&
              !controller.showGroupEarnings.value,
          onTap: () => controller.switchTab(false),
        ),
      ],
    );
  }

  Widget _earningButton({
    required String title,
    required bool isSelected,
    required String imgPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF62A87C) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              imgPath,
              width: 40,
              height: 40,
              package: AppEnvironment.packageName,
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: kw400Primary12),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GROUP EARNINGS
  // ---------------------------------------------------------------------------
  Widget _groupEarnings(FarmerGroupProfit gp) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Farmer Group Earnings", style: kw600Green18),
          const SizedBox(height: 10),

          _info("Farm Plan Id", gp.farmPlanId),
          _info("Sale value", gp.saleValue),
          _info("Pal Commission", gp.palCommission),
          _info("Outstanding Loan Amount", gp.outstandingLoanAmount),
          _info("Vendor Payments", gp.vendorPayments),
          _info("Balance to Farmer Group", gp.balanceToGroup),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FARMER EARNINGS
  // ---------------------------------------------------------------------------
  Widget _farmerEarnings(List<FarmerProfitDetails> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("Farmer Earnings", style: kw600Green18),
        const SizedBox(height: 10),

        // -------- Scrollable Farmer List --------
        SizedBox(
          height: 400, // adjust based on your UI need
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final farmer = list[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(farmer.farmerName, style: kw600Primary14),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _earnBox("Contribution", farmer.contribution),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: _earnBox("Profits", farmer.profit)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _earnBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AgColors.colorPrimary),
      ),
      child: Column(
        children: [
          Text(title, style: kw400Secondary14),
          const SizedBox(height: 6),
          Text(value, style: kw400Primary14),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Label
          Expanded(flex: 4, child: Text(title, style: kw400Secondary14)),

          // Colon (aligned properly)
          const Expanded(
            flex: 1,
            child: Text(
              ":",
              textAlign: TextAlign.center,
              style: kw400Secondary14,
            ),
          ),

          // Value
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: kw400Primary14,
            ),
          ),
        ],
      ),
    );
  }
}
