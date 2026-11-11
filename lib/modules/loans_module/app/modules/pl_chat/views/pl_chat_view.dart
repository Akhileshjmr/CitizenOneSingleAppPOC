import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/ChatMsgs.dart';
import '../../../utils/aes_encoder.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/chat_img_view.dart';
import '../../../widget/pm_pdf_view.dart';
import '../controllers/pl_chat_controller.dart';

class PlChatView extends GetView<PlChatController> {
  ///
  const PlChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: Scaffold(
        appBar: AgAppbar(
          title: 'Chat',
          actions: [
            IconButton(
              onPressed: () async {
                await controller.fetchChat();
              },
              icon: const Icon(Icons.refresh, color: AppColors.k231F20),
            ).paddingOnly(right: 10),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              /// ===============================
              /// CHAT MESSAGE LIST
              /// ===============================
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: AgLoader());
                  }

                  if (controller.chatMessages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  return ListView.builder(
                    controller: controller.scrollController.value,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    itemCount: controller.chatMessages.length,
                    itemBuilder: (context, index) {
                      final message =
                          controller.chatMessages[controller
                                  .chatMessages
                                  .length -
                              1 -
                              index];

                      return getChatCell(message);
                    },
                  );
                }),
              ),

              /// ===============================
              /// INPUT BAR
              /// ===============================
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// TEXT FIELD
                    Expanded(
                      child: AppTextField(
                        name: 'chat',
                        hintText: 'Message',
                        controller: controller.msgController,
                        borderColor: AppColors.darkGrey,
                      ),
                    ),

                    /// ATTACHMENT BUTTON
                    IconButton(
                      onPressed: () {
                        CommonUtilities().openImagePickerActionSheet(
                          context,
                          (XFile? file) {
                            docSelected(file);
                          },
                          (PlatformFile file) {
                            docFileSelected(file);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.attach_file_outlined,
                        color: AppColors.darkGrey,
                      ),
                    ),

                    /// SEND BUTTON
                    IconButton(
                      onPressed: () async {
                        if (controller.msgController.text.trim().isEmpty) {
                          return;
                        }

                        final now = DateTime.now();
                        final formattedDate = DateFormat(
                          'EEE, MMM dd, yyyy hh:mm a',
                        ).format(now);

                        await controller.sendChat(
                          data: {
                            'msg': AesEncryption.encrypt(
                              controller.msgController.text.trim(),
                            ),
                            'msgBy': UserProvider.currentUser?.addiParams?[0],
                            'reqSecureKey':
                                UserProvider.currentUser?.addiParams?[0],
                            'msgByType': 'CUSTOMER',
                            'isClarified': false,
                            'appType': controller.loanType,
                            'msgType': 'TEXT',
                            'filterVal': controller.applicationId,
                            'msgOn': formattedDate,
                          },
                        );

                        controller.msgController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();

                        /// Auto scroll to bottom
                        Future.delayed(const Duration(milliseconds: 200), () {
                          if (controller.scrollController.value.hasClients) {
                            controller.scrollController.value.animateTo(
                              0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      },
                      icon: Icon(Icons.send, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getChatCell(ChatMsgs? data) {
    return ((data?.msgByType ?? "") == 'BANK' ||
            (data?.msgByType ?? "") == 'VENDOR')
        ? (getCell(data, true))
        : getCell(data, false);
  }

  Widget getCell(ChatMsgs? data, bool isBank) {
    if ((data?.msgType ?? "") == "TEXT") {
      return isBank
          ? ChatBubble(
            clipper: ChatBubbleClipper4(
              type: isBank ? BubbleType.receiverBubble : BubbleType.sendBubble,
            ),
            alignment: isBank ? Alignment.topLeft : Alignment.topRight,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: (isBank ? 16 : 10),
              right: (isBank ? 10 : 16),
            ),
            backGroundColor:
                isBank ? Colors.grey[100] : Colors.lightGreen.shade50,
            child: Container(
              constraints: BoxConstraints(maxWidth: 1.sw * 0.7, minWidth: 130),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      SelectableText(data?.msg ?? '', style: kw400Black12),
                      16.verticalSpace,
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: SelectableText(
                      data?.msgOn ?? '',
                      textAlign: isBank ? TextAlign.start : TextAlign.end,
                      style: kw400Black12,
                    ),
                  ),
                ],
              ),
            ),
          )
          : ChatBubble(
            clipper: ChatBubbleClipper4(
              type: isBank ? BubbleType.receiverBubble : BubbleType.sendBubble,
            ),
            alignment: isBank ? Alignment.topLeft : Alignment.topRight,
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            padding: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: (isBank ? 16 : 10),
              right: (isBank ? 10 : 16),
            ),
            backGroundColor:
                isBank ? Colors.grey[100] : Colors.lightGreen.shade50,
            child: Container(
              constraints: BoxConstraints(maxWidth: 1.sw * 0.7, minWidth: 130),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      SelectableText(data?.msg ?? '', style: kw400Black12),
                      16.verticalSpace,
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: SelectableText(
                      data?.msgOn ?? '',
                      textAlign: isBank ? TextAlign.start : TextAlign.end,
                      style: kw400Black12,
                    ),
                  ),
                ],
              ),
            ),
          );
    } else if ((data?.msgType ?? "") == "IMG" ||
        (data?.msgType ?? "") == "DOC") {
      return Align(
        alignment: isBank ? Alignment.topLeft : Alignment.topRight,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if ((data?.msgType ?? "") == "IMG") {
                  controller.currentChat(data);
                  Get.find<PlChatController>();
                  Get.to<void>(() => ChatImgView());
                } else {
                  showToolPDFDownloadDialog(Get.context!, data);
                }
              },
              child:
                  data?.msgType == 'IMG'
                      ? ImageHandle(
                        url:
                            AesEncryption.decrypt(
                              data?.storage ?? '',
                            ).addBaseUrl,
                        size: Size(120.w, 100.h),
                        radius: 6,
                      )
                      : Icon(
                        (data?.extn ?? '').toLowerCase() == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.description,
                        size: 48.h,
                        color:
                            (data?.extn ?? '').toLowerCase() == 'pdf'
                                ? Colors.red
                                : AppColors.primary,
                      ),
            ),
            10.verticalSpace,
            SelectableText(
              data?.msgOn ?? '',
              textAlign: TextAlign.end,
              style: kw400Black12,
            ),
          ],
        ).paddingOnly(top: 8, left: isBank ? 8 : 0, right: isBank ? 0 : 8),
      );
    }

    return ChatBubble(
      clipper: ChatBubbleClipper4(type: BubbleType.receiverBubble),
      alignment: isBank ? Alignment.topLeft : Alignment.topRight,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.only(top: 10, bottom: 5, left: 16, right: 10),
      backGroundColor: Colors.grey[100],
      child: Container(
        constraints: BoxConstraints(maxWidth: 1.sw * 0.7, minWidth: 100),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                SelectableText(data?.msg ?? '', style: kw400Black12),
                16.verticalSpace,
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SelectableText(
                data?.msgOn ?? '',
                textAlign: TextAlign.start,
                style: kw400Black12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///To show delete Dialog
  showToolPDFDownloadDialog(BuildContext context, ChatMsgs? data) {
    print("Image Url");
    print(AesEncryption.decrypt(data?.storage ?? ""));
    String imgUrl = AesEncryption.decrypt(data?.storage ?? "");
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.all(8),
            content: SizedBox(
              height: 40,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data?.name ?? '',
                      textAlign: TextAlign.center,
                      style: kw600Black16,
                    ),
                  ),
                  10.horizontalSpace,
                  SizedBox(
                    height: 30,
                    width: 28,
                    child: IconButton(
                      padding: const EdgeInsets.all(4),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextButton(
                  onPressed: () async {
                    // SfPdfViewer.network(imgUrl.addBaseUrl);
                    controller.currentChat(data);
                    Get.find<PlChatController>();
                    await Get.to<void>(() => PmPdfView());
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey, width: 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'View PDF',
                        style: kw400Black14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child:
                // Obx(() =>
                TextButton(
                  onPressed: () async {
                    String dirPath = await controller.getDirectoryPath();
                    final bool isDownloadCompleted = await controller
                        .downloadFile(
                          imgUrl.addBaseUrl,
                          data?.name ?? "",
                          dirPath,
                        );
                    //final bool isDownloadCompleted = await downloadFile('http://65.1.78.64:8690/profitto/cms/9228/portal/view');
                    print('isDownloadCompleted : $isDownloadCompleted');
                    if (isDownloadCompleted) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: 1.sw,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.k282562,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey, width: 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child:
                    // controller.isDownloadLoading.value
                    //     ? Center(
                    //   child: Container(
                    //     height: 25,
                    //     width: 25,
                    //     child: const CircularProgressIndicator(
                    //       color: AppColors.kffffff,
                    //       strokeWidth: 2,
                    //     ),
                    //   ),
                    // )
                    //     :
                    Center(
                      child: Text(
                        'Download PDF',
                        style: kw400Black14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                // ),
              ),
            ],
          ),
    );
  }

  /// Upload the image
  Future<void> docSelected(XFile? file) async {
    controller.docFile(file);
    final DateTime now = DateTime.now();
    final String allDate = DateFormat('EEE, MMM dd, yyyy hh:mm a').format(now);
    String basename = (controller.docFile?.value)!.path;

    Uint8List imagebytes =
        await (controller.docFile.value)!.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes);

    List<String> arrDat = basename.split(".");
    String extn = arrDat.last;
    String type = "image/" + extn;

    List<String> arrStr = basename.split("/");
    String name = arrStr.last;
    await controller.sendChat(
      data: {
        'msg': '',
        'msgBy': UserProvider.currentUser?.addiParams?[0],
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0],
        'msgByType': 'CUSTOMER',
        'isClarified': false,
        'appType': controller.loanType,
        'msgType': 'IMG',
        'filterVal': controller.applicationId,
        'msgOn': allDate,
        'doc': {
          'extn': extn,
          'fileBytes': '',
          'fileDataStr': base64string,
          'name': name,
          'storage': 'Internal',
          'type': '',
        },
      },
    );
  }

  /// Upload the document
  Future<void> docFileSelected(PlatformFile? file) async {
    controller.docstFile.value = file;
    final DateTime now = DateTime.now();
    final String allDate = DateFormat('EEE, MMM dd, yyyy hh:mm a').format(now);
    String? basename = (controller.docstFile())?.path;
    final Uploadedfile = File(basename ?? '');
    final bytes = await Uploadedfile.readAsBytes();
    // Uint8List? bytes = await CommonUtilities.fileToUint8List(basename);
    if (bytes != null) {
      // Uint8List b = Uint8List(bytes.length);
      // Work with the Uint8List 'b' here
      String base64string = base64Encode(bytes);

      List<String>? arrDat = basename?.split(".");
      String? extn = arrDat?.last;
      // String type = "image/" + extn!;

      List<String>? arrStr = basename?.split("/");
      String? name = arrStr?.last;
      await controller.sendChat(
        data: {
          'msg': '',
          'msgBy': UserProvider.currentUser?.addiParams?[0],
          'reqSecureKey': UserProvider.currentUser?.addiParams?[0],
          'msgByType': 'CUSTOMER',
          'isClarified': false,
          'appType': controller.loanType,
          'msgType': 'DOC',
          'filterVal': controller.applicationId,
          'msgOn': allDate,
          'doc': {
            'extn': extn,
            'fileBytes': '',
            'fileDataStr': base64string,
            'name': name,
            'storage': 'Internal',
            'type': '',
          },
        },
      );
    } else {
      print('Bytes is null');
    }
  }
}
