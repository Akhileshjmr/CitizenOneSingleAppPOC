import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_drop_down.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/app_colors.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/constants.dart';

import '../../../components/ui/text_field/app_textfield.dart';
import '../../../components/utils/app_utils.dart';
import '../../../components/utils/date_picker.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../routes/app_pages.dart';
import '../controllers/co_applicant_controller.dart';

class CoApplicantView extends GetView<CoApplicantController> {
  const CoApplicantView({super.key});

  Future<void> _submit() async {
    if (controller.isSwitchSelected()) {
      controller.formKey.currentState!.save();
      controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication);
    } else {
      if (controller.mode == 'AutoLoan') {
        controller.onSubmitCoReferal(ApiEndPoints.plFinanceOnlineApplication);
      } else if (controller.mode == 'Auto') {
        controller.onSubmitCoReferal(ApiEndPoints.plFinanceOnlineApplication);
      } else if (controller.mode == 'CG') {
        controller.onSubmitCoReferal(ApiEndPoints.plFinanceOnlineApplication);
      } else if (controller.mode == 'REAL_ESTATE') {
        controller.onSubmitCoReferal(ApiEndPoints.plFinanceOnlineApplication);
      } else if (controller.mode == 'Personal') {
        Get.toNamed<void>(
          Routes.CO_REFERAL,
          arguments: LimitArguments(LimitMode: 'Personal'),
        );
        controller.onSubmitCoReferal(ApiEndPoints.plFinanceOnlineApplication);
      } else if (controller.mode == 'Credit') {
        await Get.toNamed(Routes.CREDIT_DOCUMENTS_VIEW);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Co-applicant'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Save',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap: _submit,
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
                  Obx(
                    () => Row(
                      mainAxisAlignment:
                          isWide
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Has co-applicant', style: kw400Black14),
                        Visibility(visible: isWide, child: SizedBox(width: 12)),
                        CupertinoSwitch(
                          value: controller.isSwitchSelected(),
                          thumbColor: AppColors.kffffff,
                          activeTrackColor: AppColors.primary,
                          onChanged: (value) {
                            controller.isSwitchSelected(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () =>
                        controller.isSwitchSelected()
                            ? _coApplicantForm(isWide)
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _coApplicantForm(bool isWide) {
    return ResponsiveFormWrap(
      isWide: isWide,
      columns: 3,
      children: [
        ResponsiveFormItem(child: _nameField()),
        ResponsiveFormItem(child: _genderField()),
        ResponsiveFormItem(child: _relationshipField()),
        ResponsiveFormItem(child: _dobField()),
        ResponsiveFormItem(child: _passportField()),
        ResponsiveFormItem(child: _passportExpiryField()),
        ResponsiveFormItem(child: _nationalIdField()),
        ResponsiveFormItem(child: _nationalIdExpiryField()),
        ResponsiveFormItem(child: _educationField()),
        ResponsiveFormItem(child: _mobileField()),
        ResponsiveFormItem(child: _companyField()),
        ResponsiveFormItem(child: _jobTitleField()),
      ],
    );
  }

  Widget _nameField() {
    return AppTextField(
      name: 'Name',
      title: 'Name*',
      hintText: 'Name*',
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter name';
        }
        return null;
      },
      controller: controller.NameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }

  Widget _genderField() {
    return AppDropDown(
      name: 'gender',
      labelText: 'Gender*',
      initialValue: controller.gender.value,
      items: [
        ...(controller.genderOptions ?? <Options>[]).map(
          (Options map) => DropdownMenuItem(
            value: map.type.toString(),
            onTap: () {
              controller.gender(map.type.toString());
              controller.genderMap = {
                'id': map.id,
                'type': map.type.toString(),
                'friendlyType': map.friendlyType.toString(),
              };
            },
            child: Text(map.friendlyType.toString()),
          ),
        ),
      ],
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please select Gender';
        }
        return null;
      },
    );
  }

  Widget _relationshipField() {
    return AppDropDown(
      name: 'RelationShip',
      labelText: 'Relationship*',
      initialValue: controller.Relation.value,
      items: [
        ...(controller.optionList ?? <Options>[]).map(
          (Options map) => DropdownMenuItem(
            value: map.type.toString(),
            onTap: () {
              controller.Relation(map.type.toString());
              controller.relationMap = {
                'id': map.id,
                'type': map.type.toString(),
                'friendlyType': map.friendlyType.toString(),
              };
            },
            child: Text(map.friendlyType.toString()),
          ),
        ),
      ],
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please select Relationship';
        }
        return null;
      },
    );
  }

  Widget _dobField() {
    return AppTextField(
      name: 'dob',
      title: 'Date of Birth*',
      hintText: 'Date of Birth*',
      suffixIcon: const Icon(Icons.calendar_month),
      readOnly: true,
      showCursor: false,
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter Date of Birth';
        }
        return null;
      },
      controller: controller.dobController,
      onTap: () async {
        hideKeyboard();

        final DateTime? value = await showAgCalendar(
          initialDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime.now().subtract(const Duration(days: 1)),
          firstDate: DateTime(1960),
          initialMode: DatePickerMode.year,
        );

        if (value != null) {
          controller.dobController.text = value.ddMMyyyy.toString();
          hideKeyboard();
        }
      },
    );
  }

