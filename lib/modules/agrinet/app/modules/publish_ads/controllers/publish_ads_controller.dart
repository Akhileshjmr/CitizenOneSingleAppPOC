import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/components/ui/ag_snackbar.dart';
import 'package:citizenone_app/modules/agrinet/app/components/utils/user_prefs.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/publish_ads/farm_plan_detail.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/publish_ads/farm_plan_list.dart';
import 'package:citizenone_app/modules/agrinet/app/data/provider/publish_ads_service.dart';
import 'package:citizenone_app/modules/agrinet/app/modules/publish_ads/controllers/publish_ads_variables.dart';
import 'package:citizenone_app/modules/agrinet/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PublishAdsController extends GetxController with PublishAdsVariables {
  RxBool isLoading = false.obs;
  RxInt docId = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchFarmPlanList();
  }

  Future<void> fetchFarmPlanList() async {
    try {
      isLoading(true);
      FarmPlanListResponse? response =
          await PublishAdsService.fetchFarmPlanList();
      if (response != null) {
        farmerPlanList(response.selectOptionList?[0].options);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> getFarmPlanDetails(Option planOption) async {
    try {
      cropDetailResponse.value = null;
      isPlanDetailLoading(true);
      dynamic requestBody = {
        "farmPlanID": {
          "friendlyType": planOption.friendlyType,
          "id": planOption.id,
          "type": planOption.type,
        },
        "id": UserPrefs.user?.userId ?? '',
      };
      final CropDetailResponse? response =
          await PublishAdsService.getFarmPlanDetails(requestBody: requestBody);
      if (response != null) {
        cropDetailResponse.value = response;
      }
      isPlanDetailLoading(false);
    } catch (e) {
      isPlanDetailLoading(false);
    }
  }

  Future<void> publishAdvertise() async {
    try {
      if (validateForm()) {
        isLoading(true);
        dynamic request = {
          "reqSecureKey": UserPrefs.user?.userId ?? '',
          "bidClose": DateFormat('dd/MM/yyyy').format(bidingCloseDate.value!),
          "cropName": [
            {
              "cropName":
                  cropDetailResponse.value!.cropName!.isNotEmpty
                      ? cropDetailResponse.value!.cropName![0].cropName
                      : 'Rice',
            },
          ],
          "documents": [
            {"docId": docId.value},
          ],
          "farmPlanID": {
            "friendlyType": selectedFarmPlan.value?.friendlyType,
            "id": selectedFarmPlan.value?.id,
            "type": selectedFarmPlan.value?.type,
          },
          "groupID": cropDetailResponse.value?.groupID,
          "minPrice": minimumPricePerKgController.text,
          "readyBy": DateFormat('dd/MM/yyyy').format(readyByDate.value!),
          "status": {"type": "NEW"},
          "totalQuantity": totalQuantity.text,
          "transportationProvided": isTransportationProvided.value,
        };
        final response = await PublishAdsService.savePublishAds(
          requestBody: request,
        );
        if (response != null) {
          clearFields();
          Get.toNamed(
            Routes.SUCCESS_INFO,
            arguments: {
              "title": "Info",
              "message": "Successfully Published the Advertise",
              "onOk": () {
                Get.offAllNamed(Routes.HOME);
              },
            },
          );
        }
        isLoading(false);
      }
      isLoading(false);
    } catch (e) {
      isLoading(false);
    }
  }

  void clearFields() {
    cropDetailResponse.value = null;
    selectedFarmPlan.value = null;
    minimumPricePerKgController.clear();
    totalQuantity.clear();
    readyByDate.value = null;
    bidingCloseDate.value = null;
  }

  bool validateForm() {
    if (selectedFarmPlan.value == null) {
      agSnackbar(title: "Error", msg: "Please select a Farm Plan");
      return false;
    }

    if (minimumPricePerKgController.text.trim().isEmpty) {
      agSnackbar(title: "Error", msg: "Please enter Minimum Price Per Kg");
      return false;
    }

    if (totalQuantity.text.trim().isEmpty) {
      agSnackbar(title: "Error", msg: "Please enter Total Quantity");
      return false;
    }

    if (readyByDate.value == null) {
      agSnackbar(title: "Error", msg: "Please select Ready By date");
      return false;
    }

    if (bidingCloseDate.value == null) {
      agSnackbar(title: "Error", msg: "Please select Bidding Close date");
      return false;
    }

    if (readyByDate.value!.isAfter(bidingCloseDate.value!)) {
      agSnackbar(
        title: "Error",
        msg: "Ready By date must be earlier than Bidding Close date",
      );
      return false;
    }

    if (docId.value == 0) {
      agSnackbar(title: "Error", msg: "Please upload document");
      return false;
    }

    return true;
  }

  Future<File?> pickFromCamera() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (picked != null) {
      final file = File(picked.path);
      selectedImages.add(file);
      return file;
    }
    return null;
  }

  Future<bool> uploadSingleDocument(int index) async {
    try {
      if ((selectedFarmPlan.value?.friendlyType ?? '').isEmpty) {
        agSnackbar(
          title: "Missing information!",
          msg: "Please select farm plan",
        );
        return false;
      }

      final item = imageItems[index];

      if (item.imageFile == null) return false;

      imageItems[index].isUploading = true;
      imageItems.refresh();

      final bytes = await item.imageFile!.readAsBytes();

      final request = {
        "documents": [
          {"file": bytes, "fileName": item.documentName},
        ],
        "farmPlanID": {
          "friendlyType": selectedFarmPlan.value?.friendlyType,
          "id": selectedFarmPlan.value?.id,
          "type": selectedFarmPlan.value?.type,
        },
        "username": (UserPrefs.user?.userId ?? '').toString(),
      };

      final response = await PublishAdsService.uploadAdvertiseDocuments(
        requestBody: request,
      );

      imageItems[index].isUploading = false;

      if (response?.message?.isError == false &&
          response?.advertiseDocs?.documents != null &&
          response!.advertiseDocs!.documents!.isNotEmpty &&
          response.advertiseDocs!.documents!.first.docId != null) {
        docId(response.advertiseDocs!.documents!.first.docId!);
        print(docId);
      }

      if (response != null) {
        imageItems[index].uploaded = true;
        imageItems[index].saved = true;
        imageItems.refresh();
        return true;
      }

      imageItems.refresh();
      return false;
    } catch (e) {
      imageItems[index].isUploading = false;
      imageItems.refresh();
      return false;
    }
  }
}
