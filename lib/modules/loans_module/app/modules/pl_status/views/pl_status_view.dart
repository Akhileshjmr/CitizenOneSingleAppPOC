import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/utils/common_utilities.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../utils/app_colors.dart';
import '../controllers/pl_status_controller.dart';

class PlStatusView extends GetView<PlStatusController> {
  const PlStatusView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Detail View'),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Approved', style: kw400Black14),
                Text(
                  '${CommonUtilities.AppCurrency} ${controller.plList[controller.listIndex.value]?.requestedloanAmount?.toStringAsFixed(2) ?? '0'}',
                  style: kw400Black14,
                ),
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sanction Letter', style: kTitleMetropolis14),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        String dirPath = await controller.getDirectoryPath();
                        final bool isDownloadCompleted = await controller
                            .downloadFile(
                              (APIService.imageBaseUrl +
                                  (controller
                                          .plList[controller.listIndex.value]
                                          ?.sactionDocId ??
                                      '')),
                              (controller
                                      .plList[controller.listIndex.value]
                                      ?.bankName ??
                                  ""),
                              dirPath,
                            );
                      },
                      child: Icon(Icons.download, size: 24),
                    ),
                    15.horizontalSpace,
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          builder:
                              (context) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(25.0),
                                    topRight: const Radius.circular(25.0),
                                  ),
                                ),
                                child: DraggableScrollableSheet(
                                  initialChildSize: 0.9,
                                  minChildSize: 0.9,
                                  maxChildSize: 0.9,
                                  builder: (context, scrollController) {
                                    print(controller.pdfUrl);
                                    return PDFBottomSheetContent(
                                      pdfUrl:
                                          APIService.imageBaseUrl +
                                          (controller
                                                  .plList[controller
                                                      .listIndex
                                                      .value]
                                                  ?.sactionDocId ??
                                              ''),
                                    );
                                  },
                                ),
                              ),
                        );
                        // controller.downloadFile('');
                        // SfPdfViewer.network(APIService.baseUrl + controller.pdfUrl);
                      },
                      child: Icon(Icons.picture_as_pdf_outlined, size: 40),
                    ),
                  ],
                ),
              ],
            ),
            10.verticalSpace,
            (controller.plList[controller.listIndex.value]?.isStatusUpdated ==
                    false)
                ? Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text('Remarks', style: kTitleMetropolis14),
                      ),
                      10.verticalSpace,
                      SizedBox(
                        height: 100,
                        child: TextField(
                          controller: controller.remarkController,
                          decoration: InputDecoration(
                            hintText: "Enter remark here",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ), // Add a grey border
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ), // Keep the grey border when enabled
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                      ),
                      15.verticalSpace,
                    ],
                  ),
                )
                : Container(),
            10.verticalSpace,
            (controller.plList[controller.listIndex.value]?.isStatusUpdated ==
                    false)
                ? Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.kffffff,
                        fixedSize: Size(150.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        textStyle: kTitleMetropolis14,
                      ),
                      onPressed: () {
                        controller.checkAceptReject(
                          'Accepted',
                          controller.remarkController.text,
                          controller
                                  .plList[controller.listIndex.value]
                                  ?.refNumber
                                  .toString() ??
                              '',
                        );
                      },
                      child: Text('Accept'),
                    ),
                    20.horizontalSpace,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kffffff,
                        foregroundColor: AppColors.grey,
                        fixedSize: Size(150.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        textStyle: kAppThemeWhiteColorSubtitleTitleMetropolis14,
                      ),
                      onPressed: () {
                        controller.checkAceptReject(
                          'Rejected',
                          controller.remarkController.text,
                          controller
                                  .plList[controller.listIndex.value]
                                  ?.refNumber
                                  .toString() ??
                              '',
                        );
                      },
                      child: Text('Reject'),
                    ),
                  ],
                )
                : Container(),
          ],
        ).paddingAll(20),
      ),
    ),
  );
}

class PDFBottomSheetContent extends StatelessWidget {
  final String pdfUrl;

  const PDFBottomSheetContent({super.key, required this.pdfUrl});
  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(pdfUrl);
  }
}
