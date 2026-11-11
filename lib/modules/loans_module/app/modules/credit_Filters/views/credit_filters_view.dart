import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/credit_filters_controller.dart';

class CreditFiltersView extends GetView<CreditFiltersController> {
  const CreditFiltersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kffffff,
    appBar: AgAppbar(
      title: 'Filter Cards',
      leadingIcon: Icons.chevron_left,
      leadingOnTap: () => Get.back(),
    ),

    bottomNavigationBar: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: false,
            child: Container(height: 100, color: Colors.yellow, width: 1.sw),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.kffffff,
              fixedSize: Size(180.w, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              textStyle: kCondensedMediumWhite14,
            ),
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setStringList(
                'associations',
                controller.selectedAssociation,
              );
              await prefs.setStringList(
                'providers',
                controller.selectedProviders,
              );
              Get.back<bool>(result: true);
            },
            child: const Text(
              'Show Cards',
              style: kTitleWhiteColorMetropolis14,
            ),
          ).paddingOnly(right: 30.w, left: 30.w, bottom: 20.h),
        ],
      ),
    ),
    body: Obx(
      () => Visibility(
        visible: controller.isLoading.isFalse,
        replacement: const Center(child: AgLoader()),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Card Association', style: kTitleMetropolis14),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 20),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.assciationList.length ?? 0,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) =>
                            _buildFilterAssociationList(index, context),
                  ),
                ),
                const Text('Card Providers', style: kTitleMetropolis14),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 20),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.providerList.length ?? 0,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) =>
                            _buildFilterProviderList(index, context),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildFilterProviderList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      onTap: () {
        if (controller.selectedProviders.contains(
          controller.providerList[index]?.id.toString() ?? '',
        )) {
          controller.selectedProviders.remove(
            controller.providerList[index]?.id.toString() ?? '',
          );
        } else {
          controller.selectedProviders.add(
            controller.providerList[index]?.id.toString() ?? '',
          );
        }
        print(controller.selectedProviders.length);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.selectedProviders.contains(
                      controller.providerList[index]?.id.toString(),
                    )
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                color: AppColors.primary,
                size: 24,
              ),
              10.horizontalSpace,
              // Checkbox(
              //   value: controller.selectedProviders.contains(
              //           controller.providerList[index]?.id.toString())
              //       ? true
              //       : false,
              //   checkColor: Colors.grey, // color of tick Mark
              //   activeColor: AppColors.k134819,
              //   onChanged: (bool? result) async {},
              // ),
              Text(
                controller.providerList[index].bankName ?? '',
                style: kSubTitleMetropolis12,
              ),
            ],
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    ),
  );

  Widget _buildFilterAssociationList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      onTap: () {
        if (controller.selectedAssociation.contains(
          controller.assciationList[index]?.friendlyType.toString() ?? '',
        )) {
          controller.selectedAssociation.remove(
            controller.assciationList[index]?.friendlyType.toString() ?? '',
          );
        } else {
          controller.selectedAssociation.add(
            controller.assciationList[index]?.friendlyType.toString() ?? '',
          );
        }
        print(controller.selectedAssociation.length);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.selectedAssociation.contains(
                      controller.assciationList[index]?.friendlyType.toString(),
                    )
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank,
                color: AppColors.primary,
                size: 24,
              ),
              10.horizontalSpace,
              // Checkbox(
              //   value: controller.selectedAssociation.contains(controller.assciationList[index]?.friendlyType.toString())?true:false,
              //   checkColor: Colors.grey,  // color of tick Mark
              //   activeColor: AppColors.k134819,
              //   onChanged: (bool? result) async {
              //
              //   },
              // ),
              Text(
                controller.assciationList[index].friendlyType ?? '',
                style: kSubTitleMetropolis12,
              ),
            ],
          ).paddingSymmetric(vertical: 10),
        ],
      ),
    ),
  );
}
