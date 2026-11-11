import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/p_r_check_eligible_controller.dart';

class PRCheckEligibleView extends GetView<PRCheckEligibleController> {
  const PRCheckEligibleView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Check Eligibility'),
    body: Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }

      return Container(
        margin: EdgeInsets.all(15),
        height: 280,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   color: AppColors.kffffff,
                  //   border: Border.all(color: AppColors.kD9D9D9),
                  //   // borderRadius: BorderRadius.circular(8.r),
                  // ),
                  margin: EdgeInsets.all(10),
                  child: ImageHandle(
                    url:
                        controller.EligibleListData()
                            .bankImage
                            ?.url
                            ?.addBaseUrl ??
                        '',
                    size: Size(120.w, 120.h),
                    borderRadius: BorderRadius.circular(10.r),
                    padding: EdgeInsets.zero,
                  ),
                ),
                0.horizontalSpace,
                Expanded(
                  child: Text(
                    controller.EligibleListData().addiParams?[0] ?? '',
                    style: kw400Black14,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                10.horizontalSpace,
                Text(
                  'Eligible Amount: ',
                  style: kw400Black14,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                10.horizontalSpace,
                Text(
                  '${CommonUtilities.AppCurrency}: ${controller.EligibleListData().addiParams?[1] ?? ''}',
                  style: kw400Black14,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            25.verticalSpace,
            GestureDetector(
              onTap: () async {
                await Get.toNamed<void>(
                  Routes.P_R_CHECK_EMI,
                  arguments: PRArguments(
                    filterval: controller.args.filterval,
                    montlyExc: controller.args.montlyExc,
                    montlyInc:
                        controller.EligibleListData().addiParams?[1] ?? '',
                    bankid: controller.args.bankid,
                    bankName:
                        controller.EligibleListData().addiParams?[0] ?? '',
                    LimtMode: '',
                  ),
                );
              },
              child: Container(
                width: 140,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Center(child: Text("Submit", style: kw500White14)),
              ).paddingSymmetric(vertical: 5),
            ),
          ],
        ),
      );
    }),
  );
}
