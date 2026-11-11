import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/ui/ag_snackbar.dart';
import 'ag_colors.dart';

/// Generic Member Selection Bottom Sheet
class AGListBottomSheet<T> {
  /// Show Bottom Sheet
  static void show<T>({
    required List<T> items,

    /// How to get display name
    required String Function(T item) getName,

    /// On item selected
    required void Function(T item, int index) onSelected,

    /// UI Config
    String title = "Select Item",
    String emptyMessage = "No data available",

    double heightFactor = 0.6,
  }) {
    // Filter empty names
    final validItems =
        items.where((e) => getName(e).trim().isNotEmpty).toList();

    if (validItems.isEmpty) {
      agSnackbar(title: "Alert", msg: emptyMessage);
      return;
    }

    Get.bottomSheet(
      _BottomSheetBody<T>(
        items: items,
        validItems: validItems,
        getName: getName,
        onSelected: onSelected,
        title: title,
        heightFactor: heightFactor,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

/* ------------------------------------------------------ */
/* ---------------- Internal UI Widget ------------------ */
/* ------------------------------------------------------ */

class _BottomSheetBody<T> extends StatelessWidget {
  final List<T> items;
  final List<T> validItems;

  final String Function(T) getName;
  final void Function(T, int) onSelected;

  final String title;
  final double heightFactor;

  const _BottomSheetBody({
    Key? key,
    required this.items,
    required this.validItems,
    required this.getName,
    required this.onSelected,
    required this.title,
    required this.heightFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * heightFactor,
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _dragHandle(),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView.separated(
              itemCount: validItems.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey.shade200),

              itemBuilder: (_, index) {
                final item = validItems[index];
                final name = getName(item);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AgColors.colorPrimary.withOpacity(0.1),
                    child: Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    Get.back();

                    final originalIndex = items.indexOf(item);

                    onSelected(item, originalIndex);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
