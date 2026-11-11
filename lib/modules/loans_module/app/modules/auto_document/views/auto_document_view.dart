import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/user_document_list.dart';
import '../controllers/auto_document_controller.dart';

class AutoDocumentView extends GetView<AutoDocumentController> {
  const AutoDocumentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Document List'),
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: AgButton(
        title: 'Continue',
        onTap: () async {
          for (int i = 0; i < controller.arrDocuments!.value.length; i++) {
            if (controller.arrDocuments?.value[i].isMandatory == true) {
              if ((controller.arrDocuments?.value[i].originalDocName ?? '')
                  .isNotEmpty) {
                controller.isAttached = true;
              } else {
                controller.isAttached = false;
                appSnackbar(
                  message: 'Please upload all the documents.',
                  snackbarState: SnackbarState.warning,
                );
                return;
              }
            }
          }

          if (controller.isAttached == true) {
            await Future.delayed(const Duration(milliseconds: 300));

            await controller.onDocSubmit({
              'orderId': LocalStore.buyNowFilterVal,
              'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
            });
          }
        },

        // child: const Text('Continue'),
      ),
    ),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: ListView.builder(
          itemCount: (controller.arrDocuments?.length ?? 0),
          itemBuilder: (context, index) {
            String type =
                controller.arrDocuments?[index].documentName?.type ?? "";
            String docName =
                controller.arrDocuments?[index].originalDocName ?? "";
            bool isAttached =
                controller.arrDocuments![index].originalDocName
                        .toString()
                        .isNotEmpty
                    ? true
                    : false;
            return UserDocumentList(
              index: 1,
              doc: Documents(),
              onPressedUpload: (int index) {},
            );
          },
        ),
      ),
    ),
  );

  void handleUpload(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      Get.toNamed<dynamic>(
        Routes.AUTO_UPLOAD_DOCUMENT,
        arguments: Documents(
          key: doc?.key,
          document: doc?.document,
          documentName: doc?.documentName,
          originalDocName: doc?.originalDocName,
          isAttachedInProcess: doc?.isAttachedInProcess,
          isMandatory: doc?.isMandatory,
          canDelete: doc?.canDelete,
          LimitMode: controller.args.LimitMode,
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
        Routes.AUTO_UPLOAD_DOCUMENT,
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
