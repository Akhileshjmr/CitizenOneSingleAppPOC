import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/utils/str_ext.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../controllers/event_display_controller.dart';

class EventDisplayView extends GetView<EventDisplayController> {
  const EventDisplayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AgAppbar(title: "Event"),
      body: Obx(
        () => Visibility(
          visible: controller.isLoading.isFalse,
          replacement: const Center(child: CircularProgressIndicator()),
          child: Column(
            children: [
              // Header "Event Display"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                color: const Color(0xFFF2F7F8),
                child: const Text(
                  'Event Display',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E6A2A),
                  ),
                ),
              ),

              // Crop Tabs
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: const Color(0xFFF2F7F8),
                child: Obx(
                  () => Row(
                    children: List.generate(
                      controller.eventsByCrop.value!.recommendedCrop!.length,
                      (index) {
                        final isSelected =
                            controller.selectedCropIndex.value == index;
                        return Expanded(
                          child: _buildEventTab(
                            title:
                                '${controller.eventsByCrop.value!.recommendedCrop?[index].cropName ?? ''} (${controller.eventsByCrop.value!.recommendedCrop?[index].varienty ?? ''})',
                            isSelected: isSelected,
                            onTap:
                                () => controller.selectCrop(
                                  index,
                                  controller
                                      .eventsByCrop
                                      .value!
                                      .recommendedCrop![index],
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Event cards list
              Expanded(
                child: Obx(() {
                  final response = controller.eventsByCrop.value;
                  final selected = controller.selectedCrop.value;

                  final allEvents = response?.calenderEvents ?? [];

                  List<CalendarEvent> events;
                  if (selected == null) {
                    events = allEvents;
                  } else {
                    final expectedName =
                        '${selected.cropName} ( ${selected.varienty} )'
                            .toLowerCase()
                            .trim();

                    events =
                        allEvents
                            .where(
                              (event) =>
                                  (event.cropName ?? '').toLowerCase().trim() ==
                                  expectedName,
                            )
                            .toList();
                  }

                  if (events.isEmpty) {
                    return const Center(child: Text('No events found'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = events[index];
                      return _buildEventCard(
                        item: item,
                        onEdit: () => controller.onEditEvent(index, item),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // Start Plan button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AgButton(title: 'Start Plan', onTap: controller.onStartPlan),
        ),
      ),
    );
  }

  // Helper method to build Event Tab
  Widget _buildEventTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFFE7EEF0),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? const Color(0xFF3E6A2A) : Colors.grey.shade400,
              width: 1.2,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected ? const Color(0xFF3E6A2A) : Colors.grey.shade800,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build Event Card
  Widget _buildEventCard({
    required CalendarEvent? item,
    required VoidCallback onEdit,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: const Color(0xFFF2F7F8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date + edit icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateUt.convertTimestampToDate(item?.eventDate ?? 0),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                InkWell(onTap: onEdit, child: const Icon(Icons.edit, size: 18)),
              ],
            ),
            const SizedBox(height: 12),

            // Event Name
            const Text(
              'Event Name',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              item?.activity1 ?? '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            if (item?.remark != null)
              const Text(
                'Remarks',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            const SizedBox(height: 4),
            if (item?.remark != null)
              Text(
                item?.remark ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4),

            // Event Week
            const Text(
              'Event Week',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              item?.weekName ?? '',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
