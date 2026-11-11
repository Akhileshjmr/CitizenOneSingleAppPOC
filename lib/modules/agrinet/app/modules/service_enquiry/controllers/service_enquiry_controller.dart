import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/service_request/service_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../data/model/common/option.dart';
import '../../../data/model/service_request/document_upload.dart';
import '../../../data/model/service_request/recommendation.dart';
import '../../../data/provider/service_enquiry_service.dart';
import '../../../routes/app_pages.dart';
import '../views/service_details_view.dart';
import 'enquiry_type.dart';

class ServiceEnquiryController extends GetxController {
  // ============================================================
  //  RECEIVE ENQUIRY TYPE FROM ARGUMENTS
  // ============================================================
  late final EnquiryType enquiryType;

  final reviewOptions = [
    {"label": "Yes", "value": true},
    {"label": "No", "value": false},
  ];

  @override
  void onInit() {
    enquiryType = Get.arguments ?? EnquiryType.service; // default
    loadInitialData();
    super.onInit();
  }

  // ============================================================
  //  DYNAMIC LABELS / FILTER VALUES BASED ON MODULE
  // ============================================================

  String get moduleTitle {
    switch (enquiryType) {
      case EnquiryType.service:
        return "Service Request";
      case EnquiryType.transport:
        return "Transport Enquiry";
      case EnquiryType.warehouse:
        return "Warehouse Enquiry";
    }
  }

  String? get bannerImage {
    switch (enquiryType) {
      case EnquiryType.service:
        return null;
      case EnquiryType.transport:
        return "assets/images/transports.jpg";
      case EnquiryType.warehouse:
        return "assets/images/warehouse.jpg";
    }
  }

  // SCREEN 1
  Rxn<Option> raisedBy = Rxn<Option>();
  RxList<Option> raisedByList = <Option>[].obs;

  Rxn<Option> selectedEntity = Rxn<Option>(); // MUST USE THIS
  RxList<Option> entityList = <Option>[].obs;

  Rxn<Option> selectedPlan = Rxn<Option>();
  RxList<Option> planList = <Option>[].obs;

  TextEditingController subjectCtrl = TextEditingController();

  // SCREEN 2
  Rxn<Option> selectedServiceType = Rxn<Option>();
  RxList<Option> serviceTypeList = <Option>[].obs;

  Rxn<Option> selectedRelatedTo = Rxn<Option>(); // should send id ONLY
  RxList<Option> relatedToList = <Option>[].obs;

  TextEditingController inquiryCtrl = TextEditingController();
  Rxn<DateTime> rxDueDate = Rxn<DateTime>();
  TextEditingController costCtrl = TextEditingController();
  TextEditingController commentCtrl = TextEditingController();
  RxBool reviewRequired = false.obs;

  // SCREEN 3 (Recommendations)
  RxList<RecommendationModel> recommendations = <RecommendationModel>[].obs;

  RxList<Option> categoryOptions = <Option>[].obs;

  // SCREEN 4 (Documents)
  RxList<DocumentUploadModel> documents = <DocumentUploadModel>[].obs;

  RxBool isLoading = false.obs;

