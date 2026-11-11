import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/yield_details_controller.dart';
import 'CropCard.dart';

class YieldDetailsView extends GetView<YieldDetailsController> {
  const YieldDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Yield Details'),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: Column(
            children: [
              // header "Yield Details"
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: const Color(0xFFF2F7F8),
                child: const Text(
                  'Yield Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),

              // list of crop cards
              Expanded(
                child: Obx(() {
                  final data = controller.yieldDetails.value;
                  if (data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: data.yieldDet!.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final crop = data.yieldDet?[index];
                      return CropCard(
                        index: index,
                        crop: crop,
                        onYieldChanged:
                            (value) => controller.onYieldChanged(index, value),
                        onYieldValueChanged:
                            (value) =>
                                controller.onYieldValueChanged(index, value),
                        onVerifyTap: () => controller.toggleVerify(index),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // bottom submit button
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: AgButton(title: "Submit", onTap: controller.submit),
            ),
          ),
        ),
      ),
    );
  }
}
