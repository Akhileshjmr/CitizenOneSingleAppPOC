import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../theme/ag_text_styles.dart';
import '../../utils/app_colors.dart';

class EmiCalculator extends StatelessWidget {
  const EmiCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      width: 1.sw,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Text Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Calculate your', style: kw400Black14),
              Text('EMI', style: kw400Black14),
            ],
          ),

          /// Button
          SizedBox(
            height: 40.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
              ),
              onPressed: () {
                Get.toNamed<void>(Routes.PL_CHECK_EMI);
              },
              child: const Text("Check Now", style: kw500White14),
            ),
          ),
        ],
      ),
    );
  }
}
