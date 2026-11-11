import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_bottomnav_buttons.dart';
import '../../../components/ui/ag_date_field.dart';
import '../../../components/ui/ag_dropdown.dart';
import '../../../components/ui/ag_radio_button.dart';
import '../../../components/ui/ag_record_card_list.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../data/model/common/option.dart';
import '../../../routes/app_pages.dart';
import '../controllers/add_dependent_controller.dart';

class AddDependentView extends GetView<AddDependentController> {
  const AddDependentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Dependent Details'),

      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            // 👇 IMPORTANT: Extra bottom padding to avoid overlap
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.showForm.value)
                  buildDependentForm()
                else ...[
                  AgRecordListCard(
                    records: controller.dependents,
                    onAddMore: () => controller.showForm.value = true,
                    onRemove: controller.removeDependent,
                    mapToDisplayList:
                        (item) => [
                          {"label": "First Name", "value": item["firstName"]},
                          {"label": "Last Name", "value": item["lastName"]},
                          {
                            "label": "Gender",
                            "value": item["gender"]?['friendlyType'] ?? '',
                          },
                          {"label": "Dob", "value": item["dob"]},
                          {
                            "label": "Relation Ship",
                            "value":
                                item["relationship"]?['friendlyType'] ?? '',
                          },
                          {"label": "Occupation", "value": item["occupation"]},
                          {
                            "label": "Monthly Income",
                            "value": item["monthlyInc"],
                          },
                          {"label": "Phone Number", "value": item["contactNo"]},
                          {
                            "label": "Id Type",
                            "value": item["idType"]?['friendlyType'] ?? '',
                          },
                          {"label": "Id Number", "value": item["idNumber"]},
                        ],
                  ),
                ],
              ],
            ),
          ),
        );
      }),

      // 👇 FIXED BOTTOM BAR
      bottomNavigationBar: Obx(() {
        return Visibility(
          visible: !controller.isLoading.value,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavButtons(
                  onBack: () => Get.back(),
                  onSaveDraft: () => controller.saveDependent("saveAsDraft"),
                  onNext: () => controller.saveDependent("next"),
                ),
                AgButton(
                  isTextButton: true,
                  title: "Skip and Continue",
                  onTap: () => Get.toNamed(Routes.COMMUNICATION_DETAILS),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // =================== SECTIONS ===================

  Widget genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 20,
          children:
              controller.genderList.map((option) {
                return Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<Option>(
                        value: option,
                        groupValue: controller.gender.value,
                        onChanged: (v) => controller.gender.value = v,
                      ),
                      Text(option.friendlyType ?? ""),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget dependentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Dependent ?", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        Wrap(
          spacing: 20,
          children:
              controller.dependentList.map((option) {
                return Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<Option>(
                        value: option,
                        groupValue: controller.selectedDependent.value,
                        onChanged:
                            (v) => controller.selectedDependent.value = v,
                      ),
                      Text(option.friendlyType ?? ""),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  // =================== FORM ===================

  Widget buildDependentForm() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade900, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AgTextField(
            name: "First Name",
            label: "First Name",
            inputType: AgInputType.stringOnly,
            onChanged: (v) => controller.firstName.value = v ?? '',
          ),

          AgTextField(
            name: "Last Name",
            label: "Last Name",
            inputType: AgInputType.stringOnly,
            onChanged: (v) => controller.lastName.value = v ?? '',
          ),

          const SizedBox(height: 12),

          genderSection(),

          AgDateField(
            name: "dob",
            label: "Date of Birth",
            rxDate: controller.dob,
            lastDate: DateTime.now(),
            onSelect: (d) => controller.dob.value = d,
          ),

          const SizedBox(height: 12),

          Obx(() {
            return AgDropdownField(
              name: "relation",
              label: "Relation",
              items:
                  controller.relationTypeList
                      .map((e) => e.friendlyType ?? "")
                      .toList(),
              value: controller.relation.value?.friendlyType,
              onChanged: (v) {
                controller.relation.value = controller.relationTypeList
                    .firstWhere((e) => e.friendlyType == v);
              },
            );
          }),

          const SizedBox(height: 12),
          dependentSection(),

          AgTextField(
            name: "Occupation",
            label: "Occupation",
            onChanged: (v) => controller.occupation.value = v ?? '',
          ),

          AgTextField(
            name: "Income",
            label: "Monthly Income (${AgConstants.currency})",
            keyboardType: TextInputType.number,
            onChanged: (v) => controller.income.value = v ?? '',
          ),

          AgTextField(
            name: "Phone",
            label: "Contact Number",
            keyboardType: TextInputType.phone,
            maxLength: 10,
            onChanged: (v) => controller.phone.value = v ?? '',
          ),

          const SizedBox(height: 12),

          Obx(() {
            return AgDropdownField(
              name: "id_type",
              label: "Id Type",
              items:
                  controller.idTypeList
                      .map((e) => e.friendlyType ?? "")
                      .toList(),
              value: controller.idType.value?.friendlyType,
              onChanged: (v) {
                controller.idType.value = controller.idTypeList.firstWhere(
                  (e) => e.friendlyType == v,
                );
              },
            );
          }),

          AgTextField(
            name: "Id Number",
            label: "Id Number",
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 16,
            onChanged: (v) => controller.idNumber.value = v ?? '',
          ),

          const SizedBox(height: 20),

          Center(
            child: AgButton(
              title: "Add",
              onTap: () => controller.addDependent(),
            ),
          ),
        ],
      ),
    );
  }
}
