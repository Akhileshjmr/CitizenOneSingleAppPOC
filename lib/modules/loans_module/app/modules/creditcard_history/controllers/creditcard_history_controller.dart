import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardReqList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';

class CreditcardHistoryController extends GetxController {
  //TODO: Implement CreditcardHistoryController

  /// Api loading
  final RxBool isLoading = true.obs;

  /// dropdown List
  final RxList<CreditCardReqList?> cardsList = <CreditCardReqList?>[].obs;

  final count = 0.obs;

  ///
  RxBool isFromOrderScreen = false.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        isFromOrderScreen(Get.arguments as bool);
      }
    }
    getCards();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// get apply cards list
  Future<void> getCards() async {
    isLoading(true);
    cardsList(await CreditCardService.getCardsHistory());
    isLoading(false);
  }
}
