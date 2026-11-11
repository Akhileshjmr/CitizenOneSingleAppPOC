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
import '../../../data/model/args/pl_chat_arguments.dart';
import '../../../data/model/loan/PreApprove/preApproveBankList/BankListForLoanList.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/auto_loan_history_controller.dart';

class AutoLoanHistoryView extends GetView<AutoLoanHistoryController> {
  const AutoLoanHistoryView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(
      title: 'Auto Loan',
      leadingOnTap: () {
        controller.isFromOrderScreen()
            ? Get.back()
            : Get.offAllNamed<void>(Routes.HOME);
      },
    ),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: Container(
          color: AppColors.kffffff,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child:
              ((controller.loanList.length == 0) &&
                      (controller.bankList?.value.length == 0))
                  ? const Center(
                    child: Text('No Auto Loans Found!', style: kw400Black14),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    itemCount:
                        ((controller.loanList.length ?? 0) +
                                (controller.bankList?.value.length ?? 0))
                            .toInt(),
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < (controller.loanList.length ?? 0)) {
                        return _buildPLList(index, context);
                      } else if (index <
                          ((controller.loanList.length ?? 0) +
                                  (controller.bankList?.value.length ?? 0))
                              .toInt()) {
                        return getBankList(
                          controller.bankList?.value[index -
                              (controller.loanList.length ?? 0)],
                        );
                      }
                    },
                  ),
        ),
      ),
    ),
  );

  Widget _buildPLList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      onTap: () {},
      child: Container(
        padding: REdgeInsets.all(8.r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ImageHandle(
                  url: (controller.loanList[index].bankLogo ?? '').addBaseUrl,
                  padding: EdgeInsets.zero,
                  size: Size(72.h, 72.w),
                  radius: 8.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Your Auto Loan submitted to ${controller.loanList[index].bankName ?? ''}',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: kw600Black16,
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Application No:', style: kw400Black14),
                const SizedBox(width: 10),
                Text(
                  textAlign: TextAlign.center,
                  controller.loanList[index].loanAppNum ?? '',
                  style: kw400Black12,
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loan Amount:', style: kw400Black14),
                Text(
                  textAlign: TextAlign.center,
                  '${CommonUtilities.AppCurrency} ${controller.loanList[index].loanAmount?.toStringAsFixed(2) ?? '0'}',
                  style: kw400Black12,
                ),
              ],
            ),
            5.verticalSpace,

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status', style: kw400Black14),

                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Routes.AUTO_LOAN_ORDER_STATUS,
                          arguments: controller.loanList[index],
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          controller.loanList[index].status ?? '',
                          style: kw400Black14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // 8.verticalSpace,
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 2, 5),
              height: 35,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Interested in\nInsurance',
                      textAlign: TextAlign.center,
                      style: kw400Black14,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: AgButton(
                          title: 'Get Quote',
                          onTap: () {
                            Get.toNamed(
                              Routes.AUTO_LOAN_INSURANCE,
                              arguments: (controller.loanList.value[index]),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            const Text('Need more help', style: kw600Black18),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.chat, color: AppColors.primary),
                    label: const Text('Chat with Us', style: kw400Black14),
                    onPressed: () {
                      Get.toNamed<void>(
                        Routes.PL_CHAT,
                        arguments: PLChatArguments(
                          chatId:
                              controller.loanList.value[index].chatId
                                  .toString() ??
                              '',
                          applicationId:
                              controller.loanList.value[index].leadId
                                  .toString() ??
                              '',
                          loanType: "AUTO",
                        ),
                      )?.then((value) => controller.getAutoLoan());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      fixedSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.phone, color: AppColors.primary),
                    label: const Text('Talk to Us', style: kw400Black14),
                    onPressed: () {
                      appSnackbar(
                        message: 'Coming Soon',
                        snackbarState: SnackbarState.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.grey,
                      shadowColor: Colors.transparent,
                      elevation: 0.0,
                      fixedSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  InkWell getBankList(BankListForLoanList? banklist) => InkWell(
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: GestureDetector(
        onTap: () {
          Get.toNamed<void>(
            Routes.P_R_UPLOAN_HISTORY,
            arguments: [controller.filterval, banklist?.gdbChBank?.key ?? ''],
          );
        },
        child: Card(
          child: Column(
            children: [
              2.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.horizontalSpace,
                  ImageHandle(
                    url:
                        banklist
                            ?.gdbChBank
                            ?.gdbChMediaAction
                            ?.urlAction
                            ?.url
                            .addBaseUrl ??
                        '',
                    size: Size(72, 72),
                    // size: Size(0.25.sw, 80.h),
                    radius: 6,
                  ).paddingAll(5),
                  8.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      4.verticalSpace,
                      Text(
                        banklist?.bankName ?? '',
                        style: kw400Black12,
                        maxLines: 3,
                      ),
                      4.verticalSpace,
                      Text(
                        'Interest Rate: ${banklist?.interestRate}% pa ',
                        style: kw400Black12,
                      ),
                      4.verticalSpace,
                      Text(
                        'Loan Amount: ${banklist?.maxAmount}',
                        style: kw400Black12,
                      ),
                      4.verticalSpace,
                      Text(
                        'Loan Status: ${banklist?.status}',
                        style: kw400Black12,
                      ),
                      4.verticalSpace,
                    ],
                  ),
                  // 5.horizontalSpace,
                ],
              ).paddingOnly(top: 10, bottom: 0),
              8.verticalSpace,
              const Text('Need more help', style: kw600Black18),
              8.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.chat, color: AppColors.primary),
                      label: const Text('Chat with Us', style: kw400Black12),
                      onPressed: () {
                        Get.toNamed<void>(
                          Routes.PL_CHAT,
                          arguments: PLChatArguments(
                            chatId: banklist?.chatId.toString() ?? '',
                            applicationId: banklist?.leadId.toString() ?? '',
                            loanType: banklist?.appType ?? "",
                          ),
                        )?.then((value) => controller.getAutoLoan());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        fixedSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.phone, color: AppColors.primary),
                      label: const Text('Talk to Us', style: kw400Black12),
                      onPressed: () {
                        appSnackbar(
                          message: 'Coming Soon',
                          snackbarState: SnackbarState.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey,
                        shadowColor: Colors.transparent,
                        elevation: 0.0,
                        fixedSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ),
                ],
              ).marginOnly(left: 8, right: 8),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    ),
  );
}
