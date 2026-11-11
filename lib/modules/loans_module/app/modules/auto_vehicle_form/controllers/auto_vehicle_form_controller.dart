import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/ComResp.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/vehicle/Vehicle_model.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../routes/app_pages.dart';

class AutoVehicleFormController extends GetxController {
  ///
  final RxBool isLoading = false.obs;

  ///
  final GlobalKey<FormBuilderState> vehicleFormKey =
      GlobalKey<FormBuilderState>();

  ///
  TextEditingController vehicleNameController = TextEditingController();

  ///
  TextEditingController vehicleTypeController = TextEditingController();

  ///
  TextEditingController vehicleDescriptionController = TextEditingController();

  ///
  TextEditingController vehicleColorController = TextEditingController();

  ///
  TextEditingController vehicleYearController = TextEditingController();

  ///
  TextEditingController vehiclePriceController = TextEditingController();

  ///
  RxList<Options>? vehicleConditionOptions = <Options>[].obs;

  ///
  final RxString condtion = 'New'.obs;

  ///
  RxList<Options>? manufacturerOptions = <Options>[].obs;

  ///
  final RxString manufacturer = 'Audi'.obs;

  ///
  final RxString orderId = ''.obs;

  ///
  Rx<VehicleModel?> vehicleModel = VehicleModel().obs;

  ///
  Rx<ComResp?> comResp = ComResp().obs;

  ///
  @override
  void onInit() {
    super.onInit();
    vehicleConditionOptions?.add(
      Options(id: 0, type: 'NEW', friendlyType: 'New'),
    );
    vehicleConditionOptions?.add(
      Options(id: 1, type: 'USED', friendlyType: 'Used'),
    );

    manufacturerOptions?.add(
      Options(id: 0, type: 'AUDI', friendlyType: 'Audi'),
    );
    manufacturerOptions?.add(
      Options(id: 1, type: 'ASHOK_LEYLAND', friendlyType: 'Ashok Leyland'),
    );
    manufacturerOptions?.add(
      Options(id: 2, type: 'Hyundai', friendlyType: 'Hyundai'),
    );
    manufacturerOptions?.add(
      Options(id: 3, type: 'Ford', friendlyType: 'Ford'),
    );
    manufacturerOptions?.add(
      Options(id: 4, type: 'Volvo', friendlyType: 'Volvo'),
    );
    manufacturerOptions?.add(
      Options(id: 5, type: 'Mercedes_Benz', friendlyType: 'Mercedes Benz'),
    );
    manufacturerOptions?.add(
      Options(id: 6, type: 'Rolls_Royce', friendlyType: 'Rolls Royce'),
    );
    manufacturerOptions?.add(
      Options(id: 7, type: 'Nissan', friendlyType: 'Nissan'),
    );
    manufacturerOptions?.add(Options(id: 8, type: 'BMW', friendlyType: 'BMW'));
    manufacturerOptions?.add(
      Options(id: 9, type: 'Fiat', friendlyType: 'Fiat'),
    );
    manufacturerOptions?.add(
      Options(id: 10, type: 'Lamborghini', friendlyType: 'Lamborghini'),
    );

    fetchVehicleDetails();
  }

  /// get vehicle details
  Future<void> fetchVehicleDetails() async {
    isLoading(true);
    vehicleModel(await AutoService.fetchVehicleDetails());
    if ((vehicleModel()?.addiParams?.length ?? 0) > 0) {
      orderId(vehicleModel()?.addiParams?.first ?? '');
      vehicleNameController.text =
          vehicleModel()?.vehicleInfo?.vehicleName ?? '';
      vehicleDescriptionController.text =
          vehicleModel()?.vehicleInfo?.vehicleDesc ?? '';
      vehicleColorController.text =
          vehicleModel()?.vehicleInfo?.vehicleColor ?? '';
      vehicleYearController.text =
          vehicleModel()?.vehicleInfo?.vehicleMakingYear.toString() ?? '';
      vehiclePriceController.text =
          vehicleModel()?.vehicleInfo?.vehiclePrice.toString() ?? '';
      vehicleTypeController.text =
          vehicleModel()?.vehicleInfo?.vehicleType ?? '';
      condtion(vehicleModel()?.vehicleInfo?.vehicleCondition ?? '');
      manufacturer(vehicleModel()?.vehicleInfo?.manufacturerType ?? '');
    }
    isLoading(false);
  }

  /// add vehicle details
  Future<void> addVehicleDetails() async {
    if (vehicleFormKey.currentState?.saveAndValidate() ?? false) {
      final Map<String, dynamic> formData = <String, dynamic>{
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
        'vehicleCondition': condtion() ?? '',
        'vehiclePrice': vehiclePriceController.text ?? '',
        'vehicleType': vehicleTypeController.text ?? '',
        'vehicleDesc': vehicleDescriptionController.text ?? '',
        'vehicleMakingYear': vehicleYearController.text ?? '',
        'vehicleColor': vehicleColorController.text ?? '',
        'vehicleName': vehicleNameController.text ?? '',
        'manufacturerType': manufacturer() ?? '',
      };
      if (orderId().isNotEmpty) {
        formData.addIf(orderId().isNotEmpty, 'filterVal', orderId());
      }
      isLoading(true);
      try {
        comResp(await AutoService.submitVehicleDetail(formData: formData));
        if (comResp()?.chMessage?.isError == false) {
          orderId(comResp()?.addiParams?.first ?? '');
          LocalStore.buyNowFilterVal = orderId();
          LocalStore.thirdParty = 'AUTO';
          await sendPaymentType(orderId(), '');
        }
      } finally {
        isLoading(false);
      }
    }
  }

  ///
  Future<bool> sendPaymentType(String filterval, String imgType) async {
    try {
      isLoading(true);
      final LimitFnaSubResp? resp = await AutoService.submitPayment(
        filterval,
        '',
        filterval,
      );
      if (resp?.chMessage?.isError == false) {
        await Get.toNamed<void>(
          Routes.PERSONAL_INFO,
          arguments: LimitArguments(LimitMode: 'Auto'),
        );
      }
      isLoading(false);
      return true;
    } finally {
      isLoading(false);
    }
  }
}
