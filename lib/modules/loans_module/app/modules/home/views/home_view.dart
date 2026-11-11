import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';

import '../../../app_environment.dart';
import '../../../data/model/loan/loan_type.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AgAppbar(
      title: "Loans",
      centerTitle: true,
      showLeadingIcon: AppEnvironment.isEmbeddedInHostApp,
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: AppColors.k727272,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    right: kIsWeb ? 8.sp : 12.sp,
                    left: kIsWeb ? 8.sp : 12.sp,
                  ),
                  itemCount: controller.loanList.length,
                  itemBuilder:
                      (_, index) => _loanCard(controller.loanList[index]),
                  separatorBuilder: (context, index) => 10.verticalSpace,
                ),
                1.verticalSpace,
                emiCalculator(),
                10.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _loanCard(LoanType data) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.sp),
      child: SizedBox(
        height: kIsWeb ? 400.h : 200.h,
        width: kIsWeb ? 220.w : 90.w,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(data.image!, fit: BoxFit.cover),

            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    data.backgroundColor1!,
                    data.backgroundColor2!.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(kIsWeb ? 10.sp : 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconChip(icon: data.icon!),
                  16.verticalSpace,
                  Text(
                    data.name!,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: kIsWeb ? 8.sp : 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                  4.verticalSpace,

                  Text(
                    data.subTitle!,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.85),
                      fontSize: kIsWeb ? 5.sp : 13.sp,
                    ),
                  ),
                  Spacer(),

                  _ApplyButton(
                    label: "Apply Now",
                    onTap: () => controller.onLoanSelected(data),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget emiCalculator() {
    return Padding(
      padding: EdgeInsets.all(kIsWeb ? 8.sp : 12.sp),
      child: Container(
        padding: EdgeInsets.all(kIsWeb ? 15.sp : 20.sp),
        height: kIsWeb ? 400.h : 160.h,
        width: kIsWeb ? 300.w : 350.w,
        decoration: BoxDecoration(
          color: AppColors.kF97316,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12.sp),
                  ),
                  child: Icon(
                    Icons.calculate_outlined,
                    color: AppColors.white,
                    size: kIsWeb ? 8.sp : 28.sp,
                  ),
                ),

                14.horizontalSpace,

                Text(
                  'EMI Calculator',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: kIsWeb ? 8.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                12.horizontalSpace,
              ],
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Calculate your monthly payments',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: kIsWeb ? 5.sp : 13.sp,
                    ),
                  ),
                ),
                kIsWeb ? 5.horizontalSpace : 30.horizontalSpace,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed<void>(Routes.PL_CHECK_EMI),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      side: const BorderSide(
                        color: AppColors.white,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: kIsWeb ? 8.sp : 18.sp,
                        vertical: kIsWeb ? 8.sp : 12.sp,
                      ),
                    ),
                    child: Text(
                      'Calculate',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: kIsWeb ? 8.sp : 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  final Icon icon;
  const _IconChip({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: icon,
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const _ApplyButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kIsWeb ? 60.h : 40.h,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: kIsWeb ? 8.sp : 15.sp,
          ),
        ),
      ),
    );
  }
}
