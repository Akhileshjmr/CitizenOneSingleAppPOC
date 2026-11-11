import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/ag_constants.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../routes/app_pages.dart';
import '../../../session/module_navigation_coordinator.dart';
import '../../../session/session_manager.dart';
import '../../../utils/app_colors.dart';
import '../../pl_status/views/pl_status_view.dart';
import '../controllers/pl_history_controller.dart';

class PlHistoryView extends GetView<PlHistoryController> {
  const PlHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (AgConstants.popBackFromLoans) {
        await Get.find<SessionManager>().exitModule();
        return false;
      }
      return true;
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AgAppbar(
        title: 'Personal Loan',
        leadingOnTap: () async {
          if (AgConstants.popBackFromLoans) {
            Get.find<SessionManager>().exitModule();
            return;
          }

          await Get.find<ModuleNavigationCoordinator>().closeModule();
        },
      ),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child:
                controller.plList.isEmpty
                    ? const Center(
                      child: Text(
                        'No personal loans Found!',
                        style: kw400Black14,
                      ),
                    )
                    : ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.plList.length,
                      separatorBuilder:
                          (BuildContext context, int index) => 10.verticalSpace,
                      itemBuilder:
                          (BuildContext context, int index) =>
                              _buildPLList(index, context),
                    ),
          ),
        ),
      ),
    ),
  );

  Widget _buildPLList(int index, BuildContext context) {
    final item = controller.plList[index];
    final String currency = item?.ccy ?? CommonUtilities.AppCurrency;

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xffF3F6FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ImageHandle(
                    url: item?.bankLogo?.addBaseUrl ?? '',
                    padding: EdgeInsets.zero,
                    radius: 0,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.bankName ?? '',
                        style: kw700Black14,
                        maxLines: 2,
                      ),
                      4.verticalSpace,
                      Text('Personal Loan', style: kw500727272s11),
                    ],
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            /// Row 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _detailTile(
                    title: 'Application No.',
                    value: item?.refNumber ?? '',
                  ),
                ),
                18.horizontalSpace,
                Expanded(
                  child: _detailTile(
                    title: 'Loan Amount',
                    value:
                        '$currency ${item?.requestedloanAmount?.toStringAsFixed(2) ?? '0'}',
                  ),
                ),
              ],
            ),

            24.verticalSpace,

            /// Row 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _detailTile(
                    title: 'Eligibility Amount',
                    value:
                        '$currency ${item?.plEligibilityAmt?.toStringAsFixed(2) ?? '0'}',
                  ),
                ),
                20.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status', style: kw500727272s11),
                      2.verticalSpace,
                      InkWell(
                        onTap: () async {
                          if (item?.status == 'New') {
                            LocalStore.loanRefId('');
                            await Get.toNamed(
                              Routes.PL_STATUS_UPDATE,
                              arguments: item,
                            )?.then((_) async {
                              // await controller.getpl();
                            });
                          } else if (item?.status == 'NEED_CLARIFICATION' ||
                              item?.isEditable == true) {
                            LocalStore.loanRefId(item?.refNumber ?? '');
                            LocalStore.bankId(item?.bankId.toString() ?? '');
                            LocalStore.loanStatus(item?.isEditable);

                            await Get.toNamed<void>(Routes.LOAN_DETAILS);
                          } else if (item?.status == 'Approved') {
                            Get.to(
                              () => PlStatusView(),
                              arguments: PlSatusArguments(
                                index: index,
                                pdfUrl: item?.sactionDocId ?? '',
                              ),
                            ) /*?.then((_) => controller.getpl())*/;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffDCEAFE),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Text(
                            item?.status ?? '',
                            style: kw400Black14.copyWith(
                              color: const Color(0xff2563EB),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Clarification Message
            if ((item?.status ?? '').toUpperCase().contains('CLARIFICATION') &&
                (item?.comments?.isNotEmpty ?? false)) ...[
              20.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Message:', style: kw400Black14),
                  8.horizontalSpace,
                  Expanded(child: SeeMoreText(text: item?.comments ?? '')),
                ],
              ),
            ],

            16.verticalSpace,

            Center(child: Text('Need more help', style: kw500Black14)),

            16.verticalSpace,

            Row(
              children: [
                Expanded(
                  child: AgButton(
                    title: 'Chat with Us',
                    prefixIcon: Icons.chat,
                    isOutlined: true,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    onTap: () {
                      appSnackbar(
                        message: 'Coming Soon',
                        snackbarState: SnackbarState.success,
                      );
                      /*Get.toNamed<void>(
                        Routes.PL_CHAT,
                        arguments: PLChatArguments(
                          chatId: item?.chatId.toString() ?? '',
                          applicationId: item?.leadId.toString() ?? '',
                          loanType: 'PERSONAL_LOAN',
                        ),
                      )?.then((_) => controller.getpl());*/
                    },
                  ),
                ),
                8.horizontalSpace,
                Expanded(
                  child: AgButton(
                    title: 'Talk to Us',
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    isOutlined: true,
                    prefixIcon: Icons.phone,
                    onTap: () {
                      appSnackbar(
                        message: 'Coming Soon',
                        snackbarState: SnackbarState.success,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailTile({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: kw500727272s11),
        2.verticalSpace,
        Text(value, style: kw500Black16),
      ],
    );
  }
}

class SeeMoreText extends StatefulWidget {
  final String text;

  const SeeMoreText({Key? key, required this.text}) : super(key: key);

  @override
  _SeeMoreTextState createState() => _SeeMoreTextState();
}

class _SeeMoreTextState extends State<SeeMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine the maximum length of text to display when collapsed
    final maxLines = 2;
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
    ); // Style for the text

    return LayoutBuilder(
      builder: (context, constraints) {
        // Create a TextPainter to measure the height of the text
        final span = TextSpan(text: widget.text, style: textStyle);
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);
        final isOverflowing =
            tp.didExceedMaxLines; // Check if the text overflows

        return RichText(
          text: TextSpan(
            style: textStyle,
            children: <TextSpan>[
              TextSpan(
                text:
                    _isExpanded
                        ? widget.text
                        : isOverflowing
                        ? '${widget.text.substring(0, tp.getPositionForOffset(Offset(constraints.maxWidth, tp.preferredLineHeight * (maxLines - 1))).offset)}...'
                        : widget.text,
                style: kw400Black14.copyWith(fontWeight: FontWeight.w500),
              ),
              if (isOverflowing) // Only show the See More/Less button if text is overflowing
                TextSpan(
                  text: _isExpanded ? ' See Less' : ' See More',
                  // Toggle button text
                  style: kw400Black14.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.k002A7F,
                  ),
                  // Style for "See More/See Less"
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            _isExpanded =
                                !_isExpanded; // Toggle the state on tap
                          });
                        },
                ),
            ],
          ),
        );
      },
    );
  }
}
