import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/app_environment.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/data/constants/app_assets.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PreApprove/PreAproveHome/Categories.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/pre_approve_dashbord_controller.dart';

class PreApproveDashbordView extends GetView<PreApproveDashbordController> {
  const PreApproveDashbordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(title: 'Pre Approve'),
    body: Container(
      margin: EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Get Your Loan in 10 Mins',
            style: kTitleMetropolis14,
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
          10.verticalSpace,
          Center(
            child: Text(
              'A pre-approval letter helps you prove to real estate agents and sellers that you are credible buyer and able to act fast when you find the perfect home.',
              style: kSubTitleMetropolis12,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ),
          40.verticalSpace,
          // Expanded(
          //   child: GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //
          //       // childAspectRatio: 180.w / 160.h
          //     ),
          //     padding: REdgeInsets.symmetric(
          //       horizontal: 12,
          //     ),
          //     itemCount: 3, // <-- required
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       return getManufacture(index);
          //     },
          //   ),
          // ),
          /*CustomScrollView(
                        primary: false,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.all(5),
                            sliver: SliverGrid.count(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              topLeft: Radius.circular(4)),
                                          child: Image.network(
                                            controller
                                                    .categoriesData()
                                                    .categories?[0]
                                                    .mediaActions
                                                    ?.first
                                                    .urlAction
                                                    ?.url
                                                    .addBaseUrl ??
                                                '',
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    5.verticalSpace,
                                    Text(
                                      controller
                                              .categoriesData()
                                              .categories?[0]
                                              .name ??
                                          '',
                                      style: kTitleMetropolis16,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    10.verticalSpace,
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              topLeft: Radius.circular(4)),
                                          child: Image.asset(AppAssets.carLoan)),
                                    ),
                                    5.verticalSpace,
                                    Text('Car Loan',
                                      style: kTitleMetropolis16,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    10.verticalSpace,
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              topLeft: Radius.circular(4)),
                                          child: Image.asset(AppAssets.personalLoan)),
                                    ),
                                    5.verticalSpace,
                                    Text('Personal Loan',
                                      style: kTitleMetropolis16,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    10.verticalSpace,
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 120,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(40),
                                            topLeft: Radius.circular(40)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(4),
                                              topLeft: Radius.circular(4)),
                                          child: Image.asset(AppAssets.otherLoan)),
                                    ),
                                    5.verticalSpace,
                                    Text('Others',
                                      style: kTitleMetropolis16,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    10.verticalSpace,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )*/
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
              children:
                  List.generate(
                    4,
                    (index) =>
                        Center(child: getOtherManufacture('', '', index)),
                  ).toList(),
            ),
          ),
        ],
      ),
    ),
  );

  InkWell getManufacture(Categories catg) => InkWell(
    onTap: () {
      Get.toNamed<void>(
        Routes.PRE_APPROVE_FINACE_PARTNER,
        arguments: catg.key ?? '',
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.kffffff,
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(4),
              ),
              child: Image.network(
                catg.mediaActions?.first.urlAction?.url?.addBaseUrl ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          15.verticalSpace,
          Text(
            catg.name ?? '',
            style: kTitleMetropolis16,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          10.verticalSpace,
        ],
      ),
    ),
  );

  InkWell getOtherManufacture(String catg, String img, int index) => InkWell(
    onTap: () {
      if (index == 0 || index == 1) {
        Get.toNamed<void>(
          Routes.PRE_APPROVE_FINACE_PARTNER,
          arguments: [
            controller.categoriesData().categories?[0].key ?? '',
            controller.args,
          ],
        );
      } else {
        appSnackbar(
          message: 'Coming soon!',
          snackbarState: SnackbarState.success,
        );
      }
      //
    },
    child: Container(
      // height: 220,
      decoration: BoxDecoration(
        color: AppColors.kffffff,
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                topLeft: Radius.circular(4),
              ),
              child:
                  (index == 0)
                      ? Image.asset(
                        AppAssets.mortgageLoan,
                        height: 120,
                        // width: 150,
                        fit: BoxFit.cover,
                        package: AppEnvironment.packageName,
                      )
                      : Image.asset(
                        controller.imageList[index - 1],
                        height: 120,
                        // width: 150,
                        fit: BoxFit.cover,
                        package: AppEnvironment.packageName,
                      ),
            ),
          ),
          5.verticalSpace,
          (index == 0)
              ? Text(
                controller.categoriesData().categories?[0].name ??
                    'Mortgage Loan',
                style: kTitleMetropolis16,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
              : Text(
                controller.arrList[index - 1],
                style: kTitleMetropolis16,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          10.verticalSpace,
        ],
      ),
    ),
  );
}
