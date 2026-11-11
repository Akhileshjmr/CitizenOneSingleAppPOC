import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/pl_features_filter_controller.dart';

class PlFeaturesFilterView extends GetView<PlFeaturesFilterController> {
  const PlFeaturesFilterView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AgAppbar(title: 'Filter Features'),

    // ✅ Bottom Button (UNCHANGED)
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AgButton(
          title: 'Choose a Bank',
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            await prefs.setStringList(
              'features',
              controller.selectedFeaturesIds,
            );

            Get.back<bool>(result: true);
          },
        ),
      ),
    ),

    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Features', style: kw400Black12),
                15.verticalSpace,

                if (controller.featuresList.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text("No Features Available"),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      itemCount:
                          controller.featuresList.first.values?.length ?? 0,

                      separatorBuilder: (_, __) => 10.verticalSpace,

                      itemBuilder:
                          (context, index) => _buildFilterBankList(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  // ✅ UPDATED ITEM BUILDER (SAFE + CLEAN)
  Widget _buildFilterBankList(int index) => Obx(() {
    final featureList = controller.featuresList;

    // Extra safety (edge case)
    if (featureList.isEmpty) return const SizedBox();

    final featureItem = featureList.first.values?[index];

    if (featureItem == null) return const SizedBox();

    final featureId = featureItem.feature?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        if (controller.selectedFeaturesIds.contains(featureId)) {
          controller.selectedFeaturesIds.remove(featureId);
        } else {
          controller.selectedFeaturesIds.add(featureId);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              controller.selectedFeaturesIds.contains(featureId)
                  ? Icon(Icons.check_box, color: AppColors.primary)
                  : Icon(
                    Icons.check_box_outline_blank,
                    color: AppColors.primary,
                  ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  featureItem.feature ?? '',
                  style: kSubTitleMetropolis12,
                ),
              ),
            ],
          ),
          15.verticalSpace,
        ],
      ),
    );
  });
}
