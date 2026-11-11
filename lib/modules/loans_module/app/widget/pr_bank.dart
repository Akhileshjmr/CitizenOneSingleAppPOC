import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../components/ui/image_hendle.dart';
import '../data/local/store/local_store.dart';
import '../data/model/loan/PreApprove/preApproveBankList/GdbChBank.dart';
import '../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../utils/app_colors.dart';

typedef SelectEmi = Function();

class PrBank extends StatefulWidget {
  PrBank({
    required this.bank,
    required this.emis,
    required this.onClick,
    Key? key,
  }) : super(key: key);
  final GdbChBank? bank;
  final List<EmiInfoDetails?>? emis;
  final Function(EmiInfoDetails? value, GdbChBank? bank) onClick;
  final RxBool isExpanded = false.obs;

  @override
  State<PrBank> createState() => _PrBankState();
}

class _PrBankState extends State<PrBank> {
  bool isSelected = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    child: Obx(
      () => GestureDetector(
        onTap: () {
          widget.isExpanded.toggle();
          LocalStore.BankId(widget.bank?.productKey.toString() ?? '');
        },
        child: Card(
          child: Column(
            children: [
              Row(
                children: [
                  8.horizontalSpace,
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    width: 64,
                    height: 64,
                    child: ImageHandle(
                      url:
                          (widget.bank?.gdbChMediaAction?.urlAction?.url ?? '')
                              .addBaseUrl,
                      size: Size(0.25.sw, 80.h),
                      radius: 6,
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.bank?.name ?? "", style: kw400Black14),
                          4.verticalSpace,
                          Text(
                            'ROI starts from: ${widget.emis?[0]?.interestRate ?? ''}% pa',
                            style: kw400Black12,
                          ),
                          2.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 40,
                    child:
                        widget.isExpanded()
                            ? const Icon(Icons.keyboard_arrow_up_outlined)
                            : const Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                ],
              ),
              widget.isExpanded()
                  ? generateEmiLayout()
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget generateEmiLayout() => Container(
    height: 175,
    child: ListView.builder(
      itemCount: widget.emis?.length ?? 0,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) => getEMICell(index),
    ),
  );

  Widget getEMICell(int index) => InkWell(
    onTap:
        () => {
          widget.onClick.call(widget.emis?[index], widget.bank),
          setState(() {
            selectedIndex = index;
            if (selectedIndex == index) {
              isSelected = true;
            } else {
              isSelected = false;
            }
          }),
        },
    child: Container(
      width: 148.w,
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(
          color:
              (isSelected == true && selectedIndex == index)
                  ? AppColors.primary
                  : AppColors.grey,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.emis?[index]?.tenure ?? '0', style: kw400Black14),
          2.verticalSpace,
          const Text('Months', style: kw400Black14),
          2.verticalSpace,
          Text(
            "Rate @ ${widget.emis?[index]?.interestRate ?? 0}% pa",
            style: kw400Black14,
          ),
          2.verticalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 36.h,
                width: double.infinity,
                alignment: Alignment.center,
                color: AppColors.primary,
                child: Text(
                  '${widget.emis?[index]!.emiAmount ?? ''}/month',
                  style: kw500White14,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          2.verticalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
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
                  "Total ${widget.emis?[index]!.totalAmount ?? ''}",
                  style: kw400White12,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
