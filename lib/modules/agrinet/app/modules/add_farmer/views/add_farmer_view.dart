import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_image.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/data/config/ag_dimens.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';

import '../../../components/ui/adhar_scan.dart';
import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/ag_date_field.dart';
import '../../../components/ui/ag_dropdown.dart';
import '../../../components/ui/ag_radio_button.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../data/model/common/ch_message.dart';
import '../../../data/model/common/option.dart';
import '../controllers/add_farmer_controller.dart';

class AddFarmerView extends GetView<AddFarmerController> {
  const AddFarmerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'General Details'),

      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// -------------------- SCAN AADHAR --------------------
                AgButton(
                  onTap: () async {
                    final scannedData = await Get.to(
                      () => const AadharScanner(),
                    );
                    if (scannedData != null) {
                      controller.parseAadharData(scannedData);
                    }
                  },
                  backgroundColor: AgColors.FF4500,
                  title: 'Scan your ID',
                  width: Get.width,
                ),

                const SizedBox(height: 20),

                /// -------------------- NAME + PHOTO SECTION --------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          /// FULL NAME
                          AgTextField(
                            name: "Full Name",
                            controller: controller.fullNameController,
                            hasBorder: false,
                            hasUnderLineBorder: true,
                            label: "Full Name",
                            onChanged: (v) {
                              controller.fullName.value = v ?? '';
                            },
                            inputType: AgInputType.stringOnly,
                          ).paddingOnly(bottom: defaultPadding),

                          /// FATHER NAME
                          AgTextField(
                            name: "Father Name",
                            controller: controller.fatherNameController,
                            hasBorder: false,
                            hasUnderLineBorder: true,
                            label: "Father Name",
                            inputType: AgInputType.stringOnly,
                            onChanged: (v) {
                              controller.fatherName.value = v ?? '';
                            },
                          ).paddingOnly(bottom: defaultPadding),

                          /// GENDER
                          genderSection(),

                          /// DOB
                          AgDateField(
                            name: "dob",
                            label: "Date of Birth",
                            rxDate: controller.rxDueDate,
                            initialDate: DateTime.now().subtract(
                              const Duration(days: 365 * 20),
                            ),
                            lastDate: DateTime.now(),
                            onSelect: (date) => controller.updateDOB(date),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// PROFILE PHOTO
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          var status = await Permission.camera.request();
                          if (!status.isGranted) {
                            agSnackbar(
                              title: "Permission",
                              msg: "Camera denied",
                            );
                            return;
                          }
                          await controller.pickFromCamera();
                        },
                        child: Obx(() {
                          final localImg = controller.profilePhoto.value;
                          final networkUrl = controller.profilePhotoUrl.value;

                          return Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AgColors.kPrimaryText),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  localImg != null
                                      ? Image.file(
                                        localImg,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )
                                      : networkUrl != null
                                      ? AgImage(imageUrl: networkUrl)
                                      : Center(
                                        child: Text(
                                          "Smile and\nTake a Picture",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AgColors.colorPrimary,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// -------------------- AGE --------------------
                Obx(() {
                  return AgTextField(
                    name: 'Age',
                    hasBorder: false,
                    hasUnderLineBorder: true,
                    label: 'Age',
                    readyOnly: true,
                    controller: TextEditingController(
                      text: controller.rxAge.value?.toString() ?? "",
                    ),
                  );
                }),

                const SizedBox(height: 16),

                /// -------------------- ADDRESS --------------------
                AgTextField(
                  name: "Residence Address",
                  controller: controller.addressController,
                  hasBorder: false,
                  hasUnderLineBorder: true,
                  label: "Residence Address",
                  onChanged: (v) {
                    controller.address.value = v ?? '';
                  },
                ).paddingOnly(bottom: defaultPadding),

                const SizedBox(height: 10),

                /// -------------------- LANGUAGE --------------------
                Obx(() {
                  final items =
                      controller.languageList
                          .map((e) => e.friendlyType ?? "")
                          .toList();

                  final selected =
                      controller.language.value?.friendlyType ?? "";

                  return AgDropdownField(
                    key: ValueKey(selected),
                    name: "language",
                    label: "Language",
                    items: items,
                    value: items.contains(selected) ? selected : "",
                    onChanged: (v) {
                      controller.language.value = controller.languageList
                          .firstWhere((e) => e.friendlyType == v);
                    },
                  );
                }),

                const SizedBox(height: 10),

                /// -------------------- MARITAL STATUS --------------------
                Obx(() {
                  final items =
                      controller.maritalList
                          .map((e) => e.friendlyType ?? "")
                          .toList();
                  final selected =
                      controller.maritalStatus.value?.friendlyType ?? "";

                  return AgDropdownField(
                    key: ValueKey(selected),
                    name: "marital_status",
                    label: "Marital Status",
                    items: items,
                    value: items.contains(selected) ? selected : "",
                    onChanged: (v) {
                      controller.maritalStatus.value = controller.maritalList
                          .firstWhere((e) => e.friendlyType == v);
                    },
                  );
                }),

                const SizedBox(height: 10),

                /// -------------------- COUNTRY --------------------
                Obx(() {
                  final items =
                      controller.countryList
                          .map((e) => e.friendlyType ?? "")
                          .toList();
                  final selected =
                      controller.countryOfBirth.value?.friendlyType ?? "";

                  return AgDropdownField(
                    key: ValueKey(selected),
                    name: "country_of_birth",
                    label: "Country of Birth",
                    items: items,
                    value: items.contains(selected) ? selected : null,
                    onChanged: (v) {
                      final selectedCountry = controller.countryList.firstWhere(
                        (e) => e.friendlyType == v,
                      );

                      controller.onCountryChanged(selectedCountry);
                    },
                  );
                }),

                const SizedBox(height: 10),

                /// -------------------- STATE OF ORIGIN --------------------
                Obx(() {
                  final hasCountry = controller.countryOfBirth.value != null;
                  final hasStates = controller.filteredStates.isNotEmpty;

                  final items =
                      hasStates
                          ? controller.filteredStates
                              .map((e) => e.friendlyType ?? "")
                              .toList()
                          : <String>[];

                  final selected =
                      controller.stateOfOrigin.value?.friendlyType ?? "";

                  return AgDropdownField(
                    key: ValueKey(selected),
                    name: "state_of_origin",
                    label: "State of Origin",
                    items: items,
                    value: items.contains(selected) ? selected : null,
                    onChanged:
                        (!hasCountry || !hasStates)
                            ? null
                            : (v) {
                              controller.stateOfOrigin.value = controller
                                  .filteredStates
                                  .firstWhere((e) => e.friendlyType == v);
                            },

                    hintText:
                        !hasCountry
                            ? "Select country first"
                            : !hasStates
                            ? "No states available"
                            : "Select state",
                  );
                }),

                const SizedBox(height: 10),

                /// -------------------- NATIONALITY --------------------
                Obx(() {
                  final items =
                      controller.nationalityList
                          .map((e) => e.friendlyType ?? "")
                          .toList();
                  final selected =
                      controller.nationality.value?.friendlyType ?? "";

                  return AgDropdownField(
                    key: ValueKey(selected),
                    name: "nationality",
                    label: "Nationality",
                    items: items,
                    value: items.contains(selected) ? selected : "",
                    onChanged: (v) {
                      controller.nationality.value = controller.nationalityList
                          .firstWhere((e) => e.friendlyType == v);
                    },
                  );
                }),

                const SizedBox(height: 20),

                isBlockListed(),

                signatureSection(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),

      /// -------------------- BOTTOM BUTTON --------------------
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: Container(
            margin: const EdgeInsets.all(defaultMargin),
            child: AgButton(
              onTap: () {
                controller.saveFarmerData();
              },
              title:
                  '${controller.isUpdate.value ? 'Update' : 'Save'} and Continue',
              width: Get.width,
            ),
          ),
        ),
      ),
    );
  }

  /// -------------------- GENDER SECTION --------------------
  Widget genderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Gender", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 6),
        Obx(() {
          return Wrap(
            spacing: 20,
            runSpacing: 8,
            children:
                controller.genderList.map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<Option>(
                        value: option,
                        groupValue: controller.gender.value,
                        onChanged: (v) => controller.gender.value = v,
                      ),
                      Text(option.friendlyType ?? ""),
                    ],
                  );
                }).toList(),
          );
        }),
      ],
    );
  }

  /// -------------------- BLOCKLIST --------------------
  Widget isBlockListed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Is Blocklisted", style: TextStyle(fontSize: 15)),
        const SizedBox(height: 6),
        Obx(() {
          return Row(
            children: [
              AppRadio(
                value: "Yes",
                groupValue: controller.isBlocklisted.value,
                onChanged: (v) => controller.isBlocklisted.value = v!,
              ),
              const Text("Yes"),
              const SizedBox(width: 20),
              AppRadio(
                value: "No",
                groupValue: controller.isBlocklisted.value,
                onChanged: (v) => controller.isBlocklisted.value = v!,
              ),
              const Text("No"),
            ],
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  /// -------------------- SIGNATURE --------------------
  Widget signatureSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              controller.showSignature.value = !controller.showSignature.value;
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.draw),
                  const SizedBox(width: 10),
                  const Text(
                    "Signature",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Icon(
                    controller.showSignature.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),

          if (controller.showSignature.value) ...[
            const SizedBox(height: 10),

            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AgColors.kBlack),
              ),
              child: Stack(
                children: [
                  Signature(
                    controller: controller.signatureController,
                    backgroundColor: AgColors.kWhite,
                  ),
                  if (controller.isSignatureDisabled.value)
                    Positioned.fill(
                      child: AbsorbPointer(
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Obx(() {
              return Visibility(
                visible: !controller.isSignatureDisabled.value,
                child: Row(
                  children: [
                    AgButton(
                      title: "Clear",
                      backgroundColor: AgColors.warning,
                      onTap: () => controller.signatureController.clear(),
                    ),
                    const SizedBox(width: 10),
                    AgButton(
                      title: "Save",
                      onTap: () async {
                        if (controller.profilePhoto.value == null &&
                            controller.profilePhotoUrl.value == null) {
                          AgAlertDialog.show(
                            title: "Profile Photo Required",
                            message: "Upload profile photo first.",
                          );
                          return;
                        }

                        final signature =
                            await controller.signatureController.toPngBytes();

                        if (signature == null) {
                          AgAlertDialog.show(
                            title: "Signature Required",
                            message: "Please provide a signature.",
                          );
                          return;
                        }

                        controller.isSignatureDisabled.value = true;

                        final ChMessage msg = await controller.uploadSignature(
                          signature,
                        );

                        AgAlertDialog.show(
                          title: "Alert",
                          message: msg.message ?? "",
                        );
                      },
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 20),
          ],
        ],
      );
    });
  }
}
