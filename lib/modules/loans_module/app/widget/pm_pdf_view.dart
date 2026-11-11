import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../modules/pl_chat/controllers/pl_chat_controller.dart';
import '../utils/aes_encoder.dart';
import '../utils/app_colors.dart';

class PmPdfView extends GetView<PlChatController> {
  const PmPdfView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: controller.currentChat.value.name ?? ""),
    body: SfTheme(
      data: SfThemeData(
        pdfViewerThemeData: SfPdfViewerThemeData(
          backgroundColor: AppColors.kffffff,
          progressBarColor: AppColors.k002A7F,
          scrollHeadStyle: PdfScrollHeadStyle(
            backgroundColor: AppColors.k002A7F,
            pageNumberTextStyle: kw500White14,
          ),
          scrollStatusStyle: PdfScrollStatusStyle(
            backgroundColor: AppColors.k002A7F.withOpacity(0.6),
            pageInfoTextStyle: kw500White14,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(16.h),
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
        child: SfPdfViewer.network(
          AesEncryption.decrypt(
            controller.currentChat.value.storage ?? "",
          ).addBaseUrl,
          controller: controller.pdfViewerController,
          interactionMode: PdfInteractionMode.pan,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {},
          onPageChanged: (PdfPageChangedDetails details) {},
        ),
      ),
    ),
  );
}
