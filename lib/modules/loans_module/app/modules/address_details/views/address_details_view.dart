import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_drop_down.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';

import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../utils/app_colors.dart';
import '../controllers/address_details_controller.dart';

class AddressDetailsView extends GetView<AddressDetailsController> {
  const AddressDetailsView({super.key});

  String _getSubmitUrl() {
    switch (controller.mode) {
      case 'Auto':
        return 'auto/orders/save-profile-forms';
      case 'CG':
        return 'orders/cg/save-profile-forms';
      case 'REAL_ESTATE':
        return 'realestate/home/orders/save-profile-forms';
      case 'Credit':
      case 'CreditReview':
        return 'creditcard/credit-card-finance-forms';
      case 'Personal':
      case 'PersonalReview':
        return ApiEndPoints.plFinanceOnlineApplication;
      case 'AutoLoan':
        return 'pl/pre-approved-loan/save-profile-forms';
      default:
        return ApiEndPoints.plFinanceOnlineApplication;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Address Info'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Save',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap: () {
            if (controller.isAddressList.value) {
              controller.onAddAddress();
            } else {
              controller.onSubmit(_getSubmitUrl());
            }
          },
        ),
        secondaryAction: ResponsiveFormAction(
          title: 'Back',
          onTap: Get.back,
          isOutlined: true,
        ),
        bodyBuilder:
            (context, isWide) => FormBuilder(
              key: controller.formKey,
              child:
                  controller.isAddressList.value
                      ? _buildSimpleForm(isWide)
                      : _buildFullForm(isWide),
            ),
      ),
    );
  }

  Widget _buildFullForm(bool isWide) {
    return ResponsiveFormWrap(
      isWide: isWide,
      columns: 3,
      children: [
        ResponsiveFormItem(
          child: _textField(
            name: 'Full Name',
            title: 'Full Name*',
            controller: controller.fullNameController,
            validator: (v) => v!.isEmpty ? 'Enter Full Name' : null,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
              LengthLimitingTextInputFormatter(30),
            ],
          ),
        ),
        ResponsiveFormItem(
          child: _textField(
            name: 'Mobile',
            title: 'Mobile Number*',
            controller: controller.MobileNumberController,
            keyboard: TextInputType.number,
            validator:
                (v) => v == null || v.length < 9 ? 'Enter valid mobile' : null,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
          ),
        ),
        ResponsiveFormItem(
          child: _textField(
            name: 'PO Box',
            title: 'Post Box No*',
            controller: controller.PoBoxNumberController,
            keyboard: TextInputType.number,
            validator:
                (v) =>
                    v == null || v.length != 6
                        ? 'Enter valid 6-digit postal code'
                        : null,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
        ),
        ResponsiveFormItem(
          child: _textField(
            name: 'Location',
            title: 'Location*',
            controller: controller.LandmarkController,
            maxLines: 1,
            validator: (v) => v!.isEmpty ? 'Enter Location' : null,
          ),
        ),
        ResponsiveFormItem(child: _stateDropdown()),
        ResponsiveFormItem(child: _countryDropdown()),
        ResponsiveFormItem(child: _addressTypeSelector(isWide)),
      ],
    );
  }

  Widget _buildSimpleForm(bool isWide) {
    return ResponsiveFormWrap(
      isWide: isWide,
      columns: 3,
      children: [
        ResponsiveFormItem(
          child: _textField(
            name: 'PO Box',
            title: 'P O Box Number',
            controller: controller.PoBoxNumberController,
          ),
        ),
        ResponsiveFormItem(
          child: _textField(
            name: 'Location',
            title: 'Location',
            controller: controller.BuildingNameController,
          ),
        ),
        ResponsiveFormItem(child: _countryDropdown()),
        ResponsiveFormItem(child: _stateDropdown()),
      ],
    );
  }

  Widget _textField({
    required String name,
    required String title,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return AppTextField(
      name: name,
      title: title,
      hintText: title,
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
    );
  }

  Widget _countryDropdown() {
    return AppDropDown(
      name: 'Country',
      labelText: 'Country*',
      initialValue: controller.selectedCountry.value,
      items:
          controller.countryList.map((item) {
            return DropdownMenuItem(
              value: item.type,
              onTap: () {
                controller.selectedCountry(item.type ?? '');
                controller.countryMap = {
                  'id': item.id,
                  'type': item.type,
                  'friendlyType': item.friendlyType,
                };
              },
              child: Text(item.type ?? ''),
            );
          }).toList(),
      validator: (v) => v == null || v.isEmpty ? 'Select country' : null,
    );
  }

  Widget _stateDropdown() {
    return AppDropDown(
      name: 'State',
      labelText: 'State*',
      initialValue: controller.emirati.value,
      items:
          controller.emrites.map((item) {
            return DropdownMenuItem(
              value: item.friendlyType,
              onTap: () {
                controller.emirati(item.friendlyType ?? '');
                controller.emritesid(item.id ?? 0);
                controller.emritesMap = {
                  'id': item.id,
                  'type': item.friendlyType,
                  'friendlyType': item.friendlyType,
                };
              },
              child: Text(item.friendlyType ?? ''),
            );
          }).toList(),
      validator: (v) => v == null || v.isEmpty ? 'Select emirate' : null,
    );
  }

  Widget _addressTypeSelector(bool isWide) {
    return Obx(() {
      final selected = controller.gender.value;

      return Row(
        children:
            controller.addressType.map((type) {
              final isSelected = selected == type;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => controller.gender(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color:
                              isSelected ? AppColors.primary : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      );
    });
  }
}
