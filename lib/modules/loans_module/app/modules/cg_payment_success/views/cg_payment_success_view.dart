import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../app_environment.dart';
import '../../../components/ui/app_loader.dart';
import '../../../data/local/store/local_store.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/cg_payment_success_controller.dart';

class CgPaymentSuccessView extends GetView<CgPaymentSuccessController> {
  const CgPaymentSuccessView({super.key});
  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      await Get.offAllNamed<void>(Routes.HOME);
      return true;
    },
    child: Scaffold(
      appBar: AgAppbar(title: 'Application Submission'),
      body: Obx(
        () => Visibility(
          visible: controller.isLoading.isFalse,
          replacement: const Center(child: AppLoader()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: generateLayout())],
          ),
        ),
      ).paddingSymmetric(vertical: 20),
    ),
  );

  Widget generateLayout() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Get.width.horizontalSpace,
      // 40.verticalSpace,
      Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.primary,
          border: Border.all(color: AppColors.grey.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(36, 36, 36, 36),
          child: Image.asset(
            'assets/images/ThumbsUpCongrats.png',
            fit: BoxFit.contain,
            color: AppColors.primary,
            package: AppEnvironment.packageName,
          ),
        ),
        // Icon(Icons.thumb_up_alt_rounded,size: 120,color: highlightGreenColor,),
      ),
      30.verticalSpace,
      ((controller.args.catType == 'CG' ||
                  controller.args.catType == 'WHITE_GOODS') &&
              controller.args.isFinance == false)
          ? Text.rich(
            TextSpan(
              // text: 'Your loan request reference No.', // default text style
              children: <TextSpan>[
                TextSpan(
                  text: 'Your loan request reference No.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: ' ${controller.Refference ?? ''} ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: 'is submitted to finance partner.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 15)
          : ((controller.args.catType == 'REAL_ESTATE' ||
                  controller.args.catType == 'Auto' ||
                  controller.args.catType == 'AUTO') &&
              controller.args.isFinance == false)
          ? Text.rich(
            TextSpan(
              // text: 'Your loan request reference No.', // default text style
              children: <TextSpan>[
                TextSpan(
                  text: 'Your loan request reference No',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: ' ${controller.Refference ?? ''} ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: 'is submitted to finance partner.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 15)
          // Text(
          //   'Your loan request reference No.  ${controller.Refference ?? ''}  is submitted to finance partner.',
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.w600,
          //     fontFamily: 'Metropolis',
          //     color: AppColors.black,
          //   ),
          //   textAlign: TextAlign.center,
          // ).paddingSymmetric(horizontal: 15)
          : const Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: 'Metropolis',
              color: AppColors.black,
            ),
          ),
      30.verticalSpace,
      ((controller.args.catType == 'CG' ||
                  controller.args.catType == 'WHITE_GOODS') &&
              controller.args.isFinance == true)
          ? Column(
            children: [
              Text(
                'Your payment is processed successfully.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              Text(
                controller.Refference ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              Text(
                'We are so grateful for the opportunity to have served you',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Text('Thank you for shopping with us!', style: kw600Black18),
              20.verticalSpace,
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 16)
          : ((controller.args.catType == 'REAL_ESTATE' ||
                  controller.args.catType == 'Auto' ||
                  controller.args.catType == 'AUTO') &&
              controller.args.isFinance == true)
          ? Column(
            children: [
              Text(
                'Your payment is processed successfully.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              10.verticalSpace,
              Text(
                'We are so grateful for the opportunity to have served you',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              20.verticalSpace,
              Text(
                'Thank you for shopping with us!',
                style: kTitleMetropolis18,
              ),
              20.verticalSpace,
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 16)
          : ((controller.args.catType == 'REAL_ESTATE' ||
                  controller.args.catType == 'Auto' ||
                  controller.args.catType == 'AUTO' ||
                  controller.args.catType == 'CG' ||
                  controller.args.catType == 'WHITE_GOODS') &&
              controller.args.isFinance == false)
          ? const Text(
            'We will notify you once your request is approved',
            style: kSubTitleMetropolis14,
            textAlign: TextAlign.center,
          )
          : controller.Refference.isEmpty
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your order will be delivered soon.',
                style: kSubTitleMetropolis14,
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Order Number: ',
              //       style: kSubTitleMetropolis14,
              //       textAlign: TextAlign.center,
              //     ),
              //     Text(
              //       (controller.args.orderId ?? controller.Refference),
              //       style: kTitleMetropolis16,
              //       textAlign: TextAlign.center,
              //     ),
              //   ],
              // ),
            ],
          )
          : Text.rich(
            TextSpan(
              // text: 'Your loan request reference No.', // default text style
              children: <TextSpan>[
                TextSpan(
                  text: 'Your order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: ' ${controller.Refference ?? ''} ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
                TextSpan(
                  text: 'will be delivered soon.\nThank You!.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Metropolis',
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ).paddingSymmetric(horizontal: 15),
      30.verticalSpace,
      Container(
        margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
        height: 44,
        child: AgButton(
          onTap:
              () async => {
                // String prefs = await SharedPreferences.getInstance();
                //   prefs.setString("UserPhone", userMobileNumber);
                if (controller.args.catType == 'REAL_ESTATE' ||
                    controller.args.catType == 'Auto' ||
                    controller.args.catType == 'AUTO')
                  {
                    if (LocalStore.thirdParty == 'AUTO')
                      {
                        Get.toNamed(Routes.AUTO_LOAN_HISTORY),
                        LocalStore.thirdParty = '',
                      }
                    else if (LocalStore.thirdParty == 'REAL_ESTATE')
                      {
                        Get.toNamed(Routes.REAL_ESTATE_LOAN_HISTORY),
                        LocalStore.thirdParty = '',
                      }
                    else
                      {
                        Get.offAllNamed(
                          Routes.AUTO_ORDERS,
                          arguments: [false, controller.args.catType],
                        ),
                      },
                  }
                else
                  {Get.offAllNamed(Routes.ORDER)},
              },
          title:
              (controller.args.catType == 'CG' ||
                      controller.args.catType == 'WHITE_GOODS')
                  ? 'Track Order'
                  : (controller.args.catType == 'REAL_ESTATE' ||
                      controller.args.catType == 'Auto' ||
                      controller.args.catType == 'AUTO')
                  ? 'Track Application'
                  : 'Track Order',
          // buttonSize: Size.fromWidth(Get.width / 3),
        ),
      ),
      20.verticalSpace,
      AgButton(
        onTap: () {
          Get.offAllNamed(Routes.HOME);
        },
        title: 'Explore Loans',
      ),
    ],
  );
}
