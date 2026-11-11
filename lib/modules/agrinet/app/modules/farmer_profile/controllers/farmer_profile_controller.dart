import 'package:get/get.dart';

import '../../../data/model/user/main_response.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/api_service/init_api_service.dart';

class FarmerProfileController extends GetxController {
  String farmerId = "";
  String status = "";
  final RxInt docId = 0.obs;

  RxBool isLoading = false.obs;
  final Rx<MainResponse> farmer = MainResponse().obs;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null) {
      farmerId = args["farmerId"];
      docId.value = args["docId"];
      status = args["status"];
    }
    readFarmerData();
    super.onInit();
  }

  Future<void> readFarmerData() async {
    try {
      isLoading(true);

      final response = await APIService.post(
        path: ApiEndPoints.farmerOnBoardSearch,
        data: {
          "farmId": farmerId,
          "generalDetails": {"name": farmerId},
        },
      );

      farmer(MainResponse.fromJson(response?.data ?? {}));
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
