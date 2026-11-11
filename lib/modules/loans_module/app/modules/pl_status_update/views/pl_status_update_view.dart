import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../utils/app_colors.dart';
import '../controllers/pl_status_update_controller.dart';

class PlStatusUpdateView extends GetView<PlStatusUpdateController> {
  const PlStatusUpdateView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AgAppbar(title: 'Personal Loan Status'),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: Container(
          decoration: BoxDecoration(
            //color: AppColors.kF9F9F9,
            border: Border.all(color: AppColors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          width: 1.sw,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  ImageHandle(
                    url: controller.plStatus.value?.bankLogo?.addBaseUrl ?? '',
                    padding: EdgeInsets.zero,
                    size: Size(100.h, 100.w),
                    radius: 1.r,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Text(
                      'Your Personal Loan submitted to ${controller.plStatus.value?.bankName ?? ''}',
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: kw400Black14,
                    ),
                  ),
                ],
              ),
              16.horizontalSpace,
              Expanded(
                flex: 8, // 80%
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text('Application No:', style: kw400Black14),
                        ),
                        const SizedBox(width: 138),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.left,
                            controller.plStatus.value?.refNumber ?? '',
                            style: kSubTitleMetropolis12,
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Eligibility Amount',
                                style: kTitleMetropolis14,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey,
                                border: Border.all(color: AppColors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              width: 120,
                              child: AppTextField(
                                readOnly: true,
                                controller: controller.eligibleAmtController,
                                name: 'Eligibility Amount',
                                keyboardType: TextInputType.number,
                                inputType: AppTextInputType.numberOnly,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Required Loan Amount',
                                style: kTitleMetropolis14,
                              ),
                            ),
                            Container(
                              width: 120,
                              child: AppTextField(
                                name: 'Loan Amount',
                                controller: controller.requestLoanAmtController,
                                keyboardType: TextInputType.number,
                                inputType: AppTextInputType.numberOnly,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter required loan amount';
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9]'),
                                  ),
                                  LengthLimitingTextInputFormatter(15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 120,
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: AgButton(
                              title: 'Accept',
                              isOutlined: true,
                              outlineColor: AppColors.primary,
                              onTap: () async {
                                controller.onApproveSubmit({
                                  'addiParams': ['ACCEPTED'],
                                  'filterVal':
                                      controller.plStatus.value?.refNumber ??
                                      '',
                                  'loanAmount':
                                      controller
                                          .plStatus
                                          .value
                                          ?.plEligibilityAmt
                                          .toString() ??
                                      '',
                                });
                              },
                            ),
                          ),
                        ),
                        10.horizontalSpace,
                        Container(
                          width: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: AgButton(
                              title: "Reject",
                              isOutlined: true,
                              onTap: () {
                                controller.onApproveSubmit({
                                  'addiParams': ['REJECTED'],
                                  'filterVal':
                                      controller.plStatus.value?.refNumber ??
                                      '',
                                  'loanAmount':
                                      controller
                                          .plStatus
                                          .value
                                          ?.plEligibilityAmt
                                          .toString() ??
                                      '',
                                });
                              },
                              outlineColor: AppColors.kff0000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
