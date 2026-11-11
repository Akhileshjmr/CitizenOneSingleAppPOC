import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/image_hendle.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/credit_home_controller.dart';

class CreditHomeView extends GetView<CreditHomeController> {
  CreditHomeView({Key? key}) : super(key: key);

  @override
  CreditHomeController controller = Get.put(CreditHomeController());

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: AppColors.kffffff,
    bottomNavigationBar: Obx(
      () => Visibility(
        visible: (controller.compareCardList.isEmpty) ? false : true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => {controller.compareCardList.clear()},
                icon: Icon(Icons.close),
              ),
            ),
            Visibility(
              visible:
                  (controller.compareCardList.length != 0 ||
                          controller.compareCardList.length == 1)
                      ? true
                      : false,
              child: Container(
                height: 200,
                color: AppColors.kffffff,
                width: 1.sw,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Visibility(
                        visible:
                            (controller.compareCardList.length > 0 ||
                                    controller.compareCardList.length == 1)
                                ? true
                                : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            10.horizontalSpace,
                            ImageHandle(
                              url:
                                  (controller.compareCardList.length != 0)
                                      ? controller
                                              .compareCardList[0]
                                              .cardImage
                                              ?.url
                                              .addBaseUrl ??
                                          ''
                                      : '',
                              padding: EdgeInsets.zero,
                              size: Size(80.w, 60.h),
                              radius: 1.r,
                            ),
                            5.verticalSpace,
                            Container(
                              width: 80,
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  (controller.compareCardList.length != 0)
                                      ? controller
                                              .compareCardList[0]
                                              .bankName ??
                                          ''
                                      : '',
                                  style: kSubTitleMetropolis12SemiBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Container(
                      width: 25.w,
                      height: 25.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.bgDark, width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'V/S',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Metropolis',
                            color: AppColors.black,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Visibility(
                            visible:
                                (controller.compareCardList.length > 0 ||
                                        controller.compareCardList.length == 2)
                                    ? true
                                    : false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                10.horizontalSpace,
                                ImageHandle(
                                  url:
                                      (controller.compareCardList.length != 0 &&
                                              controller
                                                      .compareCardList
                                                      .length >
                                                  1)
                                          ? controller
                                                  .compareCardList[1]
                                                  .cardImage
                                                  ?.url
                                                  .addBaseUrl ??
                                              ''
                                          : '',
                                  padding: EdgeInsets.zero,
                                  size: Size(80.w, 60.h),
                                  radius: 1.r,
                                ),
                                5.verticalSpace,
                                Container(
                                  width: 80,
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      (controller.compareCardList.length != 0 &&
                                              controller
                                                      .compareCardList
                                                      .length >
                                                  1)
                                          ? controller
                                                  .compareCardList[1]
                                                  .bankName ??
                                              ''
                                          : '',
                                      style: kSubTitleMetropolis12SemiBold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.horizontalSpace,
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.primary,
                        ),
                      ),
                      onPressed: () {
                        if (controller.compareCardList.length == 1) {
                          appSnackbar(
                            message: 'Please select another card to compare',
                            snackbarState: SnackbarState.warning,
                          );
                        } else {
                          Get.toNamed<void>(
                            Routes.CREDIT_COMPARE_CARDS,
                            arguments: controller.compareCardList,
                          );
                        }
                      },
                      child: const Text(
                        'Compare',
                        style: kTitleWhiteColorMetropolis14,
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
    appBar: AgAppbar(
      title: 'Cards',
      leadingIcon: Icons.chevron_left,
      leadingOnTap: () => Get.back(),
    ),

    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          child: Column(
            children: [
              10.verticalSpace,
              Row(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        height: 60,
                        margin: const EdgeInsets.fromLTRB(8, 0, 0, 18),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.k231F20,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20.0.r),
                        ),
                        width: MediaQuery.of(context).size.width - 60,
                        child:
                            (controller.selectedBenefitList.isEmpty)
                                ? Container(
                                  margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                  height: 15,
                                  child: Center(
                                    child: Text('No filters benefits found'),
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      controller.selectedBenefitList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          _buildSelectBankList(index, context),
                                ),
                      ),
                      Visibility(
                        visible:
                            controller.selectedBenefitList.isEmpty
                                ? false
                                : true,
                        child: Positioned(
                          top: 45,
                          child: Container(
                            width: 100.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                LocalStore.salary('1000');
                                controller.selectedBenefitList.clear();
                                controller.getBankList();
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CLEAR FILTER',
                                    style: kSubTitleMetropolis12,
                                  ),
                                  // Icon(
                                  //   IconData(
                                  //       (controller.isTabVisiblePosition.value == index) ? 0xe09a : 0xe098,
                                  //       fontFamily: 'MaterialIcons'),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.horizontalSpace,
                  Container(
                    // alignment: Alignment.center,
                    // color: Colors.transparent,
                    height: 40,
                    width: 40,
                    // color: Colors.grey.shade200,
                    // decoration: BoxDecoration(
                    //   // color: AppColors.k989A9A,
                    //     color: Colors.transparent,
                    //   borderRadius: BorderRadius.circular(40.0.r),
                    //   // border: Border()
                    // ),
                    child: GestureDetector(
                      onTap: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await Get.toNamed(
                          Routes.CREDIT_FILTERS,
                          arguments: [
                            prefs.get('associations'),
                            prefs.get('providers'),
                          ],
                        )?.then((dynamic value) async {
                          if (value is bool && value) {
                            // if (controller.selectedBenefitList.length >
                            //     1) {
                            //   await controller.getBankList();
                            // } else {
                            await controller.getBankList();
                            // }
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Filter',
                          //   style: kTitleMetropolis14,
                          // ),
                          Icon(
                            Icons.filter_list_alt,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       // width: 160.w,
                    //       height: 40.h,
                    //       color: AppColors.kffffff,
                    //       child:
                    //       ElevatedButton.icon(
                    //         icon: Icon(
                    //           Icons.keyboard_arrow_down_sharp,
                    //           color: AppColors.k000000,
                    //         ),
                    //         style: ButtonStyle(
                    //             backgroundColor: MaterialStateProperty.all(
                    //                 AppColors.kffffff)),
                    //         onPressed: () async {
                    //           await Get.toNamed(Routes.CREDIT_FILTERS)
                    //               ?.then((dynamic value) async {
                    //             if (value is bool && value) {
                    //               if (controller.selectedBenefitList.length >
                    //                   1) {
                    //                 await controller.getBankList('true');
                    //               } else {
                    //                 await controller.getBankList('');
                    //               }
                    //             }
                    //           });
                    //         },
                    //         label: const Text(
                    //           'Filter',
                    //           style: kTitleMetropolis14,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                  // Visibility(
                  //   visible: controller.selectedBenefitList.length == 0
                  //       ? false
                  //       : true,
                  //   child: ListView.builder(
                  //      shrinkWrap: true,
                  //      scrollDirection: Axis.horizontal,
                  //      itemCount:
                  //      controller.selectedBenefitList.length,
                  //      itemBuilder:
                  //          (BuildContext context, int index) =>
                  //          _buildSelectBankList(index, context),
                  //    )
                  //   // Column(
                  //   //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   //   children: [
                  //   //     20.verticalSpace,
                  //   //     Container(
                  //   //       // width: 1.sw,
                  //   //       child:
                  //   //       Stack(
                  //   //         alignment: AlignmentDirectional.bottomCenter,
                  //   //         children: [
                  //   //           Container(
                  //   //             margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  //   //             height: 80,
                  //   //             // width: 1.sw,
                  //   //             padding: EdgeInsets.only(top: 10, bottom: 20),
                  //   //             decoration: BoxDecoration(
                  //   //               color: Colors.white,
                  //   //               border: Border.all(
                  //   //                   color: Colors.grey.shade400, width: 2),
                  //   //               borderRadius:
                  //   //                   BorderRadius.all(Radius.circular(8.r)),
                  //   //             ),
                  //   //             child: ListView.builder(
                  //   //               shrinkWrap: true,
                  //   //               scrollDirection: Axis.horizontal,
                  //   //               itemCount:
                  //   //                   controller.selectedBenefitList.length,
                  //   //               itemBuilder:
                  //   //                   (BuildContext context, int index) =>
                  //   //                       _buildSelectBankList(index, context),
                  //   //             ),
                  //   //           ),
                  //   //           Positioned(
                  //   //             height: 30.h,
                  //   //             child: Container(
                  //   //               width: 90.w,
                  //   //               height: 40.h,
                  //   //               decoration: BoxDecoration(
                  //   //                 color: Colors.white,
                  //   //                 border: Border.all(
                  //   //                     color: Colors.grey.shade400, width: 2),
                  //   //                 borderRadius: const BorderRadius.all(
                  //   //                     Radius.circular(25)),
                  //   //               ),
                  //   //               child: GestureDetector(
                  //   //                 onTap: () async {
                  //   //                   controller.selectedBenefitList.clear();
                  //   //                 },
                  //   //                 child: Row(
                  //   //                   mainAxisAlignment:
                  //   //                       MainAxisAlignment.center,
                  //   //                   children: const [
                  //   //                     Text(
                  //   //                       'Clear Filter',
                  //   //                       style: kTitleMetropolis14,
                  //   //                     ),
                  //   //                   ],
                  //   //                 ),
                  //   //               ),
                  //   //             ),
                  //   //           ),
                  //   //         ],
                  //   //       ),
                  //   //     ),
                  //   //     20.verticalSpace
                  //   //   ],
                  //   // ),
                  // ),
                ],
              ),
              // Row(
              //   children: [
              //     Visibility(
              //         visible: controller.selectedBenefitList.length == 0
              //               ? false
              //               : true,
              //       child:  Container(
              //         height: 40,
              //         width: MediaQuery.of(context).size.width - 120,
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           scrollDirection: Axis.horizontal,
              //           itemCount:
              //               controller.selectedBenefitList.length,
              //           itemBuilder:
              //               (BuildContext context, int index) =>
              //                   _buildSelectBankList(index, context),
              //         ),
              //       ),
              //     ),10.horizontalSpace,
              //     Container(
              //       // alignment: Alignment.center,
              //       // color: AppColors.k002A7F,
              //       height: 40,
              //       width: 100,
              //       // color: Colors.grey.shade200,
              //       // decoration: BoxDecoration(
              //       //   // color: AppColors.k989A9A,
              //       //     color: Colors.transparent,
              //       //   borderRadius: BorderRadius.circular(40.0.r),
              //       //   // border: Border()
              //       // ),
              //       child: GestureDetector(
              //         onTap: () async {
              //           await Get.toNamed(Routes.CREDIT_FILTERS)
              //               ?.then((dynamic value) async {
              //             if (value is bool && value) {
              //               if (controller.selectedBenefitList.length >
              //                   1) {
              //                 await controller.getBankList('true');
              //               } else {
              //                 await controller.getBankList('');
              //               }
              //             }
              //           });
              //         },
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               'Filter',
              //               style: kTitleMetropolis14,
              //             ),
              //             Icon(Icons.keyboard_arrow_down_sharp),
              //           ],
              //         ),
              //       ),
              //       // Column(
              //       //   mainAxisAlignment: MainAxisAlignment.center,
              //       //   children: [
              //       //     Container(
              //       //       // width: 160.w,
              //       //       height: 40.h,
              //       //       color: AppColors.kffffff,
              //       //       child:
              //       //       ElevatedButton.icon(
              //       //         icon: Icon(
              //       //           Icons.keyboard_arrow_down_sharp,
              //       //           color: AppColors.k000000,
              //       //         ),
              //       //         style: ButtonStyle(
              //       //             backgroundColor: MaterialStateProperty.all(
              //       //                 AppColors.kffffff)),
              //       //         onPressed: () async {
              //       //           await Get.toNamed(Routes.CREDIT_FILTERS)
              //       //               ?.then((dynamic value) async {
              //       //             if (value is bool && value) {
              //       //               if (controller.selectedBenefitList.length >
              //       //                   1) {
              //       //                 await controller.getBankList('true');
              //       //               } else {
              //       //                 await controller.getBankList('');
              //       //               }
              //       //             }
              //       //           });
              //       //         },
              //       //         label: const Text(
              //       //           'Filter',
              //       //           style: kTitleMetropolis14,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //   ],
              //       // ),
              //     ),
              //
              //     // Visibility(
              //     //   visible: controller.selectedBenefitList.length == 0
              //     //       ? false
              //     //       : true,
              //     //   child: ListView.builder(
              //     //      shrinkWrap: true,
              //     //      scrollDirection: Axis.horizontal,
              //     //      itemCount:
              //     //      controller.selectedBenefitList.length,
              //     //      itemBuilder:
              //     //          (BuildContext context, int index) =>
              //     //          _buildSelectBankList(index, context),
              //     //    )
              //     //   // Column(
              //     //   //   crossAxisAlignment: CrossAxisAlignment.start,
              //     //   //   children: [
              //     //   //     20.verticalSpace,
              //     //   //     Container(
              //     //   //       // width: 1.sw,
              //     //   //       child:
              //     //   //       Stack(
              //     //   //         alignment: AlignmentDirectional.bottomCenter,
              //     //   //         children: [
              //     //   //           Container(
              //     //   //             margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
              //     //   //             height: 80,
              //     //   //             // width: 1.sw,
              //     //   //             padding: EdgeInsets.only(top: 10, bottom: 20),
              //     //   //             decoration: BoxDecoration(
              //     //   //               color: Colors.white,
              //     //   //               border: Border.all(
              //     //   //                   color: Colors.grey.shade400, width: 2),
              //     //   //               borderRadius:
              //     //   //                   BorderRadius.all(Radius.circular(8.r)),
              //     //   //             ),
              //     //   //             child: ListView.builder(
              //     //   //               shrinkWrap: true,
              //     //   //               scrollDirection: Axis.horizontal,
              //     //   //               itemCount:
              //     //   //                   controller.selectedBenefitList.length,
              //     //   //               itemBuilder:
              //     //   //                   (BuildContext context, int index) =>
              //     //   //                       _buildSelectBankList(index, context),
              //     //   //             ),
              //     //   //           ),
              //     //   //           Positioned(
              //     //   //             height: 30.h,
              //     //   //             child: Container(
              //     //   //               width: 90.w,
              //     //   //               height: 40.h,
              //     //   //               decoration: BoxDecoration(
              //     //   //                 color: Colors.white,
              //     //   //                 border: Border.all(
              //     //   //                     color: Colors.grey.shade400, width: 2),
              //     //   //                 borderRadius: const BorderRadius.all(
              //     //   //                     Radius.circular(25)),
              //     //   //               ),
              //     //   //               child: GestureDetector(
              //     //   //                 onTap: () async {
              //     //   //                   controller.selectedBenefitList.clear();
              //     //   //                 },
              //     //   //                 child: Row(
              //     //   //                   mainAxisAlignment:
              //     //   //                       MainAxisAlignment.center,
              //     //   //                   children: const [
              //     //   //                     Text(
              //     //   //                       'Clear Filter',
              //     //   //                       style: kTitleMetropolis14,
              //     //   //                     ),
              //     //   //                   ],
              //     //   //                 ),
              //     //   //               ),
              //     //   //             ),
              //     //   //           ),
              //     //   //         ],
              //     //   //       ),
              //     //   //     ),
              //     //   //     20.verticalSpace
              //     //   //   ],
              //     //   // ),
              //     // ),
              //   ],
              // ),
              20.verticalSpace,
              (controller.homeCardList.isEmpty)
                  ? Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                    height: 300,
                    child: Center(child: Text('No cards not found')),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: controller.homeCardList.length,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) => _buildCardList(
                          controller.homeCardList[index],
                          context,
                        ),
                  ).paddingOnly(bottom: 20),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildBankList(int index, BuildContext context) => Obx(
    () => GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  width: 1.sw,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 100,
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            ImageHandle(
                              url:
                                  controller
                                      .homeCardList[index]
                                      .cardImage
                                      ?.url
                                      .addBaseUrl ??
                                  '',
                              padding: EdgeInsets.zero,
                              size: Size(120.w, 80.h),
                              radius: 1.r,
                            ),
                            10.horizontalSpace,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                8.verticalSpace,
                                Text(
                                  controller.homeCardList[index].cardName ?? '',
                                  style: kTitleMetropolis20,
                                ),
                                Container(
                                  width: 150,
                                  child: Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      '${controller.homeCardList[index].bankName}' ??
                                          '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: kSubTitleMetropolis14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 180,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          children: [
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${CommonUtilities.AppCurrency} ${controller.homeCardList[index].minimumIncome}' ??
                                          '',
                                      style: kTitleMetropolis16,
                                    ),
                                    8.horizontalSpace,
                                    const Text(
                                      'Mininum Income',
                                      style: kSubTitleMetropolis12,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${controller.homeCardList[index].interestRate}%' ??
                                          '',
                                      style: kTitleMetropolis16,
                                    ),
                                    8.horizontalSpace,
                                    const Text(
                                      'Rate',
                                      style: kSubTitleMetropolis12,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller
                                              .homeCardList[index]
                                              .annualFee ??
                                          '',
                                      style: kTitleMetropolis16,
                                    ),
                                    8.horizontalSpace,
                                    const Text(
                                      'Annual Fee',
                                      style: kSubTitleMetropolis12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            30.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value:
                                            controller.compareCardList.contains(
                                                  controller
                                                      .homeCardList[index],
                                                )
                                                ? true
                                                : false,
                                        checkColor: Colors.grey,
                                        // color of tick Mark
                                        activeColor: AppColors.k282562,
                                        onChanged: (bool? result) async {
                                          if (controller.compareCardList
                                              .contains(
                                                controller.homeCardList[index],
                                              )) {
                                            controller.compareCardList.remove(
                                              controller.homeCardList[index],
                                            );
                                          } else {
                                            if (controller
                                                    .compareCardList
                                                    .length <
                                                2) {
                                              controller.compareCardList.add(
                                                controller.homeCardList[index],
                                              );
                                            } else {
                                              appSnackbar(
                                                message:
                                                    'You cannot compare more the two banks',
                                                snackbarState:
                                                    SnackbarState.warning,
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      const Text(
                                        'Compare',
                                        style: kTitleMetropolis16,
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 120.w,
                                  height: 40.h,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          (controller
                                                      .homeCardList[index]
                                                      .isApplied ==
                                                  false)
                                              ? MaterialStateProperty.all(
                                                AppColors.primaryDark,
                                              )
                                              : MaterialStateProperty.all(
                                                AppColors.primary,
                                              ),
                                    ),
                                    onPressed: () async {
                                      if (controller
                                              .homeCardList[index]
                                              .isApplied ==
                                          false) {
                                        LocalStore.bankId(
                                          controller.homeCardList[index].bankId
                                                  .toString() ??
                                              '',
                                        );
                                        LocalStore.productName(
                                          controller
                                                  .homeCardList[index]
                                                  .cardName
                                                  .toString() ??
                                              '',
                                        );
                                        LocalStore.productCode(
                                          controller
                                                  .homeCardList[index]
                                                  .cardCode
                                                  .toString() ??
                                              '',
                                        );
                                        LocalStore.creditCardType(
                                          controller
                                                  .homeCardList[index]
                                                  .creditCardType
                                                  .toString() ??
                                              '',
                                        );
                                        controller.getUpdateCC(
                                          controller
                                                  .homeCardList[index]
                                                  .cardName
                                                  .toString() ??
                                              '',
                                          controller
                                                  .homeCardList[index]
                                                  .bankName
                                                  .toString() ??
                                              '',
                                          controller.homeCardList[index].bankId
                                                  .toString() ??
                                              '',
                                          controller
                                                  .homeCardList[index]
                                                  .cardImage
                                                  ?.url
                                                  .toString() ??
                                              '',
                                        );
                                      } else {}
                                    },
                                    child: Text(
                                      (controller
                                                  .homeCardList[index]
                                                  .isApplied ==
                                              false)
                                          ? 'Apply Now'
                                          : 'Already Applied',
                                      style: kTitleWhiteColorMetropolis14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  height: 40.h,
                  child: Container(
                    width: 140.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.CREDIT_CARD_DEATILS,
                          arguments: controller.homeCardList[index],
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('More Details', style: kTitleMetropolis14),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildCardList(CreditCardsList card, BuildContext context) => Obx(
    () => Container(
      padding: REdgeInsets.all(8.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: card.cardImage?.url.addBaseUrl ?? '',
                height: 80,
                width: 120,
                fit: BoxFit.contain,
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.cardName ?? '', style: kTitleMetropolis18),
                    5.verticalSpace,
                    Text(
                      textAlign: TextAlign.center,
                      '${card.bankName}' ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: kSubTitleMetropolis14,
                    ),
                  ],
                ),
              ),
            ],
          ),
          10.verticalSpace,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeeContainer('Annual Fee', card.annualFee ?? ''),
                _buildFeeContainer('Joining Fee', card.joiningFees ?? ''),
                _buildFeeContainer(
                  'Cash Advance Fee',
                  card.cashAdvanceFee ?? '',
                ),
                _buildFeeContainer(
                  'Late Payment Charge',
                  card.latePaymentCharges ?? '',
                ),
              ],
            ),
          ),
          // 5.verticalSpace,
          // ExpansionTile(
          //   iconColor: Colors.black12,
          //   collapsedIconColor: Colors.black12,
          //   title: Text(
          //     card.reasons?.title ?? '',
          //     style: kTitleMetropolis14.copyWith(color: highlightGreenColor),
          //   ),
          //   children: card.reasons!.data!
          //       .map((e) => Row(
          //             children: <Widget>[
          //               const Icon(
          //                 Icons.check_circle_outline_rounded,
          //                 color: AppColors.k0AA976,
          //               ),
          //               5.horizontalSpace,
          //               Text(e.toString()),
          //             ],
          //           ))
          //       .toList(),
          // ),
          ExpansionTile(
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.primary,
            title: Text(
              card.benefits?.title ?? '',
              style: kTitleMetropolis14.copyWith(color: AppColors.k63AF23),
            ),
            children: [
              Wrap(
                spacing: 5.w,
                children:
                    card.benefits!.data!
                        .map(
                          (e) => Container(
                            padding: REdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: AppColors.bgDark,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              e.toString(),
                              style: kSubTitleMetropolis12,
                              maxLines: 5,
                              textAlign: TextAlign.start,
                            ),
                          ).paddingSymmetric(horizontal: 5, vertical: 3),
                          //     Chip(
                          //   label: Text(e.toString(),style: kSubTitleMetropolis12,maxLines: 5,),
                          //   padding: REdgeInsets.all(8.r),
                          //   backgroundColor: AppColors.kffffff,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5.r),
                          //       side: BorderSide(color: Colors.black12)),
                          // )
                        )
                        .toList(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (card.isApplied == false)
                          ? AppColors.primaryDark
                          : AppColors.primary,
                  fixedSize: Size(170.w, 35.h),
                ),
                onPressed: () async {
                  if (card.isApplied == false) {
                    LocalStore.bankId(card.bankId.toString() ?? '');
                    LocalStore.productName(card.cardName.toString() ?? '');
                    LocalStore.productCode(card.cardCode.toString() ?? '');
                    LocalStore.creditCardType(
                      card.creditCardType.toString() ?? '',
                    );
                    await controller.getUpdateCC(
                      card.cardName.toString() ?? '',
                      card.bankName.toString() ?? '',
                      card.bankId.toString() ?? '',
                      card.cardImage?.url.toString() ?? '',
                    );
                  } else {}
                },
                child: Text(
                  (card.isApplied == false) ? 'Apply Now' : 'Already Applied',
                  style: kTitleWhiteColorMetropolis14,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.compareCardList.contains(card)) {
                        controller.compareCardList.remove(card);
                      } else {
                        if (controller.compareCardList.length < 2) {
                          controller.compareCardList.add(card);
                        } else {
                          appSnackbar(
                            message: 'You cannot compare more the two banks',
                            snackbarState: SnackbarState.warning,
                          );
                        }
                      }
                    },
                    child: Icon(
                      controller.compareCardList.contains(card)
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank,
                      color: AppColors.k63AF23,
                    ),
                  ),
                  const Text(' Compare ', style: kTitleMetropolis14),
                ],
              ),
              // Checkbox(
              //   value: controller.compareCardList.contains(card)?true:false,
              //   checkColor: Colors.white,  // color of tick Mark
              //   activeColor: AppColors.k0AA976,
              //   onChanged: (bool? result) async {
              //     if (controller.compareCardList
              //         .contains(card)) {
              //       controller.compareCardList
              //           .remove(card);
              //     } else {
              //       if (controller.compareCardList.length < 2 ){
              //         controller.compareCardList
              //             .add(card);
              //       }else{
              //         appSnackbar(
              //           message: 'You cannot compare more the two banks',
              //           snackbarState: SnackbarState.warning,
              //         );
              //       }
              //     }
              //     result = !(result ?? false);
              //   },
              // ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    ).paddingSymmetric(horizontal: 10),
  );

  Widget _buildFeeContainer(String title, String value) => Column(
    children: [
      Container(
        width: 100,
        height: 34,
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: kTitleMetropolis14.copyWith(fontSize: 16),
        ),
      ),
      2.verticalSpace,
      Container(
        alignment: Alignment.center,
        margin: REdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        padding: REdgeInsets.all(10.r),
        width: 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.black),
        ),
        child: Text(
          value,
          style: kTitleMetropolis14.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );

  Widget _buildSelectBankList(int index, BuildContext context) =>
      GestureDetector(
        onTap: () async {
          // if (index == 1) {
          //   await Get.toNamed<void>(
          //     Routes.PL_FILTER_PRODUCT,
          //   );
          // }
        },
        child: Stack(
          children: [
            Container(
              // margin: const EdgeInsets.only(left: 10),
              height: 40,
              decoration: BoxDecoration(
                // color: Colors.grey.shade200,
                border: Border.all(color: AppColors.darkGrey),
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              // constraints: const BoxConstraints(
              //   maxWidth: 160,
              // ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      // width: 100,
                      child: Text(
                        controller.selectedBenefitList[index],
                        maxLines: 2,
                        style: kSubTitleMetropolis12,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    10.horizontalSpace,
                    Visibility(
                      visible: index != 0,
                      child: GestureDetector(
                        onTap: () {
                          // controller.selectedBenefitList.removeAt(index);
                          // if (controller.selectedBenefitList.length > 1) {
                          //   controller.getBankList();
                          // } else {
                          controller.getBankList();
                          // }
                        },
                        child: const Icon(
                          Icons.close,
                          color: AppColors.kff0000,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).paddingOnly(left: 10),
          ],
        ),
      );
}
