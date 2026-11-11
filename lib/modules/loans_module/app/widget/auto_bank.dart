import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../components/ui/image_hendle.dart';
import '../components/utils/common_utilities.dart';
import '../data/local/store/local_store.dart';
import '../data/model/loan/PreApprove/preApproveBankList/GdbChBank.dart';
import '../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../theme/ag_text_styles.dart';
import '../utils/app_colors.dart';

typedef SelectEmi = Function();

class AutoBank extends StatefulWidget {
  AutoBank({
    required this.bank,
    required this.emis,
    required this.onClick,
    required this.isOneBank,
    Key? key,
  }) : super(key: key);
  final GdbChBank? bank;
  final List<EmiInfoDetails?>? emis;
  final Function(EmiInfoDetails? value) onClick;
  final RxBool isExpanded = false.obs;
  final isOneBank;

  @override
  State<AutoBank> createState() => _AutoBankState();
}

class _AutoBankState extends State<AutoBank> {
  bool isSelected = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.isOneBank) {
      widget.isExpanded(true);
      LocalStore.BankId(widget.bank?.productKey.toString() ?? '');
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Obx(
        () => GestureDetector(
          onTap: () {
            if (widget.isOneBank) {
              return;
            }
            widget.isExpanded.toggle();
            LocalStore.BankId(widget.bank?.productKey.toString() ?? '');
          },
          child: Card(
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      widget.isOneBank
                          ? Container(width: 0)
                          : Container(
                            padding: const EdgeInsets.all(10),
                            width: 30,
                            child:
                                widget.isExpanded()
                                    ? Icon(
                                      Icons.radio_button_checked,
                                      size: 24,
                                      color: AppColors.primary,
                                    )
                                    : const Icon(
                                      Icons.radio_button_off,
                                      size: 24,
                                    ),
                          ),
                      8.horizontalSpace,
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        width: 120,
                        height: 64,
                        child: ImageHandle(
                          url:
                              (widget.bank?.gdbChMediaAction?.urlAction?.url ??
                                      '')
                                  .addBaseUrl,
                          size: Size(0.5.sw, 80.h),
                          radius: 6,
                        ),
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            8.verticalSpace,
                            Text(
                              widget.bank?.name ?? "",
                              style: kw500Primary14,
                            ),
                            8.verticalSpace,
                            Row(
                              children: [
                                Text(
                                  "ROI starts from ${widget.emis?[0]?.interestRate ?? ''}% ",
                                  style: kw400Black14,
                                ),
                                Text(
                                  "pa",
                                  // 'Emi Starts from: ${double.tryParse(widget.emis?[0]?.emiAmount ?? '')?.toStringAsFixed(2) ?? ''}',
                                  style: kw400Black12,
                                ),
                              ],
                            ),
                            // 2.verticalSpace,
                            // Text('Tenure: ${widget.emis?[0]?.tenure ?? ''}',
                            //     style: kSubTitleMetropolis12),
                            // 2.verticalSpace,
                            // Text(
                            //     'Interest: ${widget.emis?[0]?.interestRate ?? ''}',
                            //     style: kSubTitleMetropolis12),
                            2.verticalSpace,
                          ],
                        ),
                      ),
                    ],
                  ).paddingOnly(top: 10, bottom: 10),
                ),
                widget.isExpanded()
                    ? generateEmiLayout().paddingOnly(left: 5, bottom: 5)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateEmiLayout() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: List.generate(
        widget.emis?.length ?? 0,
        (int index) => getEMICell(index),
      ),
    ),
  );

  Widget getEMICell(int index) => InkWell(
    onTap:
        () => {
          selectedIndex = index,
          widget.onClick.call(widget.emis?[index]),
          selectedIndex = index,
          setState(() {
            if (selectedIndex == index) {
              isSelected = true;
            } else {
              isSelected = false;
            }
          }),
        },
    child: Container(
      width: 148.w,
      margin: REdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(
          color:
              (isSelected == true && selectedIndex == index)
                  ? AppColors.primary
                  : AppColors.grey,
          width: 1.0.w,
        ),
      ),
      // height: 240,
      // width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text((widget.emis?[index]?.tenure ?? "0"), style: kw600Black16),
          2.verticalSpace,
          Text("Months", style: kw400Black14),
          2.verticalSpace,
          Text(
            "Rate @ ${widget.emis?[index]?.interestRate ?? 0}% pa",
            style: kw400Black14,
          ),
          2.verticalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36.h,
                width: double.infinity,
                alignment: Alignment.center,
                color: AppColors.primary,
                child: Text(
                  widget.emis?[index]!.emiAmount?.contains('AED') == true
                      ? ''
                      : "${CommonUtilities.AppCurrency} ${"${widget.emis?[index]!.emiAmount ?? ''} / month".replaceAll('AED', '')}",
                  style: kw400White12,
                ),
              ),
            ],
          ),
          2.verticalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 36.h,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7),
                  ),
                  color: AppColors.primary,
                ),
                child: Text(
                  widget.emis?[index]!.emiAmount?.contains('AED') == true
                      ? ''
                      : "${CommonUtilities.AppCurrency} ${widget.emis?[index]!.totalAmount ?? ''}",
                  style: kw400White12,
                ),
                // color: highlightGreenColor,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
