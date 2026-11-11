import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_drop_down.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/ui/text_field/app_textfield.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../controllers/co_referal_controller.dart';

class CoReferalView extends GetView<CoReferalController> {
  const CoReferalView({super.key});

  void _submit() {
    if (controller.mode == 'AutoLoan') {
      controller.onSubmit('pl/pre-approved-loan/save-profile-forms');
    } else if (controller.mode == 'Auto') {
      controller.onSubmit('auto/orders/save-profile-forms');
    } else if (controller.mode == 'CG') {
      controller.onSubmit('orders/cg/save-profile-forms');
    } else if (controller.mode == 'REAL_ESTATE') {
      controller.onSubmit('realestate/home/orders/save-profile-forms');
    } else if (controller.mode == 'Personal' ||
        controller.mode == 'PersonalReview') {
      controller.onSubmit(ApiEndPoints.plFinanceOnlineApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Reference'),
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
            (context, isWide) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: FormBuilder(
                key: controller.formKey,
                child: ResponsiveFormWrap(
                  key: ValueKey<bool>(isWide),
                  isWide: isWide,
                  columns: 3,
                  children: [
                    const ResponsiveFormItem(
                      fullWidth: true,
                      child: Text('Reference 1', style: kw600Black18),
                    ),
                    ResponsiveFormItem(child: _nameField()),
                    ResponsiveFormItem(child: _relationshipField()),
                    ResponsiveFormItem(child: _mobileField()),
                    ResponsiveFormItem(child: _companyField()),
                    const ResponsiveFormItem(
                      fullWidth: true,
                      child: Text('Reference 2', style: kw600Black18),
                    ),
                    ResponsiveFormItem(child: _refNameField()),
                    ResponsiveFormItem(child: _refRelationshipField()),
                    ResponsiveFormItem(child: _refMobileField()),
                    ResponsiveFormItem(child: _refCompanyField()),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget _nameField() {
    return AppTextField(
      name: 'First Name',
      title: 'Name',
      hintText: 'Name',
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter first name';
        }
        return null;
      },
      controller: controller.NameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }

  Widget _relationshipField() {
    return AppDropDown(
      name: 'RelationShip',
      labelText: 'Relationship',
      initialValue: controller.Relation(),
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

  Widget _mobileField() {
    return AppTextField(
      name: 'pNumber',
      title: 'Mobile Number',
      hintText: 'Mobile Number',
      inputType: AppTextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Please enter mobile number';
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
      title: 'Company Name',
      hintText: 'Company Name',
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

  Widget _refNameField() {
    return AppTextField(
      name: 'First Name 2',
      title: 'Name',
      hintText: 'Name',
      controller: controller.RefNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
        LengthLimitingTextInputFormatter(100),
      ],
    );
  }

  Widget _refRelationshipField() {
    return AppDropDown(
      name: 'RelationShip1',
      labelText: 'Relationship',
      initialValue: controller.RefRelation(),
      items: [
        ...(controller.optionList1 ?? <Options>[]).map(
          (Options map) => DropdownMenuItem(
            value: map.type.toString(),
            onTap: () {
              controller.RefRelation(map.type.toString());
              controller.refRelationMap = {
                'id': map.id,
                'type': map.type.toString(),
                'friendlyType': map.friendlyType.toString(),
              };
            },
            child: Text(map.friendlyType.toString()),
          ),
        ),
      ],
    );
  }

  Widget _refMobileField() {
    return AppTextField(
      name: 'pNumber2',
      title: 'Mobile Number',
      hintText: 'Mobile Number',
      inputType: AppTextInputType.phone,
      controller: controller.RefmobileNoController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(9),
      ],
    );
  }

  Widget _refCompanyField() {
    return AppTextField(
      name: 'CompanyName2',
      title: 'Company Name',
      hintText: 'Company Name',
      controller: controller.RefCompanyNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }
}
