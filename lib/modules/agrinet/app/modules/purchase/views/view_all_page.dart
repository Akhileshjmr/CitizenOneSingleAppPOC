import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/purchase/purchase_main.dart';
import 'package:citizenone_app/modules/agrinet/app/data/remote/api_service/init_api_service.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/purchase_controller.dart';

class ViewAllPage extends GetView<PurchaseController> {
  const ViewAllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kEFFFF2,
      appBar: AgAppbar(title: 'Category View'),
      body: Column(
        children: [SizedBox(height: 20), Expanded(child: _categoryWidget())],
      ),
    );
  }

  Widget _categoryWidget() {
    if (controller.categoryList.isEmpty) {
      return const Center(
        child: Text(
          "No categories available",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 8,
        childAspectRatio: 1.27,
      ),
      itemCount: controller.categoryList.length,
      itemBuilder: (context, index) {
        Category category = controller.categoryList[index];

        return InkWell(
          onTap: () {
            Get.toNamed(Routes.PRODUCT_VIEW, arguments: category);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    '${APIService.baseUrl}${category.imgUrl!}',
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      category.name!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
