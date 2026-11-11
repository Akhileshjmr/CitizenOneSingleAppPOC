import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../components/ui/image_hendle.dart';
import '../modules/pl_chat/controllers/pl_chat_controller.dart';
import '../utils/aes_encoder.dart';
import '../utils/app_colors.dart';

class ChatImgView extends GetView<PlChatController> {
  const ChatImgView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(
      title: controller.currentChat.value.name ?? "",
      actions: [
        IconButton(
          onPressed: () async {
            String imgUrl = AesEncryption.decrypt(
              controller.currentChat.value.storage ?? "",
            );
            String dirPath = await controller.getDirectoryPath();
            controller.downloadFile(
              imgUrl.addBaseUrl,
              controller.currentChat.value.name ?? "",
              dirPath,
            );
          },
          icon: Container(
            decoration: const BoxDecoration(
              color: AppColors.kffffff,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Icon(Icons.arrow_circle_down_sharp, color: AppColors.primary),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    body: Container(
      margin: EdgeInsets.all(0),
      child: Expanded(
        child: ImageHandle(
          url:
              (AesEncryption.decrypt(
                controller.currentChat.value.storage ?? "",
              )).addBaseUrl,
          padding: EdgeInsets.zero,
          size: MediaQuery.sizeOf(Get.context!),
          radius: 1.r,
        ),
      ),
    ),
  );
}
