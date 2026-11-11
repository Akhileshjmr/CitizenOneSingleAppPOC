import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import '../controllers/credit_benefits_option_controller.dart';

class CreditBenefitsOptionView extends GetView<CreditBenefitsOptionController> {
  CreditBenefitsOptionView({Key? key}) : super(key: key);

  @override
  CreditBenefitsOptionController controller = Get.put(
    CreditBenefitsOptionController(),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kffffff,
    bottomNavigationBar: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: false,
            child: Container(height: 100, color: Colors.yellow, width: 1.sw),
          ),
          Obx(
            () => Visibility(
              visible: controller.selectedBenefitList.isNotEmpty ? false : true,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  shadowColor: Colors.transparent,
                  backgroundColor: AppColors.kffffff,
                  foregroundColor: AppColors.k002A7F,
                  fixedSize: Size(180.w, 40.h),
                  textStyle: kCondensedMediumWhite14,
                ),
                onPressed: () {
                  controller.onSkip();
                },
                child: const Text(
                  'Skip for Now',
                  style: kAppThemeColorTitleMetropolis16,
                ),
              ).paddingOnly(right: 30.w, left: 30.w, bottom: 5.h),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.kffffff,
              fixedSize: Size(180.w, 40.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              textStyle: kCondensedMediumWhite14,
            ),
            onPressed: () {
              if (controller.selectedBenefitList.isEmpty) {
                appSnackbar(
                  message: 'Please select benefits',
                  snackbarState: SnackbarState.warning,
                );
              } else {
                controller.onContinue();
              }
            },
            child: const Text('Continue', style: kTitleWhiteColorMetropolis14),
          ).paddingOnly(right: 30.w, left: 30.w, bottom: 20.h),
        ],
      ),
    ),
    appBar: AgAppbar(
      title: 'Select Benefits',
      leadingIcon: Icons.chevron_left,
      leadingOnTap: () => Get.back(),
    ),
    body: Obx(
      () => Visibility(
        //visible: controller.isLoading.isFalse,
        replacement: const Center(child: AgLoader()),
        child: Column(
          children: [
            10.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.horizontalSpace,
                const Text(
                  'What benefits you are looking from your card ?',
                  style: kTitleMetropolis16,
                ),
              ],
            ),
            10.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.benefitList.length,
                separatorBuilder:
                    (BuildContext context, int index) => 10.verticalSpace,
                itemBuilder:
                    (BuildContext context, int index) =>
                        _buildBenefitsList(index, context),
              ),
            ),
            // 30.verticalSpace,
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     10.horizontalSpace,
            //     const Center(
            //       child: Text(
            //         'Salary',
            //         textAlign: TextAlign.center,
            //         style: kTitleMetropolis16,
            //       ),
            //     ),
            //     10.verticalSpace,
            //     Center(
            //       child: Text(
            //         textAlign: TextAlign.center,
            //         '${LocalStore.salary()}',
            //         style: kTitleMetropolis14,
            //       ),
            //     )
            //   ],
            // ),
          ],
        ),
      ),
    ),
  );

  Widget _buildBenefitsList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      onTap: () {
        if (controller.selectedBenefitList.contains(
          controller.benefitList[index]?.friendlyType,
        )) {
          if (controller.benefitList[index]?.type == 'EARN_POINTS') {
            controller.isEarnPoin(false);
          } else if (controller.benefitList[index]?.type == 'CASHBACK') {
            controller.isCashBack(false);
          } else {
            controller.isSaveMoney(false);
          }
          controller.selectedBenefitList.remove(
            controller.benefitList[index]?.friendlyType,
          );
        } else {
          if (controller.benefitList[index]?.type == 'EARN_POINTS') {
            controller.isEarnPoin(true);
          } else if (controller.benefitList[index]?.type == 'CASHBACK') {
            controller.isCashBack(true);
          } else {
            controller.isSaveMoney(true);
          }
          controller.selectedBenefitList.add(
            controller.benefitList[index]?.friendlyType ?? '',
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgLight,
          border: Border.all(
            color:
                (controller.selectedBenefitList.contains(
                      controller.benefitList[index]?.friendlyType,
                    ))
                    ? AppColors.primary
                    : AppColors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        height: 50.h,
        width: 250.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                controller.benefitList[index]?.friendlyType ?? '',
                style: kSubTitleMetropolis12,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
