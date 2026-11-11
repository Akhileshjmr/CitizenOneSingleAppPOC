import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/employee/employee_details.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/select_box_model/SelectOptionList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../data/remote/provider/personal_loan/professional_list_service.dart';
import '../../../routes/app_pages.dart';

class ProfessionalDetailsController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxString employmentType = ''.obs;
  final RxBool isSelfEmployed = false.obs;

  /// Selected objects
  Rx<Options?> selectedIndustry = Rx<Options?>(null);
  Rx<Options?> selectedEmployer = Rx<Options?>(null);

  late LimitArguments args;
  late PRArguments preArgs;

  final RxBool isLoading = true.obs;
  RxBool showOtherField = false.obs;

  Rx<EmployeeDetails?> empList = EmployeeDetails().obs;

  final RxList<SelectOptionList?> selectoptionList = <SelectOptionList?>[].obs;

  RxList<Options> industryTypeList = <Options>[].obs;
  RxList<Options> employerList = <Options>[].obs;

  TextEditingController dateController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController monthlyIncome = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController workExperience = TextEditingController();
  TextEditingController noOfYears = TextEditingController();
  TextEditingController annualIncome = TextEditingController();
  TextEditingController otherIncome = TextEditingController();
  TextEditingController houseAllowance = TextEditingController();
  TextEditingController spouseIncome = TextEditingController();
  TextEditingController monthlyCommitments = TextEditingController();
  TextEditingController employeeNo = TextEditingController();
  TextEditingController officetelephoneNo = TextEditingController();
  TextEditingController officeMailid = TextEditingController();
  TextEditingController extensiontext = TextEditingController();

  String mode = '';

  @override
  Future<void> onInit() async {
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      mode = args.LimitMode ?? '';
    } else if (Get.arguments is PRArguments) {
      preArgs = Get.arguments;
      mode = preArgs.LimtMode;
    }

    getProffesionData(ApiEndPoints.getProfileForms);
    super.onInit();
  }

  /// Dropdown API
  Future<void> getDroupDownList() async {
    isLoading(true);

    selectoptionList(await PersonalListService.getListView());

    industryTypeList(
      selectoptionList
              .firstWhereOrNull((e) => e?.key == 'INDUSTRY_TYPE')
              ?.options ??
          [],
    );

    employerList(
      selectoptionList.firstWhereOrNull((e) => e?.key == 'EMPLOYER')?.options ??
          [],
    );

    isLoading(false);
  }

  /// Prefill API
  Future<void> getProffesionData(String url) async {
    isLoading(true);

    EmployeeDetails? resp = await ProfessionalListService.getProfessionDetails(
      url,
    );

    empList(resp);

    await getDroupDownList();

    /// Set selected industry
    if (resp?.industry?.type != null) {
      selectedIndustry.value = industryTypeList.firstWhereOrNull(
        (e) => e.type == resp?.industry?.type,
      );
    }

    /// Set selected employer
    if (resp?.employerName?.type != null) {
      selectedEmployer.value = employerList.firstWhereOrNull(
        (e) => e.type == resp?.employerName?.type,
      );

      if (resp?.employerName?.type == 'Others') {
        showOtherField.value = true;
        otherController.text = resp?.employerName?.friendlyType ?? '';
      }
    }

    /// Other fields
    monthlyIncome.text = resp?.netMonthlyIncome?.toString() ?? '';
    dateController.text =
        resp?.dateOfJoining?.toString().replaceAll('-', '/') ?? '';
    designation.text = resp?.designation ?? '';
    workExperience.text = resp?.lenthOfService?.toString() ?? '';
    noOfYears.text = resp?.yearsInBusiness?.toString() ?? '';
    annualIncome.text = resp?.annualIncome?.toString() ?? '';

    otherIncome.text = resp?.othrIncome?.toString() ?? '';
    houseAllowance.text = resp?.houseAllowance?.toString() ?? '';
    spouseIncome.text = resp?.spouseIncome?.toString() ?? '';
    monthlyCommitments.text = resp?.monthlyCommitments?.toString() ?? '';
    employeeNo.text = resp?.empNum?.toString() ?? '';
    officetelephoneNo.text = resp?.officeTelNum?.toString() ?? '';
    officeMailid.text = resp?.officeMailId?.toString() ?? '';
    extensiontext.text = resp?.extension?.toString() ?? '';

    isSelfEmployed(resp?.empStatus?.type == 'SELF_EMPLOYED');
    employmentType(isSelfEmployed.value ? 'SELF_EMPLOYED' : 'SALARIED');

    isLoading(false);
  }

  /// Convert selected option to JSON
  Map<String, dynamic>? optionToJson(Options? option) {
    if (option == null) return null;
    return {
      'id': option.id,
      'type': option.type,
      'friendlyType': option.friendlyType,
    };
  }

  /// Submit
  Future<void> onSubmit(String suburl) async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) return;

    try {
      isLoading(true);

      final formData = _buildFormData();

      final bool res = await PersonalListService.submitPersonal(
        suburl,
        formData: formData,
      );

      if (!res) return;

      _handleNavigation();
    } catch (e) {
      debugPrint("Submit Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Map<String, dynamic> _buildFormData() {
    return {
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
      'addiParams': ['EMP_DATA'],
      'filterVal': 'PROFILE',
      'orderId': LocalStore.buyNowFilterVal,
      'customerDet': {
        'empDetails': {
          'dateOfJoining': CommonUtilities.parseOutputDateStr(
            dateController.text.replaceAll('/', '-'),
          ),
          'designation': designation.text,
          'industry': optionToJson(selectedIndustry.value),
          'employerName': optionToJson(selectedEmployer.value),
          'lenthOfService': workExperience.text,
          'netMonthlyIncome': monthlyIncome.text,
          'empStatus': _empStatus(),
          'houseAllowance': houseAllowance.text,
          'spouseIncome': spouseIncome.text,
          'monthlyCommitments': monthlyCommitments.text,
          'empNum': employeeNo.text,
          'officeTelNum': officetelephoneNo.text,
          'officeMailId': officeMailid.text,
          'extension': extensiontext.text,
          'othrIncome': otherIncome.text,
          'annualIncome': annualIncome.text,
          'yearsInBusiness': noOfYears.text,
        },
      },
    };
  }

  Map<String, dynamic> _empStatus() => {
    "id": null,
    "type": employmentType.value,
    "friendlyType": null,
  };

  void _handleNavigation() {
    switch (mode) {
      case 'LimitMode':
      case 'Auto':
      case 'CG':
      case 'REAL_ESTATE':
      case 'Credit':
      case 'Personal':
        Get.toNamed<void>(
          Routes.ADDRESS_DETAILS,
          arguments: LimitArguments(LimitMode: mode),
        );
        break;

      case 'CreditReview':
      case 'PersonalReview':
        Navigator.pop(Get.context!, true);
        break;

      case 'AutoLoan':
        Get.toNamed<void>(
          Routes.ADDRESS_DETAILS,
          arguments: PRArguments(
            filterval: preArgs.filterval ?? '',
            montlyInc: monthlyIncome.text,
            montlyExc: monthlyCommitments.text,
            bankid: preArgs.bankid ?? '',
            bankName: '',
            LimtMode: 'AutoLoan',
          ),
        );
        break;

      default:
        Get.back(result: true);
    }
  }

  final String? Function(String?) emailValidators =
      FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: 'Please enter the email'),
        FormBuilderValidators.email(errorText: 'Please enter a valid email ID'),
      ]);
}
