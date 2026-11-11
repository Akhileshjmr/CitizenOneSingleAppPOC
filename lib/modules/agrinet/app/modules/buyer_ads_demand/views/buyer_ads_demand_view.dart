import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_date_field.dart';
import '../../../components/ui/ag_loader.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/buyer_ads_demand_controller.dart';

class BuyerAdsDemandView extends GetView<BuyerAdsDemandController> {
  const BuyerAdsDemandView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F1ED),
      appBar: AgAppbar(title: "Buyer Demands"),

      body: Obx(
        () =>
            controller.isSubmitting.value
                ? const Center(child: AgLoader())
                : Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9F1ED),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade400),
                        ),

                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AgTextField(
                                      name: "commodity",
                                      label: "Commodity",
                                      controller: controller.cropName,
                                    ),

                                    const SizedBox(height: 16),

                                    AgTextField(
                                      name: "min_price",
                                      label: "Minimum price per kilogram",
                                      controller: controller.pricePerKg,
                                      keyboardType: TextInputType.number,
                                    ),

                                    const SizedBox(height: 16),

                                    AgTextField(
                                      name: "total_qty",
                                      label: "Total quantity",
                                      controller: controller.totalQty,
                                      keyboardType: TextInputType.number,
                                    ),

                                    const SizedBox(height: 16),

                                    AgDateField(
                                      name: "required_on",
                                      label: "Required On",
                                      rxDate: controller.requiredDate,
                                      format: "dd/MM/yyyy",
                                      firstDate: DateTime.now(),
                                      onSelect:
                                          (date) => controller
                                              .updateRequiredDate(date),
                                    ),

                                    const SizedBox(height: 16),

                                    AgTextField(
                                      name: "description",
                                      label: "Description",
                                      controller: controller.description,
                                      maxLines: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            AgButton(
                              title: "Publish",
                              onTap: controller.submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
