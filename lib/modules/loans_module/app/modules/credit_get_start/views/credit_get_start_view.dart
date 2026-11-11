import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../app_environment.dart';
import '../../../data/constants/app_assets.dart';
import '../controllers/credit_get_start_controller.dart';

class CreditGetStartView extends GetView<CreditGetStartController> {
  const CreditGetStartView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: ""),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        10.verticalSpace,
        const Center(
          child: Text(
            'Find the right credit card for you.',
            style: kw600Black20,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 300.h,
          width: 1.sw,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Image.asset(
                AppAssets.getStartImg,
                fit: BoxFit.fill,
                package: AppEnvironment.packageName,
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Whether you want to pay less interest or earn more rewards, the right cards out there.Just answer a few questions and well narrow the search for you.',
                  style: kSubTitleMetropolis12,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: AgButton(
                      onTap: controller.onContinue,
                      title: 'Get Started',
                      isOutlined: true,
                    ),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 20.w),
        ),
      ],
    ),
  );
}
