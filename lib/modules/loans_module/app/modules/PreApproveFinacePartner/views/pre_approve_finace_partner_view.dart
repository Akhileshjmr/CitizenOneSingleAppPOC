import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/image_hendle.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PersonalLoan/pr_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/preApproveBankList/BankListForLoanList.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import '../controllers/pre_approve_finace_partner_controller.dart';

class PreApproveFinacePartnerView
    extends GetView<PreApproveFinacePartnerController> {
  const PreApproveFinacePartnerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      leadingWidth: 50,
      titleSpacing: 0.9,
      leading: Builder(
        builder:
            (BuildContext context) => IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Get.back();
              },
            ),
      ),
      backgroundColor: AppColors.primaryDark,
      title: Text(
        'Finance Partner',
        style: kTitleMetropolis14.copyWith(
          fontSize: 16,
          color: AppColors.white,
        ),
      ),
    ),
    body: Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: controller.args == 'New' ? true : false,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.kffffff,
                border: Border.all(color: AppColors.black.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed<void>(Routes.P_R_EMI_CALCULATOR);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.radio_button_off, color: AppColors.black),
                    40.horizontalSpace,
                    Text('Check Your Eligibility', style: kTitleMetropolis14),
                  ],
                ),
              ),
            ),
          ),
          20.verticalSpace,
          Text('Select Your Finance Partner', style: kTitleMetropolis14),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(
              () => Column(
                children: [
                  ...?controller.bankList().bankListForLoanList?.map(
                    (BankListForLoanList prod) => getBankList(prod),
                  ),
                  // ListView.builder(
                  //   itemCount: 10,
                  //   itemBuilder: (BuildContext context, int index) {
                  //       return getBankList(index);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  InkWell getBankList(BankListForLoanList banklist) => InkWell(
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          child: Column(
            children: [
              8.horizontalSpace,
              Row(
                children: [
                  ImageHandle(
                    url:
                        banklist
                            .gdbChBank
                            ?.gdbChMediaAction
                            ?.urlAction
                            ?.url
                            .addBaseUrl ??
                        '',
                    // size: Size(0.25.sw, 80.h),
                    radius: 6,
                  ).paddingAll(5),
                  5.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${banklist.bankName} ',
                          style: kSubTitleMetropolis12,
                          maxLines: 3,
                        ),
                        2.verticalSpace,
                        Text(
                          'Interest Rate: ${banklist.interestRate}% pa ',
                          style: kSubTitleMetropolis12,
                        ),
                        2.verticalSpace,
                        Text(
                          'Loan Amount: ${banklist.maxAmount}',
                          style: kSubTitleMetropolis12,
                        ),
                        2.verticalSpace,
                      ],
                    ),
                  ),
                  5.horizontalSpace,
                ],
              ).paddingOnly(left: 10, right: 10, top: 10, bottom: 0),
              (banklist.appliedForLoan == false)
                  ? GestureDetector(
                    onTap: () {
                      Get.toNamed<void>(
                        Routes.PERSONAL_INFO,
                        arguments: PRArguments(
                          filterval: controller.filterval ?? '',
                          montlyInc: '',
                          montlyExc: '',
                          bankid: banklist.gdbChBank?.key ?? '',
                          bankName: '',
                          LimtMode: 'AutoLoan',
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.kffffff,
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: kTitleWhiteColorMetropolis14.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ).paddingSymmetric(vertical: 16),
                  )
                  : GestureDetector(
                    onTap: () {
                      Get.toNamed<void>(
                        Routes.P_R_UPLOAN_HISTORY,
                        arguments: [
                          controller.filterval ?? '',
                          banklist.gdbChBank?.key ?? '',
                        ],
                      );
                    },
                    child: Container(
                      width: 120,
                      height: 35,
                      decoration: BoxDecoration(
                        color: AppColors.kffffff,
                        border: Border.all(
                          color: AppColors.black.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      child: Center(
                        child: Text(
                          'Loan Status',
                          style: kTitleWhiteColorMetropolis14.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ).paddingSymmetric(vertical: 5),
                  ),
            ],
          ),
        ),
      ),
    ),
  );
}
