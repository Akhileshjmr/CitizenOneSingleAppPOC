import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/app_colors.dart';
import '../controllers/pl_filter_product_controller.dart';

class PlFilterProductView extends GetView<PlFilterProductController> {
  const PlFilterProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AgAppbar(title: 'Filter Banks'),
      bottomNavigationBar: _buildBottomButton(),
      body: Obx(() {
        if (controller.isLoading()) {
          return const Center(child: CircularProgressIndicator());
        }

        final banks = controller.bankList[0]?.values ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Banks', style: kTitleMetropolis14),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: banks.length,
                  separatorBuilder: (_, __) => 10.verticalSpace,
                  itemBuilder: (_, index) => _buildBankItem(banks[index]),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 20.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.kffffff,
          fixedSize: Size(180.w, 40.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          textStyle: kw500White14,
        ),
        onPressed: _saveSelectedBanks,
        child: const Text('Choose a Bank', style: kTitleWhiteColorMetropolis14),
      ),
    );
  }

  Widget _buildBankItem(dynamic bank) {
    final bankId = bank?.id?.toString() ?? '';
    final bankName = bank?.name ?? '';

    return Obx(() {
      final isSelected = controller.selectedBankIds.contains(bankId);

      return GestureDetector(
        onTap: () => _toggleBankSelection(bankId),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              activeColor: AppColors.primary,
              checkColor: Colors.white,
              onChanged: (_) => _toggleBankSelection(bankId),
            ),
            Text(bankName, style: kSubTitleMetropolis12),
          ],
        ),
      );
    });
  }

  void _toggleBankSelection(String bankId) {
    if (controller.selectedBankIds.contains(bankId)) {
      controller.selectedBankIds.remove(bankId);
    } else {
      controller.selectedBankIds.add(bankId);
    }
  }

  Future<void> _saveSelectedBanks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bankIds', controller.selectedBankIds);
    Get.back(result: true);
  }
}
