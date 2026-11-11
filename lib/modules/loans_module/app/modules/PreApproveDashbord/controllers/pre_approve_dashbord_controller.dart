import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/constants/app_assets.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/PreAproveHome/PreApproveHomeResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/preApproveLoanService.dart';

class PreApproveDashbordController extends GetxController {
  //TODO: Implement PreApproveDashbordController
  Rx<PreApproveHomeResp> categoriesData = PreApproveHomeResp().obs;

  RxBool isLoading = false.obs;
  String args = '';

  final count = 0.obs;
  List<String> arrList = ["Car Loan", "Personal Loan", "Others",];
  List<String> imageList = [AppAssets.carLoan, AppAssets.personalLoan, AppAssets.otherLoan];
  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchProducts();
    args = Get.arguments;
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

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      PreApproveHomeResp? resp = await preApproveLoanService.getPreApproveHome();
      categoriesData(resp);
    } finally {
      isLoading(false);
    }
  }
}
