import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/app_drop_down.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/responsive_form_layout.dart';

import '../../../components/ui/text_field/app_textfield.dart';
import '../../../components/utils/No_leading_space_formatter.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../routes/app_pages.dart';
import '../controllers/property_form_controller.dart';

class PropertyFormView extends GetView<PropertyFormController> {
  const PropertyFormView({super.key});

  void _skip() {
    Get.toNamed<void>(
      Routes.PRE_APPROVE_FINANCE_PARTNER,
      arguments: ['/homeloan', 'New'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ResponsiveFormScaffold(
        appBar: const AgAppbar(title: 'Property Information'),
        isLoading: controller.isLoading.value,
        primaryAction: ResponsiveFormAction(
          title: 'Continue',
          mobileTitle: 'Continue',
          icon: Icons.arrow_forward,
          onTap: controller.addPropertyDetails,
        ),
        secondaryAction: ResponsiveFormAction(
          title: 'Skip & Continue',
          onTap: _skip,
          isOutlined: true,
        ),
        bodyBuilder:
            (context, isWide) => FormBuilder(
              key: controller.propertyFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isWide)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _skip,
                        child: const Text('Skip & Continue'),
                      ),
                    ),
                  ResponsiveFormWrap(
                    isWide: isWide,
                    children: [
                      ResponsiveFormItem(child: _propertyName()),
                      ResponsiveFormItem(child: _propertyPrice()),
                      ResponsiveFormItem(child: _propertyType()),
                      ResponsiveFormItem(child: _propertySize()),
                      ResponsiveFormItem(child: _constructionYear()),
                      ResponsiveFormItem(child: _propertyAddress()),
                      ResponsiveFormItem(child: _postalCode()),
                      ResponsiveFormItem(child: _sellerName()),
                      ResponsiveFormItem(child: _sellerContact()),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _propertyName() {
    return AppTextField(
      name: 'property_name',
      label: 'Property Name *',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter property name';
        }
        return null;
      },
      controller: controller.propertyNameController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
        LengthLimitingTextInputFormatter(50),
      ],
    );
  }

  Widget _propertyPrice() {
    return AppTextField(
      name: 'property_price',
      label: 'Property Price *',
      keyboardType: TextInputType.number,
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Please enter property price';
        }
        return null;
      },
      controller: controller.propertyValueController,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(10),
      ],
    );
  }

  Widget _propertyType() {
    return AppDropDown(
      name: 'property_type',
      labelText: 'Property Type *',
      initialValue: controller.propertyType.value,
      items: [
        ...(controller.propertyOptions ?? <Options>[]).map(
          (map) => DropdownMenuItem(
            value: map.friendlyType.toString(),
            onTap: () {
              controller.propertyValue(map.type.toString());
            },
            child: Text(map.friendlyType.toString()),
          ),
        ),
      ],
      validator: (value) {
        if (value == null) {
          return 'Please select property type';
        }
        return null;
      },
    );
  }

  Widget _propertySize() {
    return AppTextField(
      name: 'property_size',
      label: 'Property Size (Sqft)*',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter property size';
        }
        return null;
      },
      controller: controller.propertySize,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }

  Widget _constructionYear() {
    return AppTextField(
      name: 'construction_year',
      label: 'Year of Construction *',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter year of construction';
        }
        return null;
      },
      controller: controller.propertyYearController,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(4),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }

  Widget _propertyAddress() {
    return AppTextField(
      name: 'property_address',
      label: 'Property Address *',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter property address';
        }
        return null;
      },
      controller: controller.propertyAddressController,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')),
        LengthLimitingTextInputFormatter(100),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }

  Widget _postalCode() {
    return AppTextField(
      name: 'postal_code',
      label: 'Postal Box Number *',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter postal box number';
        }
        return null;
      },
      controller: controller.propertyZipController,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }

  Widget _sellerName() {
    return AppTextField(
      name: 'seller_name',
      label: 'Seller Name *',
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter seller name';
        }
        return null;
      },
      controller: controller.propertySellerController,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[a-z A-Z]')),
        LengthLimitingTextInputFormatter(30),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }

  Widget _sellerContact() {
    return AppTextField(
      name: 'seller_contact_info',
      label: 'Seller Contact Number *',
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter seller contact number';
        }
        return null;
      },
      controller: controller.propertySellerContactController,
      inputFormatters: [
        NoLeadingSpaceFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(9),
        FilteringTextInputFormatter.deny('  '),
      ],
    );
  }
}
