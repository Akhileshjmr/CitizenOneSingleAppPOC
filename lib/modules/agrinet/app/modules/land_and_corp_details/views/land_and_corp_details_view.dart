import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_bottomnav_buttons.dart';
import '../../../components/ui/ag_record_card_list.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../data/model/common/option.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_constants.dart';
import '../controllers/land_and_corp_details_controller.dart';

class LandAndCorpDetailsView extends GetView<LandAndCorpDetailsController> {
  const LandAndCorpDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Land and Crop Details"),

      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ------------------------------------------------
              // SHOW FORM OR CARD AFTER ADDING
              // ------------------------------------------------
              controller.showForm.value
                  ? buildFormUI()
                  : buildAddedRecordCard(),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),

      bottomNavigationBar: Obx(() {
        return Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: BottomNavButtons(
              onBack: () => Get.back(),
              onSaveDraft: () => controller.saveLandDetails("saveAsDraft"),
              onNext: () => controller.saveLandDetails("next"),
            ),
          ),
        );
      }),
    );
  }

  // ----------------------------------------------------------------
  // FORM UI
  // ----------------------------------------------------------------
  Widget buildFormUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AgColors.colorPrimary, width: 1),
        borderRadius: BorderRadius.circular(10),
        color: AgColors.kWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------- AREA UNIT --------------------
          Obx(() {
            final items =
                controller.areaUnitList
                    .map((e) => e.friendlyType ?? "")
                    .toList();

            final selected = controller.areaUnit.value?.friendlyType;

            return AgDropdownField(
              name: "Primary Area Unit",
              label: "Primary Area Unit",
              hintText: "Select Area Unit",

              items: items,

              value:
                  (selected != null && items.contains(selected))
                      ? selected
                      : null,

              onChanged: (v) {
                controller.areaUnit.value = controller.areaUnitList.firstWhere(
                  (e) => e.friendlyType == v,
                );
              },
            );
          }),

          AgTextField(
            name: "Village",
            label: "Village",
            onChanged: (v) => controller.village.value = v ?? '',
          ),

          // -------------------- AREA --------------------
          Obx(() {
            final unit = controller.areaUnit.value?.friendlyType ?? "";

            return AgTextField(
              name: "Area",

              label: unit.isNotEmpty ? "Area ($unit)" : "Area",

              inputType: AgInputType.numberOnly,

              onChanged: (v) {
                controller.area.value = int.tryParse(v ?? "0") ?? 0;
              },
            );
          }),

          label("Type"),
          Obx(
            () => Row(
              children: [
                Radio<Option>(
                  value: controller.ownedOption,
                  groupValue: controller.landType.value,
                  onChanged: (val) => controller.landType.value = val,
                ),
                const Text("Owned Area"),
                const SizedBox(width: 20),
                Radio<Option>(
                  value: controller.leasedOption,
                  groupValue: controller.landType.value,
                  onChanged: (val) => controller.landType.value = val,
                ),
                const Text("Leased Area"),
              ],
            ),
          ),

          AgTextField(
            name: "Irrigated (%)",
            label: "Irrigated (%)",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            onChanged:
                (v) =>
                    controller.irrigatedPerc.value =
                        int.tryParse(v ?? "0") ?? 0,
          ),

          Obx(() {
            return AgDropdownField(
              name: "Source of irrigation",
              label: "Source of irrigation",
              items:
                  controller.sourceOfIrrigationList
                      .map((e) => e.friendlyType ?? "")
                      .toList(),
              value: controller.sourceOfIrrigation.value?.friendlyType,
              onChanged: (v) {
                controller.sourceOfIrrigation.value = controller
                    .sourceOfIrrigationList
                    .firstWhere((e) => e.friendlyType == v);
              },
            );
          }),

          AgTextField(
            name: "Farm Value",
            label: "Farm Value (${AgConstants.currency})",
            keyboardType: TextInputType.number,
            maxLength: AgConstants.maxAmountLength,
            onChanged:
                (v) => controller.farmValue.value = int.tryParse(v ?? "0") ?? 0,
          ),

          Obx(() {
            return AgDropdownField(
              name: "Season",
              label: "Season",
              items:
                  controller.seasonList
                      .map((e) => e.friendlyType ?? "")
                      .toList(),
              value: controller.season.value?.friendlyType,
              onChanged: (v) {
                controller.season.value = controller.seasonList.firstWhere(
                  (e) => e.friendlyType == v,
                );
              },
            );
          }),

          AgTextField(
            name: "Crop Name",
            label: "Crop Name",
            onChanged: (v) => controller.cropName.value = v ?? '',
          ),

          Obx(() {
            final unit = controller.areaUnit.value?.friendlyType ?? "";

            return AgTextField(
              name: "Cultivated Land Area",

              label:
                  unit.isNotEmpty
                      ? "Cultivated Land Area ($unit)"
                      : "Cultivated Land Area",

              keyboardType: TextInputType.number,

              onChanged: (v) {
                controller.cultLandArea.value = int.tryParse(v ?? "0") ?? 0;
              },
            );
          }),

          const SizedBox(height: 20),

          Center(child: AgButton(title: "Add", onTap: controller.addRecord)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------
  // CARD UI AFTER ADDING RECORD
  // ----------------------------------------------------------------
  Widget buildAddedRecordCard() {
    return AgRecordListCard(
      records: controller.landRecordList,
      onAddMore: () => controller.showForm.value = true,
      onRemove: controller.removeLandRecord,

      mapToDisplayList:
          (item) => [
            {
              "label": "Primary Area Unit",
              "value": item["areaUnit"]?["type"] ?? '',
            },
            {"label": "Village", "value": item['village'] ?? ''},
            {"label": "Area", "value": item['area']?.toString() ?? ''},
            {"label": "Land Type", "value": item['landType'] ?? ''},
            {"label": "Irrigated (%)", "value": "${item['irrigatedPerc']}"},
            {"label": "Source", "value": item['sourceOfIrrigation'] ?? ''},
            {
              "label": "Farm Value",
              "value": item['farmValue']?.toString() ?? '',
            },
            {"label": "Season", "value": item['season'] ?? ''},
            {"label": "Crop Name", "value": item['cropName'] ?? ''},
            {
              "label": "Cultivated Area",
              "value": item['cultLandArea']?.toString() ?? '',
            },
          ],
    );
  }

  Widget equalRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: kw500White14)),
        Expanded(child: Text(value, style: kw500White14)),
      ],
    );
  }

  // ----------------------------------------------------------------
  // Common Widgets
  // ----------------------------------------------------------------
  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
