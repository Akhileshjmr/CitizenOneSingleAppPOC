import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/purchase_service.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/purchase/controllers/purchase_variables.dart';
import 'package:get/get.dart';

class PurchaseController extends GetxController with PurchaseVariables {
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    await getPurchaseData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getPurchaseData() async {
    try {
      isLoading(true);
      PurchaseMain? response = await PurchaseService().purchaseHomeDataApi();
      if (response != null) {
        bannerImageList.value =
            response.imgSliders!
                .map(
                  (item) =>
                      '${APIService.baseUrl.substring(0, APIService.baseUrl.length - 1)}${item.imgAction?.imgUrl}',
                )
                .toList();
        categoryList.value = response.categories!.map((item) => item).toList();
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

}
