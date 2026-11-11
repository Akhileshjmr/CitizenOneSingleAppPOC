import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_loader.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';

import '../../../components/ui/app_drop_down.dart';
import '../../../components/utils/No_leading_space_formatter.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../routes/app_pages.dart';
import '../controllers/auto_vehicle_form_controller.dart';

class AutoVehicleFormView extends GetView<AutoVehicleFormController> {
  const AutoVehicleFormView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AgAppbar(title: 'Vehicle Information'),
    bottomNavigationBar: Obx(
      () => Visibility(
        visible: controller.isLoading.isFalse,
        replacement: const Center(child: AgLoader()),
        child: Row(
          children: [
            Expanded(
              child: AgButton(
                title: 'Skip & Continue',
                isOutlined: true,
                onTap: () {
                  Get.toNamed<void>(
                    Routes.PRE_APPROVE_FINANCE_PARTNER,
                    arguments: ['/vehicleloan', 'New'],
                  );
                },
              ),
            ),

            20.horizontalSpace,

            Expanded(
              child: AgButton(
                title: 'Continue',
                onTap: controller.addVehicleDetails,
              ),
            ),
          ],
        ).paddingOnly(right: 20.w, left: 20.w, bottom: 20.h),
      ),
    ),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          padding: REdgeInsets.only(top: 20),
          physics: const BouncingScrollPhysics(),
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: IntrinsicHeight(
            child: FormBuilder(
              key: controller.vehicleFormKey,
              child: Column(
                children: [
                  AppTextField(
                    name: 'vehicle_name',
                    label: 'Vehicle Name *',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter vehicle name';
                      }
                      return null;
                    },
                    controller: controller.vehicleNameController,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z A-Z 0-9]'),
                      ),
                      LengthLimitingTextInputFormatter(30),
                      FilteringTextInputFormatter.deny('  '),
                    ],
                  ),
                  10.verticalSpace,
                  AppTextField(
                    name: 'vehicle_type',
                    label: 'Type of Vehicle *',
                    hintText: 'Type of Vehicle *',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter type of vehicle';
                      }
                      return null;
                    },
                    controller: controller.vehicleTypeController,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z A-Z 0-9]'),
                      ),
                      LengthLimitingTextInputFormatter(30),
                      FilteringTextInputFormatter.deny('  '),
                    ],
                  ),
                  10.verticalSpace,
                  AppTextField(
                    name: 'vehicle_description',
                    label: 'Vehicle Description *',
                    hintText: 'Vehicle Description *',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter vehicle description';
                      }
                      return null;
                    },
                    controller: controller.vehicleDescriptionController,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      LengthLimitingTextInputFormatter(200),
                      FilteringTextInputFormatter.deny('  '),
                    ],
                  ),
                  10.verticalSpace,
                  AppDropDown(
                    name: 'vehicle_condition',
                    labelText: 'Vehicle Condition *',
                    initialValue: controller.condtion.value,
                    items: [
                      ...(controller.vehicleConditionOptions ?? <Options>[])
                          .map(
                            (map) => DropdownMenuItem(
                              value: map.friendlyType.toString(),
                              onTap: () {
                                controller.condtion(
                                  map.friendlyType.toString(),
                                );
                              },
                              child: Text(map.friendlyType.toString()),
                            ),
                          ),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select vehicle condition';
                      }
                      return null;
                    },
                  ),
                  10.verticalSpace,
                  AppDropDown(
                    name: 'manufacturer',
                    labelText: 'Manufacturer *',
                    initialValue: controller.manufacturer.value,
                    items: [
                      ...(controller.manufacturerOptions ?? <Options>[]).map(
                        (map) => DropdownMenuItem(
                          value: map.friendlyType.toString(),
                          onTap: () {
                            controller.manufacturer(
                              map.friendlyType.toString(),
                            );
                          },
                          child: Text(map.friendlyType.toString()),
                        ),
                      ),
                    ],
                    validator: (value) {
                      if (value == null) {
                        return 'Please select manufacturer';
                      }
                      return null;
                    },
                  ),
                  10.verticalSpace,
                  AppTextField(
                    name: 'vehicle_color',
                    label: 'Vehicle Color *',
                    hintText: 'Vehicle Color *',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter vehicle color';
                      }
                      return null;
                    },
                    controller: controller.vehicleColorController,
                    inputFormatters: [
                      NoLeadingSpaceFormatter(),
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z A-Z 0-9]'),
                      ),
                      LengthLimitingTextInputFormatter(30),
                      FilteringTextInputFormatter.deny('  '),
                    ],
                  ),
                  10.verticalSpace,
                  AppTextField(
                    name: 'year_make',
                    label: 'Year Make *',
                    hintText: 'Year Make *',
                    keyboardType: TextInputType.number,
                    // obscureText: true,
                    validator: (value) {
                      if (value == false || value == null || value == '') {
                        return 'Please enter vehicle year';
                      }
                      return null;
                    },
                    controller: controller.vehicleYearController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                  10.verticalSpace,
                  AppTextField(
                    name: 'vehicle_price',
                    label: 'Vehicle Price *',
                    hintText: 'Vehicle Price *',
                    keyboardType: TextInputType.number,
                    // obscureText: true,
                    validator: (String? value) {
                      if (value == null || value == '') {
                        return 'Please enter vehicle price';
                      }
                      return null;
                    },
                    controller: controller.vehiclePriceController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                ],
              ),
            ).paddingSymmetric(horizontal: 20.w),
          ),
        ),
      ),
    ),
  );
}
