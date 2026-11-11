import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/image_hendle.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import '../controllers/credit_compare_cards_controller.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

class CreditCompareCardsView extends GetView<CreditCompareCardsController> {
  const CreditCompareCardsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
    () => Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AgAppbar(
        title: 'Compare Cards',
        leadingIcon: Icons.chevron_left,
        leadingOnTap: () => Get.back(),
      ),
      body:
          controller.isLoading()
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  margin: REdgeInsets.all(10),
                  child: IntrinsicHeight(
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                      },
                      children: [
                        _buildImagesRow(),
                        _buildTitleRow(),
                        _buildDetailRow(
                          key: 'Add on Cards',
                          value1:
                              controller.compareCardList.value[0].addOnCards ??
                              false,
                          value2:
                              controller.compareCardList.value[1].addOnCards ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Airport Lounge  Access',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .airportLoungeAccess ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .airportLoungeAccess ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Balance Transfer',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .balanceTransfer ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .balanceTransfer ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Sharia Compliant',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .shariaCompliant ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .shariaCompliant ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Emi Conversion',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .emiConversion ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .emiConversion ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Travel Benefits',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .travelBenefits ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .travelBenefits ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Fuel surcharge waiver',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .fuelSurchargeWaiver ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .fuelSurchargeWaiver ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Fuel Card',
                          value1:
                              controller.compareCardList.value[0].fuelCard ??
                              false,
                          value2:
                              controller.compareCardList.value[1].fuelCard ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Supplementary Card',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .supplementaryCard ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .supplementaryCard ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Insurance Coverage',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .insuranceCoverage ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .insuranceCoverage ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Internet Banking',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .internetBanking ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .internetBanking ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Student card',
                          value1:
                              controller
                                  .compareCardList
                                  .value[0]
                                  .travelInsurance ??
                              false,
                          value2:
                              controller
                                  .compareCardList
                                  .value[1]
                                  .travelInsurance ??
                              false,
                        ),
                        _buildDetailRow(
                          key: 'Student card',
                          value1:
                              controller.compareCardList.value[0].studentCard ??
                              false,
                          value2:
                              controller.compareCardList.value[1].studentCard ??
                              false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

      //),
    ),
  );

  _buildImagesRow() => TableRow(
    children: [
      Container(),
      ...controller.compareCardList().map(
        (CreditCardsList e) => Container(
          color: AppColors.kffffff,
          child: Column(
            children: [
              ImageHandle(
                url: e.cardImage?.url.addBaseUrl ?? '',
                padding: EdgeInsets.zero,
                size: Size(140.h, 140.w),
                radius: 1.r,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primary),
                ),
                onPressed: () async {
                  LocalStore.bankId(e.bankId.toString() ?? '');
                  LocalStore.productName(e.cardName.toString() ?? '');
                  LocalStore.productCode(e.cardCode.toString() ?? '');
                  LocalStore.creditCardType(e.creditCardType.toString() ?? '');
                  await Get.toNamed<void>(
                    Routes.PERSONAL_INFO,
                    arguments: LimitArguments(LimitMode: 'Credit'),
                  );
                },
                child: const Text('Apply', style: kTitleWhiteColorMetropolis14),
              ),
              5.verticalSpace,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGrey,
                  foregroundColor: AppColors.kffffff,
                  // fixedSize: Size(150.w, 40.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  textStyle: kTitleMetropolis14,
                ),
                onPressed: () async {
                  // await Get.toNamed<void>(
                  //   Routes.HOME,
                  // );
                },
                child: const Text(
                  'Visit Site',
                  style: kTitleWhiteColorMetropolis14,
                ),
              ),
            ],
          ),
        ).paddingAll(1),
      ),
    ],
  );

  _buildTitleRow() => TableRow(
    children: [
      Container(
        height: 60.h,
        alignment: Alignment.center,
        color: AppColors.primary,
        child: Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.kffffff,
          ),
          textAlign: TextAlign.center,
        ),
      ).paddingAll(1),
      ...controller.compareCardList().map(
        (CreditCardsList e) => Container(
          height: 60.h,
          alignment: Alignment.center,
          color: AppColors.kffffff,
          child: Text(
            e.bankName ?? '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ).paddingAll(1),
      ),
    ],
  );

  _buildDetailRow({
    required String key,
    required bool value1,
    required bool value2,
  }) => TableRow(
    children: [
      Container(
        height: 50.h,
        alignment: Alignment.centerLeft,
        color: AppColors.kffffff,
        child: Text(
          key,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ).paddingAll(1.r),
      Container(
        height: 50.h,
        padding: REdgeInsets.only(left: 10),
        alignment: Alignment.center,
        color: AppColors.kffffff,
        child: Icon(
          Icons.check_circle,
          size: 24,
          color: value1 ? AppColors.primary : Colors.red,
        ),
      ).paddingAll(1.r),
      Container(
        height: 50.h,
        padding: REdgeInsets.only(left: 10),
        alignment: Alignment.center,
        color: AppColors.kffffff,
        child: Icon(
          Icons.check_circle,
          size: 24,
          color: value2 ? AppColors.primary : Colors.red,
        ),
      ).paddingAll(1.r),
    ],
  );
}
