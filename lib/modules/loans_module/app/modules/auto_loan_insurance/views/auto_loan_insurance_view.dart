import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../data/model/args/insurance_detail_args.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auto_loan_insurance_controller.dart';

class AutoLoanInsuranceView extends GetView<AutoLoanInsuranceController> {
  const AutoLoanInsuranceView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Insurance'),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 32, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('My car is: ', style: kw400Black14),
                  Text(controller.vehicleName ?? '', style: kw600Black16),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('Condition : ', style: kw400Black14),
                  Text(controller.vehicleCondition, style: kw600Black16),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('Vehicle description: ', style: kw400Black14),
                  Text('${(controller.vehicleDesc)}', style: kw600Black16),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('Vehicle type: ', style: kw400Black14),
                  Text('${(controller.vehicleType)}', style: kw600Black16),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('Vehicle manufacturing year: ', style: kw400Black14),
                  Text(
                    '${(controller.vehicleMakingYear)}',
                    style: kw600Black16,
                  ),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('Vehicle Color: ', style: kw400Black14),
                  Text('${(controller.vehicleColor)}', style: kw600Black16),
                ],
              ),
              20.verticalSpace,
              Row(
                children: [
                  Text('will be registered in: ', style: kw400Black14),
                  Text('Dubai', style: kw400Black14),
                ],
              ),
              // 20.verticalSpace,
              // Row(
              //   children: [
              //     Text('I ve been driving for 2 years in UAE',style: kSubliteMetropolis14),
              //   ],
              // ),
              32.verticalSpace,
              AppTextField(
                controller: controller.nameC,
                name: 'Customer Name',
                label: 'Customer Name',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  LengthLimitingTextInputFormatter(50),
                ],
              ),
              20.verticalSpace,
              AppTextField(
                controller: controller.mobileNoC,
                name: 'Customer Mobile Number',
                label: 'Customer Mobile Number',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AgButton(
        title: 'Calculate Premium',
        onTap: () async {
          await Get.toNamed(
            Routes.INSURANCE_DETAIL,
            arguments: InsurencDetailArgs(
              orderKey: controller.orderKey,
              leadId: controller.orderKey,
              loanamt: controller.amount,
              catType: controller.categoryType,
            ),
          );
        },
      ),
    );
  }
}
