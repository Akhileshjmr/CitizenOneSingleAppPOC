import 'package:get/get.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/provider/CreditCardService.dart';
import '../../../routes/app_pages.dart';

class CreditThirdScreenController extends GetxController {
  final RxBool isLoading = true.obs;

  int amt = 0;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != 0) {
      amt = Get.arguments;
    }
  }

  Future<void> onContinue() async {
    getUpdateCC(LocalStore.firstName() ?? '', 'NAME_ENTERED');
  }

  Future<void> getUpdateCC(String remark, String action) async {
    isLoading(true);

    LimitFnaSubResp? resp = await CreditCardService.getApplyCC(
      '',
      '',
      '',
      '',
      remark,
      action,
    );
    isLoading(false);
    if (resp?.chMessage?.isError == false) {
      await Get.toNamed(Routes.CREDIT_SALARY, arguments: amt);
    }
  }
}
