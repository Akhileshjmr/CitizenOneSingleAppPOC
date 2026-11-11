import 'dart:developer';

import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';

import '../../components/ui/ag_snackbar.dart';
import '../model/service_request/service_request.dart';
import '../model/service_request/submit_service_request.dart';
import '../model/service_request/upload_doc.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class ServiceEnquiryService {
  /// --------------------------------------------
  /// 1) GET service_request
  /// --------------------------------------------
  Future<ServiceRequest?> fetchServiceRequest() async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.getServiceRequest,
        data: {"reqSecureKey": UserPrefs.user?.userId ?? ''},
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      final Map<String, dynamic> data = response.data ?? {};

      final model = ServiceRequest.fromJson(data);

      // SUCCESS CHECK based on your API
      if (model.message?.type == "SUCCESS" || model.message?.code == "SUCC") {
        return model;
      }

      // ERROR Handling
      agSnackbar(
        title: "Error",
        msg: model.message?.message ?? "Something went wrong",
      );
      return null;
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong: $e");
      return null;
    }
  }

  Future<ServiceRequest?> searchServiceRequest({
    required String filterVal,
    String? reqSecureKey,
  }) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.serviceRequestSearch,
        data: {
          "filterVal": filterVal,
          if (reqSecureKey != null) "reqSecureKey": reqSecureKey,
        },
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      final Map<String, dynamic> data = response.data ?? {};

      final model = ServiceRequest.fromJson(data);

      // SUCCESS CHECK based on your API
      if (model.message?.type == "SUCCESS" || model.message?.code == "SUCC") {
        return model;
      }

      // ERROR Handling
      agSnackbar(
        title: "Error",
        msg: model.message?.message ?? "Something went wrong",
      );
      return null;
    } catch (e) {
      agSnackbar(title: "Error", msg: "Something went wrong: $e");
      return null;
    }
  }

  /// --------------------------------------------
  /// 2) POST service_request_search
  /// Highly reused API → general purpose
  /// --------------------------------------------
  // Future<dynamic> searchServiceRequest({
  //   required String filterVal,
  //   String? reqSecureKey,
  // }) async {
  //   try {
  //     final body = {
  //       "filterVal": filterVal,
  //       if (reqSecureKey != null) "reqSecureKey": reqSecureKey,
  //     };
  //
  //     //     if (response == null) {
  //     //       Get.snackbar("Error", "Unable to connect to server");
  //     //       return null;
  //     //     }
  //     //
  //     //     final Map<String, dynamic> data = response.data ?? {};
  //     //
  //     //     final model = ServiceRequest.fromJson(data);
  //     //
  //     //     // SUCCESS CHECK based on your API
  //     //     if (model.message?.type == "SUCCESS" || model.message?.code == "SUCC") {
  //     //       return model;
  //     //     }
  //     //
  //     //     // ERROR Handling
  //     //     Get.snackbar("Error", model.message?.message ?? "Something went wrong");
  //     //     return null;
  //     //   } catch (e) {
  //     //     Get.snackbar("Error", "Something went wrong: $e");
  //     //     return null;
  //     //   }
  //     // }
  // }

  /// --------------------------------------------
  /// 3) POST document upload
  /// base64 + fileName
  /// --------------------------------------------
  Future<UploadResponse?> uploadDocument(
    String fileBase64,
    String fileName,
  ) async {
    try {
      final body = {
        "docDet": [
          {"file": fileBase64, "fileName": fileName},
        ],
        "requestDet": {},
        "requestGenDet": {},
      };

      final response = await APIService.post(
        path: ApiEndPoints.serviceRequestDocUpload,
        data: body,
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      final data = response.data ?? {};

      final model = UploadResponse.fromJson(data);

      // Success condition (docId exists)
      if (model.docs?.docDet != null &&
          model.docs!.docDet!.isNotEmpty &&
          model.docs!.docDet!.first.docId != null) {
        return model;
      }

      // Otherwise error
      agSnackbar(
        title: "Alert",
        msg: model.chMessage?.message ?? "Something went wrong",
      );

      return null;
    } catch (e) {
      log("Document Upload Error: $e");
      agSnackbar(title: "Error", msg: "Something went wrong: $e");
      return null;
    }
  }

  /// --------------------------------------------
  /// 4) SUBMIT Final Service Request
  /// Common for Service / Transport / Warehouse
  /// --------------------------------------------
  Future<SubmitResponse?> submitServiceRequest(
    Map<String, dynamic> requestBody,
  ) async {
    try {
      final response = await APIService.post(
        path: ApiEndPoints.serviceRequest,
        data: requestBody,
      );

      if (response == null) {
        agSnackbar(title: "Error", msg: "Unable to connect to server");
        return null;
      }

      final data = response.data ?? {};

      if (_isSuccess(data)) {
        return SubmitResponse.fromJson(data);
      }

      _showError(data);
      return null;
    } catch (e) {
      log("Submit Service Request Error: $e");
      agSnackbar(title: "Error", msg: "Something went wrong: $e");
      return null;
    }
  }

  // -------------------------------------------------------------------
  // Helper Methods (follow same style as your PlanService)
  // -------------------------------------------------------------------

  bool _isSuccess(Map<String, dynamic> data) {
    final msg = data["chMessage"];
    if (msg == null) return false;

    return msg["type"] == "SUCCESS" ||
        msg["code"] == "SUCC" ||
        msg["isError"] == false;
  }

  void _showError(Map<String, dynamic> data) {
    final msg = data["chMessage"];
    if (msg == null) {
      agSnackbar(title: "Error", msg: "Unknown API response");
      return;
    }

    agSnackbar(
      title: msg["type"] ?? "Error",
      msg: msg["message"] ?? "Something went wrong",
    );
    log("API Error: ${msg["message"] ?? "No message"}");
  }
}
