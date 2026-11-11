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
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/creditcard_history_controller.dart';

class CreditcardHistoryView extends GetView<CreditcardHistoryController> {
  const CreditcardHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AgAppbar(
      title: 'Credit Cards',
      leadingOnTap: () {
        controller.isFromOrderScreen()
            ? Get.back()
            : Get.offAllNamed<void>(Routes.HOME);
      },
    ),
    body: Obx(
      () => Visibility(
        visible: controller.isLoading.isFalse,
        replacement: const Center(child: AppLoader()),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child:
              controller.cardsList.isEmpty
                  ? const Center(
                    child: Text(
                      'No cards Found!',
                      style: kSubTitleMetropolis14,
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.cardsList.length,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) =>
                            _buildBenefitsList(index, context),
                  ),
        ),
      ),
    ),
  );

  Widget _buildBenefitsList(int index, BuildContext context) =>
  //Obx(() =>
  GestureDetector(
    onTap: () {
      Get.toNamed(
        Routes.CREDITCARD_TRACK,
        arguments: controller.cardsList[index]?.productCode,
      );
    },
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
                url:
                    controller.cardsList[index]?.cardImage?.url?.addBaseUrl ??
                    '',
                padding: EdgeInsets.zero,
                size: Size(80.h, 80.w),
                radius: 1.r,
              ),
              10.horizontalSpace,
              Expanded(
                child: Text(
                  controller.cardsList[index]?.productName ?? '',
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
            children: [
              const Expanded(
                child: Text('Application No:', style: kTitleMetropolis14),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  textAlign: TextAlign.left,
                  controller.cardsList[index]?.creditReqCode ?? '',
                  style: kSubTitleMetropolis12,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text('Credit Limit:', style: kTitleMetropolis14),
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.left,
                  '${CommonUtilities.AppCurrency} ${controller.cardsList[index]?.limitAmount?.toStringAsFixed(2) ?? '0.00'}',
                  style: kSubTitleMetropolis12,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          Column(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Status', style: kTitleMetropolis14),
                  const SizedBox(width: 120),
                  Text(
                    controller.cardsList[index]?.cardReqStatus ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Metropolis',
                      color: AppColors.black,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         elevation: MaterialStateProperty.all(0),
                  //         backgroundColor:
                  //         MaterialStateProperty.all(AppColors.kffffff)),
                  //     onPressed: () async {
                  //
                  //     },
                  //     child: Text(
                  //       controller.cardsList[index]?.cardReqStatus ?? '',
                  //       style: kBlueLinkMetropolis14,
                  //     )),
                ],
              ),
            ],
          ),
          8.verticalSpace,
          const Text('Need more help', style: kTitleMetropolis18),
          8.verticalSpace,
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.chat, color: AppColors.primary),
                  label: const Text('Chat with Us', style: kTitleMetropolis14),
                  onPressed: () {
                    Get.toNamed<void>(
                      Routes.PL_CHAT,
                      arguments: PLChatArguments(
                        chatId:
                            controller.cardsList.value[index]?.chatId
                                .toString() ??
                            '',
                        applicationId:
                            controller.cardsList.value[index]?.id.toString() ??
                            '',
                        loanType: 'CREDIT_CARD_APPLICATION',
                      ),
                    )?.then((value) => controller.getCards());
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
                  label: const Text('Talk to Us', style: kTitleMetropolis14),
                  onPressed: () {
                    appSnackbar(
                      message: 'Coming Soon',
                      snackbarState: SnackbarState.success,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey,
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
    //),
  );
  //),
}
