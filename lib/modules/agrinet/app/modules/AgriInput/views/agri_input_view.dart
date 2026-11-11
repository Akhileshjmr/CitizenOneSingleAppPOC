import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../controllers/agri_input_controller.dart';
import 'ProductEstimateDialog.dart';

class AgriInputView extends GetView<AgriInputController> {
  const AgriInputView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F7),
      appBar: AgAppbar(title: 'Agri Inputs'),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.inputs.value?.agriInputEst?.length,
                itemBuilder: (context, index) {
                  final item = controller.inputs.value?.agriInputEst?[index];
                  return _agriInputRow(item);
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomButton(),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AgColors.colorSecondaryDark,
        border: Border(bottom: BorderSide(color: Colors.white, width: 0.5)),
      ),
      child: Row(
        children: [
          _buildHeaderCell(text: 'Category', flex: 1),
          _buildHeaderCell(text: 'Product Name', flex: 2),
          _buildHeaderCell(text: 'Unit Price', flex: 1),
          _buildHeaderCell(text: 'Estimated\nQuantity'),
        ],
      ),
    );
  }

  Widget _buildHeaderCell({
    required String text,
    int flex = 1,
    Color borderColor = Colors.white,
    Color textColor = Colors.white,
    Alignment alignment = Alignment.centerLeft,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12),
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    double lineHeight = 1.2,
  }) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: borderColor, width: 0.5)),
        ),
        alignment: alignment,
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            height: lineHeight,
          ),
        ),
      ),
    );
  }

  // --------------- BOTTOM BUTTON ---------------
  Widget _bottomButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Obx(
          () => AgButton(
            title:
                controller.enableEdit.value
                    ? 'Save'
                    : 'Update Crop Maintenance',
            onTap: controller.onUpdateCropMaintenance,
          ),
        ),
      ),
    );
  }

  // ---------------- ROW ----------------
  Widget _agriInputRow(AgriInputEst? item) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF21A36F), width: 1)),
      ),
      child: Row(
        children: [
          Flexible(child: _rowCell(item?.category.friendlyType ?? '')),
          Flexible(child: _rowCell(item?.common.friendlyType ?? '')),
          Flexible(child: _rowCell(item?.unitType ?? '')),
          Flexible(child: _buildEditableQuantity(item)),
        ],
      ),
    );
  }

  /// Generic cell
  Widget _rowCell(
    String text, {
    bool alignRight = false,
    Color textColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFF21A36F), width: 1)),
      ),
      alignment: alignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }

  /// Special cell for Estimated Quantity
  Widget _buildEditableQuantity(AgriInputEst? item) {
    return Obx(() {
      final enable = controller.enableEdit.value;
      final qty = item?.estQuantity?.toString().trim();
      final isMissing = qty == null || qty.isEmpty || qty == '--';

      // Edit OFF: just show text
      if (!enable) {
        return _rowCell(
          item?.estQuantity?.toString() ?? '--',
          alignRight: true,
          textColor: Colors.red,
        );
      }

      // Edit ON & no value: show clickable "Add"
      if (enable && isMissing) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(color: Color(0xFF21A36F), width: 1),
            ),
          ),
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => _openProductEstimatePopup(item),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text(
                'Add',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );
      }

      // Edit ON but already has value: normal text
      return _rowCell(qty ?? '--', alignRight: true, textColor: Colors.black);
    });
  }

  // ------------- OPEN POPUP --------------
  void _openProductEstimatePopup(AgriInputEst? item) {
    final qtyController = TextEditingController(
      text:
          item?.estQuantity == '--' ? '' : item?.estQuantity?.toString() ?? '',
    );
    final remarksController = TextEditingController(text: item?.comments ?? '');

    Get.dialog(
      ProductEstimateDialog(
        item: item,
        qtyController: qtyController,
        remarksController: remarksController,
        onPrevious: () => Get.back(),
        onAdd: () {
          controller.saveEstimate(
            item: item,
            quantity: qtyController.text,
            remarks: remarksController.text,
          );
        },
      ),
    );
  }
}
