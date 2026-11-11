import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/text_field/app_textfield.dart';

import '../../../app_environment.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../data/constants/app_assets.dart';
import '../../../session/session_manager.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (AppEnvironment.isEmbeddedInHostApp) {
          await Get.find<SessionManager>().exitModule();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Obx(
          () => BaseScreen(
            isLoading: controller.isLoading.value,
            child: Scaffold(
              appBar:
                  AppEnvironment.isEmbeddedInHostApp
                      ? AgAppbar(
                        title: '',
                        showDivider: false,
                        showLeadingIcon: true,
                        leadingOnTap:
                            () => Get.find<SessionManager>().exitModule(),
                      )
                      : const PreferredSize(
                        preferredSize: Size.zero,
                        child: SizedBox.shrink(),
                      ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.zampost_logo,
                      fit: BoxFit.fill,
                      package: AppEnvironment.packageName,
                    ),
                    40.verticalSpace,
                    Row(
                      children: [
                        Text(
                          AppEnvironment.isEmbeddedInHostApp
                              ? "Customer's Phone Number"
                              : 'Log in to continue',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppTextField(
                      controller: controller.phoneNumberController,
                      name: 'Enter phone number',
                      hintText: 'Enter phone number',
                      inputType: AppTextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    AgButton(
                      title:
                          AppEnvironment.isEmbeddedInHostApp
                              ? 'Continue'
                              : 'Login',
                      onTap: controller.login,
                    ),
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
