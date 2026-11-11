import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/model/loan/PersonalLoan/ProductDetails.dart';
import '../../../utils/app_colors.dart';
import '../controllers/pl_compare_product_controller.dart';

class PlCompareProductView extends GetView<PlCompareProductController> {
  const PlCompareProductView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    appBar: AgAppbar(title: 'Compare Product'),
    body: Obx(
      () =>
          controller.isLoading()
              ? const Center(child: CircularProgressIndicator())
              : (controller.compareProdcuts().productDetails?.isNotEmpty ??
                  false)
              ? SingleChildScrollView(
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                  },
                  children: [
                    _buildImagesRow(),
                    _buildTitleRow(),
                    ...controller
                            .compareProdcuts()
                            .attrs
                            ?.map(
                              (e) => TableRow(
                                children: [
                                  Container(
                                    height: 50.h,
                                    alignment: Alignment.centerLeft,
                                    color: AppColors.kffffff,
                                    padding: REdgeInsets.only(left: 10),
                                    child: Text(
                                      e.key ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: AppColors.black,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ).paddingAll(1.r),
                                  if (e.compValues != null)
                                    ...e.compValues!
                                        .map(
                                          (value) => Container(
                                            height: 50.h,
                                            padding: REdgeInsets.only(left: 10),
                                            alignment: Alignment.centerLeft,
                                            color:
                                                e.compValues!.indexOf(value) ==
                                                        0
                                                    ? AppColors.grey
                                                    : AppColors.kffffff,
                                            child: Text(
                                              value.values?.firstWhereOrNull(
                                                    (e) => true,
                                                  ) ??
                                                  '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: AppColors.black,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ).paddingAll(1.r),
                                        )
                                        .toList(),
                                ],
                              ),
                            )
                            .toList() ??
                        [const TableRow()],
                  ],
                ),
              )
              : const Center(child: Text('No Data available')),
    ),
  );

  _buildImagesRow() => TableRow(
    children: [
      Container(),
      ...controller.compareProdcuts().productDetails!.map(
        (ProductDetails e) => Container(
          color: AppColors.kffffff,
          child: ImageHandle(
            url: e.bankLogo?.addBaseUrl ?? '',
            padding: EdgeInsets.zero,
            size: Size(140.h, 140.w),
            radius: 1.r,
          ),
        ).paddingAll(1),
      ),
    ],
  );

  _buildTitleRow() => TableRow(
    children: [
      Container(
        height: 80.h,
        alignment: Alignment.center,
        color: AppColors.primary,
        child: Text(
          'Bank Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.kffffff,
          ),
          textAlign: TextAlign.center,
        ),
      ).paddingAll(1),
      ...controller.compareProdcuts().productDetails!.map(
        (ProductDetails e) => Container(
          // height: 80.h,
          alignment: Alignment.center,
          color: AppColors.kffffff,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                e.bankName ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              5.verticalSpace,

              AgButton(
                title: 'Apply',
                onTap: () {
                  if (e.productCode ==
                      controller.compareBankList[0].productCode) {
                    LocalStore.bankId(
                      controller.compareBankList[0].bankId.toString() ?? '',
                    );
                  } else {
                    LocalStore.bankId(
                      controller.compareBankList[1].bankId.toString() ?? '',
                    );
                  }
                  LocalStore.editString('');
                  controller.checkBank();
                },
              ),
            ],
          ).paddingOnly(top: 8.h, left: 10.h),
        ).paddingAll(1),
      ),
    ],
  );
}
