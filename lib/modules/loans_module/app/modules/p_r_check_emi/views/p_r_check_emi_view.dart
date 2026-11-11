import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/loan/PreApprove/preApproveBankList/GdbChBank.dart';
import '../../../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../../../data/model/loan/bank_list/GdbShopEmiRespList.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/pr_bank.dart';
import '../controllers/p_r_check_emi_controller.dart';

class PRCheckEmiView extends GetView<PRCheckEmiController> {
  const PRCheckEmiView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Check EMI'),
    bottomNavigationBar: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AgButton(
          title: 'Submit',
          onTap: () {
            if (controller.emiMap.isNotEmpty) {
              controller.onSubmitBankEMi(controller.emiMap);
            } else {
              appSnackbar(message: 'Please select emi.');
            }
          },
        ),
      ],
    ).paddingOnly(right: 20.w, left: 20.w, bottom: 20.h),
    body: Obx(
      () => Visibility(
        visible: controller.isLoading.isFalse,
        replacement: const Center(child: AgLoader()),
        child:
            ((controller.arrList().length ?? 0) > 0)
                ? ListView.builder(
                  itemCount: controller.arrList().length,
                  itemBuilder: (BuildContext context, int index) {
                    final GdbShopEmiRespList? bank =
                        controller.arrList()[index];
                    return PrBank(
                      bank: bank?.gdbChBank,
                      emis: bank?.emiInfoDetails,
                      onClick: (EmiInfoDetails? value, GdbChBank? bank_list) {
                        controller.bankname = bank_list?.name ?? '';
                        controller.bank_id = bank_list?.key ?? '';
                        controller.product_id = bank_list?.productKey ?? '';
                        controller.emiMap = <String, dynamic>{
                          "reqSecureKey":
                              UserProvider.currentUser?.addiParams?[0] ?? '',
                          "filterVal":
                              '${(controller.args.filterval == '/vehicleloan') ? 'CAR_LOAN' : 'HOUSE_LOAN'}',
                          "limit": {
                            'selectedRoi': value?.interestRate.toString(),
                            "limitVal": controller.args.montlyInc,
                            "bankProductId": bank_list?.productKey,
                            "bank": {
                              "name": bank_list?.name,
                              "key": bank_list?.key,
                            },
                          },
                          "addiParams": [
                            bank_list?.productKey,
                            '${(controller.args.filterval == '/vehicleloan') ? 'CAR_LOAN' : 'HOUSE_LOAN'}',
                          ],
                        };
                        print(controller.emiMap.toString());
                      },
                    );
                  },
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 1.sw,
                      child: Text(
                        'No Bank Found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black.withOpacity(0.5),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    ),
  );
}
