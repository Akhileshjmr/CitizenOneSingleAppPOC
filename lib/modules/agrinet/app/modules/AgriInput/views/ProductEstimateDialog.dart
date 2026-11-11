import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../utils/ag_colors.dart';

class ProductEstimateDialog extends StatelessWidget {
  final AgriInputEst? item;
  final TextEditingController qtyController;
  final TextEditingController remarksController;
  final VoidCallback onPrevious;
  final VoidCallback onAdd;

  const ProductEstimateDialog({
    super.key,
    required this.item,
    required this.qtyController,
    required this.remarksController,
    required this.onPrevious,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    const brown = Color(0xFFB8781A);

    return Dialog(
      backgroundColor: AgColors.kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Product Estimates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AgColors.colorPrimaryDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Details rows
              _labelValueRow(
                'Crop Category',
                item?.category.friendlyType ?? '',
              ),
              _labelValueRow('Product Name', item?.common.friendlyType ?? ''),
              _labelValueRow(
                'Unit Type',
                item?.unitType ?? '',
              ), // or item.unitType
              const SizedBox(height: 4),

              // Estimated Quantity label
              const Text(
                'Estimated Quantity',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 4),

              // Estimated Quantity input
              TextField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // <-- allows only 0–9
                ],
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 0,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AgColors.colorPrimaryDark,
                      width: 1,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AgColors.colorPrimaryDark,
                      width: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Remarks label
              const Text(
                'Remarks',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              AgTextField(name: '', controller: remarksController),
              const SizedBox(height: 24),

              // Buttons row
              Row(
                children: [
                  Expanded(
                    child: AgButton(
                      title: 'Previous',
                      onTap: onPrevious,
                      isOutlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: AgButton(title: 'Add', onTap: onAdd)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left label
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          // Right value
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
