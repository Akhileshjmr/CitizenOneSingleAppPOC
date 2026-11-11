import 'package:citizenone_app/modules/agrinet/app/app_environment.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_png_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_textfield.dart';
import '../../../utils/ag_assets.dart';
import '../../../utils/ag_colors.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
              image: AssetImage(
                AgAssets.loginBackground,
                package: AppEnvironment.packageName,
              ),
              fit: BoxFit.cover,
            ),
          ),

          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: w * 0.88,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// LOGO
                    Center(
                      child: RepaintBoundary(
                        child: SizedBox(
                          width: w * 0.35,
                          child: PngImage.agriLogo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    /// USERNAME
                    AgTextField(
                      name: 'username',
                      controller: controller.usernameCtrl,
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AgColors.colorPrimaryDark,
                        size: 22,
                      ),
                      label: 'Username',
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD
                    AgTextField(
                      name: 'password',
                      controller: controller.passwordCtrl,
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: AgColors.colorPrimaryDark,
                        size: 22,
                      ),
                      label: 'Password',
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Change Ip",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// SIGN IN BUTTON
                    Center(
                      child: Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: w * 0.45,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2D7A3E), Color(0xFF4DB84A)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap:
                                controller.isLoading.isTrue
                                    ? null
                                    : controller.login,
                            child: Center(
                              child:
                                  controller.isLoading.isTrue
                                      ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.3,
                                        ),
                                      )
                                      : const Text(
                                        "SIGN IN",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.1,
                                        ),
                                      ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 45),

                    /// SIGN UP
                    GestureDetector(
                      onTap: () {
                        // Get.toNamed(Routes.SIGN_UP_TYPE);
                        Get.toNamed(
                          Routes.REGISTRATION,
                          arguments: {'type': 'Buyer'},
                        );
                      },
                      child: Center(
                        child: Column(
                          children: const [
                            Text(
                              "Don't have an Account?",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
