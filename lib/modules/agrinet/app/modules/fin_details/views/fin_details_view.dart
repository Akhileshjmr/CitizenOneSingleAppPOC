import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../components/ui/AgDropdownFields.dart';
import '../../../components/ui/ag_bottomnav_buttons.dart';
import '../../../components/ui/ag_date_field.dart';
import '../../../components/ui/ag_textfield.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/ag_constants.dart';
import '../controllers/fin_details_controller.dart';

class FinDetailsView extends GetView<FinDetailsController> {
  const FinDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Income and Financial details"),
      body: Obx(() {
        return BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AgColors.colorPrimary),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Income and Expense Details',
                          style: kw600Primary14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _tabs(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _showExpandOption(),
                  ),
                  const SizedBox(height: 10),

                  if (controller.selectedTab.value == 0 && controller.hasIncome)
                    _incomeListUI()
                  else if (controller.selectedTab.value == 1 &&
                      controller.hasExpense)
                    _expenseListUI()
                  else if (controller.selectedTab.value == 2 &&
                      controller.hasDocuments)
                    _documentListUI()
                  else
                    SizedBox(),

                  // Expandable panel (shows form when isPanelOpen is true)
                  if (controller.isPanelOpen.value)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _expandedPanel(),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: Obx(
        () => Visibility(
          visible: !controller.isLoading.value,
          child: _bottomButtons(),
        ),
      ),
    );
  }

  // ------------------ WIDGETS -----------------------

  Widget _tabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _tabItem("Income Details", 0, Icons.currency_exchange)),
        Expanded(
          child: _tabItem("Expense Details", 1, Icons.currency_exchange),
        ),
        Expanded(
          child: _tabItem("Document Details", 2, Icons.document_scanner),
        ),
      ],
    );
  }

  Widget _tabItem(String text, int index, IconData icon) {
    final isSelected = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        height: 110,
        margin: EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AgColors.colorPrimary : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AgColors.colorPrimary : Colors.grey,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 2,
              style: kw600Primary14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandedPanel() {
    switch (controller.selectedTab.value) {
      case 0:
        return _incomePanel();
      case 1:
        return _expensePanel();
      case 2:
        return _documentPanel();
      default:
        return Container();
    }
  }

  Widget _showExpandOption() {
    switch (controller.selectedTab.value) {
      case 0:
        return _buildPanel(
          icon: Icons.currency_exchange,
          title: "Income Details",
          iconSize: 22,
        );
      case 1:
        return _buildPanel(
          icon: Icons.currency_exchange,
          title: "Expenses Details",
          iconSize: 28,
        );
      case 2:
        return _buildPanel(
          icon: Icons.document_scanner,
          title: "Other Details",
          iconSize: 28,
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildPanel({
    required IconData icon,
    required String title,
    double iconSize = 22,
  }) {
    return GestureDetector(
      onTap: controller.togglePanel,
      child: Row(
        children: [
          Icon(icon, color: AgColors.kA13D3F, size: iconSize),
          const SizedBox(width: 10),
          Text(title, style: kA13D3Ffs14w600),
          const Spacer(),
          Icon(Icons.add, color: AgColors.kA13D3F, size: 22),
        ],
      ).paddingSymmetric(vertical: 8),
    );
  }

  // ----------------- PANELS ------------------------

  Widget _incomePanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return AgDropdownField(
            name: "Income Type",
            label: "Income Type",
            items:
                controller.incomeTypeList
                    .map((e) => e.friendlyType ?? "")
                    .toList(),
            value: controller.incomeType.value?.friendlyType,
            onChanged: (v) {
              controller.incomeType.value = controller.incomeTypeList
                  .firstWhere((e) => e.friendlyType == v);
            },
          );
        }),
        const SizedBox(height: 10),
        AgTextField(
          name: "Income",
          hasBorder: false,
          hasUnderLineBorder: true,
          label: "Income (${AgConstants.currency})",
          hintText: null,
          filled: false,
          maxLength: AgConstants.maxAmountLength,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.incomeAmount.value = v ?? '';
          },
          contentPadding: const EdgeInsets.only(bottom: 6),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _saveButton(() => controller.addIncome()),
            _cancelButton(),
          ],
        ),
      ],
    );
  }

  Widget _expensePanel() {
    return Column(
      children: [
        Obx(() {
          return AgDropdownField(
            name: "Expenses Type",
            label: "Expenses Type",
            items:
                controller.expenseTypeList
                    .map((e) => e.friendlyType ?? "")
                    .toList(),
            value: controller.expenseType.value?.friendlyType,
            onChanged: (v) {
              controller.expenseType.value = controller.expenseTypeList
                  .firstWhere((e) => e.friendlyType == v);
            },
          );
        }),
        const SizedBox(height: 10),
        AgTextField(
          name: "Expenses",
          hasBorder: false,
          hasUnderLineBorder: true,
          label: "Expenses (${AgConstants.currency})",
          hintText: null,
          filled: false,
          maxLength: AgConstants.maxAmountLength,
          keyboardType: TextInputType.number,
          onChanged: (v) {
            controller.expenseAmount.value = v ?? '';
          },
          contentPadding: const EdgeInsets.only(bottom: 6),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _saveButton(() => controller.addExpense()),
            _cancelButton(),
          ],
        ),
      ],
    );
  }

  Widget _documentPanel() {
    return Row(children: [Expanded(child: buildDocFrom()), _buildUploadCard()]);
  }

  Widget _buildUploadCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final imageHeight = maxWidth * 1.2;

          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    var status = await Permission.camera.request();

                    if (!status.isGranted) {
                      agSnackbar(
                        title: "Permission",
                        msg: "Camera permission denied",
                      );
                      return;
                    }

                    await controller.pickFromCamera();
                  },
                  child: Obx(() {
                    final img = controller.profilePhoto.value;

                    return Container(
                      width: maxWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AgColors.kPrimaryText),
                      ),
                      child:
                          img != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(img, fit: BoxFit.cover),
                              )
                              : Center(
                                child: Icon(
                                  Icons.description,
                                  size: maxWidth * 0.35,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                    );
                  }),
                ),

                SizedBox(height: 10),
                const Text("Upload Doc", style: kw600Primary14),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDocFrom() {
    return Column(
      children: [
        Obx(() {
          return AgDropdownField(
            name: "Document Name",
            label: "Document Name",
            items:
                controller.documentNameList
                    .map((e) => e.friendlyType ?? "")
                    .toList(),
            value: controller.docName.value?.friendlyType,
            onChanged: (v) {
              controller.docName.value = controller.documentNameList.firstWhere(
                (e) => e.friendlyType == v,
              );
            },
          );
        }),
        const SizedBox(height: 10),
        AgDateField(
          name: "Issue Date",
          label: "Issue Date",
          rxDate: controller.issueDate,
          lastDate: DateTime.now(),
          onSelect: controller.setIssueDate,
        ),
        const SizedBox(height: 10),
        AgDateField(
          name: "Expiry Date",
          label: "Expiry Date",
          rxDate: controller.expireDate,
          onSelect: controller.setExpiryDate,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _saveButton(() => controller.addDocument()),
            _cancelButton(),
          ],
        ),
      ],
    );
  }

  // ------------------- Card UIs -------------------

  Widget _incomeListUI() {
    return Column(
      children:
          controller.incomeList.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: AgColors.colorPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.type?.friendlyType ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    item.amount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.removeIncome(item),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _expenseListUI() {
    return Column(
      children:
          controller.expenseList.map((item) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: AgColors.colorPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.type?.friendlyType ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    item.amount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.removeExpense(item),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _documentListUI() {
    return Column(
      children:
          controller.docList.map((doc) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: AgColors.colorPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      doc.name?.friendlyType ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.removeDocument(doc),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _saveButton(VoidCallback onSave) {
    return AgButton(title: "Save", onTap: onSave);
  }

  Widget _cancelButton() {
    return Expanded(
      child: TextButton(
        onPressed: () => controller.isPanelOpen.value = false,
        child: const Text("Cancel", style: kA13D3Ffs14w400),
      ),
    );
  }

  Widget _bottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: BottomNavButtons(
        onBack: () => Get.back(),
        onSaveDraft: () => controller.saveFinDetails("saveAsDraft"),
        onNext: () => controller.saveFinDetails("next"),
      ),
    );
  }
}
