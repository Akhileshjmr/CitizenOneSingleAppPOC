import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CCStatusResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';


class CreditcardTrackController extends GetxController {
  //TODO: Implement CreditcardTrackController

  /// Api loading
  final RxBool isLoading = true.obs;

  final Rx<CcStatusResp?> ccStatus = CcStatusResp().obs;

  int amt = 0;

  String orderId = '';
  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments;
    print(orderId);
    getCardStatus(orderId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// get benefits list
  Future<void> getCardStatus(String id) async {
    isLoading(true);
    ccStatus(await CreditCardService.getCCStatus(id));
    isLoading(false);
  }
}
