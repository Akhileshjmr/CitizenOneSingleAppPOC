import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../components/ui/ag_textfield.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../utils/ag_colors.dart';

class CropCard extends StatelessWidget {
  final int index;
  final YieldDet? crop;
  final ValueChanged<String> onYieldChanged;
  final ValueChanged<String> onYieldValueChanged;
  final VoidCallback onVerifyTap;

  const CropCard({
    super.key,
    required this.index,
    required this.crop,
    required this.onYieldChanged,
    required this.onYieldValueChanged,
    required this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Crop name row
            Row(
              children: [
                const Text(
                  'Crop Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Obx(
                    () => TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // open crop selection bottom sheet if needed
                      },
                      child: Text(
                        crop?.cropName.value ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            /// Inputs row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Yield (kg/acre)
                Expanded(
                  child: Obx(
                    () => AgTextField(
                      name: 'yield_$index',
                      label: 'Yield (kg/acre)',
                      initialValue: crop?.yieldkgOracre.value ?? '0',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      onChanged: (value) => onYieldChanged(value ?? ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final n = double.tryParse(value);
                        if (n == null || n < 0) {
                          return 'Enter a valid non-negative number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                const Icon(Icons.arrow_forward, size: 22, color: Colors.blue),
                const SizedBox(width: 12),

                // Yield Value
                Expanded(
                  child: Obx(
                    () => AgTextField(
                      name: 'yieldValue_$index',
                      label: 'Yield Value',
                      initialValue: crop?.yieldValue.value ?? '0.0',
                      keyboardType: TextInputType.number,
                      isRequired: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      onChanged: (value) => onYieldValueChanged(value ?? ''),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final n = double.tryParse(value);
                        if (n == null || n < 0) {
                          return 'Enter a valid non-negative number';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Check icon (verified)
            Center(
              child: Obx(
                () => InkWell(
                  onTap: onVerifyTap,
                  borderRadius: BorderRadius.circular(15),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        crop?.valueGiven.value ?? false
                            ? AgColors.colorPrimaryDark
                            : Colors.grey.shade400,
                    child: const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
