import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/color_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/date_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/app_drop_down.dart';
import '../../../components/utils/app_utils.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../utils/app_colors.dart';
import '../controllers/p_r_emi_calculator_controller.dart';

class PREmiCalculatorView extends GetView<PREmiCalculatorController> {
  const PREmiCalculatorView({super.key});
  @override
  Widget build(BuildContext context) => Obx(
    () => Scaffold(
      appBar: AgAppbar(title: 'Eligibility Check'),
      body: FormBuilder(
        key: controller.formKey,
        child: ListView(
          padding: REdgeInsets.all(15),
          children: [
            AppTextField(
              name: 'date_of_birth',
              hintText: 'Date of birth',
              controller: controller.dobController,
              hasUnderLineBorder: true,
              suffixIcon: const Icon(Icons.calendar_month),
              readOnly: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please select date of birth.';
                }
                return null;
              },
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: controller.selectedDate(),
                  currentDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder:
                      (BuildContext context, Widget? child) => Theme(
                        data: ThemeData(
                          primarySwatch: AppColors.primary.toMaterialColor,
                        ),
                        child: child ?? const SizedBox.shrink(),
                      ),
                ).then((dynamic value) {
                  if (value is DateTime) {
                    controller.selectedDate(value);
                    controller.dobController.text = value.ddMMMyyyy.toString();
                    hideKeyboard();
                  }
                });
              },
            ),
            15.verticalSpace,
            AppTextField(
              inputType: AppTextInputType.numberOnly,
              name: 'Requested Finance Amount',
              label:
                  'Requested Finance Amount (${CommonUtilities.AppCurrency})*',
              // obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Requested Finance Amount';
                }
                return null;
              },
              controller: controller.reqFinAmtController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Monthly Income',
              inputType: AppTextInputType.numberOnly,
              label: 'Monthly Income (${CommonUtilities.AppCurrency})*',
              // obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter Monthly Income';
                }
                return null;
              },
              controller: controller.monthlyIncomeController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Other Income (If Any)',
              label: 'Other Income (${CommonUtilities.AppCurrency}) (If Any)*',
              inputType: AppTextInputType.numberOnly,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppDropDown(
              name: 'Nationality',
              labelText: 'Nationality',
              items: [
                ...(controller.nationalityOptions ?? <Options>[]).map(
                  (map) => DropdownMenuItem(
                    value: map.type.toString(),
                    onTap: () {
                      controller.nationality(map.type.toString());
                      controller.nationalityMap = {
                        "id": map.id,
                        "type": map.type.toString(),
                        "friendlyType": map.friendlyType.toString(),
                      };
                    },
                    child: Text(map.friendlyType.toString()),
                  ),
                ),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please select nationality';
                }
                return null;
              },
            ),
            15.verticalSpace,
            Row(
              children: [
                Expanded(child: _buildTitle(title: 'Source of other\n income')),
                CupertinoSlidingSegmentedControl<Income>(
                  backgroundColor: AppColors.black.withOpacity(0.1),
                  groupValue: controller.selectedIncome.call(),
                  thumbColor: AppColors.primary,
                  children: {
                    Income.rentalIncome: Text(
                      'Rental Income',
                      style:
                          (controller.selectedIncome() == Income.rentalIncome)
                              ? kw400White12
                              : kw400Black12,
                    ),
                    Income.other: Text(
                      'Others',
                      style:
                          (controller.selectedIncome() == Income.other)
                              ? kw400White12
                              : kw400Black12,
                    ),
                  },
                  onValueChanged: (value) {
                    controller.selectedIncome.call(value);
                    controller.selectedIncome.refresh();
                  },
                ),
              ],
            ),
            20.verticalSpace,
            Text('Monthly EMI', style: kw600Black16),
            20.verticalSpace,
            AppTextField(
              name: 'Auto',
              label: 'Auto (${CommonUtilities.AppCurrency})*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.autoController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Personal',
              label: 'Personal (${CommonUtilities.AppCurrency})*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.personalFinController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Credit Card Limit(All The Cards)',
              label:
                  'Credit Card Limit (${CommonUtilities.AppCurrency})(All The Cards)*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.creditCardController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Housing Finance',
              label: 'Housing Finance (${CommonUtilities.AppCurrency})*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.housingFinController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Business',
              label: 'Business (${CommonUtilities.AppCurrency})*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.businessController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            AppTextField(
              name: 'Others',
              label: 'Others (${CommonUtilities.AppCurrency})*',
              inputType: AppTextInputType.numberOnly,
              controller: controller.othersController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                LengthLimitingTextInputFormatter(15),
              ],
            ),
            15.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: AgButton(
                title: 'Calculate',
                onTap: () {
                  controller.checkPREligibility();
                },
              ),
            ).paddingSymmetric(horizontal: 10, vertical: 20),
          ],
        ),
      ),
    ),
  );

  Text _buildTitle({required String title}) => Text(title, style: kw400Black14);
}
