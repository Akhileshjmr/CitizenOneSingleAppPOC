import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import 'package:citizenone_app/modules/loans_module/app/widget/user_document_list.dart';

import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../routes/app_pages.dart';
import '../controllers/documents_controller.dart';

class DocumentsView extends GetView<DocumentsController> {
  const DocumentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.kF8FAFC,
    appBar: AgAppbar(title: 'Document List'),
    bottomNavigationBar: ColoredBox(
      color: AppColors.kffffff,
      child: AppButton(
        labelStyle: kw500White16,
        label: 'Continue',
        margin: REdgeInsets.all(20),
        onTap: () async {
          /*for (int i = 0; i < controller.arrDocuments!.value.length; i++) {
                if (controller.arrDocuments?.value[i].isMandatory == true) {
                  if (controller.arrDocuments?.value[i]
                      .isAttachedInProcess == true) {
                    controller.isAttached = true;
                  } else {
                    controller.isAttached = false;
                  }
                }
              }*/
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
          /*if (controller.isAttached == true){
                if(controller.mode == 'LimitMode') {
                  controller.onDocSubmit(
                      {
                        'filterVal': UserProvider.currentUser
                            ?.addiParams?[0] ?? '',
                        'reqSecureKey': '',
                      }, context);
                }else{
                  Get.back(result: true);
                }*/
          if (controller.isAttached == true) {
            if (controller.mode == 'LimitMode') {
              // 🔗 Ensure all docs are linked BEFORE submit
              await controller.autoLinkDocumentsIfNeeded();

              await controller.onDocSubmit({
                'filterVal': UserProvider.currentUser?.addiParams?[0] ?? '',
                'reqSecureKey': '',
              }, context);
            } else {
              Get.back(result: true);
            }
          } else {
            appSnackbar(
              message: 'Please upload all the documents.',
              snackbarState: SnackbarState.warning,
            );
          }
        },
      ),
    ),
    body: Obx(
      () =>
          controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: (controller.arrDocuments?.length ?? 0),
                itemBuilder: (context, index) {
                  String type =
                      controller.arrDocuments?[index].documentName?.type ?? "";
                  String docName =
                      controller.arrDocuments?[index].originalDocName ?? "";
                  bool isAttached =
                      controller.arrDocuments?[index].isAttachedInProcess ??
                      false;
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
              ).paddingOnly(top: 10),
    ),
  );

  /*void handleUpload(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      Get.toNamed<dynamic>(
          Routes.UPLOAD_DOCUMENTS,
          arguments: Documents(
              LimitMode: controller.mode,
              key: doc?.key,
              document: doc?.document,
              documentName: doc?.documentName,
              originalDocName: doc?.originalDocName,
              isAttachedInProcess: doc?.isAttachedInProcess,
              isMandatory: doc?.isMandatory,
              canDelete: doc?.canDelete
          )
      )?.then((value) {
        if (value is bool && value) {
          if (controller.mode == 'Auto'){
            controller.getDocuments('auto/orders/profile-doc-list');
          }else if (controller.mode == 'CG'){
            controller.getDocuments('orders/cg/profile-doc-list');
          }else if (controller.mode == 'REAL_ESTATE'){
            controller.getDocuments('realestate/home/orders/profile-doc-list');
          } else if (controller.mode == 'LimitMode'){
            controller.getDocumentsLimit('customer/profile/process-view-documents');
          }else{
            controller.getDocuments('customer/profile/profile-doc-list');
          }
        }
      });

      // }
    }
  }*/

  void handleUpload(int index) {
    if ((controller.arrDocuments?.length ?? 0) <= index) return;

    final Documents? tappedDoc = controller.arrDocuments?[index];

    Get.toNamed<dynamic>(
      Routes.UPLOAD_DOCUMENTS,
      arguments: Documents(
        LimitMode: controller.mode,
        key: tappedDoc?.key,
        document: tappedDoc?.document,
        documentName: tappedDoc?.documentName,
        originalDocName: tappedDoc?.originalDocName,
        isAttachedInProcess: tappedDoc?.isAttachedInProcess,
        isMandatory: tappedDoc?.isMandatory,
        canDelete: tappedDoc?.canDelete,
      ),
    )?.then((value) async {
      if (value is bool && value == true) {
        // 🔁 Refresh documents first
        if (controller.mode == 'LimitMode') {
          await controller.getDocumentsLimit(
            'customer/profile/process-view-documents',
          );

          // ⏳ Ensure list is refreshed
          await Future.delayed(const Duration(milliseconds: 200));

          final Documents? refreshedDoc =
              controller.arrDocuments != null &&
                      controller.arrDocuments!.length > index
                  ? controller.arrDocuments![index]
                  : null;

          if (refreshedDoc?.key != null && refreshedDoc!.key!.isNotEmpty) {
            print('Linking document with key: ${refreshedDoc.key}');
            controller.DocumentsLink(refreshedDoc.key!);
          } else {
            print('Document key missing after upload at index $index');
          }
        } else {
          // Non-limit modes
          await controller.getDocuments(ApiEndPoints.processViewDocuments);
        }
      }
    });
  }

  void handleDelete(int index) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      Get.toNamed<dynamic>(
        Routes.UPLOAD_DOCUMENTS,
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
          if (controller.mode == 'Auto') {
            controller.getDocuments('auto/orders/profile-doc-list');
          } else if (controller.mode == 'CG') {
            controller.getDocuments('orders/cg/profile-doc-list');
          } else if (controller.mode == 'REAL_ESTATE') {
            controller.getDocuments('realestate/home/orders/profile-doc-list');
          } else if (controller.mode == 'LimitMode') {
            controller.getDocumentsLimit(
              'customer/profile/process-view-documents',
            );
          } else {
            controller.getDocuments(ApiEndPoints.processViewDocuments);
          }
        }
      });
    }
  }

  /*void handleDelete(int index, BuildContext context) {
    if ((controller.arrDocuments?.length ?? 0) > index) {
      Documents? doc = controller.arrDocuments?[index];
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text(
            'Delete Document?',
            textAlign: TextAlign.center,
            style: kTitleMetropolis14,
          ),
          content: const Text(
            'Do you want to delete it?',
            style: kSubTitleMetropolis12,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: kAppThemeColorTitleMetropolis16,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: false).pop();
                Get.toNamed<dynamic>(
                    Routes.UPLOAD_DOCUMENTS,
                    arguments: Documents(
                        LimitMode: controller.mode,
                        key: doc?.key,
                        document: doc?.document,
                        documentName: doc?.documentName,
                        originalDocName: doc?.originalDocName,
                        isAttachedInProcess: doc?.isAttachedInProcess,
                        isMandatory: doc?.isMandatory,
                        canDelete: doc?.canDelete
                    )
                )?.then((value) {
                  if (value is bool && value) {
                    if (controller.mode == 'Auto'){
                      controller.getDocuments('auto/orders/profile-doc-list');
                    }else if (controller.mode == 'CG'){
                      controller.getDocuments('orders/cg/profile-doc-list');
                    }else if (controller.mode == 'REAL_ESTATE'){
                      controller.getDocuments('realestate/home/orders/profile-doc-list');
                    } else if (controller.mode == 'LimitMode'){
                      controller.getDocumentsLimit('customer/profile/process-view-documents');
                    }else{
                      controller.getDocuments('customer/profile/profile-doc-list');
                    }
                  }
                });
              },
              child: const Text('Yes'),
            ),
          ],
        )*/ /*AlertDialog(
          title: Text(
            'Delete Document?',
            style: kTitleMetropolis14,
          ),
          content: Text(
            'Do you want to delete it?',
            style: kSubTitleMetropolis12,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.back();
                // Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: false).pop();
                Get.toNamed<dynamic>(
                    Routes.UPLOAD_DOCUMENTS,
                    arguments: Documents(
                        LimitMode: controller.mode,
                        key: doc?.key,
                        document: doc?.document,
                        documentName: doc?.documentName,
                        originalDocName: doc?.originalDocName,
                        isAttachedInProcess: doc?.isAttachedInProcess,
                        isMandatory: doc?.isMandatory,
                        canDelete: doc?.canDelete
                    )
                )?.then((value) {
                  if (value is bool && value) {
                    if (controller.mode == 'Auto'){
                      controller.getDocuments('auto/orders/profile-doc-list');
                    }else if (controller.mode == 'CG'){
                      controller.getDocuments('orders/cg/profile-doc-list');
                    }else if (controller.mode == 'REAL_ESTATE'){
                      controller.getDocuments('realestate/home/orders/profile-doc-list');
                    } else if (controller.mode == 'LimitMode'){
                      controller.getDocumentsLimit('customer/profile/process-view-documents');
                    }else{
                      controller.getDocuments('customer/profile/profile-doc-list');
                    }
                  }
                });
              },
              child: Text('Yes'),
            ),
          ],
        ),*/ /*
      );
    }
  }*/
}
