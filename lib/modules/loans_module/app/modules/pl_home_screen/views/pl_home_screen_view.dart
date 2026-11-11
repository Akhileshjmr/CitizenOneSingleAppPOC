import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../widget/personal_loans/bank_card.dart';
import '../../../widget/personal_loans/compare_bar.dart';
import '../../../widget/personal_loans/filter_chip.dart';
import '../controllers/pl_home_screen_controller.dart';

class PlHomeScreenView extends GetView<PlHomeScreenController> {
  const PlHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kF8FAFC,
      appBar: const AgAppbar(title: "Personal Loan"),

      /// ✅ Compare Bar
      bottomNavigationBar: Obx(() {
        final compareList = controller.compareBankList;

        if (compareList.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          child: CompareBar(
            banks: compareList,
            onClear: controller.clearCompareList,
          ),
        );
      }),

      body: Obx(() {
        final isSingleMode = controller.showSingleBankOnly.value;

        /// ✅ SINGLE MODE (unchanged)
        if (isSingleMode) {
          if (controller.homeBankList.isEmpty ||
              controller.selectedBankIndex.value >=
                  controller.homeBankList.length) {
            return const SizedBox();
          }

          final bank =
              controller.homeBankList[controller.selectedBankIndex.value];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: BankCard(
              bank: bank,
              index: controller.selectedBankIndex.value,
            ),
          );
        }

        /// ✅ FULL SCREEN LOADER (initial only)
        if (controller.isInitialLoading) {
          return const Center(child: AgLoader());
        }

        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: Stack(
            children: [
              ListView(
                controller: controller.scrollController,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                children: [
                  16.verticalSpace,

                  /// ✅ Filters (Always Visible)
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.filterList.length,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChipWidget(
                            title: controller.filterList[index],
                            onTap: () => controller.handleFilter(index),
                          ),
                        );
                      },
                    ),
                  ),

                  16.verticalSpace,

                  /// ✅ Empty State
                  if (controller.homeBankList.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25,
                        left: 16,
                        right: 16,
                      ),
                      child: Text(
                        "No loan options found\nTry selecting a different bank",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.homeBankList.length,
                      separatorBuilder: (_, __) => 12.verticalSpace,
                      itemBuilder: (_, index) {
                        final bank = controller.homeBankList[index];
                        final key = controller.itemKeys[index] ??= GlobalKey();

                        return Container(
                          key: key,
                          child: BankCard(bank: bank, index: index),
                        );
                      },
                    ),

                  16.verticalSpace,
                ],
              ),

              /// ✅ LIST LEVEL LOADER (overlay)
              if (controller.isBankListLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(child: AgLoader()),
                ),
            ],
          ),
        );
      }),
    );
  }
}
