import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/ComResp.dart';
import '../../../data/model/loan/property_form/Property_model.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../routes/app_pages.dart';

class PropertyFormController extends GetxController {
  final RxBool isLoading = false.obs;

  ///
  final GlobalKey<FormBuilderState> propertyFormKey =
      GlobalKey<FormBuilderState>();

  ///
  Rx<PropertyModel?> propertyModel = PropertyModel().obs;

  ///
  Rx<ComResp?> comResp = ComResp().obs;

  ///
  final RxString orderId = ''.obs;

  ///
  RxList<Options>? propertyOptions = <Options>[].obs;

  ///
  TextEditingController propertyNameController = TextEditingController();

  ///
  TextEditingController propertyValueController = TextEditingController();

  ///
  TextEditingController propertySize = TextEditingController();

  ///
  TextEditingController propertyYearController = TextEditingController();

  ///
  TextEditingController propertyRegistrationController =
      TextEditingController();

  ///
  TextEditingController propertyAddressController = TextEditingController();

  ///
  TextEditingController propertyZipController = TextEditingController();

  ///
  TextEditingController propertySellerController = TextEditingController();

  ///
  TextEditingController propertySellerContactController =
      TextEditingController();

  ///
  TextEditingController propertyReraController = TextEditingController();

  ///
  final RxString propertyType = 'Apartment'.obs;

  ///
  final RxString propertyValue = 'Apartment'.obs;

  @override
  void onInit() {
    super.onInit();

    propertyOptions?.add(
      Options(id: 0, type: 'APARTMENT', friendlyType: 'Apartment'),
    );
    propertyOptions?.add(Options(id: 1, type: 'VILLA', friendlyType: 'Villa'));
    propertyOptions?.add(
      Options(id: 2, type: 'INDIVIDUAL', friendlyType: 'Individual'),
    );
    propertyOptions?.add(
      Options(id: 3, type: 'STUDIO', friendlyType: 'Studio'),
    );
    propertyOptions?.add(
      Options(id: 4, type: 'TOWN_HOUSE', friendlyType: 'Town House'),
    );
    propertyOptions?.add(
      Options(id: 5, type: 'ROW_HOUSE', friendlyType: 'Row House'),
    );
    propertyOptions?.add(
      Options(id: 6, type: 'COMMERCIALS ', friendlyType: 'Commercials'),
    );
    fetchPropertyDetails('');
  }

  /// get property details
  Future<void> fetchPropertyDetails(String orderKey) async {
    isLoading(true);
    propertyModel(await AutoService.fetchPropertyDetails(orderKey));
    if ((propertyModel()?.addiParams?.length ?? 0) > 0) {
      orderId(propertyModel()?.addiParams?.first);
      propertyNameController.text =
          propertyModel()?.orderView?.propertyName ?? '';
      propertyValueController.text =
          propertyModel()?.orderView?.propertyValue.toString() ?? '';
      propertySize.text =
          propertyModel()?.orderView?.propertySize.toString() ?? '';
      propertyYearController.text =
          propertyModel()?.orderView?.yearsOfConstruction.toString() ?? '';
      // propertyRegistrationController.text = propertyModel()?.orderView?.registrationDate ?? '';
      propertyAddressController.text =
          propertyModel()?.orderView?.propertyAddress ?? '';
      propertyZipController.text =
          propertyModel()?.orderView?.zipCode.toString() ?? '';
      propertySellerController.text =
          propertyModel()?.orderView?.sellerName ?? '';
      propertySellerContactController.text =
          propertyModel()?.orderView?.sellerContactDetails ?? '';
      // propertyReraController.text = propertyModel()?.orderView?.reraNumber ?? '';
      propertyType(propertyModel()?.orderView?.propertyType);
    }
    isLoading(false);
  }

  /// add property details
  Future<void> addPropertyDetails() async {
    if (propertyFormKey.currentState?.saveAndValidate() ?? false) {
      final Map<String, dynamic> formData = <String, dynamic>{
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
        // 'vehicleCondition':condtion() ?? '',
        'propertyName': propertyNameController.text ?? '',
        'propertyValue': propertyValueController.text ?? '',
        'propertyType': propertyValue() ?? '',
        'propertySize': propertySize.text ?? '',
        'yearsOfContruction': propertyYearController.text ?? '',
        // 'firstRegistrationDate':propertyRegistrationController.text ?? '',
        'propertyAddress': propertyAddressController.text ?? '',
        'zipCode': propertyZipController.text ?? '',
        'sellerName': propertySellerController.text ?? '',
        'sellerContactDetails': propertySellerContactController.text ?? '',
        // 'reraNumber':propertyReraController.text ?? '',
      };
      if (orderId().isNotEmpty) {
        formData.addIf(orderId().isNotEmpty, 'addiParams', [orderId()]);
      }
      isLoading(true);
      try {
        comResp(await AutoService.submitPropertyDetail(formData: formData));
        if (comResp()?.chMessage?.isError == false) {
          orderId(comResp()?.addiParams?.first ?? '');
          LocalStore.buyNowFilterVal = orderId();
          LocalStore.thirdParty = 'REAL_ESTATE';
          await sendPaymentType();
        }
      } finally {
        isLoading(false);
      }
    }
  }

  ///
  Future<void> sendPaymentType() async {
    isLoading(true);
    try {
      final bool res = await AutoService.realEstateSubmitPayment();
      if (res == true) {
        await Get.toNamed<void>(
          Routes.PERSONAL_INFO,
          arguments: LimitArguments(LimitMode: 'REAL_ESTATE'),
        );
      } else {
        appSnackbar(
          message: 'Some error occurred',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }
}
