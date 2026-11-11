import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';

import '../controllers/auto_loan_track_order_status_controller.dart';

class AutoLoanTrackOrderStatusView
    extends GetView<AutoLoanTrackOrderStatusController> {
  const AutoLoanTrackOrderStatusView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AgAppbar(title: 'Loan Status'),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: ListView.builder(
            itemCount: controller.applicationSubmitted.length,
            itemBuilder: (context, index) {
              final item = controller.applicationSubmitted[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Timeline Indicator
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color:
                                item.application == true
                                    ? AppColors.primary
                                    : AppColors.grey,
                            width: 4,
                          ),
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 60,
                        color:
                            item.application == true
                                ? AppColors.primary
                                : AppColors.grey,
                      ),
                    ],
                  ),
                  20.horizontalSpace,

                  /// Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.value ?? '', style: kw400Black12),
                      5.verticalSpace,
                      Text(
                        '${item.date ?? ''} ${item.time ?? ''}',
                        style: kw400Black12,
                      ),
                      10.verticalSpace,
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
