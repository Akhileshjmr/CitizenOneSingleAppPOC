import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/config/logger.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/loan/co_applicant/CoApplForm.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/select_box_model/SelectOptionList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../routes/app_pages.dart';

class CoApplicantController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// If the form is submitting or not
  final RxBool isLoading = false.obs;

  Rx<CoApplForm> coApplicantdata = CoApplForm().obs;

  /// Course List
  final RxList<SelectOptionList?> selectoptionList = <SelectOptionList?>[].obs;

  // late RxList<Options?> optionList = <Options?>[].obs;
  RxList<Options> optionList = <Options>[].obs;
  RxList<Options> genderOptions = <Options>[].obs;
  RxList<Options> educationOptions = <Options>[].obs;
  RxList<Options> nationalityOptions = <Options>[].obs;
  RxList<Options> noofDependentArr = <Options>[].obs;
  RxList<Options> birthPlaceOptions = <Options>[].obs;
  RxList<Options> EducationArr = <Options>[].obs;

  RxString matchFileURL = '20%'.obs;
  TextEditingController NameController = TextEditingController();
  TextEditingController CompanyNameController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emiratiNoController = TextEditingController();
  TextEditingController emiratiNoNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController annivesaryController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController facePercentageController = TextEditingController();
  TextEditingController liveFacePercentageController = TextEditingController();
  TextEditingController dateInUAEDateController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController passportNoController = TextEditingController();
  TextEditingController passporrtExpiryDateController = TextEditingController();
  TextEditingController educationQualificationController =
      TextEditingController();
  TextEditingController noOfDependentController = TextEditingController();

  final RxString dobstr = ''.obs;

  final RxString expireDTstr = ''.obs;

  final RxString gender = ''.obs;

  final RxString Relation = ''.obs;

  final RxString education = ''.obs;

  final RxString nationality = ''.obs;

  final RxString birthPlace = ''.obs;

  final RxString EducationQualification = ''.obs;

  final RxInt nationalityid = 0.obs;

  final RxInt birthPlaceid = 0.obs;

  final RxBool isSwitchSelected = false.obs;

  Map genderMap = {};

  Map relationMap = {};

  Map educationMap = {};

  Map birthPlaceMap = {};

  Map eduQUalificationMap = {};

  var noofDependentMap = {};

  late LimitArguments args;

  late PRArguments preArgs;

  String mode = '';

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode != null) {
        mode = args.LimitMode;
      } else {
        mode = '';
      }
    }
    if (Get.arguments is PRArguments) {
      preArgs = Get.arguments;
      mode = preArgs.LimtMode;
    }
    getDroupDownList();
    // getCoApplicantData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> getDroupDownList() async {
    isLoading(true);
    try {
      selectoptionList(await PersonalListService.getListView());
      optionList(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'RELATIONSHIP',
            )
            ?.options,
      );
      genderOptions(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'GENDER_TYPE',
            )
            ?.options,
      );
      educationOptions(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'LEVEL_OF_EDUCATION',
            )
            ?.options,
      );
      nationalityOptions(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'NATIONALITY',
            )
            ?.options,
      );
      noofDependentArr(
        selectoptionList
            .firstWhereOrNull((option) => option?.key == 'NO_OF_DEPENDANTS')
            ?.options,
      );
      birthPlaceOptions(
        selectoptionList
            .firstWhereOrNull((option) => option?.key == 'NATIONALITY')
            ?.options,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCoApplicantData() async {
    // isLoading(true);
    CoApplForm? resp = await PersonalListService.getCoApplicant(
      ApiEndPoints.getProfileForms,
    );
    coApplicantdata(resp);

    await getDroupDownList();

    if (resp?.name != null) {
      NameController.text = resp?.name.toString() ?? '';
    }

    if (resp?.jobTitle != null) {
      jobTitleController.text = resp?.jobTitle.toString() ?? '';
    }
    if (resp?.companyName != null) {
      CompanyNameController.text = resp?.companyName.toString() ?? '';
    }
    if (resp?.mobileNum != null) {
      mobileNoController.text = resp?.mobileNum.toString() ?? '';
    }

    if (resp?.nationalId != null) {
      emiratiNoController.text = resp?.nationalId.toString() ?? '';
    }

    // if (resp?.nationalId != null) {
    //   emiratiNoNameController.text = resp?.nationalId.toString() ?? '';
    // }

    final dob = resp?.dateOfbirth?.toString();

    if (dob != null && dob.isNotEmpty) {
      dobController.text = dob.replaceAll('-', '/');
    }

    expiryDateController.text =
        resp?.nationalIdExpDate?.toString().replaceAll('-', '/') ?? '';

    if (resp?.passportNum != null) {
      passportNoController.text = resp?.passportNum ?? '';
    } else {
      passportNoController.text = '';
    }

    passporrtExpiryDateController.text =
        resp?.passportExpDate?.replaceAll('-', '/') ?? '';

    dobstr(resp?.dateOfbirth ?? '');

    expireDTstr(resp?.nationalIdExpDate ?? '');

    if (resp?.gender?.type != null) {
      gender(resp?.gender?.type ?? '');
      genderMap = {
        'id':
            genderOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.gender?.type,
                )
                ?.id,
        'type':
            genderOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.gender?.type,
                )
                ?.type,
        'friendlyType':
            genderOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.gender?.type,
                )
                ?.friendlyType,
      };
      print(resp?.gender?.friendlyType ?? '');
    } else if (genderOptions.isNotEmpty) {
      gender('');
    }

    if (resp?.education?.type?.isNotEmpty ?? false) {
      education(resp?.education?.type ?? '');
      educationMap = {
        'id':
            educationOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.education?.type,
                )
                ?.id,
        'type':
            educationOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.education?.type,
                )
                ?.type,
        'friendlyType':
            educationOptions()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.education?.type,
                )
                ?.friendlyType,
      };
    } else if (educationOptions.isNotEmpty) {
      education('');
    }

    if (resp?.relationship?.type?.isNotEmpty ?? false) {
      Relation(resp?.relationship?.type ?? '');
      relationMap = {
        'id':
            optionList()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.relationship?.type,
                )
                ?.id,
        'type':
            optionList()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.relationship?.type,
                )
                ?.type,
        'friendlyType':
            optionList()
                .firstWhereOrNull(
                  (Options industryType) =>
                      industryType.type == resp?.relationship?.type,
                )
                ?.friendlyType,
      };
    } else if (optionList.isNotEmpty) {
      Relation('');
    }
  }

  Future<void> onSubmit(String suburl) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading(true);
      Map<String, dynamic> formData = <String, dynamic>{};
      try {
        formData = <String, dynamic>{
          'reqSecureKey': UserProvider.currentUser?.addiParams[0] ?? '',
          'filterVal': 'PROFILE',
          "addiParams": ["CO_APPLICANT"],
          'orderId': LocalStore.buyNowFilterVal ?? '',
          "customerDet": {
            "coApplDetails": {
              "name": NameController.text,
              "gender": genderMap,
              "relationship": relationMap,
              "dateOfbirth": CommonUtilities.parseOutputDateStr(
                dobController.text.replaceAll('/', '-') ?? '',
              ),
              "passportNum": passportNoController.text,
              "passportExpDate": CommonUtilities.parseOutputDateStr(
                passporrtExpiryDateController.text.replaceAll('/', '-') ?? '',
              ),
              "nationalId": emiratiNoController.text,
              "nationalIdExpDate": CommonUtilities.parseOutputDateStr(
                expiryDateController.text.replaceAll('/', '-') ?? '',
              ),
              "education": educationMap,
              "mobNum": mobileNoController.text,
              "companyName": CompanyNameController.text,
              "jobTitle": jobTitleController.text,
              "monthlyIncome": 56000,
            },
          },
        };
        logD(formData.toString());
        final bool res = await PersonalListService.submitPersonal(
          suburl,
          formData: formData,
        );
        if (res) {
          if (mode == 'AutoLoan') {
            onSaveFinace(mode, 'pl/pre-approved-loan/save-profile-retail');
          } else if (mode == 'Auto') {
            /*Get.toNamed<void>(
                Routes.CO_REFERAL,
                arguments: LimitArguments(LimitMode: 'Auto')
            );*/
          } else if (mode == 'CG') {
            /*Get.toNamed<void>(
                Routes.CO_REFERAL,
                arguments: LimitArguments(LimitMode: 'CG')
            );*/
          } else if (mode == 'REAL_ESTATE') {
            /*Get.toNamed<void>(
                Routes.CO_REFERAL,
                arguments: LimitArguments(LimitMode: 'REAL_ESTATE')
            );*/
          } else if (mode == 'Personal') {
            Get.toNamed<void>(
              Routes.CO_REFERAL,
              arguments: LimitArguments(LimitMode: 'Personal'),
            );
          } else if (mode == 'Credit') {
            await Get.toNamed(Routes.CREDIT_DOCUMENTS_VIEW);
          }
        }
      } on Exception catch (e) {
        logE(e);
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> onSubmitCoReferal(String suburl) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading(true);
      Map<String, dynamic> formData = <String, dynamic>{};
      try {
        formData = <String, dynamic>{
          'reqSecureKey': UserProvider.currentUser?.addiParams[0] ?? '',
          'filterVal': 'PROFILE',
          "addiParams": ["CO_APPLICANT"],
          'orderId': LocalStore.buyNowFilterVal ?? '',
          "customerDet": {"coApplDetails": null},
        };
        logD(formData.toString());
        final bool res = await PersonalListService.submitPersonal(
          suburl,
          formData: formData,
        );
        if (res) {
          if (mode == 'AutoLoan') {
            onSaveFinace(mode, 'pl/pre-approved-loan/save-profile-retail');
          } else if (mode == 'Auto') {
            Get.toNamed<void>(
              Routes.CO_REFERAL,
              arguments: LimitArguments(LimitMode: 'Auto'),
            );
          } else if (mode == 'CG') {
            Get.toNamed<void>(
              Routes.CO_REFERAL,
              arguments: LimitArguments(LimitMode: 'CG'),
            );
          } else if (mode == 'REAL_ESTATE') {
            Get.toNamed<void>(
              Routes.CO_REFERAL,
              arguments: LimitArguments(LimitMode: 'REAL_ESTATE'),
            );
          } else if (mode == 'Personal') {
            Get.toNamed<void>(
              Routes.CO_REFERAL,
              arguments: LimitArguments(LimitMode: 'Personal'),
            );
          } else if (mode == 'Credit') {
            await Get.toNamed(Routes.CREDIT_DOCUMENTS_VIEW);
          }
        }
      } on Exception catch (e) {
        logE(e);
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> onSaveFinace(String mode, String geturl) async {
    isLoading(true);
    try {
      final bool res = await AutoService.submitFinaceFrom(geturl);

      if (res == true) {
        /*if (mode == 'Auto') {
          Get.toNamed<void>(
            Routes.AUTO_BANK_LIST,
            arguments: LimitArguments(LimitMode: 'Auto'),
          );
        } else if (mode == 'CG') {
          Get.toNamed<void>(
            Routes.AUTO_BANK_LIST,
            arguments: LimitArguments(LimitMode: 'CG'),
          );
        } else */
        if (mode == 'REAL_ESTATE') {
          // onPaymentType();
        } else if (mode == 'Personal') {
          await Get.toNamed(Routes.PL_DOCUMENTS);
        } else if (mode == 'Credit') {
          await Get.toNamed(Routes.CREDIT_DOCUMENTS_VIEW);
        } else if (mode == 'AutoLoan') {
          Get.toNamed<void>(
            Routes.P_R_CHECK_ELIGIBLE,
            arguments: PRArguments(
              filterval: preArgs.filterval ?? '',
              montlyInc: preArgs.montlyInc ?? '',
              montlyExc: preArgs.montlyExc ?? '',
              bankid: preArgs.bankid ?? '',
              bankName: '',
              LimtMode: 'AutoLoan',
            ),
          );
        }
      } else {
        appSnackbar(message: 'Faild', snackbarState: SnackbarState.warning);
      }
    } finally {
      isLoading(false);
    }
  }
}
