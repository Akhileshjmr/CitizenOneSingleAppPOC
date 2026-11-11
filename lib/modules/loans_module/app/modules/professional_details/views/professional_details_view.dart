import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/constants.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/app_drop_down.dart';
import '../../../components/ui/app_radio.dart';
import '../../../components/ui/responsive_form_layout.dart';
import '../../../components/ui/text_field/app_textfield.dart';
import '../../../components/utils/app_utils.dart';
import '../../../components/utils/date_picker.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/professional_details_controller.dart';

class ProfessionalDetailsView extends GetView<ProfessionalDetailsController> {
  const ProfessionalDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Professional Info'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Save',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap:
              () =>
                  controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication),
        ),
        secondaryAction: ResponsiveFormAction(
          title: 'Back',
          onTap: Get.back,
          isOutlined: true,
        ),
        bodyBuilder:
            (context, isWide) => FormBuilder(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveFormWrap(
                    isWide: isWide,
                    columns: 3,
                    children: [
                      ResponsiveFormItem(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: kw500Black14,
                                children: [
                                  TextSpan(text: 'Employment Type'),
                                  const TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            12.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEmploymentTypeRadio(
                                    'SALARIED',
                                    'Salaried',
                                  ),
                                ),
                                Expanded(
                                  child: _buildEmploymentTypeRadio(
                                    'SELF_EMPLOYED',
                                    'Self Employed',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () =>
                        controller.isSelfEmployed.value
                            ? generateSelfEmployedForm(isWide)
                            : generateSalariedForm(isWide),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget generateSalariedForm(bool isWide) {
    return ResponsiveFormWrap(
      isWide: isWide,
      columns: 3,
      children: [
        ResponsiveFormItem(
          child: Obx(() {
            final list = controller.industryTypeList;

            return AppDropDown<Options>(
              name: 'industry',
              labelText: 'Type of Industry*',
              initialValue: controller.selectedIndustry.value,
              items:
                  list.map((item) {
                    return DropdownMenuItem<Options>(
                      value: item,
                      child: Text(item.friendlyType ?? ''),
                    );
                  }).toList(),
              onChanged: (value) {
                controller.selectedIndustry.value = value;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select type of industry';
                }
                return null;
              },
            );
          }),
        ),
        ResponsiveFormItem(
          child: Obx(
            () => AppDropDown(
              name: 'organization',
              labelText: 'Name of the Organisation*',
              initialValue: controller.selectedEmployer.value?.type,
              items:
                  controller.employerList.map((item) {
                    return DropdownMenuItem(
                      value: item.type,
                      onTap: () {
                        controller.selectedEmployer.value = item;
                        controller.showOtherField.value =
                            item.friendlyType == 'Others';
                      },
                      child: Text(item.friendlyType ?? ''),
                    );
                  }).toList(),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Please select organisation'
                          : null,
            ),
          ),
        ),
        if (controller.showOtherField.value)
          ResponsiveFormItem(
            child: Obx(
              () => AppTextField(
                name: 'others',
                title: 'Others',
                controller: controller.otherController,
                validator:
                    (value) => value!.isEmpty ? 'Please enter others' : null,
              ),
            ),
          ),

        ResponsiveFormItem(
          child: AppTextField(
            name: 'dateOfJoining',
            title: 'Date of Joining*',
            suffixIcon: const Icon(Icons.calendar_month),
            controller: controller.dateController,
            readOnly: true,
            showCursor: false,
            onTap: () async {
              hideKeyboard();

              final DateTime? value = await showAgCalendar(
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );

              if (value != null) {
                controller.dateController.text = value.ddMMyyyy.toString();
              }
            },
            validator: (value) => value!.isEmpty ? 'Please select date' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'designation',
            title: 'Designation*',
            controller: controller.designation,
            validator: (v) => v!.isEmpty ? 'Enter designation' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'experience',
            title: 'Total Experience*',
            controller: controller.workExperience,
            keyboardType: TextInputType.number,
            maxLength: 2,
            validator: (v) => v!.isEmpty ? 'Enter experience' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'monthlyIncome',
            title: 'Monthly Income*',
            controller: controller.monthlyIncome,
            maxLength: 8,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter monthly income' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'otherIncome',
            title: 'Other Income*',
            controller: controller.otherIncome,
            maxLength: 8,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter other income' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'houseAllowance',
            title: 'House Allowance*',
            maxLength: 8,
            controller: controller.houseAllowance,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter house allowance' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'spouseIncome',
            title: 'Spouse Income*',
            maxLength: 8,
            controller: controller.spouseIncome,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter spouse income' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'commitments',
            title: 'Monthly Commitments*',
            maxLength: 8,
            controller: controller.monthlyCommitments,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter commitments' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'employeeNo',
            title: 'Employee No*',
            controller: controller.employeeNo,
            validator: (v) => v!.isEmpty ? 'Enter employee no' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'extension',
            title: 'Extension*',
            maxLength: 8,
            controller: controller.extensiontext,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Enter extension' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'officePhone',
            title: 'Office Telephone No*',
            controller: controller.officetelephoneNo,
            inputType: AppTextInputType.phone,
            validator: (v) {
              if (v!.isEmpty) return 'Enter phone';
              if (v.length < 9) return 'Min 9 digits';
              return null;
            },
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'officeEmail',
            title: 'Office Email*',
            controller: controller.officeMailid,
            keyboardType: TextInputType.emailAddress,
            validator: controller.emailValidators,
          ),
        ),
      ],
    );
  }

  Widget generateSelfEmployedForm(bool isWide) {
    return ResponsiveFormWrap(
      isWide: isWide,
      columns: 3,
      children: [
        ResponsiveFormItem(
          child: AppTextField(
            name: 'annualIncome',
            title: 'Annual Income*',
            maxLength: 8,
            controller: controller.annualIncome,
            inputType: AppTextInputType.numberOnly,
            validator: (v) => v!.isEmpty ? 'Enter annual income' : null,
          ),
        ),
        ResponsiveFormItem(
          child: AppTextField(
            name: 'yearsBusiness',
            title: 'Years in Business*',
            controller: controller.noOfYears,
            inputType: AppTextInputType.numberOnly,
            validator: (v) => v!.isEmpty ? 'Enter years' : null,
            maxLength: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildEmploymentTypeRadio(String value, String title) {
    return Obx(() {
      return AppRadio<String>(
        value: value,
        groupValue: controller.employmentType.value,
        title: title,
        onChanged: (val) {
          if (val == null) return;

          controller.employmentType.value = val;
          controller.isSelfEmployed.value = val == 'SELF_EMPLOYED';
        },
      );
    });
  }
}
