import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/image_hendle.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/args/pl_chat_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/preApproveBankList/BankListForLoanList.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/real_estate_loan_history_controller.dart';

class RealEstateLoanHistoryView
    extends GetView<RealEstateLoanHistoryController> {
  const RealEstateLoanHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.kffffff,
    appBar: AgAppbar(
      title: 'Home Loan',
      leadingOnTap: () {
        controller.isFromOrderScreen()
            ? Get.back()
            : Get.offAllNamed<void>(Routes.HOME);
      },
    ),
    body: Obx(
      () => Visibility(
        visible: controller.isLoading.value ? false : true,
        replacement: const Center(child: AppLoader()),
        child: Container(
          color: AppColors.kffffff,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child:
              ((controller.loanList.length == 0) &&
                      (controller.bankList?.value.length == 0))
                  ? const Center(
                    child: Text(
                      'No Home Loans Found!',
                      style: kSubTitleMetropolis14,
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    itemCount:
                        ((controller.loanList.length ?? 0) +
                                (controller.bankList?.value?.length ?? 0))
                            .toInt(),
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder: (BuildContext context, int index) {
                      if (index < (controller.loanList.length ?? 0)) {
                        return _buildPLList(index, context);
                      } else if (index <
                          ((controller.loanList.length ?? 0) +
                                  (controller.bankList?.value?.length ?? 0))
                              .toInt()) {
                        return getBankList(
                          controller.bankList?.value[index -
                              (controller.loanList.length ?? 0)],
                        );
                      }
                      // ...?controller.bankList().bankListForLoanList?.map(
                      // (BankListForLoanList prod) =>
                      // getBankList(prod),
                      // )
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
                  url: (controller.loanList[index]?.bankLogo ?? '').addBaseUrl,
                  padding: EdgeInsets.zero,
                  size: Size(72.h, 72.w),
                  radius: 8.r,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Text(
                    'Your Home Loan submitted to ${controller.loanList[index]?.bankName ?? ''}', //',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: kTitleMetropolis16,
                  ),
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Application No:', style: kTitleMetropolis14),
                const SizedBox(width: 10),
                Text(
                  textAlign: TextAlign.center,
                  controller.loanList[index]?.loanAppNum ?? '',
                  style: kSubTitleMetropolis12,
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Loan Amount:', style: kTitleMetropolis14),
                Text(
                  textAlign: TextAlign.center,
                  '${CommonUtilities.AppCurrency} ${controller.loanList[index]?.loanAmount?.toStringAsFixed(2) ?? '0'}',
                  style: kSubTitleMetropolis12,
                ),
              ],
            ),
            5.verticalSpace,
            /*Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Expanded(
              child: Text(
                'Eligibility Amount:',
                style: kTitleMetropolis14,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                '${CommonUtilities.AppCurrency} ${controller.loanList[index]?.loanAmount?.toStringAsFixed(2) ?? '0'}',
                style: kSubTitleMetropolis12,
              ),
            )
          ]),*/
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status', style: kTitleMetropolis14),
                    /*Text(
                          controller.loanList[index]?.status ?? '',
                          style: kBlueLinkMetropolis12,
                        ),
*/
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
                          color: AppColors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.kffffff,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          controller.loanList[index]?.status ?? '',
                          style: kBlueLinkMetropolis12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            const Text('Need more help', style: kTitleMetropolis18),
            8.verticalSpace,
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.chat, color: AppColors.primary),
                    label: const Text(
                      'Chat with Us',
                      style: kTitleMetropolis14,
                    ),
                    onPressed: () {
                      Get.toNamed<void>(
                        Routes.PL_CHAT,
                        arguments: PLChatArguments(
                          chatId:
                              controller.loanList[index]?.chatId.toString() ??
                              '',
                          applicationId:
                              controller.loanList[index]?.leadId.toString() ??
                              '',
                          loanType: "REAL_ESTATE",
                        ),
                      )?.then((value) => controller.getHomeLoan());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kffffff,
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
                    label: const Text('Talk to Us', style: kTitleMetropolis14),
                    onPressed: () {
                      appSnackbar(
                        message: 'Coming Soon',
                        snackbarState: SnackbarState.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kffffff,
                      shadowColor: Colors.transparent,
                      elevation: 0,
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
                        style: kSubTitleMetropolis12,
                        maxLines: 3,
                      ),
                      4.verticalSpace,
                      Text(
                        'Interest Rate: ${banklist?.interestRate}% pa ',
                        style: kSubTitleMetropolis12,
                      ),
                      4.verticalSpace,
                      Text(
                        'Loan Amount: ${banklist?.maxAmount}',
                        style: kSubTitleMetropolis12,
                      ),
                      4.verticalSpace,
                      Text(
                        'Loan Status: ${banklist?.status}',
                        style: kSubTitleMetropolis12,
                      ),
                      4.verticalSpace,
                    ],
                  ),
                  // 5.horizontalSpace,
                ],
              ).paddingOnly(top: 10, bottom: 0),
              8.verticalSpace,
              const Text('Need more help', style: kTitleMetropolis18),
              8.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.chat, color: AppColors.primary),
                      label: const Text(
                        'Chat with Us',
                        style: kTitleMetropolis14,
                      ),
                      onPressed: () {
                        Get.toNamed<void>(
                          Routes.PL_CHAT,
                          arguments: PLChatArguments(
                            chatId: banklist?.chatId.toString() ?? '',
                            applicationId: banklist?.leadId.toString() ?? '',
                            loanType: banklist?.appType ?? "",
                          ),
                        )?.then((value) => controller.getHomeLoan());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
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
                      label: const Text(
                        'Talk to Us',
                        style: kTitleMetropolis14,
                      ),
                      onPressed: () {
                        appSnackbar(
                          message: 'Coming Soon',
                          snackbarState: SnackbarState.success,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
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
