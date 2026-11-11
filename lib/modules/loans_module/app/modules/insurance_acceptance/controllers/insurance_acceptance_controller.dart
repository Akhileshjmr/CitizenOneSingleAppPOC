import 'package:get/get.dart';

import '../../../data/model/args/insurance_detail_args.dart';
import '../../../data/model/insurance/PrdInsurList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/order_service.dart';
import '../../../utils/static_value_constant.dart';

class InsuranceAcceptanceController extends GetxController {
  final Rx<PrdInsurList> bankInsurence = PrdInsurList().obs;
  RxBool isLoading = true.obs;
  late AutoInsurencDetailArgs args;

  @override
  void onInit() {
    if (Get.arguments is AutoInsurencDetailArgs) {
      args = Get.arguments;
      bankInsurence(args.insurList);
    }
    super.onInit();
  }

  Future<void> acceptInsurence() async {
    try {
      isLoading(true);
      Map<String, dynamic> req = {
        "prodCode": "",
        "orderId": args.leadId,
        "custName": StaticValueConstant.user_Name,
        "requestId": args.requestid,
        "productPrice": args.loanamt,
        "insurerName": bankInsurence.value.insurerName,
        "premiumAmt": bankInsurence.value.premiumAmt,
        "tax": bankInsurence.value.tax,
        "totalPremium": bankInsurence.value.totalPremiumAmt,
        "idv": bankInsurence.value.idv,
        'mobileNo': StaticValueConstant.PhoneNumber,
      };
      final resp = await OrderService.getInsurenceDetail(
        ApiEndPoints.autoAcceptenceInsurence,
        req,
      );
      Get.back(result: true);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