  Widget _passportField() {
    return AppTextField(
      name: 'Passport No.',
      title: 'Passport No.*',
      hintText: 'Passport No.*',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter Passport No.';
        }
        return null;
      },
      controller: controller.passportNoController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z0-9]')),
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }

  Widget _passportExpiryField() {
    return AppTextField(
      name: 'Passport expiry date',
      title: 'Passport expiry date*',
      hintText: 'Passport expiry date*',
      suffixIcon: const Icon(Icons.calendar_month),
      readOnly: true,
      showCursor: false,
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter Passport expiry date ';
        }
        return null;
      },
      controller: controller.passporrtExpiryDateController,
      onTap: () async {
        hideKeyboard();

        final DateTime? value = await showAgCalendar(
          initialDate: DateTime.now().subtract(const Duration(days: 1)),
          firstDate: DateTime.now().subtract(const Duration(days: 1)),
          lastDate: DateTime(2101),
          initialMode: DatePickerMode.year,
        );

        if (value != null) {
          controller.passporrtExpiryDateController.text =
              value.ddMMyyyy.toString();
          hideKeyboard();
        }
      },
    );
  }

  Widget _nationalIdField() {
    return AppTextField(
      name: 'emiratesId',
      title: 'National ID* ',
      hintText: 'National ID* ',
      inputType: AppTextInputType.numberOnly,
      validator: (String? value) {
        if ((value?.length ?? 0) > 3) {
          final prefix = value?.substring(0, 3);
          if (value!.isEmpty) {
            return 'Please enter National ID number';
          } else if (value.length < 15) {
            return 'National ID cannot be less than 15 digits';
          }
        } else if (value?.isEmpty ?? true) {
          return 'Please enter National ID number';
        }
        return null;
      },
      controller: controller.emiratiNoController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(15),
      ],
    );
  }

  Widget _nationalIdExpiryField() {
    return AppTextField(
      name: 'expiryDate',
      title: 'National ID expiry date*',
      hintText: 'National ID expiry date*',
      suffixIcon: const Icon(Icons.calendar_month),
      readOnly: true,
      showCursor: false,
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter National ID expiry date';
        }
        return null;
      },
      controller: controller.expiryDateController,
      onTap: () async {
        hideKeyboard();

        final DateTime? value = await showAgCalendar(
          initialDate: DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now().add(const Duration(days: 30)),
          lastDate: DateTime(2101),
          initialMode: DatePickerMode.year,
        );

        if (value != null) {
          controller.expiryDateController.text = value.ddMMyyyy.toString();
          hideKeyboard();
        }
      },
    );
  }

  Widget _educationField() {
    return AppDropDown(
      name: 'Educational Qualification*',
      labelText: 'Educational Qualification*',
      initialValue: controller.education.value,
      items: [
        ...(controller.educationOptions ?? <Options>[]).map(
          (Options map) => DropdownMenuItem(
            value: map.type.toString(),
            onTap: () {
              controller.education(map.type.toString());
              controller.educationMap = {
                'id': map.id,
                'type': map.type.toString(),
                'friendlyType': map.friendlyType.toString(),
              };
            },
            child: Text(map.friendlyType.toString()),
          ),
        ),
      ],
      validator: (String? value) {
        if (value?.isEmpty ?? true) {
          return 'Please select Educational Qualification';
        }
        return null;
      },
    );
  }

  Widget _mobileField() {
    return AppTextField(
      name: 'pNumber',
      title: 'Mobile Number*',
      hintText: 'Mobile Number*',
      inputType: AppTextInputType.numberOnly,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter Mobile Number';
        }
        return null;
      },
      controller: controller.mobileNoController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(9),
      ],
    );
  }

  Widget _companyField() {
    return AppTextField(
      name: 'CompanyName',
      title: 'Company Name*',
      hintText: 'Company Name*',
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter Company Name';
        }
        return null;
      },
      controller: controller.CompanyNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget _jobTitleField() {
    return AppTextField(
      name: 'Job title/designation',
      title: 'Job title/designation*',
      controller: controller.jobTitleController,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter Job title';
        }
        return null;
      },
    );
  }
}
