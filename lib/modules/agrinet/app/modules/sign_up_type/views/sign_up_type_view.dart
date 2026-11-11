import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ag_assets.dart';
import '../controllers/sign_up_type_controller.dart';

class SignUpTypeView extends GetView<SignUpTypeController> {
  const SignUpTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final h = Get.height;
    final w = Get.width;

    return Scaffold(
      backgroundColor: AgColors.colorPrimary,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AgAssets.loginBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _userTypeButton(
                  icon: Icons.person,
                  text: "Buyer",
                  onTap: () {
                    Get.toNamed(
                      Routes.REGISTRATION,
                      arguments: {'type': 'Buyer'},
                    );
                  },
                ),

                const SizedBox(height: 40),

                _userTypeButton(
                  icon: Icons.person,
                  text: "Vendor",
                  onTap: () {
                    Get.toNamed(
                      Routes.REGISTRATION,
                      arguments: {'type': 'Vendor'},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userTypeButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width * 0.70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AgColors.colorSecondaryDark, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AgColors.colorPrimary, size: 32),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
