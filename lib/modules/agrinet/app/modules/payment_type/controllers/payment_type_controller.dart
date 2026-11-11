import 'package:citizenone_app/modules/agrinet/app/utils/ag_assets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentTypeController extends GetxController {
  List paymentOptions = [
    {'name': 'Online', 'icon': AgAssets.onlinePayment},
    {'name': 'Offline', 'icon': AgAssets.offlinePayment},
    {'name': 'Loan', 'icon': AgAssets.loanPayment},
  ];
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController ccvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController transIdController = TextEditingController();
  RxBool isSaveMyCardActive = false.obs;
  RxBool isLoading = false.obs;
  RxString price = '0'.obs;
  @override
  void onInit() {
    super.onInit();
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      price.value = arguments.toString();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
