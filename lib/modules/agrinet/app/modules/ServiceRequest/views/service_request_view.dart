import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/service_request_controller.dart';
import 'ServiceRequestCard.dart';

class ServiceRequestView extends GetView<ServiceRequestController> {
  const ServiceRequestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: 'Service Request'),
      body: Obx(() {
        final items = controller.list()?.serviceReq ?? [];

        if (items.isEmpty) {
          return const Center(
            child: Text(
              "No service requests found!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 20),
          itemCount: items.length,
          itemBuilder: (_, index) {
            return ServiceRequestCard(
              item: items[index],
              onStatusClick: () {
                Get.toNamed(Routes.SERVICE_DETAILS, arguments: items[index]);
              },
            );
          },
        );
      }),
    );
  }
}
