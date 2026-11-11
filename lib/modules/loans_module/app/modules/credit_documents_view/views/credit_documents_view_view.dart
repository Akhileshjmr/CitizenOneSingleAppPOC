import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/Documents/views/UserDocumentList.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';

import '../controllers/credit_documents_view_controller.dart';

class CreditDocumentsViewView extends GetView<CreditDocumentsViewController> {
  const CreditDocumentsViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Document List'),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: AgButton(
        title: 'Continue',

        onTap: () async {
          final allMandatoryAttached = (controller.arrDocuments ?? [])
              .where((doc) => doc.isMandatory == true)
              .every(
                (doc) =>
                    (doc.isAttachedInProcess == true) ||
                    (doc.originalDocName?.isNotEmpty == true),
              );

          if (allMandatoryAttached) {
            await Get.toNamed(Routes.CREDIT_REVIEW_SCREEN);
          } else {
            appSnackbar(
              message: 'Please upload all the documents.',
              snackbarState: SnackbarState.warning,
            );
          }
        },
        // child: const Text('Continue'),
      ),
    ),
    body: Obx(
      () => ListView.builder(
        itemCount: (controller.arrDocuments?.length ?? 0),
        itemBuilder: (context, index) {
          String type =
              controller.arrDocuments?[index].documentName?.type ?? "";
          String docName =
              controller.arrDocuments?[index].originalDocName ?? "";
          bool isAttached =
              controller.arrDocuments?[index].isAttachedInProcess ?? false;
          return UserDocumentList(
            type,
            docName,
            index,
            isAttached,
            controller.arrDocuments?.value[index],
            (ind) {
              handleUpload(ind);
            },
            (ind) {
              handleDelete(ind);
            },
            (ind) {
              controller.DocumentsLink(
                controller.arrDocuments![ind].key.toString(),
              );
            },
          );
          // (type, docName, false);
        },
      ),
    ),
  );

  void handleUpload(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      print("DOC:");
      Documents? doc = controller.arrDocuments?[index];
      print(doc);
      print('Upload button Clicked');
      Get.toNamed<dynamic>(
        Routes.CREDIT_DOCUMENTS_UPLOAD,
        arguments: Documents(
          key: doc?.key,
          document: doc?.document,
          documentName: doc?.documentName,
          originalDocName: doc?.originalDocName,
          isAttachedInProcess: doc?.isAttachedInProcess,
          isMandatory: doc?.isMandatory,
          canDelete: doc?.canDelete,
        ),
      )?.then((value) {
        if (value is bool && value) {
          controller.getDocuments();
        }
      });
    }
  }

  void handleDelete(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      Get.toNamed<dynamic>(
        Routes.CREDIT_DOCUMENTS_UPLOAD,
        arguments: Documents(
          LimitMode: controller.mode,
          key: doc?.key,
          document: doc?.document,
          documentName: doc?.documentName,
          originalDocName: doc?.originalDocName,
          isAttachedInProcess: doc?.isAttachedInProcess,
          isMandatory: doc?.isMandatory,
          canDelete: doc?.canDelete,
        ),
      )?.then((value) {
        if (value is bool && value) {
          controller.getDocuments();
        }
      });
    }
  }
}
