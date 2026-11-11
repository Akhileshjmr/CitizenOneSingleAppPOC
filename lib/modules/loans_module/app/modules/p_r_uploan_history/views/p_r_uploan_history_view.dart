import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/p_r_uploan_history_controller.dart';

class PRUploanHistoryView extends GetView<PRUploanHistoryController> {
  const PRUploanHistoryView({super.key});
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      await Get.offAllNamed<void>(Routes.HOME);
      return true;
    },
    child: Scaffold(
      appBar: AgAppbar(title: 'Loan History'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Obx(
          () =>
              controller.isLoading()
                  ? const Center(child: CircularProgressIndicator())
                  : (controller.loanData.value.loanList == null)
                  ? Center(child: Text('No Data Found'))
                  : Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipOval(
                          child: Icon(
                            Icons.thumb_up_alt_rounded,
                            color: AppColors.primary,
                            size: 80,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'Congratulations!',
                                    textAlign: TextAlign.center,
                                    style: kw400Black14,
                                  ),
                                  5.verticalSpace,
                                  Center(
                                    child:
                                        controller
                                                    .loanData
                                                    .value
                                                    .loanList![0]
                                                    .status
                                                    ?.type ==
                                                'SUBMITTED_TO_BANK'
                                            ? const Text(
                                              'Your loan request is submitted to bank',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: kTitleMetropolis14,
                                            )
                                            : const Text(
                                              'Your Loan is sanctioned by bank',
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: kTitleMetropolis14,
                                            ),
                                  ),
                                  5.verticalSpace,
                                  Visibility(
                                    visible:
                                        controller
                                                    .loanData
                                                    .value
                                                    .loanList![0]
                                                    .status
                                                    ?.type ==
                                                'SUBMITTED_TO_BANK'
                                            ? true
                                            : false,
                                    child: const Center(
                                      child: Text(
                                        'we will confirm you about the status shortly.',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: kTitleMetropolis14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Column(
                          children: [
                            _buildTextTile(
                              leadingTitle: 'Bank Name',
                              trailingTitle:
                                  controller
                                      .loanData()
                                      .loanList
                                      ?.first
                                      .bankName
                                      .toString() ??
                                  '',
                            ),
                            _buildTextTile(
                              leadingTitle: 'Customer Ref#',
                              trailingTitle:
                                  controller
                                      .loanData()
                                      .loanList
                                      ?.first
                                      .custCode
                                      .toString() ??
                                  '',
                            ),
                            _buildTextTile(
                              leadingTitle: 'Loan Type',
                              trailingTitle:
                                  controller
                                      .loanData()
                                      .loanList
                                      ?.first
                                      .loanType
                                      .toString() ??
                                  '',
                            ),
                            _buildTextTile(
                              leadingTitle: 'Status',
                              trailingTitle: (controller
                                          .loanData()
                                          .loanList
                                          ?.first
                                          .status
                                          ?.type
                                          .toString() ??
                                      '')
                                  .replaceAll("_", " "),
                            ),
                            _buildTextTile(
                              leadingTitle: 'Submission Date',
                              trailingTitle:
                                  controller
                                      .loanData()
                                      .loanList
                                      ?.first
                                      .submissionDate
                                      .toString() ??
                                  '',
                            ),
                            _buildTextTile(
                              leadingTitle: 'Approved Date',
                              trailingTitle: (controller
                                          .loanData()
                                          .loanList
                                          ?.first
                                          .activateDate
                                          .toString() ??
                                      '')
                                  .replaceAll("null", " "),
                            ),
                            // _buildTextTile(
                            //   leadingTitle: 'Expiry Date',
                            //   trailingTitle: (controller.loanData().loanList?.first.expiryDate.toString() ?? '').replaceAll("null", " "),
                            // ),
                            // _buildTextTile(
                            //   leadingTitle: 'Suggested Amount',
                            //   trailingTitle: controller.loanData().loanList?.first.suggestedLimit.toString() ?? '',
                            // ),
                            _buildTextTile(
                              leadingTitle: 'Loan Amount',
                              trailingTitle:
                                  controller
                                      .loanData()
                                      .loanList
                                      ?.first
                                      .suggestedLimit
                                      .toString() ??
                                  '',
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,
                      GestureDetector(
                        onTap: () async {
                          await Get.offAllNamed<void>(Routes.HOME);
                        },
                        child: Container(
                          width: 120,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.4),
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: const Center(
                            child: Text('Explore Loans', style: kw500White14),
                          ),
                        ).paddingSymmetric(vertical: 5),
                      ),
                    ],
                  ),
        ),
      ),
    ),
  );

  Widget _buildTextTile({
    required String leadingTitle,
    required String trailingTitle,
    FontWeight fontWeight = FontWeight.w400,
  }) => Row(
    children: [
      Expanded(child: Text(leadingTitle, style: kSubTitleMetropolis12)),
      Text(
        trailingTitle,
        textAlign: TextAlign.right,
        style: kTitleMetropolis14,
      ),
    ],
  ).paddingSymmetric(horizontal: 16, vertical: 10);
}
