import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_bottomnav_buttons.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/communication_details_controller.dart';

class CommunicationDetailsView extends GetView<CommunicationDetailsController> {
  const CommunicationDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF5F4),

      appBar: AgAppbar(title: 'Communication Details'),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade900, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AgTextField(
                    name: "Farm Address",
                    label: "Farm Address",
                    controller: controller.addressController,
                    onChanged: (v) => controller.address.value = v ?? '',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.getAddress();
                      },
                      child: Icon(
                        Icons.location_on_sharp,
                        color: AgColors.FF4500,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AgTextField(
                    name: "Phone Number",
                    label: "Phone Number",
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    inputType: AgInputType.numberOnly,
                    onChanged: (v) => controller.phone.value = v ?? '',
                    maxLength: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Bottom Buttons
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: BottomNavButtons(
              onBack: () => Get.back(),
              onSaveDraft: () => controller.saveContactInfo("saveAsDraft"),
              onNext: () => controller.saveContactInfo("next"),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------- WIDGETS -----------------------

  Widget buildTextField(String label, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 4),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3E5E2A)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF3E5E2A)),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldWithIcon({
    required String label,
    required TextEditingController ctrl,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 4),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3E5E2A)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3E5E2A)),
                  ),
                ),
              ),
            ),
            Icon(icon, color: Colors.orange, size: 32),
          ],
        ),
      ],
    );
  }
}
