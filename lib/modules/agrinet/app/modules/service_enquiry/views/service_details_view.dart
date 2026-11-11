import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_date_field.dart';
import '../../../components/ui/ag_dropdown_option.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/service_enquiry_controller.dart';
import 'recommendations_view.dart';

class ServiceDetailsView extends GetView<ServiceEnquiryController> {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),
      appBar: AgAppbar(title: "Service Details", showLogout: true),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: AgLoader());
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ------------------- MAIN CARD -------------------
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F1ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),

                  child: Column(
                    children: [
                      // ------------------- SERVICE TYPE -------------------
                      Obx(
                        () => AgDropDownOption(
                          name: "service_type",
                          label: "Service Type",
                          items: controller.serviceTypeList,
                          value: controller.selectedServiceType.value,
                          hintText: "Select",
                          onChanged: (v) {
                            controller.selectedServiceType(v);

                            if (v != null) {
                              controller.selectedRelatedTo.value = null;
                              controller.searchServiceType(v);
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ------------------- RELATED TO / SUB CATEGORY -------------------
                      Obx(
                        () => AgDropDownOption(
                          name: "related_to",
                          label: "Related To",
                          items: controller.relatedToList,
                          value: controller.selectedRelatedTo.value,
                          hintText: "Select",
                          onChanged: (v) {
                            controller.selectedRelatedTo(v);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ------------------- INQUIRY DETAILS -------------------
                      AgTextField(
                        name: "inquiry",
                        label: "Inquiry Details",
                        controller: controller.inquiryCtrl,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 16),

                      // ------------------- DUE DATE -------------------
                      AgDateField(
                        name: "due_date",
                        label: "Due Date",
                        rxDate: controller.rxDueDate,
                        firstDate: DateTime.now(),
                      ),

                      const SizedBox(height: 16),

                      // ------------------- ESTIMATED COST -------------------
                      AgTextField(
                        name: "cost",
                        label: "Estimated Cost",
                        controller: controller.costCtrl,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 20),

                      // ------------------- REVIEW REQUIRED -------------------
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Review Required",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ),
                      Obx(() {
                        return Row(
                          children: [
                            ...controller.reviewOptions.map(
                              (opt) => Row(
                                children: [
                                  Radio<bool>(
                                    value: opt["value"] as bool,
                                    groupValue: controller.reviewRequired.value,
                                    onChanged:
                                        (v) =>
                                            controller.reviewRequired.value =
                                                v!,
                                  ),
                                  Text(opt["label"] as String),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 16),

                      // ------------------- COMMENTS -------------------
                      AgTextField(
                        name: "comments",
                        label: "Comments",
                        maxLines: 2,
                        controller: controller.commentCtrl,
                      ),
                    ],
                  ),
                ),

                // ------------------- BUTTONS -------------------
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AgButton(
                          isOutlined: true,
                          title: "Previous",
                          onTap: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AgButton(
                          title: "Next",
                          onTap: () {
                            if (controller.validateServiceDetails()) {
                              Get.to(() => const RecommendationsView());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
