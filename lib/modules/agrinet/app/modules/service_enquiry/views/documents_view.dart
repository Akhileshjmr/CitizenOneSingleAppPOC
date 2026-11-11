import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/service_enquiry/views/widget/document_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../controllers/service_enquiry_controller.dart';

class DocumentsView extends GetView<ServiceEnquiryController> {
  const DocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),
      appBar: AgAppbar(title: "Document Upload", showLogout: true),

      body: Obx(() {
        return SafeArea(
          child:
              controller.isLoading.value
                  ? const Center(child: AgLoader())
                  : Column(
                    children: [
                      // ================= SCROLLABLE SECTION =================
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9F1ED),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ================= HEADER =================
                                Row(
                                  children: [
                                    const Icon(Icons.description_outlined),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Upload Documents",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),

                                    /// ADD BUTTON
                                    GestureDetector(
                                      onTap: controller.addDocument,
                                      child: const Icon(
                                        Icons.add_circle_outline,
                                        size: 26,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // ================= DOCUMENT GRID =================
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.documents.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        childAspectRatio: 0.66,
                                      ),
                                  itemBuilder: (context, index) {
                                    return DocumentItemWidget(index: index);
                                  },
                                ),
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
                                title: "Submit",
                                onTap: controller.submit,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        );
      }),
    );
  }
}
