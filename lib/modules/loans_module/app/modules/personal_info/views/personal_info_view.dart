import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/constants.dart';

import '../../../components/ui/app_drop_down.dart';
import '../../../components/ui/text_field/app_textfield.dart';
import '../../../components/utils/date_picker.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/static_value_constant.dart';
import '../controllers/personal_info_controller.dart';

class PersonalInfoView extends GetView<PersonalInfoController> {
  ///
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      Get.back(result: true);
      return true;
    },
    child: Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Personal Info'),
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
              child: ResponsiveAutoWrap(
                isWide: isWide,
                columns: 3,
                children: [
                  20.verticalSpace,

                  /// ✅ FIXED CONDITIONAL BLOCK
                  if ((controller.mode == 'REAL_ESTATE') &&
                      StaticValueConstant.isApplyPreApprovedLoan) ...[
                    20.verticalSpace,

                    AppDropDown(
                      name: 'Select Bank',
                      labelText: 'Select Bank*',
                      initialValue:
                          (controller.preApprovedBankList).any(
                                (e) => e.type == controller.initialBankName,
                              )
                              ? controller.initialBankName
                              : null,
                      items:
                          controller.preApprovedBankList.value
                              .map(
                                (Options map) => DropdownMenuItem(
                                  value: map.type.toString(),
                                  onTap: () {
                                    controller.preApprovedBankName(
                                      map.type.toString(),
                                    );
                                    controller.slectedPreApprovedBankId(
                                      map.id.toString(),
                                    );
                                  },
                                  child: Text(map.friendlyType.toString()),
                                ),
                              )
                              .toList(),
                    ),

                    20.verticalSpace,

                    AppTextField(
                      name: 'Pre Approved Reference Number',
                      title: 'Pre Approved Reference Number',
                      hintText: 'Pre Approved Reference Number',
                      isEnabled: false,
                      controller: controller.preApprovedBankRefNumber.value,
                    ),

                    20.verticalSpace,

                    AppTextField(
                      name: 'Pre Approved Reference Amount',
                      title: 'Pre Approved Reference Amount',
                      hintText: 'Pre Approved Reference Amount',
                      isEnabled: false,
                      controller: controller.preApprovedBankAmount.value,
                    ),

                    20.verticalSpace,
                  ],

                  /// ✅ REMAINING CODE (UNCHANGED)
                  AppDropDown(
                    name: 'title',
                    labelText: 'Title*',
                    initialValue:
                        (controller.optionList).any(
                              (e) => e.type == controller.title.value,
                            )
                            ? controller.title.value
                            : null,
                    items: [
                      ...(controller.optionList ?? <Options>[]).map(
                        (Options map) => DropdownMenuItem(
                          value: map.type.toString(),
                          onTap: () {
                            controller.title(map.type.toString());
                            controller.titleMap = {
                              "id": map.id,
                              "type": map.type.toString(),
                              "friendlyType": map.friendlyType.toString(),
                            };
                          },
                          child: Text(map.friendlyType.toString()),
                        ),
                      ),
                    ],
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select title';
                      }
                      return null;
                    },
                  ),

                  20.verticalSpace,

                  AppDropDown(
                    name: 'gender',
                    labelText: 'Gender*',
                    initialValue:
                        (controller.genderOptions).any(
                              (e) => e.type == controller.gender.value,
                            )
                            ? controller.gender.value
                            : null,
                    items: [
                      ...(controller.genderOptions).map(
                        (Options map) => DropdownMenuItem(
                          value: map.type.toString(),
                          onTap: () {
                            controller.gender(map.type.toString());
                          },
                          child: Text(map.friendlyType.toString()),
                        ),
                      ),
                    ],
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select gender';
                      }
                      return null;
                    },
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'firstName',
                    title: 'First Name*',
                    hintText: 'First Name*',
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                    controller: controller.firstNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      LengthLimitingTextInputFormatter(100),
                    ],
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'middleName',
                    title: 'Middle Name',
                    hintText: 'Middle Name',
                    // obscureText: true,
                    // validator: controller.middleNameValidators,
                    controller: controller.middleNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'lastName',
                    title: 'Last Name*',
                    hintText: 'Last Name*',
                    // obscureText: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                    controller: controller.lastNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'emilid',
                    title: 'Email ID*',
                    hintText: 'Email ID*',
                    // obscureText: true,
                    validator: controller.emailValidators,
                    controller: controller.emailIdController,
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'pNumber',
                    title: 'Mobile Number*',
                    hintText: 'Mobile Number*',
                    // obscureText: true,
                    readOnly: true,
                    isEnabled: false,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter mobile number';
                      }
                      return null;
                    },
                    controller: controller.mobileNoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(9),
                    ],
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'dob',
                    title: 'Date of Birth*',
                    hintText: 'Date of Birth*',
                    suffixIcon: Icon(Icons.calendar_month),
                    readOnly: true,
                    showCursor: false,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter date of birth';
                      }
                      return null;
                    },
                    controller: controller.dobController,
                    onTap: () async {
                      hideKeyboard();

                      final DateTime? value = await showAgCalendar(
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime(1960),
                      );

                      if (value != null) {
                        controller.dobController.text =
                            value.ddMMyyyy.toString();
                        hideKeyboard();
                      }
                    },
                  ),

                  20.verticalSpace,

                  AppTextField(
                    name: 'Current Country Residence Since',
                    title: 'Current Country Residence Since*',
                    hintText: 'Current Country Residence Since*',
                    suffixIcon: Icon(Icons.calendar_month),
                    readOnly: true,
                    showCursor: false,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter Current Country Residence Since';
                      }
                      return null;
                    },
                    controller: controller.dateInUAEDateController,
                    onTap: () async {
                      hideKeyboard();

                      final value = await showAgCalendar(
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime(1960),
                      );

                      if (value != null) {
                        controller.dateInUAEDateController.text =
                            value.ddMMyyyy.toString();
                        hideKeyboard();
                      }
                    },
                  ),
                  20.verticalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: const TextSpan(
                          style: kw400Black14,
                          children: [
                            TextSpan(text: 'Marital Status'),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: _buildGenderRadio(
                                value: 'MARRIED',
                                title: 'Married',
                                selected: controller.Marital_Status.value,
                              ),
                            ),
                            Expanded(
                              child: _buildGenderRadio(
                                value: 'UNMARRIED',
                                title: 'Unmarried',
                                selected: controller.Marital_Status.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  AppDropDown(
                    name: 'No. of Dependent*',
                    labelText: 'No. of Dependent*',
                    initialValue:
                        (controller.noofDependentArr).any(
                              (e) => e.type == controller.noofDependent.value,
                            )
                            ? controller.noofDependent.value
                            : null,
                    items: [
                      ...(controller.noofDependentArr).map(
                        (map) => DropdownMenuItem(
                          value: map.type.toString(),
                          onTap: () {
                            controller.noofDependent(map.type.toString());
                            controller.noofDependentMap = {
                              "id": map.id,
                              "type": map.type.toString(),
                              "friendlyType": map.friendlyType.toString(),
                            };
                          },
                          child: Text(map.friendlyType.toString()),
                        ),
                      ),
                    ],
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select no. of dependent';
                      }
                      return null;
                    },
                  ),

                  /*if (controller.mode.value.isEmpty)
                    AppTextField(
                      name: 'birth',
                      title: "Special Person's Birthday*",
                      hintText: "Special Person's Birthday*",
                      suffixIcon: const Icon(Icons.calendar_month),
                      readOnly: true,
                      controller: controller.birthdayController,
                      onTap: () async {
                        hideKeyboard();
                        final value = await showAgCalendar(
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          firstDate: DateTime(1960),
                        );
                        if (value != null) {
                          controller.birthdayController.text =
                              value.ddMMM.toString();
                        }
                      },
                    ),*/
                  // if (controller.mode.value.isEmpty) 20.verticalSpace,

                  /// Anniversary
                  /*if (controller.Marital_Status.value == 'MARRIED')
                    AppTextField(
                      name: 'anniversary',
                      title: 'Anniversary*',
                      hintText: 'Anniversary*',
                      suffixIcon: const Icon(Icons.calendar_month),
                      readOnly: true,
                      controller: controller.annivesaryController,
                      onTap: () async {
                        hideKeyboard();
                        final value = await showAgCalendar(
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime.now().subtract(
                            const Duration(days: 1),
                          ),
                          firstDate: DateTime(1960),
                        );
                        if (value != null) {
                          controller.annivesaryController.text =
                              value.ddMMM.toString();
                        }
                      },
                    ),*/
                  if (controller.Marital_Status.value == 'MARRIED')
                    20.verticalSpace,
                  AppTextField(
                    name: 'nationalId',
                    title: 'National ID* ',
                    hintText: 'National ID* ',
                    inputType: AppTextInputType.numberOnly,
                    // obscureText: true,
                    validator: (String? value) {
                      if ((value?.length ?? 0) > 3) {
                        var prefix = value?.substring(0, 3);
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
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  20.verticalSpace,
                  AppTextField(
                    name: 'fullName',
                    title: 'Name as per National ID*',
                    hintText: 'Name as per National ID*',
                    // obscureText: true,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Please enter Name as per National ID';
                      }
                      return null;
                    },
                    controller: controller.emiratiNoNameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                  20.verticalSpace,
                  // FormBuilderDateTimePicker(
                  //   name: 'expiryDate',
                  //
                  //   validator: (value) {
                  //     if (!((value?.difference(DateTime.now()) ??
                  //             0.days) >=
                  //         30.days)) {
                  //       return 'expiry date must be 30 days after of today.';
                  //     }
                  //     return null;
                  //   },
                  //   initialDatePickerMode: DatePickerMode.year,
                  //
                  // ),
                  AppTextField(
                    name: 'expiryDate',
                    title: 'National ID expiry date*',
                    hintText: 'National ID expiry date*',
                    suffixIcon: Icon(Icons.calendar_month),
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
                        initialDate: DateTime.now().add(
                          const Duration(days: 30),
                        ),
                        firstDate: DateTime.now().add(const Duration(days: 30)),
                        lastDate: DateTime(2101),
                        initialMode: DatePickerMode.year,
                      );

                      if (value != null) {
                        controller.expiryDateController.text =
                            value.ddMMyyyy.toString();
                        hideKeyboard();
                      }
                    },
                  ),
                  20.verticalSpace,
                  Obx(
                    () => AppDropDown(
                      name: 'Nationality',
                      labelText: 'Nationality*',
                      initialValue:
                          (controller.nationalityOptions).any(
                                (e) => e.type == controller.nationality.value,
                              )
                              ? controller.nationality.value
                              : null,
                      items:
                          (controller.nationalityOptions())
                              .map(
                                (Options map) => DropdownMenuItem<String>(
                                  value: map.type.toString(),
                                  onTap: () {
                                    controller.nationality(
                                      map.friendlyType.toString(),
                                    );
                                    controller.nationalityid(map.id?.toInt());
                                    controller.nationalityMap = {
                                      "id": map.id,
                                      "type": map.type.toString(),
                                      "friendlyType":
                                          map.friendlyType.toString(),
                                    };
                                  },
                                  child: Text(map.friendlyType.toString()),
                                ),
                              )
                              .toList(),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please select nationality';
                        }
                        return null;
                      },
                    ),
                  ),
                  20.verticalSpace,
                  Obx(
                    () => AppDropDown(
                      name: 'Country of birth',
                      labelText: 'Country of birth*',
                      initialValue:
                          (controller.birthPlaceOptions).any(
                                (e) => e.type == controller.birthPlace.value,
                              )
                              ? controller.birthPlace.value
                              : null,
                      items:
                          (controller.birthPlaceOptions())
                              .map(
                                (Options map) => DropdownMenuItem<String>(
                                  value: map.type.toString(),
                                  onTap: () {
                                    controller.birthPlace(
                                      map.friendlyType.toString(),
                                    );
                                    controller.birthPlaceid(map.id?.toInt());
                                    controller.birthPlaceMap = {
                                      "id": map.id,
                                      "type": map.type.toString(),
                                      "friendlyType":
                                          map.friendlyType.toString(),
                                    };
                                  },
                                  child: Text(map.friendlyType.toString()),
                                ),
                              )
                              .toList(),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please select country of birth';
                        }
                        return null;
                      },
                    ),
                  ),
                  20.verticalSpace,
                  AppTextField(
                    name: 'Passport No.',
                    title: 'Passport No*.',
                    hintText: 'Passport No*.',
                    // obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter passport no.';
                      }
                      return null;
                    },
                    controller: controller.passportNoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  20.verticalSpace,
                  AppTextField(
                    name: 'Passport expiry date',
                    title: 'Passport expiry date*',
                    hintText: 'Passport expiry date*',
                    suffixIcon: Icon(Icons.calendar_month),
                    readOnly: true,
                    showCursor: false,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter passport expiry date ';
                      }
                      return null;
                    },
                    controller: controller.passporrtExpiryDateController,
                    onTap: () async {
                      hideKeyboard();

                      final DateTime? value = await showAgCalendar(
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 1),
                        ),
                        lastDate: DateTime(2101),
                        initialMode: DatePickerMode.year,
                      );

                      if (value != null) {
                        controller.passporrtExpiryDateController.text =
                            value.ddMMyyyy.toString();
                        hideKeyboard();
                      }
                    },
                  ),
                  20.verticalSpace,
                  AppDropDown(
                    name: 'Educational Qualification*',
                    labelText: 'Educational Qualification*',
                    initialValue:
                        (controller.educationOptions ?? []).any(
                              (e) => e.type == controller.education.value,
                            )
                            ? controller.education.value
                            : null,
                    items: [
                      ...(controller.educationOptions).map(
                        (Options map) => DropdownMenuItem(
                          value: map.type.toString(),
                          onTap: () {
                            controller.education(map.type.toString());
                            controller.educationMap = {
                              "id": map.id,
                              "type": map.type.toString(),
                              "friendlyType": map.friendlyType.toString(),
                            };
                          },
                          child: Text(map.friendlyType.toString()),
                        ),
                      ),
                    ],
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please select education qualification';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
      ),
    ),
  );

  void _submit() {
    controller.formKey.currentState!.save();
    if (controller.mode == 'Auto') {
      controller.onSubmit('auto/orders/save-profile-forms');
    } else if (controller.mode == 'CG') {
      controller.onSubmit('orders/cg/save-profile-forms');
    } else if (controller.mode == 'REAL_ESTATE') {
      controller.onSubmit('realestate/home/orders/save-profile-forms');
    } else if (controller.mode == 'Credit' ||
        controller.mode == 'CreditReview') {
      controller.onSubmit('creditcard/credit-card-finance-forms');
    } else if (controller.mode == 'Personal' ||
        controller.mode == 'PersonalReview') {
      controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication);
    } else if (controller.mode == 'AutoLoan') {
      controller.onSubmit('pl/pre-approved-loan/save-profile-forms');
    } else {
      controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication);
    }
  }

  Widget _buildGenderRadio({
    required String selected,
    required String value,
    required String title,
  }) {
    final bool isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        controller.Marital_Status(value);
      },
      child: Row(
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey,
                width: 2,
              ),
            ),
            child:
                isSelected
                    ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                    : null,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
