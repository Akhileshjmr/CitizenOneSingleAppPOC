import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/category_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/product_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';

import '../../components/ui/ag_snackbar.dart';

class PurchaseService {
  dynamic userId = UserPrefs.user?.userId ?? '';
  Future<PurchaseMain?> purchaseHomeDataApi() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.purchaseHome,
        data: {
          "comReq": {"reqSecureKey": userId},
        },
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return PurchaseMain.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  Future<CategoryViewResponse?> purchaseCategoryView({
    required categoryName,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.purchaseCategoryView,
        data: {
          "comReq": {"filterVal": categoryName, "reqSecureKey": userId},
        },
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return CategoryViewResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  Future<ProductViewResponse?> categoryProductView({
    required productKey,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.categoryProductView,
        data: {
          "comReq": {"filterVal": productKey, "reqSecureKey": userId},
        },
      );
      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      } else if (response.data != null && response.statusCode == 200) {
        return ProductViewResponse.fromJson(response.data!);
      } else {
        agSnackbar(title: "Error", msg: "Invalid server response");
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong");
      return null;
    }
    return null;
  }

  Future<void> categoryProductCrossSalePrds({required productKey}) async {
    try {
      await APIService.post(
        path: ApiEndPoints.crossSaleProds,
        data: {
          "comReq": {"filterVal": productKey, "reqSecureKey": userId},
        },
      );
    } catch (e) {
      Exception('Failed to fetch cross sale products');
    }
  }

  Future<void> categoryProductUpSalePrds({required productKey}) async {
    try {
      await APIService.post(
        path: ApiEndPoints.upSaleProds,
        data: {
          "comReq": {"filterVal": productKey, "reqSecureKey": userId},
        },
      );
    } catch (e) {
      Exception('Failed to fetch up sale products');
    }
  }

  Future<void> addOrRemoveWishList({
    required requestBody,
    required bool isAddWishList,
  }) async {
    try {
      await APIService.post(
        path:
            isAddWishList
                ? ApiEndPoints.addWishList
                : ApiEndPoints.removeWishList,
        data: requestBody,
      );
    } catch (e) {
      Exception('Failed to update wishlist');
    }
  }

  Future<dynamic> buyNowProducts({
    required productKey,
    required vendorId,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyNowPrds,
        data: {
          "comReq": {
            "addiParams": [vendorId],
            "filterVal": productKey,
            "reqSecureKey": "447349",
          },
        },
      );
      if (response != null &&
          response.data != null &&
          response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('ss');
    }
  }

  Future<void> payOnlineProducts({
    required productKey,
    required vendorId,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.buyNowPrds,
        data: {
          "comReq": {
            "addiParams": [vendorId],
            "filterVal": productKey,
            "reqSecureKey": "447349",
          },
        },
      );
      print(response);
    } catch (e) {
      print('ss');
    }
  }
}
