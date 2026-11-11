import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/config/logger.dart';
import '../../../data/enums/doc_type.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/loan/accura_scan/egy_nat_id.dart';
import '../../../data/model/loan/forms/personal_form/GenDet.dart';
import '../../../data/model/loan/pre_approved/PreApprovedResp.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/select_box_model/SelectOptionList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/static_value_constant.dart';

class PersonalInfoController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// Current marital status of the logged in user
  final RxString Marital_Status = ''.obs;

  /// Current gender of the logged in user
  final RxString dobstr = ''.obs;

  final RxString expireDTstr = ''.obs;

  final RxString gender = ''.obs;

  final RxString title = ''.obs;

  final RxString education = ''.obs;

  final RxString nationality = ''.obs;

  final RxString birthPlace = ''.obs;

  final RxString EducationQualification = ''.obs;

  final RxInt nationalityid = 0.obs;

  final RxInt birthPlaceid = 0.obs;

  /// If the form is submitting or not
  final RxBool isLoading = false.obs;

  late LimitArguments args;
  late PRArguments preArgs;

  /// Course List
  final RxList<SelectOptionList?> selectoptionList = <SelectOptionList?>[].obs;

  // final RxList<PersonalDet?> personaldata = <PersonalDet?>[].obs;
  Rx<PersonalDet> personaldata = PersonalDet().obs;

  ///Pre Approved Loan Detail
  RxString preApprovedRefNumber = "".obs;
  RxString preApprovedRefAmount = "".obs;
  RxList<Options> preApprovedBankList = <Options>[].obs;

  final RxString preApprovedBankName = ''.obs;
  String initialBankName = '';
  final RxString slectedPreApprovedBankId = ''.obs;
  Rx<TextEditingController> preApprovedBankRefNumber =
      TextEditingController().obs;
  Rx<TextEditingController> preApprovedBankAmount = TextEditingController().obs;

  // late RxList<Options?> optionList = <Options?>[].obs;
  RxList<Options> optionList = <Options>[].obs;
  RxList<Options> genderOptions = <Options>[].obs;
  RxList<Options> educationOptions = <Options>[].obs;
  RxList<Options> nationalityOptions = <Options>[].obs;
  RxList<Options> noofDependentArr = <Options>[].obs;
  RxList<Options> birthPlaceOptions = <Options>[].obs;
  RxList<Options> EducationArr = <Options>[].obs;

  RxString matchFileURL = '20%'.obs;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
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

  final RxString noofDependent = ''.obs;

  late String dropDownValue;

  final RxInt count = 0.obs;

  Map nationalityMap = {};

  Map titleMap = {};

  Map educationMap = {};

  Map birthPlaceMap = {};

  Map eduQUalificationMap = {};

  var noofDependentMap = {};

  RxString mode = ''.obs;

  String birthday = '';
  String anniversary = '';

  @override
  Future<void> onInit() async {
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode != null) {
        mode.value = args.LimitMode;
      } else {
        mode.value = '';
      }
    } else if (Get.arguments is PRArguments) {
      preArgs = Get.arguments;
      mode.value = preArgs.LimtMode;
    } else {
      mode.value = '';
    }
    if (mode.value == 'Auto') {
      getPeronalData('auto/orders/get-profile-forms');
    } else if (mode.value == 'CG') {
      getPeronalData('orders/cg/get-profile-forms');
    } else if (mode.value == 'REAL_ESTATE') {
      fetchPreApprovedLoan();
      getPeronalData('realestate/home/orders/get-profile-forms');
    } else if (mode.value == 'Credit' || mode.value == 'CreditReview') {
      getPeronalData('creditcard/get-cc-form-fields');
    } else if (mode.value == 'Personal' || mode.value == 'PersonalReview') {
      getPeronalData(ApiEndPoints.getProfileForms);
    } else if (mode.value == 'AutoLoan') {
      getPeronalData('pl/pre-approved-loan/get-profile-forms');
    } else {
      getPeronalData(ApiEndPoints.getProfileForms);
    }

    super.onInit();
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

  Future<void> updateDataFromScanning(
    Map<String, dynamic> scannedResult,
    DocTypeWithCountry? docType,
    RxString? faceMatchScore,
    RxString? livenessScore, {
    OcrData? egyNatIdOcr,
  }) async {
    if ((scannedResult.containsKey('front_data') &&
            scannedResult['front_data'] != null) ||
        (scannedResult.containsKey('mrz_data') &&
            scannedResult['mrz_data'] != null) ||
        (docType == DocTypeWithCountry.EG_NI && egyNatIdOcr != null)) {
      switch (docType) {
        case DocTypeWithCountry.UAE_ENI:
          String? dob = DateFormat('dd-MM-yyyy').format(
            DateFormat('dd-MM-yy').parse(
              scannedResult['mrz_data']['Date of Birth'].toString().replaceAll(
                "/",
                "-",
              ),
            ),
          );

          String? expiryDate = DateFormat('dd-MM-yyyy').format(
            DateFormat('dd-MM-yy').parse(
              scannedResult['mrz_data']['Date of Expiry'].toString().replaceAll(
                "/",
                "-",
              ),
            ),
          );
          formKey.currentState?.patchValue({
            'emiratesId': scannedResult['front_data']['ID No'],
            'fullName': scannedResult['front_data']['First Name'],
            'dob': dob,
            'expiryDate': expiryDate,
            'firstName': scannedResult['mrz_data']['First Name'],
            'lastName': scannedResult['mrz_data']['Last Name'],
            'Nationality': scannedResult['mrz_data']['Nationality'],
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'UAE',
          });

          scannedResult['mrz_data']['Sex'] == 'MALE'
              ? gender('MALE')
              : gender('FEMALE');

          nationality('UAE');
          nationalityid(1);
          nationalityMap = {"id": 1, "type": 'UAE', "friendlyType": 'UAE'};
          break;

        case DocTypeWithCountry.UAE_DL:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'dob': scannedResult['front_data']['Date of Birth']
                .toString()
                .replaceAll("/", "-"),
            'expiryDate': scannedResult['front_data']['Date of Expiry']
                .toString()
                .replaceAll("/", "-"),
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'UAE',
          });
          break;
        case DocTypeWithCountry.UAE_VNP:
          // TODO: Handle this case.
          break;

        case DocTypeWithCountry.EG_NI:
          formKey.currentState?.patchValue({
            'firstName': egyNatIdOcr?.firstName,
            'fullName': egyNatIdOcr?.firstName,
            'lastName': egyNatIdOcr?.lastName,
            'address': egyNatIdOcr?.address,
            'emiratesId': egyNatIdOcr?.idNo,
            'dob': egyNatIdOcr?.date,
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'Egypt',
          });
          nationality('Egypt');
          nationalityid(3);
          nationalityMap = {"id": 3, "type": 'Egypt', "friendlyType": 'Egypt'};
          break;

        case DocTypeWithCountry.EG_DL:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'emiratesId': scannedResult['front_data']['Driving License Number'],
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'Egypt',
          });
          break;

        case DocTypeWithCountry.EG_VNP:
          // TODO: Handle this case.
          break;

        case DocTypeWithCountry.IND_PASS:
          formKey.currentState?.patchValue({
            'firstName': scannedResult['mrz_data']['First Name'],
            'lastName': scannedResult['mrz_data']['Last Name'],
            'fullName': scannedResult['front_data']['name'],
            'emiratesId': scannedResult['front_data']['passport no'],
            'dob': scannedResult['mrz_data']['Date of Birth']
                .toString()
                .replaceAll("/", "-"),
            'expiryDate': scannedResult['mrz_data']['Date of Expiry']
                .toString()
                .replaceAll("/", "-"),
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'INDIA',
          });
          nationality('INDIA');
          nationalityid(2);
          nationalityMap = {"id": 2, "type": 'INDIA', "friendlyType": 'INDIA'};
          scannedResult['mrz_data']['Sex'] == 'M'
              ? gender('MALE')
              : gender('FEMALE');
          break;

        case DocTypeWithCountry.IND_VID:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'emiratesId': scannedResult['front_data']['ID No'],
            'dob': scannedResult['front_data']['Birth Date']
                .toString()
                .replaceAll("/", "-"),
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'INDIA',
          });
          nationality('INDIA');
          nationalityid(2);
          nationalityMap = {"id": 2, "type": 'INDIA', "friendlyType": 'INDIA'};
          scannedResult['front_data']['Gender'] == 'MALE'
              ? gender('MALE')
              : gender('FEMALE');
          break;

        case DocTypeWithCountry.IND_DL:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'emiratesId': scannedResult['front_data']['DL No'],
            'dob': scannedResult['front_data']['Birth Date']
                .toString()
                .replaceAll("/", "-"),
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'INDIA',
          });
          nationality('INDIA');
          nationalityid(2);
          nationalityMap = {"id": 2, "type": 'INDIA', "friendlyType": 'INDIA'};
          break;

        case DocTypeWithCountry.IND_VNP:
          // TODO: Handle this case.
          break;

        case DocTypeWithCountry.IND_AC:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'dob': scannedResult['front_data']['Birth Date']
                .toString()
                .replaceAll("/", "-"),
            'emiratesId': scannedResult['front_data']['Aadhar Number'],
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'INDIA',
          });
          nationality('INDIA');
          nationalityid(2);
          nationalityMap = {"id": 2, "type": 'INDIA', "friendlyType": 'INDIA'};
          scannedResult['front_data']['Gender'] == 'MALE'
              ? gender('MALE')
              : gender('FEMALE');
          break;

        case DocTypeWithCountry.IND_PC:
          formKey.currentState?.patchValue({
            'fullName': scannedResult['front_data']['Name'],
            'firstName': scannedResult['front_data']['Name'],
            'dob': scannedResult['front_data']['Date of Birth']
                .toString()
                .replaceAll("/", "-"),
            'emiratesId': scannedResult['front_data']['ID no'],
            'facePercentage':
                double.tryParse(faceMatchScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'livePercentage':
                double.tryParse(livenessScore!())?.toStringAsFixed(2) ??
                '' + '%',
            'Nationality': 'INDIA',
          });
          nationality('INDIA');
          nationalityid(2);
          nationalityMap = {"id": 2, "type": 'INDIA', "friendlyType": 'INDIA'};
          break;

        case DocTypeWithCountry.NONE:
          break;
        case null:
        // TODO: Handle this case.
      }
    }
  }

  /// Get user sessions
  Future<void> getDroupDownList() async {
    isLoading(true);
    try {
      selectoptionList(await PersonalListService.getListView());
      optionList(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'TITLE',
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

  /// Get user sessions
  Future<void> getPeronalData(String geturl) async {
    try {
      isLoading(true);
      PersonalDet? resp = await PersonalListService.getPersonalDetails(geturl);
      String mobile = await UserProvider.getMobileNumber();
      personaldata(resp);

      await getDroupDownList();

      if (resp?.firstName != null) {
        firstNameController.text = resp?.firstName.toString() ?? '';
      }

      if (resp?.middleName != null) {
        middleNameController.text = resp?.middleName.toString() ?? '';
      }

      if (resp?.lastName != null) {
        lastNameController.text = resp?.lastName.toString() ?? '';
      }
      if (resp?.email != null) {
        emailIdController.text = resp?.email.toString() ?? '';
      }

      mobileNoController.text = mobile;

      /*if (resp?.pNumber != null) {
      mobileNoController.text = "895156154";
    }*/

      if (resp?.emiratesId != null) {
        emiratiNoController.text = resp!.emiratesId.toString() ?? '';
      }

      if (resp?.fullName != null) {
        emiratiNoNameController.text = resp?.fullName.toString() ?? '';
      }

      if (resp?.dob != null) {
        dobController.text = resp?.dob.toString() ?? '';
      }

      if (resp?.expiryDate != null) {
        expiryDateController.text = resp!.expiryDate.toString().replaceAll(
          '-',
          '/',
        );
      }

      if (resp?.facematchPercentage != null) {
        facePercentageController.text =
            resp?.facematchPercentage?.toStringAsFixed(2) ?? '';
      }

      if (resp?.livelinessPercentage != null) {
        liveFacePercentageController.text =
            resp?.livelinessPercentage?.toStringAsFixed(2) ?? '';
      }

      if (resp?.birthday?.friendlyType != null) {
        birthdayController.text = convertDateFormat(
          resp?.birthday?.friendlyType ?? '',
        );
        birthday = resp?.birthday?.friendlyType ?? '';
      } else {
        birthdayController.text = '';
        birthday = '';
      }

      if (resp?.anniversary?.friendlyType != null) {
        annivesaryController.text = convertDateFormat(
          resp?.anniversary?.friendlyType ?? '',
        );
        anniversary = resp?.anniversary?.friendlyType ?? '';
      } else {
        annivesaryController.text = '';
        anniversary = '';
      }

      if (resp?.passportNum != null) {
        passportNoController.text = resp?.passportNum ?? '';
      } else {
        passportNoController.text = '';
      }

      final passportDate = resp?.passportExpDate;

      passporrtExpiryDateController.text =
          passportDate != null && passportDate.isNotEmpty
              ? passportDate.replaceAll('-', '/')
              : '';

      if (resp?.noOfDependents != null) {
        noOfDependentController.text = resp?.noOfDependents ?? '';
        noofDependent(resp?.noOfDependents ?? '');
      } else {
        noOfDependentController.text = '';
        noofDependent('');
      }

      final date = resp?.dateSinceInUAE?.toString();

      if (date != null && date.isNotEmpty) {
        dateInUAEDateController.text = date.replaceAll('-', '/');
      } else {
        dateInUAEDateController.text = '';
      }

      if ((resp?.maritalStatus?.type ?? '') == 'SINGLE') {
        Marital_Status('UNMARRIED');
      } else {
        Marital_Status(resp?.maritalStatus?.type ?? '');
      }

      dobstr(resp?.dob ?? '');
      expireDTstr(resp?.expiryDate ?? '');
      if (resp?.gender?.isNotEmpty ?? false) {
        gender(resp?.gender ?? '');
      } else if (genderOptions.isNotEmpty) {
        gender('');
      }
      if (resp?.levelOfEducation?.type?.isNotEmpty ?? false) {
        education(resp?.levelOfEducation?.type ?? '');
        educationMap = {
          'id':
              educationOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.levelOfEducation?.type,
                  )
                  ?.id,
          'type':
              educationOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.levelOfEducation?.type,
                  )
                  ?.type,
          'friendlyType':
              educationOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.levelOfEducation?.type,
                  )
                  ?.friendlyType,
        };
      } else if (educationOptions.isNotEmpty) {
        education('');
      }

      if (resp?.title?.isNotEmpty ?? false) {
        title(resp?.title ?? '');
      } else if (optionList.isNotEmpty) {
        title('');
      }

      if (resp?.nationality?.type?.isNotEmpty ?? false) {
        nationality(resp?.nationality?.type ?? '');
        nationalityid(resp?.nationality?.id ?? 0);
        nationalityMap = {
          'id':
              nationalityOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.nationality?.type,
                  )
                  ?.id,
          'type':
              nationalityOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.nationality?.type,
                  )
                  ?.type,
          'friendlyType':
              nationalityOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.nationality?.type,
                  )
                  ?.friendlyType,
        };
      } else if (nationalityOptions.isNotEmpty) {
        nationality('');
      }

      if (resp?.countryOfBirth?.type?.isNotEmpty ?? false) {
        birthPlace(resp?.countryOfBirth?.type ?? '');
        birthPlaceid(resp?.countryOfBirth?.id ?? 0);
        birthPlaceMap = {
          'id':
              birthPlaceOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.countryOfBirth?.type,
                  )
                  ?.id,
          'type':
              birthPlaceOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.countryOfBirth?.type,
                  )
                  ?.type,
          'friendlyType':
              birthPlaceOptions()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.countryOfBirth?.type,
                  )
                  ?.friendlyType,
        };
      } else if (birthPlaceOptions.isNotEmpty) {
        birthPlace('');
      }
    } finally {
      isLoading(false);
    }
  }

  String convertDateFormat(String inputDate) {
    try {
      // Parse the input date string
      DateTime parsedDate = DateFormat('dd-MM').parse(inputDate);
      // Format the parsed date to the desired format
      String formattedDate = DateFormat('dd-MMM').format(parsedDate);
      return formattedDate;
    } catch (e) {
      return inputDate;
    }
  }

  /// User ID field validators
  final String? Function(String?) userValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter the Title'),
      ]);
  final String? Function(String?) firstNameValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(
          errorText: 'Please enter the first name',
        ),
      ]);

  final String? Function(String?) lastNameValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter the last name'),
      ]);

  final String? Function(String?) emailValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter the email'),
        FormBuilderValidators.email(errorText: 'Please enter a valid email id'),
      ]);
  final String? Function(String?) mobileValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Please enter the mobile'),
      ]);

  /// On login button tap
  Future<void> onSubmit(String suburl) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      if (Marital_Status.value == '') {
        appSnackbar(
          message: 'Please select marital status',
          snackbarState: SnackbarState.danger,
        );
      } else {
        isLoading(true);
        Map<String, dynamic> formData = <String, dynamic>{};
        try {
          String Spdt = birthday;
          if (Spdt.isEmpty && birthdayController.text.isNotEmpty) {
            // Fallback if birthday string wasn't set but controller has text
            try {
              Spdt = DateFormat(
                'dd-MM-yyyy',
              ).format(DateFormat('dd-MMM').parse(birthdayController.text));
            } catch (e) {
              Spdt = birthdayController.text;
            }
          }

          String anvdt = anniversary;
          if (anvdt.isEmpty && annivesaryController.text.isNotEmpty) {
            try {
              anvdt = DateFormat(
                'dd-MM-yyyy',
              ).format(DateFormat('dd-MMM').parse(annivesaryController.text));
            } catch (e) {
              anvdt = annivesaryController.text;
            }
          }

          LocalStore.emailId(emailIdController.text);
          formData = <String, dynamic>{
            'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
            'addiParams': ['PERSONAL_DETAILS'],
            'filterVal': 'PROFILE',
            'orderId': LocalStore.buyNowFilterVal,
            'customerDet': {
              'genDet': {
                'title': title.value,
                'firstName': firstNameController.text,
                'middleName': middleNameController.text,
                'lastName': lastNameController.text,
                'livelinessPercentage':
                    liveFacePercentageController.text.isEmpty
                        ? '0.0'
                        : liveFacePercentageController.text,
                'facematchPercentage':
                    facePercentageController.text.isEmpty
                        ? '0.0'
                        : facePercentageController.text,
                'maritalStatus': {
                  'id': '',
                  'type': Marital_Status.value,
                  'friendlyType': '',
                },
                'dob': CommonUtilities.parseOutputDateStr(
                  dobController.text.replaceAll('/', '-'),
                ),
                'gender': gender.value,
                'levelOfEducation': educationMap,
                'emiratesId': emiratiNoController.text,
                'preApprovedRefNum': preApprovedBankRefNumber.value.text,
                'preApprovedBankId': slectedPreApprovedBankId.value,
                'email': emailIdController.text,
                'fullName': emiratiNoNameController.text,
                'expiryDate': CommonUtilities.parseOutputDateStr(
                  expiryDateController.text.replaceAll('/', '-'),
                ),
                'nationality': nationalityMap,
                'birthday': {
                  'id': '',
                  'type': 'BIRTHDAY',
                  'friendlyType': Spdt,
                },
                'anniversary': {
                  'id': '',
                  'type': 'ANNIVERSARY',
                  'friendlyType': anvdt,
                },
                "noOfDependents": noofDependent.value,
                "countryOfBirth": birthPlaceMap,
                "dateSinceInUAE": dateInUAEDateController.text.replaceAll(
                  '/',
                  '-',
                ),
                "passportNum": passportNoController.text,
                "passportExpDate": passporrtExpiryDateController.text
                    .replaceAll('/', '-'),
              },
            },
          };
          logD(formData.toString());
          final bool res = await PersonalListService.submitPersonal(
            suburl,
            formData: formData,
          );
          if (res) {
            if (mode.value == 'LimitMode') {
              await Get.offNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'LimitMode'),
              );
            } else if (mode.value == 'Auto') {
              await Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'Auto'),
              );
            } else if (mode.value == 'CG') {
              await Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'CG'),
              );
            } else if (mode.value == 'REAL_ESTATE') {
              await Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'REAL_ESTATE'),
              );
            } else if (mode.value == 'Credit') {
              await Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'Credit'),
              );
            } else if (mode.value == 'Personal') {
              await Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: LimitArguments(LimitMode: 'Personal'),
              );
            } else if (mode.value == 'CreditReview' ||
                mode.value == 'PersonalReview') {
              Navigator.pop(Get.context!, true);
            } else if (mode.value == 'AutoLoan') {
              Get.toNamed<void>(
                Routes.PROFESSIONAL_DETAILS,
                arguments: PRArguments(
                  filterval: preArgs.filterval ?? '',
                  montlyInc: '',
                  montlyExc: '',
                  bankid: preArgs.bankid ?? '',
                  bankName: '',
                  LimtMode: 'AutoLoan',
                ),
              );
            } else {
              Get.back(result: true);
            }
          }
        } on Exception catch (e) {
          logE(e);
        } finally {
          isLoading(false);
        }
      }
    }
  }

  Future<void> fetchPreApprovedLoan() async {
    if ((mode.value == 'REAL_ESTATE') &&
        StaticValueConstant.isApplyPreApprovedLoan) {
      initialBankName = StaticValueConstant.preApprovedBankName;
      try {
        isLoading(true);
        PreApprovedResp? resp =
            await AutoService.fetchRealEstatePreApprovedLoans();
        if ((resp?.loanList?.length ?? 0) > 0) {
          preApprovedRefAmount(resp?.loanList?[0]?.suggestedLimit);
          preApprovedRefNumber(resp?.loanList?[0]?.refNum);
          preApprovedBankName(resp?.loanList?[0]?.bankName);
          slectedPreApprovedBankId(resp?.loanList?[0]?.bankProductId);

          preApprovedBankRefNumber.value.text =
              resp?.loanList?[0]?.refNum ?? "";
          preApprovedBankAmount.value.text =
              resp?.loanList?[0]?.suggestedLimit ?? "";
          preApprovedBankName.refresh();

          List<Options> opt = [];
          for (var i = 0; i < (resp?.loanList?.length ?? 0); i += 1) {
            opt.add(
              Options(
                id: int.parse(resp?.loanList?[i]?.bankProductId ?? "0"),
                type: resp?.loanList?[i]?.bankName,
                friendlyType: resp?.loanList?[i]?.bankName,
              ),
            );
          }
          preApprovedBankList(opt);
        }
        isLoading(false);
      } finally {
        isLoading(false);
      }
    }
  }
}

/// To hide the keyboard
void hideKeyboard() {
  Get.focusScope?.unfocus();
}
