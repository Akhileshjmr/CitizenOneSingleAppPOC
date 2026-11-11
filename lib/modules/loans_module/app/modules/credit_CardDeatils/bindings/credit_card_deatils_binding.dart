import 'package:get/get.dart';

import '../controllers/credit_card_deatils_controller.dart';

class CreditCardDeatilsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditCardDeatilsController>(
      () => CreditCardDeatilsController(),
    );
  }
}
