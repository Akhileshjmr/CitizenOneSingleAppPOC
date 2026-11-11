import 'dart:io';

import 'package:citizenone_app/modules/agrinet/app/data/model/common/option.dart';
import 'package:citizenone_app/modules/agrinet/app/data/model/publish_ads/farm_plan_detail.dart';
import 'package:citizenone_app/modules/agrinet/app/utils/ag_apptranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

mixin PublishAdsVariables {
  AgApptranslation agApptranslation = AgApptranslation();
  RxList<Option> farmerPlanList = <Option>[].obs;
  Rxn<Option> selectedFarmPlan = Rxn<Option>();
  TextEditingController minimumPricePerKgController = TextEditingController();
  TextEditingController totalQuantity = TextEditingController();
  Rxn<DateTime> readyByDate = Rxn<DateTime>();
  Rxn<DateTime> bidingCloseDate = Rxn<DateTime>();
  RxBool isTransportationProvided = false.obs;
  RxBool isPlanDetailLoading = false.obs;
  Rxn<CropDetailResponse> cropDetailResponse = Rxn<CropDetailResponse>();
  RxList<File> selectedImages = <File>[].obs;
  final profilePhotoUrl = Rx<String?>(null);
  RxBool showImageCard = false.obs;
  RxString documentName = ''.obs;
  final RxList<ImageDocItem> imageItems = <ImageDocItem>[].obs;
}

class ImageDocItem {
  String? documentName;
  File? imageFile;
  bool saved;
  bool showError;
  bool uploaded;
  bool isUploading;

  ImageDocItem({
    this.documentName,
    this.imageFile,
    this.saved = false,
    this.showError = false,
    this.uploaded = false,
    this.isUploading = false,
  });
}
