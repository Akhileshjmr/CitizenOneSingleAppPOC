import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../data/model/common/option.dart';
import '../controllers/finance_request_controller.dart';

class FinanceRequestView extends GetView<FinanceRequestController> {
  const FinanceRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Finance Request'),
      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: FormBuilder(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Loan Purpose dropdown - Wrap in Obx
                  Obx(
                    () => AgDropdownField<Option?>(
                      name: "loanPurpose",
                      label: "Loan Purpose",
                      items: controller.loanPurposeList,
                      value: controller.matchOption(
                        controller.selectedLoanPurpose.value,
                        controller.loanPurposeList,
                      ),
                      itemLabel: (o) => o?.friendlyType ?? "",
                      onChanged:
                          (v) => controller.selectedLoanPurpose.value = v,
                    ),
                  ),

                  /// Purpose Description
                  AgTextField(
                    name: 'purposeDescription',
                    label: 'Purpose Description',
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    isRequired: false,
                    hasUnderLineBorder: true,
                    hasBorder: false,
                  ),
                  const SizedBox(height: 12),

                  /// Product Name dropdown - Wrap in Obx
                  Obx(
                    () => AgDropdownField<Option?>(
                      name: "productName",
                      label: "Product Name",
                      items: controller.productNameList,
                      value: controller.matchOption(
                        controller.selectedProduct.value,
                        controller.productNameList,
                      ),
                      itemLabel: (o) => o?.friendlyType ?? "",
                      onChanged: (v) => controller.selectedProduct.value = v,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Govt Scheme radio
                  const Text(
                    'Govt Scheme',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  _buildGovtSchemeRadio(),

                  /// Scheme dropdown - Wrap in Obx
                  Obx(
                    () => AgDropdownField<Option?>(
                      name: "Collateral Pool Code",
                      label: "Collateral Pool Code",
                      items: controller.collateralPoolCodeList,
                      value: controller.matchOption(
                        controller.collateralPoolCode.value,
                        controller.collateralPoolCodeList,
                      ),
                      itemLabel: (o) => o?.friendlyType ?? "",
                      onChanged: (v) => controller.collateralPoolCode.value = v,
                    ),
                  ),

                  /// Loan Amount
                  AgTextField(
                    name: 'loanAmount',
                    label: 'Loan Amount (${AgConstants.currency})',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    maxLength: 10,
                    hasUnderLineBorder: true,
                    hasBorder: false,
                  ),

                  /// Duration
                  AgTextField(
                    name: 'duration',
                    label: 'Duration (${AgConstants.duration})',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    maxLength: 3,
                    hasUnderLineBorder: true,
                    hasBorder: false,
                  ),

                  /// Distance to Branch
                  AgTextField(
                    name: 'distanceToBranch',
                    label: 'Distance to Branch (${AgConstants.distance})',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    maxLength: 3,
                    hasUnderLineBorder: true,
                    hasBorder: false,
                  ),

                  /// Collateral Value
                  /* AgTextField(
                    name: 'collateralValue',
                    label: 'Collateral Value',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    hasUnderLineBorder: true,
                    hasBorder: false,
                  ),
                  const SizedBox(height: 24),

                  /// Collateral Document label
                  const Text(
                    'Collateral Document',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AgColors.colorPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Collateral upload area (camera icon)
                  Center(
                    child: InkWell(
                      onTap: controller.pickCollateralDoc,
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.camera_alt,
                              size: 72,
                              color: Colors.black,
                            ),
                            Positioned(
                              top: 30,
                              left: 32,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),*/
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),

      /// Save button
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AgButton(title: 'Save', onTap: controller.onSave),
            ),
          ),
        ),
      ),
    );
  }

  // Separate method for the radio widget
  Widget _buildGovtSchemeRadio() {
    return GetX<FinanceRequestController>(
      builder: (controller) {
        return Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: controller.isGovtScheme.value,
              onChanged: (v) => controller.isGovtScheme.value = v!,
              activeColor: AgColors.colorPrimaryDark,
            ),
            const Text('Yes'),
            const SizedBox(width: 20),
            Radio<bool>(
              value: false,
              groupValue: controller.isGovtScheme.value,
              onChanged: (v) => controller.isGovtScheme.value = v!,
              activeColor: AgColors.colorPrimaryDark,
            ),
            const Text('No'),
          ],
        );
      },
    );
  }
}
