import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import '../controllers/credit_card_deatils_controller.dart';

class CreditCardDeatilsView extends GetView<CreditCardDeatilsController> {
  const CreditCardDeatilsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kffffff,
    appBar: AppBar(
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
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
      backgroundColor: AppColors.kC4E59E,
      title: Text(
        'Card Details',
        style: kTitleMetropolis14.copyWith(fontSize: 16),
      ),
    ),
    body: Obx(
      () => Visibility(
        visible: controller.isLoading.isFalse,
        replacement: const Center(child: AppLoader()),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fees & Charges', style: kTitleMetropolis14),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${CommonUtilities.AppCurrency} ${controller.homeCardList[0].annualFee}' ??
                                    '',
                                style: kTitleMetropolis14,
                              ),
                              8.horizontalSpace,
                              const Text(
                                'Annual Fee',
                                style: kSubTitleMetropolis12,
                              ),
                            ],
                          ),
                          100.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${CommonUtilities.AppCurrency} ${controller.homeCardList[0].cashAdvanceFee}' ??
                                    '',
                                style: kTitleMetropolis14,
                              ),
                              8.horizontalSpace,
                              const Text(
                                'Cash Advance Fee',
                                style: kSubTitleMetropolis12,
                              ),
                            ],
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${CommonUtilities.AppCurrency} ${controller.homeCardList[0].joiningFees}' ??
                                    '',
                                style: kTitleMetropolis14,
                              ),
                              8.horizontalSpace,
                              const Text(
                                'Joining Fees',
                                style: kSubTitleMetropolis12,
                              ),
                            ],
                          ),
                          100.horizontalSpace,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${CommonUtilities.AppCurrency} ${controller.homeCardList[0].latePaymentCharges}' ??
                                    '',
                                style: kTitleMetropolis14,
                              ),
                              8.horizontalSpace,
                              const Text(
                                'Late Payment Charges',
                                style: kSubTitleMetropolis12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                25.verticalSpace,
                const Text('Key Benefits', style: kTitleMetropolis14),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✔  Airport Lounge Access',
                        style: kSubTitleMetropolis12,
                      ),
                      5.verticalSpace,
                      const Text(
                        '✔  Travel Benefits',
                        style: kSubTitleMetropolis12,
                      ),
                      5.verticalSpace,
                      const Text('✔  Fuel Card', style: kSubTitleMetropolis12),
                      5.verticalSpace,
                      const Text('✔  Cashback', style: kSubTitleMetropolis12),
                    ],
                  ),
                ),
                25.verticalSpace,
                const Text('Other Key Benefits', style: kTitleMetropolis14),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount:
                        controller.homeCardList[0].benefits?.data?.length ?? 0,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) =>
                            _buildBenefitsList(index, context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildBenefitsList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '■  ${controller.homeCardList[0].benefits?.data![index]}' ?? '',
            style: kSubTitleMetropolis12,
          ),
          5.verticalSpace,
        ],
      ),
    ),
  );
}
