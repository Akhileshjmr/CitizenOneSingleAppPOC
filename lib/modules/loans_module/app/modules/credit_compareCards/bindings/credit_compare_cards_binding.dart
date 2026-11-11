import 'package:get/get.dart';

import '../controllers/credit_compare_cards_controller.dart';

class CreditCompareCardsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCompareCardsController>(
      () => CreditCompareCardsController(),
    );
  }
}
