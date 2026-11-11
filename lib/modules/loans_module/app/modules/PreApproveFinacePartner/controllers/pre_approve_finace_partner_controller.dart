import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/preApproveBankList/PreBankListResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/preApproveLoanService.dart';



class PreApproveFinacePartnerController extends GetxController {
  //TODO: Implement PreApproveFinacePartnerController

  Rx<PreBankListResp> bankList = PreBankListResp().obs;

  RxBool isLoading = false.obs;

  final count = 0.obs;

  String filterval = '';
  String args = '';

  @override
  void onInit() {
    filterval = Get.arguments[0];
    args = Get.arguments[1];
    fetchBankList(filterval);
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

  Future<void> fetchBankList(String filter) async {
    isLoading(true);
    try {
      PreBankListResp? resp = await preApproveLoanService.getPreApproveFinance(filter);
      bankList(resp);
    } finally {
      isLoading(false);
    }
  }
}
