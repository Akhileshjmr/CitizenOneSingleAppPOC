import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_dropdown_option.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/ui/ag_check_icon.dart';
import '../../../../components/ui/ag_textfield.dart';
import '../../controllers/service_enquiry_controller.dart';

class RecommendationItemWidget extends StatelessWidget {
  final int index;

  const RecommendationItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceEnquiryController>();
    final item = controller.recommendations[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          /// CATEGORY
          AgDropDownOption(
            name: "cat_$index",
            label: "Category",
            items: controller.categoryOptions,
            value: item.category, // FIXED
            hintText: "Select",
            onChanged: (opt) async {
              item.category = opt;
              item.product = null;
              item.productOptions.clear();

              if (opt != null) {
                await controller.searchCategoryForRecommendation(
                  opt.id.toString(),
                  index,
                );
              }

              controller.recommendations.refresh();
            },
          ),

          const SizedBox(height: 16),

          /// PRODUCT
          AgDropDownOption(
            name: "prod_$index",
            label: "Product/Service",
            items: item.productOptions,
            value: item.product, // FIXED
            hintText: "Select",
            onChanged: (opt) {
              item.product = opt;
              controller.recommendations.refresh();
            },
          ),

          const SizedBox(height: 16),

          /// COMMENTS
          AgTextField(
            name: "comments_$index",
            label: "Comments",
            maxLines: 2,
            initialValue: item.comments,
            onChanged: (v) => item.comments = v ?? "",
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// ✔ SAVE CHECK BUTTON
              AgCheckIcon(
                onSave: () async {
                  // validation
                  if (item.category == null) {
                    agSnackbar(title: "Alert", msg: "Select Category");
                    return false;
                  }
                  if (item.product == null) {
                    agSnackbar(title: "Alert", msg: "Select Product/Service");
                    return false;
                  }

                  return true;
                },
              ),

              const SizedBox(width: 20),

              IconButton(
                onPressed: () => controller.deleteRecommendation(index),
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 26,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
