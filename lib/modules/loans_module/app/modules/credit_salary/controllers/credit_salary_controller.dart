import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/provider/CreditCardService.dart';
import '../../../routes/app_pages.dart';

class CreditSalaryController extends GetxController {
  final RxBool isLoading = false.obs;

  RxDouble salary = 1000.0.obs;

  TextEditingController salaryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != 0) {
      salaryController.text = '${Get.arguments}';
    }
  }

  Future<void> getUpdateCC(String remark, String action) async {
    try {
      isLoading(true);
      LimitFnaSubResp? resp = await CreditCardService.getApplyCC(
        '',
        '',
        '',
        '',
        remark,
        action,
      );
      if (resp?.chMessage?.isError == false) {
        await Get.toNamed(Routes.CREDIT_BENEFITS_OPTION);
      }
    } finally {
      isLoading(false);
    }
  }
}
