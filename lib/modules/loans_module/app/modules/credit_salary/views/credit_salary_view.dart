import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/local_store.dart';
import '../../../utils/app_colors.dart';
import '../controllers/credit_salary_controller.dart';

class CreditSalaryView extends GetView<CreditSalaryController> {
  const CreditSalaryView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: Obx(
      () => Visibility(
        visible: !controller.isLoading.value,
        child: AgButton(
          title: 'Continue',
          onTap: () async {
            if (controller.salaryController.text.isEmpty) {
              appSnackbar(
                snackbarState: SnackbarState.warning,
                message: 'Please enter salary',
              );
            } else if (int.parse(controller.salaryController.text) < 1000) {
              appSnackbar(
                snackbarState: SnackbarState.warning,
                message: 'salary should be greater then 1000',
              );
            } else if (int.parse(controller.salaryController.text) > 100000) {
              appSnackbar(
                snackbarState: SnackbarState.warning,
                message: 'salary should not be greater then 100000',
              );
            } else {
              LocalStore.salary(controller.salaryController.text);
              await controller.getUpdateCC(
                controller.salaryController.text,
                'INCOME_ENTERED',
              );
            }
          },
        ).paddingOnly(right: 30.w, left: 30.w, bottom: 20.h),
      ),
    ),
    appBar: AgAppbar(title: ''),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(10.0),
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.kffffff,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 280.h,
                  width: 1.sw,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    children: [
                      20.verticalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.horizontalSpace,
                          const Text('Monthly Salary', style: kw600Black16),
                        ],
                      ),
                      30.verticalSpace,
                      Container(
                        width: 180.w, // Full Width of Screen
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey, width: 2),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50.w,
                              height: 40.h,
                              color: AppColors.grey,
                              alignment: Alignment.center,
                              child: Text(
                                '${CommonUtilities.AppCurrency}',
                                style: kTitleMetropolis14.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            10.horizontalSpace,
                            Container(
                              width: 110.w,
                              height: 40.h,
                              padding: const EdgeInsets.all(3.0),
                              child: TextField(
                                controller: controller.salaryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(8),
                                ],
                                onChanged: (value) {
                                  double amt = double.parse(value ?? '0.0');
                                  if (amt > 1000.0) {
                                    if (amt > 100000.0) {
                                      controller.salary(100000.0);
                                    } else {
                                      controller.salary(amt);
                                    }
                                  }
                                },
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      Container(
                        width: 1.sw,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Slider(
                              thumbColor: AppColors.primary,
                              activeColor: AppColors.primary,
                              inactiveColor: AppColors.grey,
                              min: 1000,
                              max: 100000,
                              value: controller.salary(),
                              onChanged: (double value) {
                                controller.salary(value);
                                controller.salaryController.text =
                                    value.round().toString();
                                controller.salary.refresh();
                              },
                            ),
                            2.verticalSpace,
                            const Row(
                              children: [
                                Text('1000', style: kSubTitleMetropolis12),
                                Spacer(),
                                Text('100000', style: kSubTitleMetropolis12),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
              ],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
    ),
  );
}
