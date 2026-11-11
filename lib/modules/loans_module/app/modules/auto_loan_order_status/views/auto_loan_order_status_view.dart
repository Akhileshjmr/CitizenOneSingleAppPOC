import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/model/args/track_order_args.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/pdf_viewer_screen.dart';
import '../controllers/auto_loan_order_status_controller.dart';

class AutoLoanOrderStatusView extends GetView<AutoLoanOrderStatusController> {
  const AutoLoanOrderStatusView({super.key});
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      Get.back(result: true);
      return true;
    },
    child: Scaffold(
      appBar: AgAppbar(title: 'Loan Status Details'),

      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------------------------
                      // Loan Info Card
                      // -------------------------
                      Card(
                        margin: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ImageHandle(
                                    url:
                                        (controller.loanItem.bankLogo ?? '')
                                            .addBaseUrl,
                                    padding: EdgeInsets.zero,
                                    size: Size(72.h, 72.w),
                                    radius: 8.r,
                                  ),
                                  10.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      'Your Home Loan submitted to ${controller.loanItem.bankName ?? ''}',
                                      maxLines: 2,
                                      style: kTitleMetropolis16,
                                    ),
                                  ),
                                ],
                              ),
                              10.verticalSpace,
                              _infoRow(
                                "Application No:",
                                controller.loanItem.loanAppNum ?? '',
                              ),
                              6.verticalSpace,
                              _infoRow(
                                "Loan Amount:",
                                "${CommonUtilities.AppCurrency} ${controller.loanItem.loanAmount?.toStringAsFixed(2) ?? '0'}",
                              ),
                            ],
                          ),
                        ),
                      ),

                      20.verticalSpace,

                      // -------------------------
                      // Check Your Loan Status Button (Replacement)
                      // -------------------------
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Material(
                          color: Colors.white,
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Get.toNamed(
                                Routes.AUTO_LOAN_TRACK_ORDER_STATUS,
                                arguments: TrackOrderArgs(
                                  key: controller.loanItem.loanAppNum ?? '',
                                  categoryType:
                                      controller.loanItem.categoryType ?? '',
                                  isLoanStatus: true,
                                ),
                              );
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.k63AF23,
                                  width: 1.2,
                                ),
                              ),
                              child: const Text(
                                'Check Your Loan Status',
                                style: kw500Green14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      14.verticalSpace,

                      // ------------------------------------------------------
                      // STATIC BUTTONS (API NOT AVAILABLE YET)
                      // ------------------------------------------------------
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: AgButton(
                          title: 'View Insurer Detail',
                          onTap: () {
                            print('Static: View Insurer Detail');
                          },
                        ),
                      ),

                      /* Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: AppButton(
                  backgroundColor: highlightGreenColor,
                  label: 'Offer Letter',
                  labelStyle: kButtonTitleMetropolis14,
                  margin: REdgeInsets.fromLTRB(15, 5, 15, 5),
                  onTap: () async {
                    print('Offer letter clicked');

                    try {
                      // 1️⃣ Call API
                      await controller.fetchOfferLetter();

                      // 2️⃣ Get URL
                      final String? offerLetterUrl =
                      controller.getOfferLetterUrl();

                      // 3️⃣ Open PDF
                      if (offerLetterUrl != null &&
                          offerLetterUrl.isNotEmpty) {
                        await Get.to(
                              () => PdfViewerScreen(
                            pdfUrl: offerLetterUrl,
                          ),
                        );
                      } else {
                        appSnackbar(
                          message: 'Unable to load offer letter',
                          snackbarState: SnackbarState.warning,
                        );
                      }
                    } catch (e) {
                      appSnackbar(
                        message: 'Something went wrong while loading offer letter',
                        snackbarState: SnackbarState.warning,
                      );
                    }
                  },
                )
              ),*/
                      Obx(() {
                        if (!controller.hasOfferLetter) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child: AgButton(
                            title: 'Offer Letter',
                            onTap: () async {
                              final url = controller.getOfferLetterUrl();
                              if (url != null && url.isNotEmpty) {
                                await Get.to(
                                  () => PdfViewerScreen(pdfUrl: url),
                                );
                              }
                            },
                          ),
                        );
                      }),

                      20.verticalSpace,
                    ],
                  ),
                ),
      ),
    ),
  );

  // ---------------------------
  // Reusable widgets
  // ---------------------------
  Widget _infoRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: kw400Black14),
      Text(value, style: kw400Black12),
    ],
  );
}
