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
import '../../../utils/app_colors.dart';
import '../../../widget/user_document_list.dart';
import '../controllers/p_r_document_list_controller.dart';

class PRDocumentListView extends GetView<PRDocumentListController> {
  const PRDocumentListView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Document List'),
    backgroundColor: AppColors.kF8FAFC,
    bottomNavigationBar: AgButton(
      title: 'Continue',
      onTap: () {
        for (int i = 0; i < controller.arrDocuments!.value.length; i++) {
          if (controller.arrDocuments?.value[i].isMandatory == true) {
            if (controller.arrDocuments?.value[i].isAttachedInProcess == true) {
              controller.isAttached = true;
            } else {
              controller.isAttached = false;
            }
          }
        }
        if (controller.isAttached == true) {
          controller.onDocSubmit({
            "limit": {
              "bank": {
                "key": controller.args.bankid,
                "name": controller.args.bankName,
              },
              "bankProductId": controller.args.montlyExc,
              "limitVal": controller.args.montlyInc.replaceAll(",", ""),
            },
            "addiParams": [
              LocalStore.buyNowFilterVal,
              ((controller.args.filterval == '/vehicleloan')
                  ? 'CAR_LOAN'
                  : 'HOUSE_LOAN'),
            ],
            "filterHashKey": 0,
            "filterVal": "SAVE",
            "hKey": 0,
            "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
          });
        } else {
          appSnackbar(
            message: 'Please upload all the documents.',
            snackbarState: SnackbarState.warning,
          );
        }
      },
    ).paddingAll(20),
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
            /*return UserDocumentList(
              type,
              docName,
              index,
              isAttached,
              controller.arrDocuments?.value[index],
              (ind) {
                handleUpload(ind);
              },
            );*/
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
        Routes.P_R_UPLOAD_DOCUMENT,
        arguments: Documents(
          key: doc?.key,
          document: doc?.document,
          documentName: doc?.documentName,
          originalDocName: doc?.originalDocName,
          isAttachedInProcess: doc?.isAttachedInProcess,
          isMandatory: doc?.isMandatory,
          canDelete: doc?.canDelete,
          LimitMode: '',
        ),
      )?.then((value) {
        if (value is bool && value) {
          controller.getDocuments();
        }
      });

      // }
    }
  }

  void handleDelete(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      Get.toNamed<dynamic>(
        Routes.P_R_UPLOAD_DOCUMENT,
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
