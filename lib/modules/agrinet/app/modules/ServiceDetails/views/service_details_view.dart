import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/str_ext.dart';
import '../controllers/service_details_controller.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    // Provide controller if not injected elsewhere
    final controller = Get.put(ServiceDetailsController());

    const green = Color(0xFF2F5D26); // appbar green (adjust if needed)
    const bg = Color(0xFFF2F7F8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AgAppbar(title: "Service List"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            _buildServiceCard(controller),
            const SizedBox(height: 20),
            // add other content below if needed
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(ServiceDetailsController controller) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          children: [
            // Header (icon + title)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F6F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF3E6A2A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Service Details',
                    style: TextStyle(
                      color: Color(0xFF3E6A2A),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // SR Number centered
            Obx(() {
              return Text(
                controller.service.value?.srNumber ?? '',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              );
            }),

            const SizedBox(height: 16),

            // Divider
            const Divider(height: 1, thickness: 1),

            const SizedBox(height: 12),

            // Two-column label/value table
            _buildTwoColumnRows(controller),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTwoColumnRows(ServiceDetailsController c) {
    // Helper to build a label-value pair widget
    Widget row(String label, Widget valueWidget) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Label
            Expanded(
              flex: 5,
              child: Text(
                label,
                style: const TextStyle(fontSize: 15, color: Color(0xFF6E7B7A)),
              ),
            ),

            // Value
            Expanded(flex: 5, child: valueWidget),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Row 1: Related To | Service Type
        row(
          'Related To',
          Obx(
            () => Text(
              controller.service.value?.requestDet?.relatedTo?.friendlyType ??
                  '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        row(
          'Service Type',
          Obx(
            () => Text(
              controller.service.value?.requestDet?.serviceType?.friendlyType ??
                  '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Row 2: Date | Status
        row(
          'Date',
          Obx(
            () => Text(
              DateUt.convertTimestampToDate(
                controller.service.value?.requestDet?.dueDate ?? 0,
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        row(
          'Status',
          Obx(
            () => Text(
              controller.service.value?.requestDet?.status?.friendlyType ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Row 3: Estimated Cost | Admin Comments
        row(
          'Estimated Cost',
          Obx(
            () => Text(
              (controller.service.value?.requestDet?.estimatedCost ?? '')
                  .toString(),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        // row(
        //   'Admin- Comments',
        //   Obx(() => Text(
        //     controller.service.value?.requestDet?.comments ??'',
        //     style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        //     textAlign: TextAlign.right,
        //   )),
        // ),
        const SizedBox(height: 4),

        // Row 4: Admin- Actual Cost | Admin- Closed Date
        /*row(
          'Admin- Actual Cost',
          Obx(
            () => Text(
              controller.service.value?.actualCost ?? '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ),*/
        // row(
        //   'Admin- Closed Date',
        //   Obx(() => Text(
        //     c.adminClosedDate.value,
        //     style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        //     textAlign: TextAlign.right,
        //   )),
        // ),
      ],
    );
  }
}
