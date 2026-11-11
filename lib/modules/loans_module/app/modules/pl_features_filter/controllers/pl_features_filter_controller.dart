import 'package:get/get.dart';

import '../../../data/model/loan/PersonalLoan/Features.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlFeaturesFilterController extends GetxController {
  /// List of provider list
  final RxList<Features> featuresList = <Features>[].obs;

  /// List of selected Bnaks ID
  final RxList<String> selectedFeaturesIds = <String>[].obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != 0) {
      selectedFeaturesIds(Get.arguments);
    }
    getFeaturesList();
  }

  /// get filter bank list
  Future<void> getFeaturesList() async {
    try {
      isLoading(true);
      featuresList(
        (await PersonalLoanService.getFilterFeaturesList()).cast<Features>(),
      );
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
