import 'package:get/get.dart';

import '../../../data/model/args/insurance_detail_args.dart';
import '../../../data/model/insurance/AutoProdInsuranceResponse.dart';
import '../../../data/model/insurance/PrdInsurList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/order_service.dart';
import '../../../utils/static_value_constant.dart';

class InsuranceDetailController extends GetxController {
  RxBool isLoading = true.obs;
  final RxList<PrdInsurList> bankInsurence = <PrdInsurList>[].obs;
  final Rx<AutoProdInsuranceResponse?> insurenceDetails =
      AutoProdInsuranceResponse().obs;
  late InsurencDetailArgs args;

  final count = 0.obs;

  @override
  Future<void> onInit() async {
    if (Get.arguments is InsurencDetailArgs) {
      args = Get.arguments;
      if (args.catType == 'AUTO') {
        await getInsurance();
      } else {
        await fetchRealInsurence();
      }
    }
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

  Future<void> fetchRealInsurence() async {
    try {
      isLoading(true);
      Map<String, dynamic> req = {
        "leadId": args.leadId ?? '',
        "orderNumber": args.orderKey ?? '',
        "custName": StaticValueConstant.user_Name,
        "requestId": "",
        "url": "",
        "loanAmount": args.loanamt ?? '',
        'mobileNo': StaticValueConstant.PhoneNumber,
      };
      AutoProdInsuranceResponse? resp = await OrderService.getInsurenceDetail(
        ApiEndPoints.acceptInsurence,
        req,
      );
      bankInsurence(resp?.prdInsurList);
      insurenceDetails(resp);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getInsurance() async {
    Map<String, dynamic> req = {
      "prodCode": "",
      "orderId": args.leadId,
      "custName": StaticValueConstant.user_Name,
      "requestId": '',
      "url": "",
      'productPrice': args.loanamt,
      'mobileNo': StaticValueConstant.PhoneNumber,
    };
    isLoading(true);
    AutoProdInsuranceResponse? resp = await OrderService.getInsurance(
      ApiEndPoints.autoProdInsurance,
      req,
    );
    insurenceDetails(resp);
    bankInsurence(resp?.prdInsurList);
    isLoading(false);
  }
}
