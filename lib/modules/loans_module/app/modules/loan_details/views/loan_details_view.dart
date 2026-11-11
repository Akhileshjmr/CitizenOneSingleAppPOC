import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';

import '../../../components/ui/text_field/app_textfield.dart';
import '../controllers/loan_details_controller.dart';

class LoanDetailsView extends GetView<LoanDetailsController> {
  const LoanDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Loan Details'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Save',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap: controller.onSubmit,
        ),
        secondaryAction: ResponsiveFormAction(
          title: 'Back',
          onTap: Get.back,
          isOutlined: true,
        ),
        bodyBuilder:
            (context, isWide) => FormBuilder(
              key: controller.loanFormKey,
              child: ResponsiveFormWrap(
                isWide: isWide,
                columns: 3,
                children: [
                  ResponsiveFormItem(child: _purposeField()),
                  ResponsiveFormItem(child: _loanAmountField()),
                  ResponsiveFormItem(child: _tenureField()),
                ],
              ),
            ),
      ),
    );
  }

  Widget _purposeField() {
    return AppTextField(
      controller: controller.loanPurposeController,
      name: 'loanPurpose',
      hintText: 'Purpose of Loan',
      title: 'Purpose of Loan *',
      keyboardType: TextInputType.text,
      validator: controller.loanPurposeValidators,
      inputType: AppTextInputType.stringOnly,
    );
  }

  Widget _loanAmountField() {
    return AppTextField(
      controller: controller.loanAmtController,
      name: 'loanAmount',
      hintText: 'Loan Amount',
      title: 'Loan Amount',
      keyboardType: TextInputType.number,
      maxLength: 8,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter loan amount';
        } else if (int.parse(value) == 0) {
          return 'Loan amount should be greater than 0';
        }
        return null;
      },
      inputType: AppTextInputType.numberOnly,
    );
  }

  Widget _tenureField() {
    return AppTextField(
      controller: controller.tenureController,
      name: 'tenure',
      hintText: 'Tenure',
      title: 'Tenure (Months) *',
      maxLength: 3,
      keyboardType: TextInputType.number,
      validator: controller.tenureValidators,
      inputType: AppTextInputType.numberOnly,
    );
  }
}
