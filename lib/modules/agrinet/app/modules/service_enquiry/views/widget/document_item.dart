import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../components/ui/ag_check_icon.dart';
import '../../../../components/ui/ag_textfield.dart';
import '../../controllers/service_enquiry_controller.dart';

class DocumentItemWidget extends StatelessWidget {
  final int index;

  const DocumentItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceEnquiryController>();
    final doc = controller.documents[index];

    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F1ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// UPLOAD PROGRESS BAR
            doc.isUploading.value
                ? LinearProgressIndicator(
                  value: doc.progress.value == 0 ? null : doc.progress.value,
                  minHeight: 5,
                  backgroundColor: Colors.black12,
                  color: Colors.green,
                )
                : const SizedBox(height: 5),

            /// IMAGE PICKER
            GestureDetector(
              onTap: () => controller.pickDocumentFile(index),
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child:
                    doc.preview != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(doc.preview!, fit: BoxFit.cover),
                        )
                        : const Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 6),

            /// NAME FIELD
            AgTextField(
              name: "doc_$index",
              hintText: "Document Name",
              controller: doc.textController,
              onChanged: (v) => doc.name = v ?? "",
            ),

            const SizedBox(height: 4),

            /// SAVE BUTTON (REUSABLE COMPONENT)
            Align(
              alignment: Alignment.center,
              child: AgCheckIcon(
                enabled: doc.filePath != null,
                onSave: () async {
                  // if (doc.filePath == null || doc.filePath!.isEmpty) {
                  //   agSnackbar(
                  //     title: "Alert",
                  //     msg: "Please select an image before uploading.",
                  //   );
                  //   return false; // check stays grey
                  // }

                  await controller.saveDocument(index);
                  return doc.isSaved.value; // make green only on success
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
