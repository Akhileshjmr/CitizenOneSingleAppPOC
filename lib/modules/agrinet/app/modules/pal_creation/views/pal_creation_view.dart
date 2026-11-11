import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_textfield.dart';
import '../controllers/pal_creation_controller.dart';

class PalCreationView extends GetView<PalCreationController> {
  const PalCreationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgColors.kWhite,
      appBar: AgAppbar(title: 'Pal Registration'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AgColors.colorPrimaryDark.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AgTextField(
                      label: 'First Name',
                      controller: controller.firstNameCtrl,
                      name: '',
                    ),
                    const SizedBox(height: 8),
                    AgTextField(
                      label: 'Last Name',
                      controller: controller.lastNameCtrl,
                      name: '',
                    ),
                    const SizedBox(height: 8),

                    // DOB with AgTextField (readOnly + calendar icon)
                    AgTextField(
                      label: 'Date Of Birth',
                      controller: controller.dobCtrl,
                      readyOnly: true,
                      // readOnly: true,
                      onTap: () => controller.pickDob(context),
                      suffix: const Icon(Icons.calendar_today, size: 18),
                      name: '',
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: 'M',
                              groupValue: controller.gender.value,
                              onChanged:
                                  (v) => controller.gender.value = v ?? '',
                              title: const Text('Male'),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: 'F',
                              groupValue: controller.gender.value,
                              onChanged:
                                  (v) => controller.gender.value = v ?? '',
                              title: const Text('Female'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    AgTextField(
                      label: 'E-mail',
                      controller: controller.emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      name: '',
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Mobile Number (UserName)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AgColors.colorPrimaryDark,
                            ),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.flag, size: 18),
                              SizedBox(width: 4),
                              Text('+91'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AgTextField(
                            label: '',
                            controller: controller.mobileCtrl,
                            keyboardType: TextInputType.phone,
                            name: '',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    AgTextField(
                      label: 'User Name',
                      controller: controller.userNameCtrl,
                      name: '',
                    ),
                    const SizedBox(height: 8),
                    AgTextField(
                      label: 'Password',
                      controller: controller.passwordCtrl,
                      // helperText: 'password',
                      obscureText: true,
                      name: '',
                    ),
                    const SizedBox(height: 8),
                    AgTextField(
                      label: 'Re-password',
                      controller: controller.confirmPasswordCtrl,
                      // helperText: 'Confirm Password',
                      obscureText: true,
                      name: '',
                    ),

                    const SizedBox(height: 12),
                    // const Text(
                    //   'Home Branch',
                    //   style:
                    //   TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    // ),
                    // const SizedBox(height: 4),
                    Obx(
                      () => AgDropdownField(
                        name: 'HOME_BRANCH_LIST',
                        label: 'Home Branch',
                        items: controller.getOptionNames('HOME_BRANCH_LIST'),
                        value: controller.selectedBranch.value,
                        onChanged: (value) {
                          controller.selectedBranch.value = value;

                          final opt = controller.getOptionByFriendlyName(
                            'HOME_BRANCH_LIST',
                            value,
                          );

                          print("Selected Branch ID: ${opt?.id}");
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
                vertical: 12,
              ),
              child: SizedBox(
                width: double.infinity,
                child: AgButton(title: 'Sign up', onTap: controller.onSignUp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
