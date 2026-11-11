import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_string_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/land_farm_details_controller.dart';

class LandFarmDetailsView extends GetView<LandFarmDetailsController> {
  const LandFarmDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: "Land Details"),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child:
              controller.landDetails.isEmpty
                  ? const Center(child: Text("No land details found"))
                  : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: controller.landDetails.length,
                    itemBuilder: (_, index) {
                      final land = controller.landDetails[index];
                      return _buildLandCard(land, index);
                    },
                  ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Row(
              children: [
                Expanded(
                  child: AgButton(
                    title: 'Select Farmer',
                    onTap: controller.showMemberPopup,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AgButton(title: "Save", onTap: controller.onSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- LAND CARD ----------
  Widget _buildLandCard(LandDetail land, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row('Village', land.village ?? ''),
          const SizedBox(height: 10),
          _row(
            'Owned Area ${StringUtil.formatUnit(land.areaUnit ?? '')}',
            '${land.ownedArea ?? ''}',
          ),
          const SizedBox(height: 10),
          _row(
            'Leased Area ${StringUtil.formatUnit(land.areaUnit ?? '')}',
            '${land.leasedArea ?? ''}',
            valueBold: true,
          ),
          const SizedBox(height: 10),
          _row('Irrigated %', '${land.irrigatedPerc ?? ''}', valueBold: true),
          const SizedBox(height: 10),

          /// Source of irrigation + checkbox
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Source of irrigation',
                  style: TextStyle(fontSize: 15, color: Color(0xff8A8F94)),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  land.sourceOfIrrigation ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Checkbox(
                value: land.isChecked ?? false,
                onChanged: (v) => controller.toggleLandChecked(index, v),
                activeColor: AgColors.colorPrimaryDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          _row('Farm value', '${land.farmValue ?? ''}', valueBold: true),
          const SizedBox(height: 12),

          const Text(
            'Land Contribution',
            style: TextStyle(fontSize: 15, color: AgColors.colorPrimaryDark),
          ),

          /// 🔥 NO CONTROLLER – value stored per land
          AgTextField(
            name: "",
            keyboardType: TextInputType.number,
            initialValue: land.contribution?.toString() ?? '',
            onChanged: (value) {
              land.contribution = int.tryParse(value ?? "0");
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool valueBold = false}) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(fontSize: 15, color: Color(0xff8A8F94)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: valueBold ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
