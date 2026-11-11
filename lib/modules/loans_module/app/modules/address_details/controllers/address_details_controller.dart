import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/api_service/ApiEndPoints.dart';

import '../../../data/config/logger.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/address/AddressDet.dart';
import '../../../data/model/args/address_args.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/select_box_model/SelectOptionList.dart';
import '../../../data/remote/provider/address/address_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/static_value_constant.dart';

/// ✅ Extension for safe list access
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class AddressDetailsController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxBool isLoading = true.obs;
  RxBool isAddressList = false.obs;

  late AddressDetailArgs argAdds;
  late groceryDetailArgs argGrocery;

  final RxList<SelectOptionList?> selectoptionList = <SelectOptionList?>[].obs;
  Rx<AddressDet> addressdata = AddressDet().obs;

  /// ✅ FIXED NAMING
  RxList<Options> countryList = <Options>[].obs;
  RxList<Options> emrites = <Options>[].obs;
  RxList<Options> cities = <Options>[].obs;

  final RxInt countryid = 0.obs;
  final RxInt emritesid = 0.obs;

  final RxString selectedCountry = 'UAE'.obs;
  final RxString emirati = ''.obs;
  final RxString countryName = ''.obs;

  late RxString gender = 'Home'.obs;

  List<String> addressType = ['Home', 'Office', 'Others'];

  TextEditingController fullNameController = TextEditingController();
  TextEditingController MobileNumberController = TextEditingController();
  TextEditingController PoBoxNumberController = TextEditingController();
  TextEditingController BuildingNameController = TextEditingController();
  TextEditingController FlatNumberController = TextEditingController();
  TextEditingController LandmarkController = TextEditingController();
  TextEditingController AreaController = TextEditingController();

  late LimitArguments args;
  late PRArguments preArgs;

  Map<String, dynamic> countryMap = {};
  Map<String, dynamic> emritesMap = {};

  String mode = '';

  RxBool isHomeTapped = false.obs;
  RxBool isOfficeTapped = false.obs;
  RxBool isOtherTapped = false.obs;

  @override
  Future<void> onInit() async {
    fullNameController.text = StaticValueConstant.user_Name ?? '';
    MobileNumberController.text = StaticValueConstant.PhoneNumber ?? '';

    await getDroupDownList();

    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      mode = args.LimitMode;
    } else if (Get.arguments is PRArguments) {
      preArgs = Get.arguments;
      mode = preArgs.LimtMode;
    } else if (Get.arguments is AddressDetailArgs) {
      argAdds = Get.arguments;
      isAddressList(argAdds.isAddressList);
    }

    await loadInitialData();
    super.onInit();
  }

  Future<void> loadInitialData() async {
    if (isAddressList.value) {
      await getPeronalData(ApiEndPoints.getProfileForms);
      return;
    }

    switch (mode) {
      case 'Auto':
        await getPeronalData('auto/orders/get-profile-forms');
        break;
      case 'CG':
        await getPeronalData('orders/cg/get-profile-forms');
        break;
      case 'REAL_ESTATE':
        await getPeronalData('realestate/home/orders/get-profile-forms');
        break;
      case 'Credit':
      case 'CreditReview':
        await getPeronalData('creditcard/get-cc-form-fields');
        break;
      case 'Personal':
      case 'PersonalReview':
        await getPeronalData(ApiEndPoints.getPlFinanceFields);
        break;
      case 'AutoLoan':
        await getPeronalData('pl/pre-approved-loan/get-profile-forms');
        break;
      default:
        await getPeronalData(ApiEndPoints.getProfileForms);
    }
  }

  Future<void> getDroupDownList() async {
    try {
      isLoading(true);

      selectoptionList(await PersonalListService.getListView());

      countryList(
        selectoptionList
                .firstWhereOrNull((e) => e?.key == 'NATIONALITY')
                ?.options ??
            [],
      );

      emrites(
        selectoptionList.firstWhereOrNull((e) => e?.key == 'STATES')?.options ??
            [],
      );
    } finally {
      isLoading(false);
    }
  }

  /// 🔥 FIXED MAIN LOGIC
  Future<void> getPeronalData(String url) async {
    try {
      isLoading(true);

      final resp = await AddressService.getPersonalDetails(url);
      if (resp == null) return;

      addressdata(resp);

      /// ✅ COUNTRY FIX
      Options? countryObj;

      if (resp.country != null) {
        countryObj = resp.country;
      } else {
        countryObj = countryList.firstOrNull;
      }

      if (countryObj != null) {
        selectedCountry(countryObj.type ?? '');
        countryid(countryObj.id ?? 0);
        countryName(countryObj.friendlyType ?? '');

        countryMap = {
          "id": countryObj.id ?? 0,
          "type": countryObj.type ?? '',
          "friendlyType": countryObj.friendlyType ?? '',
        };
      }

      /// STATE
      final stateName = resp.stateName;
      if (stateName != null && stateName.isNotEmpty) {
        emirati(stateName);
        emritesMap = {
          "id": resp.stateInfo,
          "type": stateName,
          "friendlyType": stateName,
        };
      } else {
        final defaultState = emrites.firstOrNull;
        if (defaultState != null) {
          emirati(defaultState.friendlyType ?? '');
          emritesid(defaultState.id ?? 0);

          emritesMap = {
            "id": defaultState.id,
            "type": defaultState.friendlyType,
            "friendlyType": defaultState.friendlyType,
          };
        }
      }

      /// TEXT FIELDS
      fullNameController.text = resp.personName ?? '';
      PoBoxNumberController.text = resp.postBoxNum ?? '';
      BuildingNameController.text = resp.building ?? '';
      FlatNumberController.text = resp.houseNo ?? '';
      LandmarkController.text = resp.landMark ?? '';
      AreaController.text = resp.area ?? '';
      MobileNumberController.text = resp.contactNum?.toString() ?? '';

      /// ADDRESS TYPE
      gender(resp.typeOfAddress ?? 'Home');

      isHomeTapped(resp.typeOfAddress == null || resp.typeOfAddress == 'Home');
      isOfficeTapped(resp.typeOfAddress == 'Office');
      isOtherTapped(resp.typeOfAddress == 'Others');
    } catch (e) {
      logE(e);
    } finally {
      isLoading(false);
    }
  }

  /// ADD ADDRESS
  Future<void> onAddAddress() async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) return;

    final req = {
      "addDet": {
        "addressLine": BuildingNameController.text,
        "cityInfo": addressdata.value.cityInfo,
        "cityName": addressdata.value.cityName,
        "contactNum": MobileNumberController.text,
        "landMark": LandmarkController.text,
        "personName": fullNameController.text,
        "postalCode": PoBoxNumberController.text,
        "stateInfo": emritesMap['id'],
        "stateName": emritesMap['friendlyType'],
        "typeOfAddress": gender.value,
      },
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
    };

    final isAdded = await PersonalListService.addAddress(formData: req);
    if (isAdded) Get.back(result: true);
  }

  Future<void> onSubmit(String suburl) async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) return;

    try {
      isLoading(true);

      final formData = {
        "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
        "addiParams": ["ADDRESS"],
        "filterVal": "PROFILE",
        'orderId': LocalStore.buyNowFilterVal,
        "customerDet": {
          "addressDet": {
            "addressLine": LandmarkController.text,
            "cityInfo": addressdata.value.cityInfo,
            "cityName": addressdata.value.cityName,
            "contactNum": MobileNumberController.text,
            "landMark": LandmarkController.text,
            "personName": fullNameController.text,
            "stateInfo": emritesid().toString(),
            "typeOfAddress": gender.value,
            "postalCode": PoBoxNumberController.text,
            "stateName": emritesMap['friendlyType'],
            "country": countryMap,
          },
        },
      };

      final res = await PersonalListService.submitPersonal(
        suburl,
        formData: formData,
      );

      if (!res) return;

      if (isAddressList.value) {
        Get.back();
        return;
      }

      handleNavigationAfterSubmit();
    } finally {
      isLoading(false);
    }
  }

  void handleNavigationAfterSubmit() {
    switch (mode) {
      case 'Auto':
      case 'REAL_ESTATE':
      case 'Personal':
        Get.toNamed(
          Routes.CO_APPLICANT,
          arguments: LimitArguments(LimitMode: mode),
        );
        break;

      default:
        Get.back(result: true);
    }
  }
}
