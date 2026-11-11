import 'package:get/get.dart';

import '../controllers/borrow_amt_controller.dart';

class BorrowAmtBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BorrowAmtController>(
      () => BorrowAmtController(),
    );
  }
}
