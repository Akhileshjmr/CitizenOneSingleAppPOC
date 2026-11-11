import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';

class CreditCardDeatilsController extends GetxController {
  //TODO: Implement CreditCardDeatilsController

  /// List of home banks
  final RxList<CreditCardsList> homeCardList = <CreditCardsList>[].obs;

  /// Api loading
  final RxBool isLoading = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    homeCardList.add(Get.arguments);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
