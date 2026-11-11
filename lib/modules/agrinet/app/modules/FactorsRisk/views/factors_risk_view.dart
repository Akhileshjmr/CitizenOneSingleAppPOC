import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_radio_button.dart';
import '../../../data/model/common/option.dart';
import '../../../theme/ag_text_styles.dart';
import '../controllers/factors_risk_controller.dart';

class FactorsRiskView extends GetView<FactorsRiskController> {
  const FactorsRiskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Factors and Risk'),

      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              radioGroupOption(
                title: "Climatic Conditions",
                options: controller.getOptions('CLIMATE_CONDITION'),
                selected: controller.climaticConditions,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Soil Fertility",
                options: controller.getOptions('SOIL_FERTILITY'),
                selected: controller.soilFertility,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Seed Quality",
                options: controller.getOptions('SEED_QUALITY'),
                selected: controller.seedQuality,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Fertilizers Usage",
                options: controller.getOptions('FERTILIZERS_USAGE'),
                selected: controller.fertilizersUsage,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Pesticides / Chemicals Usage",
                options: controller.getOptions('CHEMICALS_USAGE'),
                selected: controller.chemicalsUsage,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Irrigation Method",
                options: controller.getOptions('IRRIGATION_METHOD'),
                selected: controller.irrigationMethod,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Irrigation Coverage",
                options: controller.getOptions('IRRIGATION_COVERAGE'),
                selected: controller.irrigationCoverage,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Agro Equipment Availability",
                options: controller.getOptions('AGRO_EQUIPMNT_AVAILABLE'),
                selected: controller.agroEquipmentAvail,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Access to Credit",
                options: controller.getOptions(
                  'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
                ),
                selected: controller.accessToCredit,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Labour Availability",
                options: controller.getOptions(
                  'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
                ),
                selected: controller.labourAvailability,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Forecasted Yield",
                options: controller.getOptions('FORECASTED_YIELD'),
                selected: controller.forecastedYield,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Electricity Supply",
                options: controller.getOptions('ELECTRICITY_SUPPLY'),
                selected: controller.electricitySupply,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Storage Availability",
                options: controller.getOptions(
                  'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
                ),
                selected: controller.storageAvailability,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Transportation Availability",
                options: controller.getOptions(
                  'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
                ),
                selected: controller.transportationAvail,
              ),
              const SizedBox(height: 9),
              Divider(),
              const SizedBox(height: 9),

              radioGroupOption(
                title: "Harvest & Marketing",
                options: controller.getOptions(
                  'ACCES_LABOUR_STORAGE_TRANSP_HARVEST',
                ),
                selected: controller.harvestMarketing,
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: AgButton(
                title: 'Save and Continue',
                onTap: controller.onSaveAndContinue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget radioGroupOption({
    required String title,
    required List<Option> options,
    required Rxn<Option> selected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: k297B33FS16w600),
        const SizedBox(height: 6),

        Obx(
          () => Wrap(
            spacing: 20,
            runSpacing: 8,
            children:
                options.map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<Option>(
                        value: option,
                        groupValue: selected.value,
                        onChanged: (v) => selected.value = v,
                      ),
                      Text(option.friendlyType ?? option.type ?? ''),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
