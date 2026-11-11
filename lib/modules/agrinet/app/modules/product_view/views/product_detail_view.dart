import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/product_view_response.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/product_view/controllers/product_view_controller.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailView extends GetView<ProductViewController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AgAppbar(title: 'Product View'),
      body: _body(),
    );
  }

  Widget _body() => Obx(() {
    controller.selectedProductDetails;
    List<Option> options =
        controller.viewProductDetails.value?.product?.options ?? [];

    if (controller.isLoading.value) {
      return const Center(child: AgLoader());
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Image.network(
                    '${APIService.baseUrl}${controller.viewProductDetails.value?.product?.basicDet?.imgUrl}',
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.center,
                        color: AgColors.kFA7927,
                        child: Text(
                          controller
                                  .viewProductDetails
                                  .value
                                  ?.product
                                  ?.basicDet
                                  ?.name!
                                  .substring(0, 1)
                                  .toUpperCase() ??
                              '',
                          style: kw500White20.copyWith(
                            fontSize: 70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      );
                    },
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  controller
                          .viewProductDetails
                          .value
                          ?.product
                          ?.basicDet
                          ?.name ??
                      '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${controller.viewProductDetails.value?.product?.basicDet?.salePrice}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      '@${controller.viewProductDetails.value?.product?.basicDet?.name}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionIcon(icon: Icons.share, label: 'Share'),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    _actionIcon(icon: Icons.compare, label: 'Similar'),
                    Text(
                      '|',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.onTapFavoriteIconDetail(
                          controller.viewProductDetails.value!.product!,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            controller
                                        .viewProductDetails
                                        .value
                                        ?.product
                                        ?.basicDet
                                        ?.isAddedInWish ==
                                    true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 22,
                            color:
                                controller
                                            .viewProductDetails
                                            .value
                                            ?.product
                                            ?.basicDet
                                            ?.isAddedInWish ==
                                        true
                                    ? Colors.red
                                    : Colors.grey[700],
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Wishlist',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),

                const SizedBox(height: 24),
                const Text(
                  'Product Options',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    final option = options[index];
                    final isSelected =
                        controller.selectedOptionIndex.value == index;

                    return GestureDetector(
                      onTap: () => controller.selectOption(index),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF47642A)
                                    : Colors.grey.shade300,
                            width: 1.3,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AgColors.k4467C7,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                option.name!.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  option.values?.first ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  controller
                          .viewProductDetails
                          .value
                          ?.product
                          ?.basicDet
                          ?.desc ??
                      '',
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),

        AgButton(
          onTap:
              () => controller.proceedToBuy(
                controller.viewProductDetails.value!.product!,
              ),
          backgroundColor: AgColors.FF4500,
          title: 'Proceed',
          width: Get.width * 0.5,
        ),
      ],
    );
  });

  Widget _actionIcon({required icon, required label}) {
    return Row(
      children: [
        Icon(icon, size: 22, color: Colors.grey[700]),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
