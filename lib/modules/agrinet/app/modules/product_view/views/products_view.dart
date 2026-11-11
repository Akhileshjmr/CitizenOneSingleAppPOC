import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_carousel_slider.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/category_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/product_view/views/product_card.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_view_controller.dart';

class ProductView extends GetView<ProductViewController> {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kF9F9F9,
      appBar: AgAppbar(title: 'Products'),
      body: _body(context),
    );
  }

  Widget _body(context) => Padding(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView(
      child: Obx(
        () =>
            controller.isLoading.value
                ? Center(child: AgLoader())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bannerWidget(),
                    _titleWidget(title: 'Sub Categories'),
                    _subCategoryWidget(),
                    _titleWidget(title: 'Products'),
                    const SizedBox(height: 10),
                    _productsGrid(),
                  ],
                ),
      ),
    ),
  );

  Widget _bannerWidget() =>
      AgCarouselSlider(imageList: controller.bannerImageList);

  Widget _subCategoryWidget() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: Column(
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height * 0.15,
          child: Image.network(
            '${APIService.baseUrl.substring(0, APIService.baseUrl.length - 1)}${controller.productDetails?.imgUrl!}',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                color: AgColors.kFA7927,
                child: Text(
                  controller.productDetails!.name!
                      .substring(0, 1)
                      .toUpperCase(),
                  style: kw500White20.copyWith(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            controller.productDetails!.name!,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  Widget _titleWidget({required title}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(title, style: TextStyle(color: AgColors.buttonColor)),
  );

  Widget _productsGrid() => Container(
    color: AgColors.kWhite,
    child: Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: controller.productLists.length,
        itemBuilder: (context, index) {
          Product product = controller.productLists[index];
          // print(product);
          return ProductCard(
            onCardTap: () async {
              await controller.onTapProductCard(product);
            },
            isFavorite: product.isAddedInWish ?? false,
            onFavoriteTap: () => controller.onTapFavoriteIcon(product),
            imageUrl: APIService.baseUrl + product.imgUrl!,
            name: product.name!,
            price: product.salePrice!,
            oldPrice: product.retPrice ?? 'NA',
            subtitle: 'Exchange Offer & more',
          );
        },
      ),
    ),
  );
}
