import 'package:get/get.dart';

import '../../../data/model/args/cart_arguments.dart';

class CgPaymentSuccessController extends GetxController {
  String Refference = '';
  final RxBool isLoading = true.obs;
  final count = 0.obs;
  late CgStatusArguments args;
  @override
  void onInit() {
    super.onInit();

    print("Success Track Order");

    isLoading(true);
    if (Get.arguments is CgStatusArguments) {
      args = Get.arguments;
      Refference = args.orderId ?? '';
    }
    if (Get.arguments is String) {
      if (Get.arguments != null) {
        Refference = Get.arguments as String;
        print('Referes$Refference');
      }
    }
    isLoading(false);
  }
}
