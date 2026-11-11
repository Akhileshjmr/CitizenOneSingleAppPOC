import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/utils/common_utilities.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/user_doc.dart';
import '../../../widget/user_doc_bottom_navbar.dart';
import '../controllers/pl_upload_documents_controller.dart';

class PlUploadDocumentsView extends GetView<PlUploadDocumentsController> {
  const PlUploadDocumentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Preview'),
    body: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              20.verticalSpace,
              Text(
                controller.args?.documentName?.type ?? '',
                style: kw600Black16,
              ),
              6.verticalSpace,
              if ((controller.args?.originalDocName ?? '').isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Document ID :', style: kw400Black12),
                    4.horizontalSpace,
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        _getFileName(controller.args?.originalDocName),
                        style: kw400Black12,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ).paddingOnly(left: 50),
            ],
          ),
        ),
        /*UserDocTextField(
              val: controller.args?.originalDocName ?? "",
              onChangeTextField: (text) {
                handleTextChange(text);
              },
            ),*/
        Expanded(
          child: Obx(() {
            final hasUploadedDoc =
                (controller.docFile.value?.path ?? '').isNotEmpty ||
                (controller.docstFile.value?.path ?? '').isNotEmpty ||
                (kIsWeb && (controller.docstFile.value?.bytes != null));

            return Container(
              width: double.infinity,
              color: hasUploadedDoc ? AppColors.black : AppColors.kffffff,
              child: Center(
                child: UserDoc(
                  file: controller.docFile.value,
                  docsFile: controller.docstFile(),
                  onUploadDoc: () {
                    controller.handleUploadDocClicked();
                  },
                  onDeleteDoc: () {
                    handleDeleteDocClicked(context);
                  },
                ),
              ),
            );
          }),
        ),
      ],
    ),
    bottomNavigationBar: Obx(
      () =>
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                padding: const EdgeInsets.fromLTRB(6, 8, 6, 24),
                decoration: const BoxDecoration(color: AppColors.kffffff),
                child: UserDocBottomNavBar(
                  isBottom: controller.isBootom.value,
                  onPressedUploadDoc: () {
                    handleUploadDoc(context);
                  },
                ),
              ),
    ),
  );

  Future<void> handleUploadDoc(BuildContext context) async {
    print('Upload Document Clicked');

    if (controller.docstFile()?.name.toLowerCase().contains('pdf') ?? false) {
      final file = controller.docstFile()!;
      Uint8List? bytes = file.bytes;

      if (bytes == null && file.path != null) {
        bytes = await CommonUtilities.fileToUint8List(file.path!);
      }

      if (bytes == null) {
        return;
      }

      String base64string = base64.encode(bytes);
      String extn = file.extension ?? file.name.split('.').last;
      String name = file.name;

      final bool res = await controller.uploadDocument(
        extn,
        base64string,
        name,
      );
      if (res == true) {
        controller.hideLoader();
        Navigator.of(context).pop(true);
      }
    } else if (controller.docFile.value?.path.isNotEmpty ?? false) {
      final file = controller.docFile.value!;
      String fileName = file.name;

      Uint8List imagebytes = await file.readAsBytes();
      String base64string = base64.encode(imagebytes);

      String extn = fileName.split('.').last;

      final bool res = await controller.uploadDocument(
        extn,
        base64string,
        fileName,
      );

      if (res == true) {
        Navigator.of(context).pop(true);
      }
    }
  }

  void showAlert(String title, String text, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void showAlertSuccess(String title, String text, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void openBottomSheet() {}

  void handleTextChange(String text) {
    if (text == '') {
      return;
    }
    controller.docID(text).obs;
  }

  void handleDeleteDocClicked(BuildContext context) {
    print('delete Doc');
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),*/
            title: const Center(
              child: Text(
                'Alert!',
                style: TextStyle(
                  color: AppColors.kff0000,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            content: const Text(
              'Do you want to delete this file?',
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: kw600Black16),
              ),
              16.horizontalSpace,
              TextButton(
                onPressed: () {
                  controller.docFile(XFile(''));
                  controller.docstFile(PlatformFile(name: '', size: 0));
                  controller.isBootom(false).obs;
                  Navigator.of(context).pop();
                  controller.handleUploadDocClicked();
                },
                child: Text('Yes', style: kw600Black16),
              ),
            ],
          ),
    );
  }
}

String _getFileName(String? path) {
  if (path == null || path.isEmpty) return '';
  List<String> parts = path.split('/');
  return parts.isNotEmpty ? parts.last : path;
}
