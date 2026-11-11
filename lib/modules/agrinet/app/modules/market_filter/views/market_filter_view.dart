import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/base_screen.dart';
import '../../../data/config/ag_dimens.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/market_filter_controller.dart';

class MarketFilterView extends GetView<MarketFilterController> {
  const MarketFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Market Filter"),

      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---------- DATE ROW ----------
                  Row(
                    children: [
                      Expanded(child: datePickerWidget(isFrom: true)),
                      Container(width: 1, height: 90, color: Colors.grey),
                      Expanded(child: datePickerWidget(isFrom: false)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ---------- STATE DROPDOWN ----------
                  Obx(() {
                    final items =
                        controller.stateNames; // computed in controller
                    final selected = controller.selectedStateName;

                    return AgDropdownField(
                      name: "State",
                      label: "State",
                      items: items,
                      value: selected,
                      onChanged: (v) {
                        controller.updateSelectedState(v);
                      },
                    );
                  }),

                  const SizedBox(height: 20),

                  /// ---------- COMMODITY DROPDOWN ----------
                  Obx(() {
                    final items = controller.commodityNames;
                    final selected = controller.selectedCommodityName;

                    return AgDropdownField(
                      name: "Commodity",
                      label: "Commodity",
                      items: items,
                      value: selected,
                      onChanged: (v) {
                        controller.updateSelectedCommodity(v);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: AgButton(
              title: "Filter",
              onTap: () => controller.applyFilters(),
            ),
          ),
        ),
      ),
    );
  }

  /// DATE PICKER WIDGET
  Widget datePickerWidget({required bool isFrom}) {
    return InkWell(
      onTap: () {
        isFrom ? controller.pickFromDate() : controller.pickToDate();
      },

      child: Column(
        children: [
          Icon(Icons.calendar_today, size: 50, color: AgColors.colorPrimary),
          const SizedBox(height: 5),

          Text(
            isFrom ? "From" : "To",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 5),

          /// Only the text updates — optimized!
          Obx(() {
            final date =
                isFrom ? controller.fromDate.value : controller.toDate.value;

            return Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          }),
        ],
      ),
    );
  }
}
