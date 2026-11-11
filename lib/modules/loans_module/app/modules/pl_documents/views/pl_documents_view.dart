import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/user_document_list.dart';
import '../controllers/pl_documents_controller.dart';

class PlDocumentsView extends GetView<PlDocumentsController> {
  const PlDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Documents List'),

      /// ✅ Bottom Button (hidden during loading)
      bottomNavigationBar: Obx(() {
        if (controller.isLoading.value) return const SizedBox();

        return SafeArea(
          child: AgButton(
            title: 'Continue',
            onTap: _onContinue,
          ).paddingOnly(right: 30.w, left: 30.w, bottom: 20.h),
        );
      }),

      /// ✅ Body with overlay loader
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemCount: controller.arrDocuments.length,
            itemBuilder: (context, index) {

              final doc = controller.arrDocuments[index];

              return UserDocumentList(
                index: index,
                doc: doc,
                onPressedUpload: handleUpload,
              );
            },
          ),
        ),
      ),
    );
  }

  /// ================= CONTINUE =================
  void _onContinue() async {
    if (!controller.validateMandatoryDocuments()) {
      return;
    }

    await Get.toNamed(Routes.PL_REVIEW_SUBMIT);
  }

  /// ================= UPLOAD =================
  void handleUpload(int index) {
    if (index >= controller.arrDocuments.length) return;

    final doc = controller.arrDocuments[index];

    Get.toNamed<dynamic>(
      Routes.PL_UPLOAD_DOCUMENTS,
      arguments: Documents(
        key: doc.key,
        document: doc.document,
        documentName: doc.documentName,
        originalDocName: doc.originalDocName,
        isAttachedInProcess: doc.isAttachedInProcess,
        isMandatory: doc.isMandatory,
        canDelete: doc.canDelete,
      ),
    )?.then((value) {
      if (value is bool && value) {
        controller.getDocuments();
      }
    });
  }

  /// ================= DELETE =================
  void handleDelete(int index) {
    if (index >= controller.arrDocuments.length) return;

    final doc = controller.arrDocuments[index];

    Get.toNamed<dynamic>(
      Routes.PL_UPLOAD_DOCUMENTS,
      arguments: Documents(
        LimitMode: controller.mode,
        key: doc.key,
        document: doc.document,
        documentName: doc.documentName,
        originalDocName: doc.originalDocName,
        isAttachedInProcess: doc.isAttachedInProcess,
        isMandatory: doc.isMandatory,
        canDelete: doc.canDelete,
      ),
    )?.then((value) {
      if (value is bool && value) {
        controller.getDocuments();
      }
    });
  }
}
