import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/crop_suggestion_controller.dart';

class CropSuggestionView extends GetView<CropSuggestionController> {
  const CropSuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: "Crop Suggestion"),

      body: Obx(
        () => Visibility(
          visible: controller.isLoading.isFalse,
          replacement: const Center(child: CircularProgressIndicator()),
          child: Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   color: const Color(0xffE6F1F2),
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //   child: const Text(
              //     "Recommended Crop",
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              //   ),
              // ),
              const SizedBox(height: 4),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount:
                        controller.crops.value?.recommendedCrop?.length ?? 0,
                    itemBuilder: (_, index) {
                      final model =
                          controller.crops.value!.recommendedCrop![index];
                      return _buildCropItem(model);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: AgButton(title: "Submit", onTap: controller.onSubmit),
      ),
    );
  }

  /// ----------------------------
  /// CROP ITEM UI (Earlier separate class)
  /// ----------------------------
  Widget _buildCropItem(RecommendedCrop? model) {
    const Color kGreen = Color(0xff4F6F39);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelValue("Crop Name", model?.cropName ?? ''),
          const SizedBox(height: 6),

          _labelValue("Varient", model?.varienty ?? ''),
          const SizedBox(height: 6),

          Row(
            children: [
              const Text(
                "Recommended",
                style: TextStyle(fontSize: 15, color: Color(0xff71808F)),
              ),
              const SizedBox(width: 16),

              Obx(
                () => Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: model?.recommended.value ?? false,
                      onChanged: (v) {
                        if (v == null) return;
                        model?.recommended.value = v;
                      },
                      activeColor: kGreen,
                    ),
                    const Text("Yes", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              Obx(
                () => Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: model?.recommended.value ?? false,
                      onChanged: (v) {
                        if (v == null) return;
                        model?.recommended.value = v;
                      },
                      activeColor: kGreen,
                    ),
                    const Text("No", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ----------------------------
  /// LABEL + VALUE WIDGET
  /// ----------------------------
  Widget _labelValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xff71808F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
