import 'package:get/get.dart';

import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/provider/credit_card/credit_card_service.dart';
import '../../../routes/app_pages.dart';

class CreditGetStartController extends GetxController {
  final RxBool isLoading = true.obs;

  @override
  Future<void> onInit() async {
    await getUpdateCC('Shown interest on credit card.', 'INTERESTED');
    super.onInit();
  }

  Future<void> onContinue() async {
    await Get.toNamed(Routes.CREDIT_BEFORE_START);
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
    if (resp?.chMessage?.isError == false) {}
  }
}
