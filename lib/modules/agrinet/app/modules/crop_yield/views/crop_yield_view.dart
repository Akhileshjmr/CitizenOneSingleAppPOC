import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_record_card_list.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_colors.dart';
import '../../../utils/ag_constants.dart';
import '../../../utils/enums/nav_types.dart';
import '../controllers/crop_yield_controller.dart';

class CropYieldView extends GetView<CropYieldController> {
  const CropYieldView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Crop Yield History"),

      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child:
                controller.showForm.value
                    ? buildFormUI()
                    : buildAddedRecordCard(),
          ),
        );
      }),

      bottomNavigationBar: Obx(() {
        return Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                bottomBtn("Back", NavType.back, true),
                SizedBox(width: defaultMargin),
                bottomBtn("Save", NavType.save, false),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ------------------ FORM UI ------------------
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
          Obx(
            () => AgDropdownField(
              name: "Year",
              label: "Year",
              items:
                  controller.yearList.map((e) => e.friendlyType ?? "").toList(),
              value: controller.selectedYear.value?.friendlyType,
              onChanged: (v) {
                controller.selectedYear.value = controller.yearList.firstWhere(
                  (e) => e.friendlyType == v,
                );
              },
            ),
          ),

          Obx(
            () => AgDropdownField(
              name: "Season",
              label: "Season",
              items:
                  controller.seasonList
                      .map((e) => e.friendlyType ?? "")
                      .toList(),
              value: controller.selectedSeason.value?.friendlyType,
              onChanged: (v) {
                controller.selectedSeason.value = controller.seasonList
                    .firstWhere((e) => e.friendlyType == v);
              },
            ),
          ),

          AgTextField(
            name: "Crop Name",
            label: "Crop Name",
            onChanged: (v) => controller.cropName.value = v ?? "",
          ),

          AgTextField(
            name: "Yield",
            label: "Yield (kg/acre)",
            keyboardType: TextInputType.number,
            onChanged:
                (v) => controller.yield.value = double.tryParse(v ?? "0") ?? 0,
          ),

          AgTextField(
            name: "Yield Value",
            label: "Yield value (${AgConstants.currency})",
            keyboardType: TextInputType.number,
            maxLength: AgConstants.maxAmountLength,
            onChanged:
                (v) =>
                    controller.yieldValue.value =
                        double.tryParse(v ?? "0") ?? 0,
          ),

          const SizedBox(height: 20),
          Center(child: AgButton(title: "Add", onTap: controller.addRecord)),
        ],
      ),
    );
  }

  // ------------------ LIST UI (Card view) ------------------
  Widget buildAddedRecordCard() {
    return AgRecordListCard(
      records: controller.yieldRecordList,
      onAddMore: () => controller.showForm.value = true,
      onRemove: controller.removeRecord,
      mapToDisplayList:
          (item) => [
            {"label": "Year", "value": item["year"]},
            {"label": "Season", "value": item["season"]},
            {"label": "Crop Name", "value": item["cropName"]},
            {"label": "Yield", "value": item["yield"]},
            {"label": "Yield Value", "value": item["yieldValue"]},
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

  Widget bottomBtn(String title, NavType navType, bool isOutlined) {
    return AgButton(
      title: title,
      width: 100,
      isOutlined: isOutlined,
      onTap: () {
        switch (navType) {
          case NavType.back:
            Get.back();
            break;

          case NavType.save:
            controller.saveYieldDetails("saveAsDraft");
            break;
          case NavType.next:
            throw UnimplementedError();
        }
      },
    );
  }
}
