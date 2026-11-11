import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/insurance_acceptance_controller.dart';

class InsuranceAcceptanceView extends GetView<InsuranceAcceptanceController> {
  const InsuranceAcceptanceView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Insurance Acceptance'),
    body: Obx(
      () => Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(7.r),
            ),
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      child: Image.network(
                        controller.bankInsurence.value.logo?.url?.addBaseUrl ??
                            '',
                        fit: BoxFit.cover,
                        height: 60,
                        width: 60,
                      ),
                    ),
                    10.verticalSpace,
                    Column(
                      children: [
                        Text('Premium Amount', style: kw400Black12),
                        10.verticalSpace,
                        Container(
                          alignment: Alignment.center,
                          width: 140,
                          height: 40,
                          // color: AppColors.k26C900,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.grey,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            controller.bankInsurence.value.premiumAmt
                                    .toString() ??
                                '',
                            style: kw400White12,
                          ),
                        ),
                        5.verticalSpace,
                        Text('Excluding Tax', style: kSubTitleMetropolis12),
                      ],
                    ),
                  ],
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'IDV :${controller.bankInsurence.value.idv.toString() ?? ''}',
                      style: kSubTitleMetropolis12,
                    ),
                  ],
                ),
                10.verticalSpace,
                Text(
                  controller.bankInsurence.value.insurerName.toString(),
                  style: kw400Black14,
                ),
                10.verticalSpace,
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    border: Border.all(
                      color: AppColors.grey.withOpacity(0.3),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Reimbursement within 7 working days for non cashless',
                    style: kSubTitleMetropolis12,
                  ),
                ),
                5.verticalSpace,
                Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: 1.sw,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    border: Border.all(
                      color: AppColors.grey.withOpacity(0.3),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    'Self video claims',
                    style: kSubTitleMetropolis12,
                  ),
                ),
                5.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.kffffff,
                        fixedSize: Size(150.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        textStyle: kw500White16,
                      ),
                      onPressed: () {
                        controller.acceptInsurence();
                        // Get.toNamed(Routes.AUTO_FINANCIAL_INFO);
                      },
                      child: Text('Accept'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
