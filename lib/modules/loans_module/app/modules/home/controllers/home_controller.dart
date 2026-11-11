import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../data/constants/app_assets.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/model/loan/loan_type.dart';
import '../../../routes/app_pages.dart';
import '../../../session/session_manager.dart';
import '../../../utils/app_colors.dart';

class HomeController extends GetxController {
  final List<LoanType> loanList = [
    LoanType(id: 1, name: "Ezy Personal Loan", image: AppAssets.loanPersonalBg,backgroundColor1: AppColors.k155DFC,backgroundColor2:AppColors.k1C398E,icon: Icon(Icons.person,size: kIsWeb ? 15.sp :22.sp,color: AppColors.white,),subTitle: "Quick approval, flexible terms"),
    LoanType(id: 2, name: "Ezy Auto Loan", image: AppAssets.loanAutoBg,backgroundColor1: AppColors.k9810FA, backgroundColor2:AppColors.k59168B,icon: Icon(Icons.directions_car,size: kIsWeb ? 15.sp : 22.sp,color: AppColors.white),subTitle: "Drive your dream car today"),
    LoanType(id: 3, name: "Ezy Home Loan", image: AppAssets.loanHomeBg,backgroundColor1: AppColors.k009689, backgroundColor2:AppColors.k0B4F4A,icon: Icon(Icons.home,size:kIsWeb ? 15.sp :  22.sp,color: AppColors.white),subTitle: "Build your future, own your home"),
    LoanType(id: 4, name: "Ezy Credit Card", image: AppAssets.loanCreditCardBg,backgroundColor1: AppColors.k63AF23,backgroundColor2:AppColors.k63AF23,icon: Icon(Icons.credit_card,size: kIsWeb ? 15.sp : 22.sp,color: AppColors.white),subTitle: "Get instant cashback"),
  ];

  /// Handle Loan Click
  Future<void> onLoanSelected(LoanType data) async {
    switch (data.id) {
      case 1:
        LocalStore.loanRefId('');
        Get.toNamed(Routes.BORROW_AMT);
        break;

      case 2:
        Get.toNamed(Routes.AUTO_VEHICLE_FORM);
        break;

      case 3:
        Get.toNamed(Routes.PROPERTY_FORM);
        break;

      case 4:
        final value = await Get.toNamed<dynamic>(Routes.CREDIT_GET_START);

        if (value is bool && value) {
          LocalStore.isCreditCard(false);
        }
        break;

      default:
        break;
    }
  }

  void showLogoutPopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Alert!',
              style: TextStyle(
                color: AppColors.kff0000,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Text(
            'Are you sure? Do you want to logout?',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('No', style: kw600Black16),
            ),

            const SizedBox(width: 16),

            TextButton(
              onPressed: () async {
                Get.back();
                await Get.find<SessionManager>().exitModule();
              },
              child: Text('Yes', style: kw600Black16),
            ),
          ],
        );
      },
    );
  }
}
