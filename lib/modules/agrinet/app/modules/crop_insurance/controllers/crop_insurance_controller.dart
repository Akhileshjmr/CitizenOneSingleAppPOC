import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/data/provider/crop_insurance_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../components/ui/ag_alert_dialogue.dart';
import '../../../components/ui/ag_snackbar.dart';
import '../../FarmingDashboard/bindings/farming_dashboard_binding.dart';

class CropInsuranceController extends GetxController {
  final formKey = GlobalKey<FormState>();

  String farmingPlanId = '';

  // Text Editing Controllers
  final sumInsuredController = TextEditingController();
  final govtShareController = TextEditingController();
  final govtPrmAmtController = TextEditingController();
  final grpShareController = TextEditingController();
  final grpPrmAmtController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();

  // Document list
  var documents = <ServiceRequestDocumentDetails>[].obs;

  var isLoading = false.obs;

  @override
  onInit() {
    fetchInitData();
    super.onInit();
  }

  // Pick an image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      Get.defaultDialog(
        title: "Confirm Image",
        content: Image.file(File(image.path)),
        confirm: TextButton(
          onPressed: () {
            // In a real app, you would upload this and get back a URL
            documents.add(
              ServiceRequestDocumentDetails(file: File(image.path)),
            );
            Get.back();
          },
          child: Text("ADD"),
        ),
        cancel: TextButton(onPressed: () => Get.back(), child: Text("CANCEL")),
      );
    }
  }

  Map<String, dynamic> buildCropInsuranceRequest() {
    return {
      "activateFromDate": fromDateController.text,
      "activateToDate": toDateController.text,
      "cmOtherDocs": [],
      "farmingPlanId": farmingPlanId,
      "governmentPrmAmt": govtPrmAmtController.text,
      "governmentShare": govtShareController.text,
      "groupPremiumAmt": grpPrmAmtController.text,
      "groupShare": grpShareController.text,
      "screenId": "CROP_INSURANCE",
      "sumInsured": sumInsuredController.text,
    };
  }

  void onFinalSubmit() async {
    if (!validateCropInsuranceData()) return;

    isLoading.value = true;

    final request = buildCropInsuranceRequest();

    final response = await CropInsuranceService.saveCropInsurance(
      request: request,
    );

    isLoading.value = false;

    if (response != null && !(response.chMessage?.isError ?? false)) {
      AgAlertDialog.show(
        title: "Success",
        message:
            response.chMessage?.message ??
            "Crop Insurance Submitted Successfully!",
        onOk: () {
          Get.back();
        },
      );
    } else {
      agSnackbar(
        title: "Error",
        msg: response?.chMessage?.message ?? "Submission failed",
      );
    }
  }

  // Select Date
  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat("dd/MM/yyyy").format(picked);
    }
  }

  void validateToDate(DateTime selected) {
    if (fromDate.value != null && selected.isBefore(fromDate.value!)) {
      agSnackbar(
        msg: "To Date cannot be earlier than From Date",
        title: "Invalid Date",
      );

      toDate.value = null;
      toDateController.clear();
      return;
    }

    // Valid date
    toDate.value = selected;
    toDateController.text = DateFormat("dd/MM/yyyy").format(selected);
  }

  void validateFromDate(DateTime selected) {
    fromDate.value = selected;
    fromDateController.text = DateFormat("dd/MM/yyyy").format(selected);

    // Check if existing To Date becomes invalid
    if (toDate.value != null && toDate.value!.isBefore(selected)) {
      toDate.value = null;
      toDateController.clear();
      agSnackbar(
        title: "Invalid Date Range",
        msg: "To Date reset because it was earlier than the new From Date.",
      );
    }
  }

  @override
  void onClose() {
    sumInsuredController.dispose();
    govtShareController.dispose();
    govtPrmAmtController.dispose();
    grpShareController.dispose();
    grpPrmAmtController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    super.onClose();
  }

  void fetchInitData() {
    final args = Get.arguments as FarmArguments?;

    if (args != null) {
      farmingPlanId = args.farmingPlanId.trim();
    } else {
      farmingPlanId = '';
    }
  }

  bool validateCropInsuranceData() {
    if (sumInsuredController.text.isEmpty) {
      _showError("Sum Insured is required");
      return false;
    }
    if (govtShareController.text.isEmpty) {
      _showError("Government Share is required");
      return false;
    }
    if (govtPrmAmtController.text.isEmpty) {
      _showError("Government Premium Amount is required");
      return false;
    }
    if (grpShareController.text.isEmpty) {
      _showError("Group Share is required");
      return false;
    }
    if (grpPrmAmtController.text.isEmpty) {
      _showError("Group Premium Amount is required");
      return false;
    }

    if (fromDate.value == null || fromDateController.text.isEmpty) {
      _showError("From Date is required");
      return false;
    }

    if (toDate.value == null || toDateController.text.isEmpty) {
      _showError("To Date is required");
      return false;
    }

    if (toDate.value!.isBefore(fromDate.value!)) {
      _showError("To Date cannot be earlier than From Date");
      return false;
    }

    if (farmingPlanId.isEmpty) {
      _showError("Farming Plan ID is missing");
      return false;
    }

    /*if (documents.isEmpty) {
      _showError("Please upload at least one document");
      return false;
    }*/

    return true;
  }

  void _showError(String msg) {
    agSnackbar(title: "Missing Information", msg: msg);
  }
}

class ServiceRequestDocumentDetails {
  File? file;
  String? fileUrl;

  ServiceRequestDocumentDetails({this.file, this.fileUrl});
}
