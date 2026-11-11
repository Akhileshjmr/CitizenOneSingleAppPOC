import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/category_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/product_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/purchase_service.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/product_view/controllers/product_view_variables.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/product_view/views/product_detail_view.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ProductViewController extends GetxController with ProductViewVariables {
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    await fetchArguments();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchArguments() async {
    dynamic arguments = Get.arguments;
    if (arguments != null) {
      productDetails = arguments;
      await getCategoryViewData(categoryName: productDetails?.key ?? '');
    }
  }

  void selectOption(int index) {
    selectedOptionIndex.value = index;
  }

  Future<void> getCategoryViewData({required String categoryName}) async {
    try {
      isLoading(true);
      categoryViewResponse = await PurchaseService().purchaseCategoryView(
        categoryName: categoryName,
      );
      if (categoryViewResponse != null) {
        bannerImageList.value =
            categoryViewResponse!.category!.imgSliders!
                .map(
                  (item) =>
                      '${APIService.baseUrl.substring(0, APIService.baseUrl.length - 1)}${item.imgAction?.imgUrl}',
                )
                .toList();
        productLists(categoryViewResponse!.category!.products!);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> onTapProductCard(Product product) async {
    try {
      isLoading(true);

      viewProductDetails.value = await PurchaseService().categoryProductView(
        productKey: product.key,
      );
      await PurchaseService().categoryProductCrossSalePrds(
        productKey: product.key,
      );
      await PurchaseService().categoryProductUpSalePrds(
        productKey: product.key,
      );
      if (viewProductDetails.value != null &&
          viewProductDetails.value!.product != null) {
        Get.to(() => ProductDetailView());
      } else {
        agSnackbar(title: "Error", msg: "Unable to fetch product details");
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> onTapFavoriteIcon(Product product) async {
    dynamic requestBody = {
      "comReq": {
        "filterVal": product.key,
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      },
    };
    product.isAddedInWish = !(product.isAddedInWish ?? false);
    await PurchaseService().addOrRemoveWishList(
      requestBody: requestBody,
      isAddWishList: product.isAddedInWish ?? false,
    );
    productLists.refresh();
  }

  Future<void> onTapFavoriteIconDetail(ProductDetails product) async {
    dynamic requestBody = {
      "comReq": {
        "filterVal": product.basicDet?.key,
        "reqSecureKey": UserPrefs.user?.userId ?? '',
      },
    };
    product.basicDet?.isAddedInWish =
        !(product.basicDet?.isAddedInWish ?? false);
    await PurchaseService().addOrRemoveWishList(
      requestBody: requestBody,
      isAddWishList: product.basicDet?.isAddedInWish ?? false,
    );
    viewProductDetails.refresh();
  }

  Future<void> proceedToBuy(ProductDetails product) async {
    try {
      isLoading(true);
      final response = await PurchaseService().buyNowProducts(
        productKey: product.basicDet?.key ?? '',
        vendorId: product.basicDet?.vendor?.key ?? '',
      );
      if (response != null) {
        Get.toNamed(
          Routes.PAYMENT_TYPE,
          arguments: product.basicDet?.salePrice,
        );
      }

      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }
}
