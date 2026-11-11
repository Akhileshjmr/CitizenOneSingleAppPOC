import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_dropdown_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_environment.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/service_enquiry_controller.dart';

class ServiceEnquiryView extends GetView<ServiceEnquiryController> {
  const ServiceEnquiryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),

      // DYNAMIC TITLE (Service Request / Transport Enquiry / Warehouse Enquiry)
      appBar: AgAppbar(title: controller.moduleTitle, showLogout: true),

      body: Obx(() {
        return SafeArea(
          child:
              controller.isLoading.value
                  ? const Center(child: AgLoader())
                  : Column(
                    children: [
                      // ==================== SCROLLABLE CONTENT ====================
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F1ED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ---------- FULL WIDTH BANNER ----------
                                controller.bannerImage != null
                                    ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.asset(
                                        controller.bannerImage!,
                                        fit: BoxFit.cover,
                                        height: 160,
                                        package: AppEnvironment.packageName,
                                      ),
                                    )
                                    : const SizedBox.shrink(),

                                // ---------- FORM ----------
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 4),

                                      // RAISED BY
                                      AgDropDownOption(
                                        name: "raised_by",
                                        label: "Raised By",
                                        items: controller.raisedByList,
                                        value: controller.raisedBy.value,
                                        hintText: "Select",
                                        onChanged: (v) {
                                          controller.raisedBy(v);

                                          controller.getEntityId();
                                        },
                                      ),

                                      const SizedBox(height: 16),

                                      // ENTITY
                                      controller.entityList.isNotEmpty
                                          ? Column(
                                            children: [
                                              AgDropDownOption(
                                                name: "entity_id",
                                                label: "Entity ID",
                                                items: controller.entityList,
                                                value:
                                                    controller
                                                        .selectedEntity
                                                        .value,
                                                hintText: "Select",
                                                onChanged: (v) {
                                                  controller.selectedEntity(v);
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                            ],
                                          )
                                          : const SizedBox(),

                                      // SUBJECT
                                      AgTextField(
                                        name: "subject",
                                        label: "Subject",
                                        controller: controller.subjectCtrl,
                                      ),

                                      const SizedBox(height: 16),

                                      // PLAN
                                      AgDropDownOption(
                                        name: "plan_id",
                                        label: "Farming Plan ID",
                                        items: controller.planList,
                                        value: controller.selectedPlan.value,
                                        hintText: "Select",
                                        onChanged: (v) {
                                          controller.selectedPlan(v);
                                        },
                                      ),

                                      const SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // ==================== FIXED NEXT BUTTON ====================
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: AgButton(
                          title: "Next",
                          onTap: controller.onReqNext,
                        ),
                      ),
                    ],
                  ),
        );
      }),
    );
  }
}
