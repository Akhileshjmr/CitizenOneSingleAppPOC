
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/creditcard_track_controller.dart';

class CreditcardTrackView extends GetView<CreditcardTrackController> {
  const CreditcardTrackView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kffffff,
    appBar: /*AppBar(
      backgroundColor: AppColors.kC5E4A2,
      //foregroundColor: Colors.black,
      bottomOpacity: 0.0,
      elevation: 0.0,
      leading: const AppBackButton(),
      title: const Text(
        'Credit Cards Status',
        style: kTitleMetropolis14,
      ),
    ),*/
    AppBar(
      elevation: 2,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.black,
      leadingWidth: 50,
      titleSpacing: 0.9,
      title: const Text(
        'Credit Cards Status',
        style: kTitleMetropolis14,
      ),
      leading: Builder(
        builder: (BuildContext context) => IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: AppColors.k231F20,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
    ),
    body:
   Obx(() =>
        Visibility(
          visible: controller.isLoading.isFalse,
          replacement: const Center(
            child: AppLoader(),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  decoration:  const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                  ),
                  alignment: Alignment.center,
                  height: 120,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      16.verticalSpace,
                      Container(
                        child: Container(
                          decoration:  BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                                color: (controller.ccStatus.value?.applicationStatus == 'Submitted To Bank')
                                    ? AppColors.primary
                                    : AppColors.white,
                                width: 2),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                          ),
                          width: 30.w,
                          height: 30.h,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '✔',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Metropolis',
                                color: (controller.ccStatus.value?.applicationStatus == 'Submitted To Bank')
                                 ? AppColors.primary
                                    : AppColors.white,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Submitted To Bank',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Metropolis',
                            color: (controller.ccStatus.value?.applicationStatus == 'Submitted To Bank')
                               ? AppColors.primary
                                    : AppColors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Center(
                child: Container(
                  decoration:  const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                  ),
                  alignment: Alignment.center,
                  height: 120,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      16.verticalSpace,
                      Container(
                        child: Container(
                          decoration:  BoxDecoration(
                            color: AppColors.black,
                            border: Border.all(
                                color: (controller.ccStatus.value?.applicationStatus == 'In Process')
                                   ? AppColors.primary
                                    : AppColors.white,
                                width: 2),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                          ),
                          width: 30.w,
                          height: 30.h,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '✔',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Metropolis',
                                color: (controller.ccStatus.value?.applicationStatus == 'In Process')
                                    ? AppColors.primary
                                    : AppColors.white,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'In Process',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Metropolis',
                            color: (controller.ccStatus.value?.applicationStatus == 'In Process')
                               ? AppColors.primary
                                    : AppColors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              20.verticalSpace,
              Center(
                child: Container(
                  decoration:  const BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                  ),
                  alignment: Alignment.center,
                  height: 120,
                  width: 200,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      16.verticalSpace,
                      Container(
                        child: Container(
                          decoration:  BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(
                                color: (controller.ccStatus.value?.applicationStatus == 'Approved')
                                   ? AppColors.primary
                                    : AppColors.white,
                                width: 2),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                          ),
                          width: 30.w,
                          height: 30.h,
                          child:  Align(
                            alignment: Alignment.center,
                            child: Text(
                              '✔',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Metropolis',
                                color: (controller.ccStatus.value?.applicationStatus == 'Approved')
                                  ? AppColors.primary
                                    : AppColors.white,
                                height: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Approved',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'Metropolis',
                            color: (controller.ccStatus.value?.applicationStatus == 'Approved')
                             ? AppColors.primary
                                    : AppColors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    ),
  );
}
