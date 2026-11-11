import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/image_hendle.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/credit_final_submit_controller.dart';

class CreditFinalSubmitView extends GetView<CreditFinalSubmitController> {
  const CreditFinalSubmitView({super.key});
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      await Get.offAllNamed<void>(Routes.HOME);
      return true;
    },
    child: Scaffold(
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: 1.sw,
                margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
                child: Column(
                  children: [
                    20.verticalSpace,
                    ImageHandle(
                      url:
                          controller.resp.value.cardImage?.url?.addBaseUrl ??
                          '',
                      padding: EdgeInsets.zero,
                      size: Size(150.w, 100.h),
                      radius: 1.r,
                    ),
                    10.verticalSpace,
                    Text(
                      controller.resp.value.bankName ?? '',
                      style: kw600Black16,
                    ),
                    10.verticalSpace,
                    const Text('Thank you!', style: kSubTitleMetropolis14),
                    10.verticalSpace,
                    const Text(
                      'Your Application Reference Number:',
                      style: kSubTitleMetropolis14,
                    ),
                    10.verticalSpace,
                    Text(
                      controller.resp.value.creditCardCode ?? '',
                      style: kTitleMetropolis16,
                    ),
                    30.verticalSpace,
                    Center(
                      child: Align(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Thank you for applying for the ${controller.resp.value.bankName ?? ''} Credit Card.',
                          style: kSubTitleMetropolis14,
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    const Center(
                      child: Align(
                        child: Text(
                          textAlign: TextAlign.center,
                          'We have successfully captured your Card application, unfortunately a decision cannot be reached at this point of time.',
                          style: kSubTitleMetropolis14,
                        ),
                      ),
                    ),
                    30.verticalSpace,
                    const Center(
                      child: Align(
                        child: Text(
                          textAlign: TextAlign.center,
                          'We will finalise your application as soon as possible and you will hear from us within the next 5 to 10 business days.',
                          style: kSubTitleMetropolis14,
                        ),
                      ),
                    ),
                    30.verticalSpace,

                    AgButton(
                      title: 'Track Application',
                      onTap: () {
                        Get.toNamed(Routes.CREDITCARD_HISTORY);
                      },
                    ),
                    15.verticalSpace,
                    AgButton(
                      isOutlined: true,
                      title: 'Explore Loans',
                      onTap: () => Get.offAllNamed<void>(Routes.HOME),
                    ),
                    15.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
