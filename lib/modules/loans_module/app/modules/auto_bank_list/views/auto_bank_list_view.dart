import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../../../data/model/loan/bank_list/GdbShopEmiRespList.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/aes_encoder.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/auto_bank.dart';
import '../controllers/auto_bank_list_controller.dart';

class AutoBankListView extends GetView<AutoBankListController> {
  const AutoBankListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Finance Option'),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child:
            ((controller.arrList().length ?? 0) > 0)
                ? ListView.builder(
                  itemCount: controller.arrList().length,
                  itemBuilder: (BuildContext context, int index) {
                    final GdbShopEmiRespList? bank =
                        controller.arrList()[index];
                    return AutoBank(
                      isOneBank:
                          (controller.arrList().length == 1) ? true : false,
                      bank: bank?.gdbChBank,
                      emis: bank?.emiInfoDetails,
                      onClick: (EmiInfoDetails? value) {
                        if (controller.selectedEMIPlan().tenure ==
                            value?.tenure) {
                          controller.selectedEMIPlan(EmiInfoDetails());
                        } else {
                          controller.selectedEMIPlan(value);
                        }
                        controller.selectedBank(bank);
                        controller.selectedBank.refresh();
                      },
                    );
                  },
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 1.sw,
                      child: Text(
                        'No banks are eligible',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    ),
    bottomNavigationBar: Obx(
      () => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child:
            controller.selectedEMIPlan().downPayment?.isNotEmpty ?? false
                ? ColoredBox(
                  color: AppColors.kffffff,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Down-payment amount', style: kw400Black12),
                          Text(
                            '${CommonUtilities.AppCurrency} ${double.tryParse(controller.selectedEMIPlan().downPayment ?? '')?.toStringAsFixed(2) ?? 0}',
                            style: kw400Black12,
                          ),
                        ],
                      ),
                      const Spacer(),
                      AgButton(
                        title: 'Check EMI',
                        onTap: () async {
                          await controller.onSubmit(
                            controller
                                    .selectedEMIPlan()
                                    .downPayment
                                    ?.replaceAll(
                                      CommonUtilities.AppCurrency,
                                      '',
                                    )
                                    .trim() ??
                                '0',
                            controller.selectedEMIPlan().emiAmount ?? '0',
                            controller.selectedEMIPlan().interestRate ?? '',
                            controller.selectedEMIPlan().tenure ?? '',
                            controller.selectedEMIPlan().totalAmount ?? '0',
                          );
                          await showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            isScrollControlled: true,
                            builder:
                                (BuildContext context) => Padding(
                                  padding: REdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ImageHandle(
                                            url:
                                                controller
                                                    .selectedBank()
                                                    .gdbChBank
                                                    ?.gdbChMediaAction
                                                    ?.urlAction
                                                    ?.url
                                                    ?.addBaseUrl ??
                                                '',
                                            size: Size(80.r, 80.r),
                                            radius: 6,
                                          ),
                                          20.horizontalSpace,
                                          Expanded(
                                            child: Text(
                                              controller
                                                      .selectedBank()
                                                      .gdbChBank
                                                      ?.name ??
                                                  '',
                                              style: kw400Black14,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ).paddingSymmetric(horizontal: 20),

                                      _buildDivider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          buildRichText(
                                            text: 'Finance Amount',
                                            amount:
                                                controller
                                                    .selectedEMIPlan()
                                                    .loanAmount ??
                                                '0',
                                          ),
                                          buildRichText(
                                            text: 'EMI Amount',
                                            amount:
                                                controller
                                                    .selectedEMIPlan()
                                                    .emiAmount ??
                                                '0',
                                          ),
                                        ],
                                      ).paddingSymmetric(horizontal: 20),
                                      _buildDivider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          buildRichTextPercentage(
                                            text: 'Interest Rate',
                                            amount:
                                                controller
                                                    .selectedEMIPlan()
                                                    .interestRate ??
                                                '',
                                          ),
                                          buildRichText(
                                            text: 'Down Payment',
                                            amount:
                                                controller
                                                    .selectedEMIPlan()
                                                    .downPayment ??
                                                '0',
                                          ),
                                        ],
                                      ).paddingSymmetric(horizontal: 20),
                                      _buildDivider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          AgButton(
                                            isOutlined: true,
                                            title: 'Fee/Charges',
                                            onTap: () async {
                                              bool res =
                                                  await controller
                                                      .onFeeSubmit();
                                              if (res == true &&
                                                  controller
                                                      .feeAndCharges
                                                      .isNotEmpty) {
                                                (controller
                                                            .feeAndCharges
                                                            .length <
                                                        2)
                                                    ? await showDialog(
                                                      context: Get.context!,
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => Dialog(
                                                            insetPadding:
                                                                EdgeInsets.symmetric(
                                                                  vertical:
                                                                      50.h,
                                                                  horizontal:
                                                                      10.w,
                                                                ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                controller.buildRow(
                                                                  title:
                                                                      controller
                                                                          .feeAndCharges
                                                                          .first
                                                                          .feesChargeName ??
                                                                      ' ',
                                                                  subTitle:
                                                                      controller
                                                                          .feeAndCharges
                                                                          .first
                                                                          .appliedCharge ??
                                                                      ' ',
                                                                ),
                                                                10.verticalSpace,

                                                                Container(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                  height: 1,
                                                                  width: 1.sw,
                                                                ),
                                                                10.verticalSpace,
                                                                controller.buildRow(
                                                                  title:
                                                                      'Total',
                                                                  subTitle:
                                                                      '${AesEncryption.decrypt(controller.totalCharge ?? '') ?? ' '}',
                                                                ),
                                                                10.verticalSpace,
                                                                15.verticalSpace,
                                                                AgButton(
                                                                  title: 'OK',
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              ],
                                                            ).paddingAll(20.r),
                                                          ),
                                                    )
                                                    : await showDialog(
                                                      context: Get.context!,
                                                      builder:
                                                          (
                                                            BuildContext
                                                            context,
                                                          ) => Dialog(
                                                            insetPadding:
                                                                EdgeInsets.symmetric(
                                                                  vertical:
                                                                      50.h,
                                                                  horizontal:
                                                                      10.w,
                                                                ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                controller.buildRow(
                                                                  title:
                                                                      controller
                                                                          .feeAndCharges
                                                                          .first
                                                                          .feesChargeName ??
                                                                      ' ',
                                                                  subTitle:
                                                                      controller
                                                                          .feeAndCharges
                                                                          .first
                                                                          .appliedCharge ??
                                                                      ' ',
                                                                ),
                                                                10.verticalSpace,
                                                                controller.buildRow(
                                                                  title:
                                                                      controller
                                                                          .feeAndCharges[1]
                                                                          .feesChargeName ??
                                                                      ' ',
                                                                  subTitle:
                                                                      controller
                                                                          .feeAndCharges[1]
                                                                          .appliedCharge ??
                                                                      ' ',
                                                                ),
                                                                10.verticalSpace,
                                                                Container(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                  height: 1,
                                                                  width: 1.sw,
                                                                ),
                                                                10.verticalSpace,
                                                                controller.buildRow(
                                                                  title:
                                                                      'Total',
                                                                  subTitle:
                                                                      '${AesEncryption.decrypt(controller.totalCharge ?? '') ?? ' '}',
                                                                ),
                                                                15.verticalSpace,
                                                                AgButton(
                                                                  title: 'OK',
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              ],
                                                            ).paddingAll(20.r),
                                                          ),
                                                    );
                                              } else {
                                                appSnackbar(
                                                  message:
                                                      'Fee and charges not available',
                                                );
                                              }
                                            },
                                            width: Get.width / 2.5,
                                          ),
                                          AgButton(
                                            isOutlined: true,
                                            title: 'Proceed',
                                            onTap: () async {
                                              if (controller.args.LimitMode ==
                                                  'CG') {
                                                await Get.toNamed<void>(
                                                  Routes.AUTO_DOCUMENT,
                                                  arguments: LimitArguments(
                                                    LimitMode: 'CG',
                                                  ),
                                                );
                                              } else if (controller
                                                      .args
                                                      .LimitMode ==
                                                  'REAL_ESTATE') {
                                                await Get.toNamed<void>(
                                                  Routes.AUTO_DOCUMENT,
                                                  arguments: LimitArguments(
                                                    LimitMode: 'REAL_ESTATE',
                                                  ),
                                                );
                                              } else {
                                                await Get.toNamed<void>(
                                                  Routes.AUTO_DOCUMENT,
                                                  arguments: LimitArguments(
                                                    LimitMode: 'Auto',
                                                  ),
                                                );
                                              }
                                            },
                                            width: Get.width / 2.5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20, vertical: 10),
                )
                : SizedBox(width: Get.width),
      ),
    ),
  );

  RichText buildRichText({required String text, required String amount}) =>
      RichText(
        text: TextSpan(
          text: text,
          style: kw400Black14,
          children: [TextSpan(text: '\n$amount', style: kw400Black12)],
        ),
        textAlign: TextAlign.center,
      );

  RichText buildRichTextPercentage({
    required String text,
    required String amount,
  }) => RichText(
    text: TextSpan(
      text: text,
      style: kw400Black14,
      children: [TextSpan(text: '\n$amount % pa', style: kw400Black12)],
    ),
    textAlign: TextAlign.center,
  );

  Divider _buildDivider() => Divider(
    color: AppColors.black.withOpacity(0.5),
    height: 50.h,
    thickness: 1,
  );

  Widget generateLayout() => Container(
    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: SingleChildScrollView(child: Column(children: [])),
  );
}
