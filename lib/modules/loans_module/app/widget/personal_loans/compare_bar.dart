import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../components/ui/ag_button.dart';
import '../../data/remote/provider/personal_loan/pl_bank_detils.dart';
import '../../modules/pl_compare_product/controllers/pl_compare_product_controller.dart';

class CompareBar extends StatelessWidget {
  final List<PlBankDetils> banks;
  final VoidCallback onClear;

  const CompareBar({super.key, required this.banks, required this.onClear});

  @override
  Widget build(BuildContext context) {
    /// ✅ SHOW when >= 1
    if (banks.isEmpty) return const SizedBox();

    final isEnabled = banks.length >= 2;

    return SafeArea(
      top: false,
      child: Container(
        height: 90.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2A3A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// TEXT
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${banks.length} bank${banks.length > 1 ? 's' : ''} selected",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
                4.verticalSpace,
                Text(
                  isEnabled ? "Compare Offers" : "Select one more bank",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            /// BUTTON
            GestureDetector(
              onTap: () {
                if (!isEnabled) {
                  Get.snackbar(
                    "Select 2 Banks",
                    "Please select at least two banks to compare",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                _showCompareBottomSheet(banks);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  "View Comparison",
                  style: TextStyle(
                    color: isEnabled ? Colors.black : Colors.black45,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 SAME FUNCTION (UNCHANGED)
  void _showCompareBottomSheet(List<PlBankDetils> banks) {
    final controller = Get.put(PlCompareProductController());

    controller.compareBankList.assignAll(banks);
    controller.getCompareData();

    Get.bottomSheet(
      FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Compare Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: const Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const Expanded(child: _CompareContent()),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _CompareContent extends GetView<PlCompareProductController> {
  const _CompareContent();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      /// LOADING
      if (controller.isLoading.value) {
        return const Center(child: AgLoader());
      }

      /// NO DATA
      if (controller.compareProdcuts.value.productDetails?.isEmpty ?? true) {
        return const Center(child: Text("No Data available"));
      }

      final products = controller.compareProdcuts.value.productDetails!;
      final attrs = controller.compareProdcuts.value.attrs ?? [];

      return Column(
        children: [
          /// 🔥 STICKY BANK HEADER (NEW)
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  products.map((e) {
                    return Column(
                      children: [
                        _buildBankLogo(e.bankLogo),
                        8.verticalSpace,
                        SizedBox(
                          width: 120.w,
                          child: Text(
                            e.bankName ?? '',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),

          /// 🔥 SCROLLABLE ATTRIBUTES ONLY
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  ...attrs.map((e) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.key ?? '',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        8.verticalSpace,

                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children:
                                e.compValues!.map((value) {
                                  return Expanded(
                                    child: Center(
                                      child: Text(
                                        value.values?.firstWhereOrNull(
                                              (e) => true,
                                            ) ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        16.verticalSpace,
                      ],
                    );
                  }).toList(),

                  20.verticalSpace,
                ],
              ),
            ),
          ),

          /// 🔥 STICKY APPLY BUTTONS
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _applyButton(
                    isPrimary: true,
                    onTap: () => _handleApply(products[0]),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: _applyButton(
                    isPrimary: false,
                    onTap: () => _handleApply(products[1]),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// APPLY BUTTON UI
  Widget _applyButton({required bool isPrimary, required VoidCallback onTap}) {
    return AgButton(
      title: "Apply Now",
      onTap: onTap,
      height: 48.h,
      borderRadius: 12.r,

      /// PRIMARY → solid color
      backgroundColor: isPrimary ? AppColors.primary : Colors.white,

      /// SECONDARY → outlined
      isOutlined: !isPrimary,
      outlineColor: AppColors.primary,

      /// TEXT STYLE
      textStyle: TextStyle(
        color: isPrimary ? Colors.white : AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  /// APPLY ACTION
  void _handleApply(dynamic product) {
    controller.checkBank();
  }

  /// BANK LOGO
  Widget _buildBankLogo(String? logo) {
    final url = (logo ?? '').toString();

    if (url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          url.addBaseUrl,
          height: 50.h,
          width: 50.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultIcon(),
        ),
      );
    }

    return _defaultIcon();
  }

  /// DEFAULT ICON
  Widget _defaultIcon() {
    return Container(
      height: 50.h,
      width: 50.w,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Icon(Icons.account_balance),
    );
  }
}
