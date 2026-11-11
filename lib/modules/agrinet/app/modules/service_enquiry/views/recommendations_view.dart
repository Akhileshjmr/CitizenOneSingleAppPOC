import 'package:citizenone_app/modules/agrinet/app/modules/service_enquiry/views/widget/recommendation_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../controllers/service_enquiry_controller.dart';
import 'documents_view.dart';

class RecommendationsView extends GetView<ServiceEnquiryController> {
  const RecommendationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),
      appBar: AgAppbar(title: "Recommendations", showLogout: true),

      body: SafeArea(
        child: Column(
          children: [
            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F1ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Column(
                    children: [
                      // ================= HEADER =================
                      Row(
                        children: [
                          const Icon(Icons.people_alt_outlined),
                          const SizedBox(width: 8),
                          const Text(
                            "Recommendations",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: controller.addRecommendation,
                            child: const Icon(Icons.add, size: 26),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ================= LIST ITEMS =================
                      Obx(() {
                        final list = controller.recommendations;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return RecommendationItemWidget(index: index);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // ================= FIXED BOTTOM BUTTONS =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: AgButton(
                      title: "Previous",
                      isOutlined: true,
                      onTap: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AgButton(
                      title: "Next",
                      onTap: () => Get.to(() => const DocumentsView()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
