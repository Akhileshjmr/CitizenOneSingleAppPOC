import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../../modules/pl_home_screen/controllers/pl_home_screen_controller.dart';
import '../../theme/ag_text_styles.dart';
import '../../utils/app_colors.dart';

class BankCard extends GetView<PlHomeScreenController> {
  final dynamic bank;
  final int index;

  const BankCard({super.key, required this.bank, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.compareBankList.contains(bank);

      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey,
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                /// LOGO (fallback handled)
                _buildBankLogo(),

                12.horizontalSpace,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bank.bankName ?? '', style: kw500Black16),

                      6.verticalSpace,

                      /// TAG
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kffDCFCE7,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Personal Loan",
                          style: kw50015803D11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            16.verticalSpace,

            /// SALARY + RATE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoItem(value: "${bank.minimumSalary}", label: "Min Salary"),
                _infoItem(value: "${bank.flatRate}%", label: "Flat Rate"),
              ],
            ),

            16.verticalSpace,

            /// BUTTON ROW
            Row(
              children: [
                /// COMPARE BUTTON
                Expanded(
                  child: AgButton(
                    isEnabled: controller.homeBankList.length > 1,
                    title: isSelected ? "Selected" : "Compare",
                    onTap: () => controller.toggleCompare(bank),
                    isOutlined: true,
                  ),
                ),

                12.horizontalSpace,

                /// APPLY BUTTON (Gradient)
                Expanded(
                  child: AgButton(
                    title: "Apply Now",
                    onTap: () => controller.applyBank(bank),
                  ),
                ),
              ],
            ),

            12.verticalSpace,

            /// MORE INFO
            Center(
              child: GestureDetector(
                onTap: () {
                  _showMoreInfo(context);
                  controller.getFeatures(bank.productCode ?? '');
                },
                child: Text(
                  "More Info",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /// ---------------- LOGO ----------------
  Widget _buildBankLogo() {
    final url = (bank.bankLogo ?? '').toString().addBaseUrl;

    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          height: 44.h,
          width: 44.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(),
        ),
      );
    }

    return _defaultIcon();
  }

  Widget _defaultIcon() {
    return Container(
      height: 44.h,
      width: 44.w,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.account_balance, color: Colors.blue),
    );
  }

  /// ---------------- INFO ITEM ----------------
  Widget _infoItem({required String value, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: kw500Black16),
        4.verticalSpace,
        Text(label, style: kw400Black12),
      ],
    );
  }

  /// ---------------- MORE INFO SHEET ----------------
  void _showMoreInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  /// 🔥 STICKY HEADER (NOT SCROLLING)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "More Info",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),

                  const Divider(),

                  /// 🔥 SCROLLABLE AREA
                  Expanded(
                    child: Obx(() {
                      if (controller.isFeaturesLoading.value) {
                        /// 🔥 LOADER UI
                        return const Center(child: AppLoader());
                      }

                      /// 🔥 ACTUAL CONTENT
                      return ListView(
                        controller: scrollController,
                        children: [
                          /// BANK HEADER
                          Row(
                            children: [
                              _buildBankLogo(),
                              12.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bank.bankName ?? '',
                                      style: kw500Black16,
                                    ),
                                    6.verticalSpace,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Personal Loan",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          16.verticalSpace,

                          /// FEATURES LIST
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.tabItems.length,
                            itemBuilder: (_, i) {
                              return Obx(() {
                                final isOpen = controller.openTabs.contains(i);

                                return GestureDetector(
                                  onTap: () {
                                    if (isOpen) {
                                      controller.openTabs.remove(i);
                                    } else {
                                      controller.openTabs.add(i);
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding: EdgeInsets.all(14.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              controller.tabItems[i].title,
                                              style: kw500Black16,
                                            ),
                                            Icon(
                                              isOpen
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                            ),
                                          ],
                                        ),

                                        if (isOpen) ...[
                                          10.verticalSpace,
                                          containsHtml(
                                                controller.tabItems[i].subTitle,
                                              )
                                              ? Html(
                                                data:
                                                    controller
                                                        .tabItems[i]
                                                        .subTitle,
                                                style: {
                                                  "body": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                    fontSize: FontSize(
                                                      kw400Black12.fontSize ??
                                                          12,
                                                    ),
                                                    fontWeight:
                                                        kw400Black12.fontWeight,
                                                    fontFamily:
                                                        kw400Black12.fontFamily,
                                                    color: kw400Black12.color,
                                                  ),
                                                  "p": Style(
                                                    margin: Margins.zero,
                                                    padding: HtmlPaddings.zero,
                                                  ),
                                                },
                                              )
                                              : Text(
                                                controller.tabItems[i].subTitle,
                                                style: kw400Black12,
                                              ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool containsHtml(String text) {
    return RegExp(r'<[^>]*>').hasMatch(text);
  }
}
