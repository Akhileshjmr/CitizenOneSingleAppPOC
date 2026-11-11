import 'package:get/get.dart';

import '../../../components/utils/str_ext.dart';
import '../../../data/model/shgDetails/shgDetailsResp.dart';
import '../../../data/provider/FarmPlanService.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';
import '../views/EventRescheduleDialog.dart';
import '../views/StartDateInputDialog.dart';

class EventDisplayController extends GetxController {
  Rx<FarmingPlanResponse?> eventsByCrop = FarmingPlanResponse().obs;
  // Full events list (optional, if you want to keep a copy)
  final RxList<CalendarEvent> allEvents = <CalendarEvent>[].obs;

  late FarmArguments args;
  final RxBool isLoading = false.obs;

  // selected tab index
  final selectedCropIndex = 0.obs;

  // Selected crop & filtered list
  // Filtered events for UI
  final RxList<CalendarEvent> filteredEvents = <CalendarEvent>[].obs;

  // Selected crop from recommendedCrop
  final Rx<RecommendedCrop?> selectedCrop = Rx<RecommendedCrop?>(null);

  // events per crop index
  // final eventsByCrop = <int, List<EventItem>>{}.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is FarmArguments) {
      args = Get.arguments;
    }
    loadFarmData();
  }

  Future<void> loadFarmData() async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFromResponse();
      final farmData = await FarmPlanService.getEventsList(formData: formData);
      if (farmData?.chMessage?.isError == false) {
        eventsByCrop.value = farmData;
        allEvents.assignAll(eventsByCrop.value?.calenderEvents ?? []);
        // Default: show all events
        filteredEvents.assignAll(allEvents);
      }
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFromResponse() {
    return {"farmingPlanId": args.farmingPlanId, "screenId": "CALENDER_EVENTS"};
  }

  // List<EventItem> get currentEvents =>
  //     eventsByCrop[selectedCropIndex.value] ?? [];

  void selectCrop(int index, RecommendedCrop crop) {
    selectedCropIndex.value = index;
    selectedCrop.value = crop;
  }

  void setFarmingPlan(FarmingPlanResponse response) {
    eventsByCrop.value = response;
    allEvents.assignAll(response.calenderEvents ?? []);
    // Default: show all events
    filteredEvents.assignAll(allEvents);
  }

  void onEditEvent(int index, CalendarEvent item) {
    Get.dialog(
      EventRescheduleDialog(
        title: item.weekName ?? '', // or item.title
        startDate: DateUt.convertTimestampToDate(item.eventDate ?? 0),
        description: item.integraAndInterfaces ?? '',
        remark: item.remark ?? "",
        onSubmit: (rescheduleDate, remarks, id) {
          // TODO: send API request / update state
          print('Rescheduled to: $rescheduleDate');
          print('Remarks: $remarks');
          final eventDateMillis = rescheduleDate?.millisecondsSinceEpoch;

          print('Current eventDate: $eventDateMillis');
          rescheduleData('${eventDateMillis ?? item.eventDate}', remarks, id);
        },
        id: item.id ?? 0,
      ),
      barrierDismissible: false, // like your screenshot
    );
  }

  Future<void> onStartPlan() async {
    Get.dialog(
      StartDateInputDialog(
        onProceed: (selectedDate) async {
          // Handle date here
          final formatted =
              '${selectedDate.day.toString().padLeft(2, '0')}/'
              '${selectedDate.month.toString().padLeft(2, '0')}/'
              '${selectedDate.year}';
          final eventDateMillis = selectedDate.millisecondsSinceEpoch;
          await selectData('$eventDateMillis');
        },
      ),
      barrierDismissible: false,
    );
  }

  Future<void> selectData(String currentDate) async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createFormDataFrom(currentDate);
      final farmData = await FarmPlanService.GroupFarmDeatilsList(
        formData: formData,
      );
      if (farmData?.chMessage?.isError == false) {}
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDataFrom(String StDate) {
    return {
      "createdDate": StDate,
      "farmingPlanId": args.farmingPlanId,
      "screenId": "CROP_SUGGESTION",
    };
  }

  Future<void> rescheduleData(String currentDate, String remark, int id) async {
    try {
      isLoading.value = true;

      // Get group list first
      final formData = _createFormDatarescheduleFrom(currentDate, id, remark);
      final farmData = await FarmPlanService.RescheduleEvent(
        formData: formData,
      );
      if (farmData?.chMessage?.isError == false) {}
    } catch (e) {
      print('Error loading farm data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _createFormDatarescheduleFrom(
    String StDate,
    int sid,
    String remark,
  ) {
    return {"eventDate": StDate, "id": sid, "remark": remark};
  }
}
