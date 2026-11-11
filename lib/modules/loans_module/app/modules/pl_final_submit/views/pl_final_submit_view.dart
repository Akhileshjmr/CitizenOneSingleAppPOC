import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../../../routes/app_pages.dart';
import '../controllers/pl_final_submit_controller.dart';

class PlFinalSubmitView extends GetView<PlFinalSubmitController> {
  const PlFinalSubmitView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.settings.name == Routes.HOME);
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Obx(
          () => BaseScreen(
            isLoading: controller.isLoading.value,
            child: controller.hasError.value ? _errorView() : _successView(),
          ),
        ),
      ),
    );
  }

  Widget _successView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90.h,
              width: 90.w,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),

            24.verticalSpace,

            Text(
              "Application Submitted!",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            16.verticalSpace,

            Text(
              "Thank you for applying for the ${controller.resp.value.bankName ?? ''} Loan. "
              "We have successfully captured your loan application.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),

            12.verticalSpace,

            Text(
              "We will finalise your application as soon as possible and you will hear from us within the next 24 Hours.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),

            32.verticalSpace,

            Text(
              "REFERENCE NUMBER",
              style: TextStyle(
                fontSize: 12.sp,
                letterSpacing: 1,
                color: Colors.grey,
              ),
            ),

            8.verticalSpace,

            Text(
              controller.resp.value.refNumber ?? '',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            40.verticalSpace,

            AgButton(
              title: "Track Application",
              onTap: () {
                Get.toNamed(Routes.PL_HISTORY);
              },
            ),

            20.verticalSpace,

            GestureDetector(
              onTap: () {
                Get.offNamedUntil(
                  Routes.HOME,
                  (route) => route.settings.name == Routes.LOANS_LOGIN,
                );
              },
              child: Text(
                "Explore Loans",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90.h,
              width: 90.w,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 40),
            ),

            24.verticalSpace,

            Text(
              controller.errorTitle.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            16.verticalSpace,

            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),

            40.verticalSpace,

            AgButton(
              title: "Try Again",
              onTap: () {
                controller.checkBank(controller.tenure);
              },
            ),

            20.verticalSpace,

            GestureDetector(
              onTap: () {
                Get.until((route) => route.settings.name == Routes.HOME);
              },
              child: Text(
                "Go To Home",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
