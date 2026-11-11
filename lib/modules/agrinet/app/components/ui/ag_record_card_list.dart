import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/ag_text_styles.dart';
import '../../utils/ag_colors.dart';
import 'ag_text_button.dart';

class AgRecordListCard extends StatelessWidget {
  final RxList<Map<String, dynamic>> records;
  final VoidCallback onAddMore;
  final void Function(int index) onRemove;

  /// Receives a function to convert each record into list of label/value items
  final List<Map<String, dynamic>> Function(Map<String, dynamic> record)
  mapToDisplayList;

  const AgRecordListCard({
    super.key,
    required this.records,
    required this.onAddMore,
    required this.onRemove,
    required this.mapToDisplayList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: AgTextButton(title: "Add More", onTap: onAddMore),
        ),

        Obx(() {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final item = records[index];
              final displayList = mapToDisplayList(item);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AgColors.kDialogBg, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  color: AgColors.colorPrimary,
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            displayList.map((row) {
                              return equalRow(row["label"], "${row["value"]}");
                            }).toList(),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: () => onRemove(index),
                        child: const Icon(
                          Icons.close,
                          color: AgColors.kDialogBg,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget equalRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: kw500White14)),
        Expanded(child: Text(value, style: kw500White14)),
      ],
    );
  }
}
