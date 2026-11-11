import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_date_field.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_radio_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/config/ag_dimens.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Buyer Registration"),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SizedBox(
          width: double.infinity,
          child: AgButton(
            title: "Sign up",
            onTap: () => controller.validateForm(),
          ),
        ),
      ),
      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AgTextField(
                  name: "firstName",
                  label: "First Name",
                  controller: controller.firstNameCtrl,
                ),
                const SizedBox(height: 8),

                AgTextField(
                  name: "lastName",
                  label: "Last Name",
                  controller: controller.lastNameCtrl,
                ),
                const SizedBox(height: 8),

                AgDateField(
                  name: "dob",
                  label: "Date Of Birth",
                  rxDate: controller.dob,
                  initialDate: DateTime.now().subtract(
                    const Duration(days: 365 * 20),
                  ),
                  lastDate: DateTime.now().subtract(const Duration(days: 1)),
                  onSelect: (d) => controller.dob.value = d,
                ),
                const SizedBox(height: 8),

                const Text("Gender", style: TextStyle(fontSize: 15)),
                const SizedBox(height: 6),

                Row(
                  children:
                      controller.genderList.map((option) {
                        return Obx(
                          () => Row(
                            children: [
                              AppRadio(
                                value: option,
                                groupValue: controller.gender.value,
                                onChanged: (v) => controller.gender.value = v,
                              ),
                              Text(option.friendlyType ?? ""),
                              const SizedBox(width: 24),
                            ],
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 8),

                AgTextField(
                  name: "email",
                  label: "E-mail",
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailCtrl,
                ),
                const SizedBox(height: 8),

                AgTextField(
                  name: "mobile",
                  label: "Mobile Number (UserName)",
                  keyboardType: TextInputType.phone,
                  controller: controller.mobileCtrl,
                ),
                const SizedBox(height: 8),

                AgTextField(
                  name: "password",
                  label: "Password",
                  obscureText: true,
                  controller: controller.passwordCtrl,
                ),
                const SizedBox(height: 8),

                AgTextField(
                  name: "confirmPassword",
                  label: "Re-password",
                  obscureText: true,
                  controller: controller.confirmPasswordCtrl,
                ),

                const SizedBox(height: 26),
              ],
            ),
          ),
        );
      }),
    );
  }
}