  // API 1 → LOAD MASTER DATA
  Future<void> loadInitialData() async {
    isLoading.value = true;
    final res = await ServiceEnquiryService().fetchServiceRequest();
    isLoading.value = false;

    if (res == null) return;

    final fullRaisedBy = res.getOptions("SERVICE_REQ_RAISED_BY");
    final fullServiceTypes = res.getOptions("SERVICE_TYPE");

    switch (enquiryType) {
      // 1) SERVICE REQUEST (Normal flow)
      case EnquiryType.service:
        raisedByList.assignAll(fullRaisedBy);
        serviceTypeList.assignAll(fullServiceTypes);
        categoryOptions.assignAll(res.getOptions("RCMD_CATEGORY"));
        break;

      // 2) TRANSPORT ENQUIRY
      case EnquiryType.transport:
        raisedByList.assignAll(
          fullRaisedBy.where((e) => e.type == "PAL" || e.friendlyType == "Pal"),
        );

        serviceTypeList.assignAll(
          fullServiceTypes.where(
            (e) =>
                e.type == "TRANSPORT INQUIRY" ||
                e.friendlyType == "Transport Inquiry",
          ),
        );

        categoryOptions.assignAll(
          res
              .getOptions("RCMD_CATEGORY")
              .where(
                (e) => e.type == "Transport" || e.friendlyType == "Transport",
              ),
        );
        break;

      // 3) WAREHOUSE ENQUIRY
      case EnquiryType.warehouse:
        raisedByList.assignAll(
          fullRaisedBy.where((e) => e.type == "PAL" || e.friendlyType == "Pal"),
        );

        serviceTypeList.assignAll(
          fullServiceTypes.where(
            (e) =>
                e.type == "STORAGE INQUIRY" ||
                e.friendlyType == "Storage Inquiry",
          ),
        );

        categoryOptions.assignAll(
          res
              .getOptions("RCMD_CATEGORY")
              .where((e) => e.type == "Storage" || e.friendlyType == "Storage"),
        );
        break;
    }

    // COMMON LISTS
    planList.assignAll(res.getOptions("FARMING_PLAN"));

    // AUTO-SELECT PAL only for Transport / Warehouse
    if (enquiryType == EnquiryType.transport ||
        enquiryType == EnquiryType.warehouse) {
      final pal = raisedByList.firstWhereOrNull(
        (e) => e.type == "PAL" || e.friendlyType == "Pal",
      );

      if (pal != null) {
        raisedBy.value = pal;
        getEntityId(); // Load entity after selecting PAL
      }
    }
  }

  // Load Entity (based on RaisedBy)
  Future<void> getEntityId() async {
    if (raisedBy.value == null) return;

    isLoading.value = true;
    final res = await ServiceEnquiryService().searchServiceRequest(
      filterVal: raisedBy.value!.type ?? "",
    );
    isLoading.value = false;

    if (res == null) return;

    entityList.assignAll(res.getOptions(raisedBy.value?.type ?? ""));
  }

  // Load Subcategory
  Future<void> searchServiceType(Option selected) async {
    selectedServiceType.value = selected;

    isLoading.value = true;
    final res = await ServiceEnquiryService().searchServiceRequest(
      filterVal: selected.type ?? "",
    );
    isLoading.value = false;

    if (res == null) return;

    relatedToList.assignAll(res.selectOptionList?.first.options ?? []);
  }

  // Load Product list for Recommendation
  Future<void> searchCategoryForRecommendation(String catId, int index) async {
    isLoading.value = true;

    final res = await ServiceEnquiryService().searchServiceRequest(
      filterVal: catId,
      reqSecureKey: "RECOMMEND",
    );

    isLoading.value = false;

    if (res == null) return;

    final items = res.selectOptionList?.first.options ?? [];

    recommendations[index].productOptions = items;
    recommendations.refresh();
  }

  void addRecommendation() {
    recommendations.add(RecommendationModel());
    recommendations.refresh();
  }

  void deleteRecommendation(int index) {
    if (index < recommendations.length) {
      recommendations.removeAt(index);
      recommendations.refresh();
    }
  }

  // DOCUMENT UPLOAD

  void addDocument() {
    documents.add(DocumentUploadModel());
    update();
  }

  Future<void> saveDocument(int index) async {
    final doc = documents[index];

    try {
      doc.isUploading.value = true;
      doc.progress.value = 0.3; // mock real-time progression step 1

      final base64 = await doc.fileToBase64();
      if (base64 == null) {
        agSnackbar(title: "Error", msg: "Please select a document");
        return;
      }

      doc.progress.value = 0.6; // step 2

      final res = await ServiceEnquiryService().uploadDocument(
        base64,
        doc.name,
      );

      doc.progress.value = 1.0; // complete

      if (res != null && res.docs?.docDet != null) {
        final uploaded = res.docs!.docDet!.first;

        doc.docId = uploaded.docId.toString();
        doc.isSaved.value = true;
      }
    } catch (e) {
      agSnackbar(title: "Error", msg: "Upload failed: $e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 600));
      doc.isUploading.value = false;
      doc.progress.value = 0.0;
      documents.refresh();
    }
  }

  Future<void> pickDocumentFile(int index) async {
    try {
      final picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo == null) return;

      documents[index].preview = File(photo.path);
      documents[index].filePath = photo.path;

      if (documents[index].name.isEmpty) {
        documents[index].name = "Document ${index + 1}";
        documents[index].textController.text = documents[index].name;
      }

      documents.refresh();
    } catch (e) {
      agSnackbar(title: "Error", msg: "Camera error: $e");
    }
  }

