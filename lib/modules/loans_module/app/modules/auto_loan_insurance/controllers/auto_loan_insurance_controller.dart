import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/model/loan/auto_loan/Order.dart';
import '../../../data/model/loan/auto_loan/VehicleData.dart';
import '../../../utils/static_value_constant.dart';

class AutoLoanInsuranceController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController mobileNoC = TextEditingController();

  String vehicleCondition = "";
  String vehiclePrice = "";
  String vehicleType = "";
  String vehicleDesc = "";
  String vehicleMakingYear = "";
  String vehicleColor = "";
  String vehicleName = "";
  String manufacturerType = "";

  String orderKey = '';
  String leadID = '';
  String amount = '';
  String categoryType = '';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    nameC.text = StaticValueConstant.user_Name;
    mobileNoC.text = StaticValueConstant.PhoneNumber;

    if (Get.arguments is Order) {
      Order argms = Get.arguments as Order;
      VehicleData arg = argms.vehicleData ?? VehicleData();
      vehicleCondition = arg.vehicleCondition ?? "";
      vehiclePrice = (arg.vehiclePrice ?? 0).toString();
      ;
      vehicleType = arg.vehicleType ?? "";
      ;
      vehicleDesc = arg.vehicleDesc ?? "";
      ;
      vehicleMakingYear = (arg.vehicleMakingYear ?? 0).toString();
      vehicleColor = arg.vehicleColor ?? "";
      vehicleName = arg.vehicleName ?? "";
      manufacturerType = arg.manufacturerType ?? "";
      orderKey = (argms.orderId ?? 0).toString();
      categoryType = argms.categoryType ?? "";
      leadID = (argms.leadId ?? 0).toString();
      amount = (arg.vehiclePrice ?? 0).toString();
    }
  }
}
