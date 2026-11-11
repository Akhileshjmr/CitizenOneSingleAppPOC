import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/str_ext.dart';

import '../../../components/ui/text_field/app_textfield.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../controllers/income_detail_controller.dart';

class IncomeDetailView extends GetView<IncomeDetailController> {
  const IncomeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Income Info'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Save',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap: () {
            if (controller.mode == 'Auto') {
              controller.onSubmit('auto/orders/save-profile-forms');
            } else if (controller.mode == 'CG') {
              controller.onSubmit('orders/cg/save-profile-forms');
            } else if (controller.mode == 'REAL_ESTATE') {
              controller.onSubmit('realestate/home/orders/save-profile-forms');
            } else {
              controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication);
            }
          },
        ),
        secondaryAction: ResponsiveFormAction(
          title: 'Back',
          onTap: () => Get.back(result: true),
          isOutlined: true,
        ),
        bodyBuilder:
            (context, isWide) => FormBuilder(
              key: controller.formKey,
              child: ResponsiveFormWrap(
                isWide: isWide,
                children: [
                  ResponsiveFormItem(child: _monthlyIncomeField()),
                  ResponsiveFormItem(child: _otherIncomeField()),
                  ResponsiveFormItem(child: _allowancesField()),
                  ResponsiveFormItem(child: _deductionsField()),
                ],
              ),
            ),
      ),
    );
  }

  Widget _monthlyIncomeField() {
    return AppTextField(
      name: 'Monthly Income',
      label: 'Monthly Income',
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'please enter salary income!';
        }
        if (value.areAllCharactersZero) {
          return 'enter valid income';
        }
        return null;
      },
      controller: controller.MonthlyIncomeController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _otherIncomeField() {
    return AppTextField(
      name: 'Other Income',
      label: 'Other Income',
      keyboardType: TextInputType.number,
      controller: controller.OtherIncomeController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _allowancesField() {
    return AppTextField(
      name: 'Allowances',
      label: 'Allowances',
      controller: controller.AllowancesController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _deductionsField() {
    return AppTextField(
      name: 'Deductions',
      label: 'Deductions',
      controller: controller.DeducationController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }
}