  // SUBMIT FINAL REQUEST
  Future<void> submit() async {
    try {
      if (!areAllDocumentsUploaded()) {
        agSnackbar(
          title: "Alert",
          msg: "Please upload all documents before submitting.",
        );
        return;
      }

      isLoading.value = true;

      final req = {
        "docDet": documents.map((e) => e.toSubmitJson()).toList(),

        "recomondationDet": recommendations.map((e) => e.toJson()).toList(),

        "requestDet": {
          "comments": commentCtrl.text,
          "dueDate": rxDueDate.value?.millisecondsSinceEpoch,
          "enquiryDetail": inquiryCtrl.text,
          "estimatedCost": double.tryParse(costCtrl.text) ?? 0.0,
          "raisedBy": raisedBy.value?.toJson(),
          "relatedTo": selectedRelatedTo.value?.toJson(),
          "reviveRequired": reviewRequired.value,
          "serviceType": selectedServiceType.value?.toJson(),
        },

        "requestGenDet": {
          "entityId":
              selectedEntity.value?.toJson() ?? raisedBy.value?.toJson(),
          "farmingPlanId": selectedPlan.value?.toJson(),
          "name": raisedBy.value?.toJson(),
          "subject": subjectCtrl.text,
        },
      };

      final res = await ServiceEnquiryService().submitServiceRequest(req);

      if (res == null) {
        agSnackbar(
          title: "Error",
          msg: "Something went wrong. Please try again.",
        );
        return;
      }

      AgAlertDialog.show(
        title: "Info",
        message: "${res.chMessage?.message}\nRequest Code: ${res.tempStr}",
        onOk: () => Get.offAllNamed(Routes.HOME),
      );
    } catch (e) {
      agSnackbar(title: "Error", msg: "Submit failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // VALIDATION
  void onReqNext() {
    if (raisedBy.value == null) {
      AgAlertDialog.show(title: "Alert", message: "Select Raised By");
      return;
    }
    if (selectedPlan.value == null) {
      AgAlertDialog.show(title: "Alert", message: "Select Farming Plan");
      return;
    }
    if (subjectCtrl.text.isEmpty) {
      AgAlertDialog.show(title: "Alert", message: "Enter Subject");
      return;
    }

    Get.to(() => const ServiceDetailsView());
  }

  bool areAllDocumentsUploaded() {
    for (final d in documents) {
      if (!d.isSaved.value) return false;
    }
    return true;
  }

  bool validateServiceDetails() {
    if (selectedServiceType.value == null) {
      agSnackbar(title: "Alert", msg: "Select Service Type");
      return false;
    }

    if (selectedRelatedTo.value == null) {
      agSnackbar(title: "Alert", msg: "Select Related To");
      return false;
    }

    if (inquiryCtrl.text.trim().isEmpty) {
      agSnackbar(title: "Alert", msg: "Enter Inquiry Details");
      return false;
    }

    if (rxDueDate.value == null) {
      agSnackbar(title: "Alert", msg: "Select Due Date");
      return false;
    }

    if (costCtrl.text.trim().isEmpty) {
      agSnackbar(title: "Alert", msg: "Enter Estimated Cost");
      return false;
    }

    if (double.tryParse(costCtrl.text.trim()) == null) {
      agSnackbar(title: "Alert", msg: "Enter a valid Estimated Cost");
      return false;
    }

    if (commentCtrl.text.trim().isEmpty) {
      agSnackbar(title: "Alert", msg: "Enter Comments");
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    super.onClose();
    subjectCtrl.dispose();
    inquiryCtrl.dispose();
    costCtrl.dispose();
    commentCtrl.dispose();
  }
}
