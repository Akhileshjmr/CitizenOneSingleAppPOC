import 'package:flutter/material.dart';

import '../../../components/utils/str_ext.dart';
import '../../../data/model/farmPlan/ServiceResp.dart';

class ServiceRequestCard extends StatelessWidget {
  final ServiceReq? item; // your model
  final VoidCallback? onStatusClick; // <-- NEW: status click action

  const ServiceRequestCard({super.key, required this.item, this.onStatusClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("SR Number", item?.srNumber ?? ""),
          _row("Related To", item?.requestDet?.relatedTo?.friendlyType ?? ""),

          // CLICKABLE STATUS ROW
          _row(
            "Status",
            item?.requestDet?.status?.friendlyType ?? "",
            valueColor: Colors.red,
            valueFontWeight: FontWeight.bold,
            onTap: onStatusClick, // <-- activates click
          ),

          _row(
            "Service Type",
            item?.requestDet?.serviceType?.friendlyType ?? "--",
          ),
          _row(
            "Date",
            DateUt.convertTimestampToDate(item?.requestDet?.dueDate ?? 0),
          ),
        ],
      ),
    );
  }

  /// ROW BUILDER (supports click on value)
  Widget _row(
    String title,
    String value, {
    Color valueColor = Colors.black,
    FontWeight valueFontWeight = FontWeight.normal,
    VoidCallback? onTap, // <---- NEW
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // LEFT: TITLE
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
          ),

          // RIGHT: VALUE (Clickable if onTap != null)
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: valueFontWeight,
                  color: onTap != null ? Colors.blue : valueColor,
                  decoration:
                      onTap != null
                          ? TextDecoration.underline
                          : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
