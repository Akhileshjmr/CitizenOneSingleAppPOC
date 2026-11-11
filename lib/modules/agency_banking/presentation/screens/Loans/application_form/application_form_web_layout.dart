import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbGenLovValDesc.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovs.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovsMaster.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/employment_form.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/general_form.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/stepper_header.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constants/controllers.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../data/models/lms_models/casa_account_models/CasaAccountCreateRequest.dart';
import '../../../../data/models/lms_models/customer_registration_models/CustDocument.dart';
import '../../../../data/models/lms_models/customer_registration_models/CustDocumentResponse.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustGenDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAddiInfoForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlCommDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlEmpDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductList.dart';
import '../../../../data/models/lms_models/loan_product_models/GdbMerchantDisProductPurRequest.dart';
import '../../../../data/models/lms_models/loan_product_models/GdbVendorProductDetails.dart';
import '../../../../data/models/lms_models/term_deposit_models/TdAccNomineeRequest.dart';
import '../../../../data/models/lms_models/term_deposit_models/TdAccOpeningRequest.dart';
import '../../../../utils/AESEncryption.dart';
import '../../../../utils/CommDateTimeUtils.dart';
import '../../../../utils/CommSuccessDialogues.dart';
import '../../../../utils/Loader.dart';
import '../../../../utils/RandomNumberGenerator.dart';
import '../../../blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_bloc.dart';
import '../../../blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_event.dart';
import '../../../blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_state.dart';
import '../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import '../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_state.dart';
import '../../../blocs/lms_blocs/customer_search/customer_search_bloc.dart';
import '../../../blocs/lms_blocs/customer_search/customer_search_state.dart';
import '../../../blocs/lms_blocs/eligibility_score_bloc/eligibility_score_bloc.dart';
import '../../../blocs/lms_blocs/eligibility_score_bloc/eligibility_score_state.dart';
import '../../../blocs/lms_blocs/emi_calculation_bloc/emi_calculation_bloc.dart';
import '../../../blocs/lms_blocs/emi_calculation_bloc/emi_calculation_state.dart';
import '../../../blocs/lms_blocs/loan_apply_bloc/loan_apply_bloc.dart';
import '../../../blocs/lms_blocs/loan_apply_bloc/loan_apply_event.dart';
import '../../../blocs/lms_blocs/loan_apply_bloc/loan_apply_state.dart';
import '../../../blocs/lms_blocs/td_account_bloc/td_account_opening_bloc.dart';
import '../../../blocs/lms_blocs/td_account_bloc/td_account_opening_event.dart';
import '../../../blocs/lms_blocs/td_account_bloc/td_account_opening_state.dart';
import '../../Dashboard/widgets/BankSelectionScreen.dart';
import 'product_form/RetalLoanForm.dart';
import 'product_form/SavingsAccountForm.dart';
import 'product_form/TermDeposit.dart';
import 'widgets/additional_form.dart';
import 'widgets/communication_form.dart';
import 'widgets/document_details.dart';
import 'widgets/document_verification.dart';

class ApplicationFormWebLayout extends StatefulWidget {
  final String? selectedSubOption;
  final String? selectedProductGroup;
  final String? selectedProductId;
  final String? selectedVendor;
  final String? selectedStore;
  final List<GdbVendorProductDetails>? selectedProductDetails;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  _ApplicationFormWebLayoutState createState() =>
      _ApplicationFormWebLayoutState();

  const ApplicationFormWebLayout({
    super.key,
    this.selectedSubOption,
    this.selectedProductGroup,
    this.selectedProductId,
    this.selectedVendor,
    this.selectedStore,
    this.selectedProductDetails,
    required this.loginResponse,
    required this.selectedBank,
  });
}

class _ApplicationFormWebLayoutState extends State<ApplicationFormWebLayout> {
  int _currentStep = 0;
  bool isCommDataPreFetched = false;
  final List<String> _steps = [
    "General",
    "Communication",
    "Employment",
    "Additional",
    "Documents",
    "Account Details", // index 5 — to be changed dynamically
    "KYC Verification",
  ];
  List<CustDocument> uploadedDocuments = [];
  List<CustDocumentResponse> documentsGot = [];
  Uint8List? uploadedDocument;
  Uint8List? customerPhoto;
  Uint8List? customerSignature;
  String? photoExtension;
  String? signatureExtension;
  bool isLoanSelected = false;
  bool isSavingAccountSelected = false;
  bool isTermDepositSelected = false;
  //GdbCustRtlForm customerDet=GdbCustRtlForm();
  GdbCustRtlFormResponse customerDet = GdbCustRtlFormResponse();
  GdbCustGenDetForm genDetForm = GdbCustGenDetForm();
  GdbCustRtlCommDetForm commDetForm = GdbCustRtlCommDetForm();
  GdbCustRtlEmpDetForm custRtlEmpDetForm = GdbCustRtlEmpDetForm();
  GdbCustRtlAddiInfoForm custRtlAddiInfoForm = GdbCustRtlAddiInfoForm();
  CustDocumentResponse profilePic = CustDocumentResponse();
  CustDocumentResponse? signature;
  List<CustDocumentResponse>? docs = [];
  String? customerCode;
  bool _nominee = true;
  bool _isExistingNominee = true;
  bool _isCustomerSearchSuccess = false;
  bool isDocUploaded = false;
  late GetLovBloc lovBloc;
  // Map<String, List<DropdownMenuItem<String>>> dropdownItems = {};
  Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> dropdownItems = {};
  LoginUserReqResInfo loginUserReqResInfo = LoginUserReqResInfo();
  Map<String, List<AbGenLovValDesc>> lovValues = {};

  @override
  void initState() {
    super.initState();
    uploadedDocs.clear();
    gotDocs.clear();
    imageData = null;
    photoExtension = null;
    signatureExtension = null;
    _loadProductType();
    clearAllControllers();
    AppLogger.debug('Initializing application form layout');
    AppLogger.debug('Product selection loaded');
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo.message =
        loginUserReqResInfo.headerInfo.message = "SKIP_SESSION";
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs custLov = AbLovs(module: "AB_LOV_CUST", genLovs: null);
    request.abLovs = [custLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));

    if (nationalIdController.text.isEmpty) {
      nationalIdController.text = 'ZMW';
      nationalIdController.selection = TextSelection.collapsed(
        offset: nationalIdController.text.length,
      );
    }
  }

  void clearAllControllers() {
    _isCustomerSearchSuccess = false;
    otpController.clear();
    downPaymentAmountController.clear();
    amountController.clear();
    tenureMonthsController.clear();
    selectedGender = null;
    gender = null;
    selectedNationality = null;
    selectedAcademicDegree = null;
    selectedResidentialStatus = null;
    selectedNationalityResidency = null;
    selectedMaritalStatus = null;
    selectedProfession = null;
    selectedEducationLevel = null;
    selectedArea = null;
    selectedCity = null;

    // General Details
    mobileNoController.clear();
    fNameController.clear();
    middleNameController.clear();
    lController.clear();
    fullNameController.clear();
    dofbController.clear();
    emailController.clear();
    nationalIdController.clear();
    dateofExpiryController.clear();
    passportNoController.clear();
    dateofIssueController.clear();
    nationalityController.clear();

    // Communication Details
    addresscontroller.clear();
    emergencyContactPersonController.clear();
    emergencyPhoneController.clear();
    numberController.clear();
    buildingNoController.clear();
    floorNumberController.clear();
    districtController.clear();
    flatNumberController.clear();
    streetNumberController.clear();

    // Employment Details
    titleController.clear();
    currentEmployerController.clear();
    empStatusController.clear();
    workingAddressController.clear();
    workingEmail.clear();
    hireDate.clear();
    designation.clear();
    netMonthlyIncomeController.clear();
    netMonthlyExpenseController.clear();
    workingPhoneNo.clear();
    buildingNo.clear();
    streetNo.clear();
    districtName.clear();

    // Additional Details
    bankaccTypecontroller.clear();
    academicDegree.clear();

    //Savings Account
    openingBalance.clear();
    accountOpeningCharges.clear();
    emiController.clear();
    scoreController.clear();
  }

  void _loadProductType() async {
    if (widget.selectedSubOption == 'Retail Loan') {
      setState(() {
        isLoanSelected = true;
        _steps[5] = "Account Details"; // dynamic step change
      });
    } else if (widget.selectedSubOption == 'Saving Account') {
      setState(() {
        isSavingAccountSelected = true;
        _steps[5] = "Account Details"; // dynamic step change
      });
    } else if (widget.selectedSubOption == 'Term Deposit') {
      setState(() {
        isTermDepositSelected = true;
        _steps[5] = "Term Deposit Details"; // dynamic step change
      });
    }
  }

  void setFields(GdbCustRtlFormResponse customerDet) {
    // General Details
    fNameController.text = customerDet.genDet?.firstName ?? '';
    middleNameController.text = customerDet.genDet?.middleName ?? '';
    lController.text = customerDet.genDet?.lastName ?? '';
    fullNameController.text = customerDet.genDet?.fullName ?? '';
    dofbController.text = "24/10/1985";

    setState(() {
      final genderFromApi = customerDet.genDet?.gender?.trim().toLowerCase();
      if (genderFromApi == 'male') {
        selectedGender = 'Male';
      } else if (genderFromApi == 'female') {
        selectedGender = 'Female';
      } else if (genderFromApi == 'other') {
        selectedGender = 'Other';
      } else {
        selectedGender = '';
      }
    });

    emailController.text =
        customerDet.commDet?.primaryAddress?.emailAddress ?? '';
    nationalIdController.text = customerDet.genDet?.nationalIdNo ?? '';
    dateofExpiryController.text = customerDet.genDet?.nationalIdDoe ?? '';
    passportNoController.text = customerDet.genDet?.pNumber ?? '';
    dateofIssueController.text = customerDet.genDet?.passportDoe ?? '';
    nationalityController.text = customerDet.genDet?.passportType ?? '';

    // Communication Details
    addresscontroller.text =
        customerDet.commDet?.primaryAddress?.addressLine ?? '';
    emergencyContactPersonController.text =
        customerDet.commDet?.primaryAddress?.emerContactPerson ?? '';
    emergencyPhoneController.text =
        customerDet.commDet?.primaryAddress?.emerContactPhNum ?? '';
    numberController.text = customerDet.commDet?.primaryAddress?.phNum ?? '';
    buildingNoController.text =
        customerDet.commDet?.primaryAddress?.buildingNo ?? '';
    floorNumberController.text =
        customerDet.commDet?.primaryAddress?.floorNumber ?? '';
    districtController.text =
        customerDet.commDet?.primaryAddress?.distictName ?? '';
    flatNumberController.text =
        customerDet.commDet?.primaryAddress?.flatNumber ?? '';
    streetNumberController.text =
        customerDet.commDet?.primaryAddress?.streatNumber ?? '';

    // Employment Details
    titleController.text = customerDet.empDetails?.jobTitle ?? '';
    currentEmployerController.text =
        customerDet.empDetails?.employerName?.type ?? '';
    empStatusController.text = customerDet.empDetails?.empStatus?.type ?? '';
    workingAddressController.text =
        customerDet.empDetails?.workingAddress?.addressLine ?? '';
    workingEmail.text = customerDet.genDet?.nationality?.type ?? '';
    industry = customerDet.empDetails?.industry?.type;
    hireDate.text = customerDet.empDetails?.hiringDate ?? '';
    designation.text = customerDet.empDetails?.jobTitle ?? '';
    netMonthlyIncomeController.text =
        customerDet.empDetails?.netMonthlyIncome?.toString() ?? '';
    netMonthlyExpenseController.text =
        customerDet.empDetails?.netMonthlyExpense?.toString() ?? '';
    workingAddressController.text =
        customerDet.empDetails?.workingAddress?.addressLine ?? '';
    workingPhoneNo.text = customerDet.empDetails?.workingAddress?.phNum ?? '';
    workingEmail.text =
        customerDet.empDetails?.workingAddress?.emailAddress ?? '';
    buildingNo.text = customerDet.empDetails?.currEmpBuildNo ?? '';
    streetNo.text = customerDet.empDetails?.currEmpStrNo ?? '';
    districtName.text = customerDet.empDetails?.currEmpDistName ?? '';
    governateName = customerDet.empDetails?.currEmpGover;

    bankaccTypecontroller.text = customerDet.addiDet?.bankAccType?.type ?? '';
    yearsCurrent = customerDet.addiDet?.timeWithCurrEmployer?.type;

    academicDegree.text = customerDet.addiDet?.academicDeg?.type ?? '';

    // -------------------------
    // Safe assign as OBJECTS
    // -------------------------

    AbGenLovValDesc? safeAssignObj({
      String? apiValue,
      String? apiId,
      required List<AbGenLovValDesc> items,
    }) {
      if ((apiValue == null || apiValue.isEmpty) && apiId == null) return null;

      final normalizedApi = apiValue?.trim().toLowerCase();

      final match = items.firstWhere(
        (item) =>
            // ✅ Match by ID
            (apiId != null && item.val?.toString() == apiId) ||
            // ✅ Match apiValue with val
            (normalizedApi != null &&
                item.val?.trim().toLowerCase() == normalizedApi) ||
            // ✅ Match apiValue with desc
            (normalizedApi != null &&
                item.desc?.trim().toLowerCase() == normalizedApi),
        orElse: () => AbGenLovValDesc(val: null, desc: null),
      );

      return (match.val != null || match.desc != null) ? match : null;
    }

    // Prepare LOV values from dropdownItems
    final nationality = (dropdownItems["ch-lov-nationality"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final resStatusItems = (dropdownItems["ch-lov-residential-status"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final natResidencyItems = (dropdownItems["ch-lov-nationality-type"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final maritalItems = (dropdownItems["ch-lov-marital-status"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final profItems = (dropdownItems["ch-lov-profession"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final eduItems = (dropdownItems["ch-lov-level-of-education"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final area = (dropdownItems["ch-lov-area"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    final city = (dropdownItems["ch-lov-city"] ?? [])
        .map((e) => e.value as AbGenLovValDesc)
        .toList();

    // Assign values using safeAssignObj
    selectedNationality = safeAssignObj(
      apiValue: customerDet.genDet?.nationality?.type,
      apiId: customerDet.genDet?.nationality?.id?.toString(),
      items: nationality,
    );

    selectedResidentialStatus = safeAssignObj(
      apiValue: customerDet.addiDet?.residentialStatus?.type,
      apiId: customerDet.addiDet?.residentialStatus?.id?.toString(),
      items: resStatusItems,
    );

    selectedNationalityResidency = safeAssignObj(
      apiValue: customerDet.addiDet?.nationalityOrResidency?.type,
      apiId: customerDet.addiDet?.nationalityOrResidency?.id?.toString(),
      items: natResidencyItems,
    );

    selectedMaritalStatus = safeAssignObj(
      apiValue: customerDet.addiDet?.maritalStatus?.type,
      apiId: customerDet.addiDet?.maritalStatus?.id?.toString(),
      items: maritalItems,
    );

    selectedProfession = safeAssignObj(
      apiValue: customerDet.addiDet?.profession?.type,
      apiId: customerDet.addiDet?.profession?.id?.toString(),
      items: profItems,
    );

    selectedEducationLevel = safeAssignObj(
      apiValue: customerDet.addiDet?.levelOfEducation?.type,
      apiId: customerDet.addiDet?.levelOfEducation?.id?.toString(),
      items: eduItems,
    );

    selectedCity = safeAssignObj(
      apiValue: customerDet.commDet?.primaryAddress?.city?.type,
      apiId: customerDet.commDet?.primaryAddress?.city?.id?.toString(),
      items: city,
    );

    selectedArea = safeAssignObj(
      apiValue: customerDet.commDet?.primaryAddress?.area?.type,
      apiId: customerDet.commDet?.primaryAddress?.area?.id?.toString(),
      items: area,
    );

    // ✅ Photo decoding
    if (customerDet.profilePic?.file != null) {
      try {
        final String base64Str = customerDet.profilePic!.file!.split(',').last;
        final decoded = base64Decode(base64Str);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            customerPhoto = decoded;
          });
        });
      } catch (e) {
        AppLogger.error('Error decoding photo', e);
      }
    }

    // ✅ Signature decoding
    if (customerDet.signature?.file != null) {
      try {
        final String base64Str = customerDet.signature!.file!.split(',').last;
        final decoded = base64Decode(base64Str);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            customerSignature = decoded;
          });
        });
      } catch (e) {
        AppLogger.error('Error decoding signature', e);
      }
    }

    // ✅ Documents
    if (customerDet.docs != null && customerDet.docs!.isNotEmpty) {
      try {
        final List<CustDocumentResponse> decodedDocs =
            customerDet.docs!.map((docRes) {
          final base64Str = docRes.file ?? '';
          base64Decode(base64Str);
          return CustDocumentResponse(
            docName: docRes.docName ?? 'Unnamed',
            docRef: docRes.docRef ?? "",
            file: docRes.file ?? "",
          );
        }).toList();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            documentsGot = decodedDocs;
          });
        });
      } catch (e) {
        AppLogger.error('Error decoding documents', e);
      }
    }

    // Final refresh
    setState(() {});
  }

  void clearFields() {
    // General Details
    fNameController.clear();
    middleNameController.clear();
    lController.clear();
    fullNameController.clear();
    dofbController.clear();
    gender = null;
    emailController.clear();
    nationalIdController.clear();
    dateofExpiryController.clear();
    passportNoController.clear();
    dateofIssueController.clear();
    selectedNationality = null;
    nationalityController.clear();

    // Communication Details
    addresscontroller.clear();
    emergencyContactPersonController.clear();
    emergencyPhoneController.clear();
    numberController.clear();
    citycontroller.clear();
    areaController.clear();
    buildingNoController.clear();
    floorNumberController.clear();
    districtController.clear();
    flatNumberController.clear();
    streetNumberController.clear();

    // Employment Details
    employmentStatus = null;
    industry = null;
    hireDate.clear();
    designation.clear();
    netMonthlyIncomeController.clear();
    netMonthlyExpenseController.clear();
    workingAddressController.clear();
    workingPhoneNo.clear();
    workingEmail.clear();
    buildingNo.clear();
    streetNo.clear();
    districtName.clear();
    governateName = null;

    // Additional Details
    custType = null;
    yearsCurrent = null;
    residentialStatus = null;
    profession = null;
    education = null;
    maritalStatus = null;
    selectedEducation = null;
    selectedPlaceOfIssue = null;
    relationship = null;
    timeAtAddressController.clear();
  }

  void submitLoanApplication(BuildContext context) {
    if (amountController.text.isEmpty &&
        tenureMonthsController.text.isEmpty &&
        mobileNoController.text.isEmpty) {
      showCustomBottomPopup(
          context, "Please Enter Mobile Number , Amount and Tenure");
      return;
    }
    if (mobileNoController.text.isEmpty) {
      showCustomBottomPopup(context, "Please Enter Mobile Number");
      return;
    }
    if (amountController.text.isEmpty && tenureMonthsController.text.isEmpty) {
      showCustomBottomPopup(context, "Please Enter Amount and Tenure");
      return;
    }
    if (amountController.text.isEmpty) {
      showCustomBottomPopup(context, "Please Enter Amount");
      return;
    }
    if (tenureMonthsController.text.isEmpty) {
      showCustomBottomPopup(context, "Please Enter Tenure");
      return;
    }
    if (otpController.text.isEmpty) {
      showCustomBottomPopup(context, "OTP is required");
      return;
    }
    GdbMerchantDisProductPurRequest gdbMerchantDisProductPurRequest =
        GdbMerchantDisProductPurRequest();
    gdbMerchantDisProductPurRequest.mobileNumber =
        AESEncryptionService.encrypt(mobileNoController.text ?? '');

    // ✅ Product list item
    GdbMerchantDisProductList gdbMerchantDisProductList =
        GdbMerchantDisProductList();
    gdbMerchantDisProductList.orderId = AESEncryptionService.encrypt(
        RandomNumberGenerator.generateId('ORD', 5));
    gdbMerchantDisProductList.productId =
        AESEncryptionService.encrypt(widget.selectedProductId ?? '');
    gdbMerchantDisProductList.productPrice =
        double.tryParse(amountController.text);
    gdbMerchantDisProductList.discount = 0;
    gdbMerchantDisProductList.pricing = 0;
    gdbMerchantDisProductList.discountType = 0;
    gdbMerchantDisProductList.adminFees = 0;
    gdbMerchantDisProductList.tenure =
        int.tryParse(tenureMonthsController.text);
    gdbMerchantDisProductList.downPayment = 0;
    gdbMerchantDisProductPurRequest.productList = [gdbMerchantDisProductList];
    // ✅ Print debug
    AppLogger.debug('Loan application request prepared');
    // ✅ Dispatch
    context.read<LoanApplyBloc>().add(
          LoanApplySubmitted(gdbMerchantDisProductPurRequest),
        );
  }

  void submitTdApplication(BuildContext context) {
    TdAccOpeningRequest request = TdAccOpeningRequest();
    request.custType = "SME";
    request.customerCode = customerCode ?? '';
    request.productCode = "TDPRD02051810";
    request.accountNumber = "CASA02062021";
    request.bookedBy = "Cash";

    final valueDate =
        CommDateTimeUtils.parseDateFromText(valueDateController.text);
    request.valueDate =
        valueDate != null ? DateFormat('yyyy-MM-dd').format(valueDate) : null;
    request.initDepositAmt =
        double.tryParse(initialDepositAmountController.text);
    request.spreadVrble = double.tryParse(spreadController.text);
    request.nominee = _nominee;
    request.existNominee = _isExistingNominee;
    request.intrPaymentType = "Monthly";
    request.maturityInstrctns = "Redeem principal and interest";

    TdAccNomineeRequest nomineeRequest = TdAccNomineeRequest();
    nomineeRequest.applicantCode = "M00200000116";
    nomineeRequest.customerName = "AKKR";
    final nomineeDob =
        CommDateTimeUtils.parseDateFromText(nominnedobController.text);
    nomineeRequest.dob =
        nomineeDob != null ? DateFormat('yyyy-MM-dd').format(nomineeDob) : null;
    nomineeRequest.address = nomineeaddressController.text;
    nomineeRequest.relationship = "Wife";
    request.nomineeDetails = [nomineeRequest];

    context.read<TdAccountOpeningBloc>().add(
          TdAccountOpeningSubmitted(request),
        );
  }

  void savingAccountApplication(BuildContext context) {
    if (openingBalance.text.isEmpty) {
      showCustomBottomPopup(context, "Enter Opening Balance");
      return;
    }
    if (otpController.text.isEmpty) {
      showCustomBottomPopup(context, "OTP is required");
      return;
    }
    if (customerCode == null) {
      showCustomBottomPopup(context, "Please Create Customer");
      return;
    }
    CasaAccountCreateRequest request = CasaAccountCreateRequest();

    if (openingDate.text.trim().isNotEmpty) {
      request.openingDate = DateFormat('yyyy-MM-dd').parse(openingDate.text);
    } else {
      request.openingDate = null; // handle accordingly
    }
    request.openingBalance = double.tryParse(openingBalance.text) ?? 0.0;

    // All others are hardcoded
    request.accountType = "Single";
    request.customercode = AESEncryptionService.encrypt(customerCode ?? '');
    request.productCode = AESEncryptionService.encrypt("CASAPD2007183");
    request.modeOfOperation = "XYZ";
    request.isVendorAccount = isVendorAccount;
    request.vendorName = null;
    request.waiverOff = false;
    if (accountOpeningCharges.text.trim().isNotEmpty) {
      request.accountOpeningCharges =
          double.tryParse(accountOpeningCharges.text.trim());
    }
    request.chequeBook = hasChequeBook;
    request.passBook = hasPassbook;
    request.standingInstruction = false;
    request.overDraft = false;
    request.nominationFacility = true;
    request.atm = hasATM;
    request.teleBanking = false;
    request.internetBanking = true;
    request.mobileBanking = true;
    request.smsBanking = true;
    request.sms = hasSMSAlert;
    request.email = hasEmailAlert;
    request.both = false;

    // Now you can pass this `request` to your API layer or bloc
    AppLogger.debug('Savings account request prepared');

    context
        .read<CasaAccountOpeningBloc>()
        .add(CasaAccountOpeningSubmitted(request));
  }

  void customerRegistration(BuildContext context) {
    final req = GdbCustRtlAppRequest<GdbCustRtlFormResponse>();
    req.screenId = 'CLIENT_DATA';
    req.isDraft = false;
    GdbCustRtlFormResponse form = GdbCustRtlFormResponse();
    form.phone = AESEncryptionService.encrypt(mobileNoController.text);
    form.kycStatus = "SUCCESS";
    form.genDet = genDetForm;
    form.commDet = commDetForm;
    form.empDetails = custRtlEmpDetForm;
    form.addiDet = custRtlAddiInfoForm;
    form.docs = docs;
    form.signature = signature;
    form.profilePic = profilePic;
    req.customerDet = form;
    context.read<CustomerRegistrationBloc>().add(
          CustomerRegistrationSubmitted<GdbCustRtlFormResponse>(req),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerRegistrationBloc, CustomerRegistrationState>(
          listener: (context, state) {
            if (state is CustomerRegistrationLoading) {
              context.read<LoadingCubit>().show();
            }
            if (state is CustomerRegistrationSuccess) {
              context.read<LoadingCubit>().hide();
              final res = state.gdbMerchantDisProductPurResponse;
              if (res.customerDet?.genDet != null) {
                genDetForm = res.customerDet?.genDet ?? GdbCustGenDetForm();
              }
              if (res.customerDet?.commDet != null) {
                commDetForm =
                    res.customerDet?.commDet ?? GdbCustRtlCommDetForm();
              }
              if (res.customerDet?.empDetails != null) {
                custRtlEmpDetForm =
                    res.customerDet?.empDetails ?? GdbCustRtlEmpDetForm();
              }
              if (res.customerDet?.addiDet != null) {
                custRtlAddiInfoForm =
                    res.customerDet?.addiDet ?? GdbCustRtlAddiInfoForm();
              }
              if (res.customerDet?.docs != null) {
                docs = res.customerDet?.docs;
              }
              if (res.customerDet?.profilePic != null) {
                profilePic =
                    res.customerDet?.profilePic ?? CustDocumentResponse();
              }
              if (res.customerDet?.signature != null) {
                signature =
                    res.customerDet?.signature ?? CustDocumentResponse();
              }
              if (_currentStep == 4) {
                // first time (upload success) → mark as uploaded but DON'T increment
                if (res.customerDet?.genDet == null &&
                    res.customerDet?.docs != null) {
                  setState(() {
                    isDocUploaded = true;
                  });
                  return;
                }
                if (_currentStep == 4 &&
                    res.customerDet?.docs != null &&
                    res.customerDet?.genDet != null) {
                  customerCode =
                      state.gdbMerchantDisProductPurResponse.custCode;
                  customerRegistrationSuccessDialog(
                      context,
                      state.gdbMerchantDisProductPurResponse,
                      customerCode,
                      "",
                      widget.loginResponse,
                      widget.selectedBank);
                  _currentStep++;
                }
              }
              setState(() {
                setState(() {
                  if (_currentStep < _steps.length - 1 && _currentStep != 5) {
                    _currentStep++;
                  }
                });
              });
            }
            if (state is CustomerRegistrationFailure) {
              context.read<LoadingCubit>().hide();
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<CustomerSearchBloc, CustomerSearchState>(
          listener: (context, state) {
            if (state is CustomerSearchLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is CustomerSearchSuccess) {
              final responseData = state.gdbMerchantDisProductPurRequest;
              customerCode =
                  AESEncryptionService.decrypt(responseData.custCode ?? '');
              AppLogger.debug('Customer search returned general details');
              if (responseData.customerDet != null) {
                setState(() {
                  _isCustomerSearchSuccess = true;
                  isCommDataPreFetched = true;
                  customerDet = responseData.customerDet!;
                });
                showCustomBottomPopup(
                  context,
                  "This mobile number is already registered",
                );
                clearFields();
                customerDet = responseData.customerDet!;
                setFields(customerDet);
              }
            }
            /*if (state is CustomerSearchSuccess) {
              final responseData = state.gdbMerchantDisProductPurRequest;
              if (responseData.customerDet != null) {
                setState(() {
                  //_isCustomerSearchSuccess = true;
                  isCommDataPreFetched=true;
                  customerDet = responseData.customerDet!;
                });
                if(responseData.customerDet?.genDet == null || responseData.customerDet?.commDet == null ||
                    responseData.customerDet?.empDetails==null || responseData.customerDet?.addiDet== null){
                  _isCustomerSearchSuccess = true;
                  showCustomBottomPopup(context, "Application form is not Completed, Please fill the form");
                }
                showCustomBottomPopup(
                  context,
                  "Customer is already registered, Please go to Product Details"
                      "\nproceed with Loan application",
                );
                clearFields();
                customerDet = responseData.customerDet!;
                setFields(customerDet);
              }
            }*/
            else if (state is CustomerSearchFailure) {
              setState(() {
                _isCustomerSearchSuccess =
                    false; // enables NEXT, disables SAVE in step 0
                isCommDataPreFetched = false;
              });
              clearFields();
              AppLogger.error('Customer search failed', state.error);
              showCustomBottomPopup(
                  context, "Customer is not registered, Please fill the form");
            }
          },
        ),
        BlocListener<TdAccountOpeningBloc, TdAccountOpeningState>(
          listener: (context, state) {
            if (state is TdAccountOpeningLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is TdAccountOpeningSuccess) {
              final res = state.tdAccOpeningResponse;
              AppLogger.debug('TD account opening successful');
              tdApplySuccessDialog(context, res);
            } else if (state is TdAccountOpeningFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<CasaAccountOpeningBloc, CasaAccountOpeningState>(
          listener: (context, state) {
            if (state is CasaAccountOpeningLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is CasaAccountOpeningSuccess) {
              final res = state.casaAccountCreateResponse;
              AppLogger.debug('CASA account opening successful');
              casaApplySuccessDialog(
                  context,
                  res,
                  widget.loginResponse ?? LoginUserReqResInfo(),
                  widget.selectedBank);
            } else if (state is CasaAccountOpeningFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<EmiCalculationBloc, EmiCalculationState>(
          listener: (context, state) {
            if (state is EmiCalculationLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is EmiCalculationSuccess) {
              final response = state.emiCalculateResponse;
              final firstEmiValue = (response.loanEmiList != null &&
                      response.loanEmiList!.isNotEmpty)
                  ? response.loanEmiList!.first
                  : null;
              if (firstEmiValue != null) {
                emiController.text = firstEmiValue.toString();
              } else {
                emiController.text = '';
              }
            } else if (state is EmiCalculationFailure) {
              // showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<EligibilityScoreBloc, EligibilityScoreState>(
          listener: (context, state) {
            if (state is EligibilityScoreLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is EligibilityScoreSuccess) {
              final scoreVal = state.scoreReqRes.customerScore;
              scoreController.text =
                  (scoreVal != null) ? scoreVal.toString() : '22';
            } else if (state is EligibilityScoreFailure) {
              // showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<LoanApplyBloc, LoanApplyState>(
          listener: (context, state) {
            if (state is LoanApplyLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is LoanApplySuccess) {
              final res = state.gdbMerchantDisProductPurResponse;
              loanApplySuccessDialog(
                  context, res, widget.loginResponse, widget.selectedBank);
            } else if (state is LoanApplyFailure) {
              AppLogger.error('Loan application failed', state.error);
              showCustomBottomPopup(context, state.error);
              //showCustomBottomPopup(context, "Loan apply failure");
            }
          },
        ),
        BlocListener<GetLovBloc, GetLovState>(
            bloc: lovBloc,
            listener: (context, state) {
              if (state is GetLovSuccess) {
                for (var abLov in state.user.abLovs) {
                  for (var genLov in abLov.genLovs ?? []) {
                    String lovId = genLov.lovId;

                    if (genLov.valDes != null) {
                      lovValues[lovId] = genLov.valDes!;

                      dropdownItems[lovId] = genLov.valDes!
                          .map<DropdownMenuItem<AbGenLovValDesc>>((valDes) {
                        final String? rawVal = valDes.val?.toString();
                        final String? desc = valDes.desc;

                        // Decide what to show
                        String displayText;
                        if (rawVal != null && int.tryParse(rawVal) != null) {
                          // val is numeric → show desc (fallback to val if desc null)
                          displayText = desc ?? rawVal;
                        } else {
                          // val is string → show val
                          displayText = rawVal ?? '';
                        }
                        return DropdownMenuItem<AbGenLovValDesc>(
                          value: valDes,
                          child: Text(
                            displayText,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList();
                    }
                  }
                }
                setState(() {});
              } else if (state is GetLovFailure) {
                showCustomBottomPopup(context, state.error);
              }
            }),
      ],
      child: Stack(
        children: [
          _buildScaffoldContent(context), // moved scaffold to separate method
          const GlobalLoader(), // overlay always available
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      appBar: CustomAppBar(
        title: "Application Form",
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// --- Stepper Header ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StepperHeader(
                currentStep: _currentStep,
                steps: _steps,
                onStepSelected: (index) {
                  setState(() => _currentStep = index);
                },
/*                  onStepSelected: (index) {
                    // If customer search was not successful → block all clicking
                    if (!_isCustomerSearchSuccess) {
                      return;
                    }
                    // Allow only backward step navigation
                    if (index < _currentStep) {
                      setState(() => _currentStep = index);
                    }
                  }*/
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// --- Step Content ---
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  elevation: 2,
                  color: AppColors.applicationCardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStepNext(int stepIndex) {
    // If customer search success, just skip submit logic and increment step
    if (_isCustomerSearchSuccess && stepIndex < 5) {
      setState(() {
        if (_currentStep < _steps.length - 1) {
          _currentStep++;
        }
      });
      return;
    }

    // 🔽 Regular existing flow
    switch (stepIndex) {
      case 0:
        GeneralDetailsForm.submitGenDetails(context);
        break;
      case 1:
        CommunicationForm.submitCommunicationDetails(context);
        break;
      case 2:
        EmploymentForm.submitEmploymentDetails(context);
        break;
      case 3:
        AdditionalForm.submitAdditionalDetails(context);
        break;
      case 4:
        if (isDocUploaded) {
          customerRegistration(context);
        } else {
          showCustomBottomPopup(
              context, "Please Upload Documents, photo and signature ..!");
        }
        break;
      case 5:
        if (isLoanSelected) {
          submitLoanApplication(context);
        } else if (isTermDepositSelected) {
          submitTdApplication(context);
        } else if (isSavingAccountSelected) {
          savingAccountApplication(context);
        }
        break;
    }
  }

  /// --- Step Content Switcher ---
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return GeneralDetailsForm(
          onNext: () => _handleStepNext(0),
          lovValues: dropdownItems,
          isCommDataPreFetched: isCommDataPreFetched,
        );
      case 1:
        return CommunicationForm(
          onNext: () => _handleStepNext(1),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: dropdownItems,
          isCommDataPreFetched: isCommDataPreFetched,
          custRtlFormResponse: customerDet,
        );
      case 2:
        return EmploymentForm(
          onNext: () => _handleStepNext(2),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: dropdownItems,
          isCommDataPreFetched: isCommDataPreFetched,
          custRtlFormResponse: customerDet,
        );
      case 3:
        return AdditionalForm(
          onNext: () => _handleStepNext(3),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: dropdownItems,
          isCommDataPreFetched: isCommDataPreFetched,
          custRtlFormResponse: customerDet,
        );

      case 4:
        return KycDocumentDetails(
          onNext: () => _handleStepNext(4),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          onDocumentsReady: (docs) {
            setState(() {
              uploadedDocuments = docs;
            });
          },
          onPhotoSignatureReady: (photo, signature, ext, signExtension) {
            setState(() {
              customerPhoto = photo;
              customerSignature = signature;
              photoExtension = ext;
              signatureExtension = signExtension;
            });
          },
          initialPhoto: customerPhoto, // ✅ pass photo to widget
          initialSignature: customerSignature, // ✅ pass signature to widget
          initialDocuments: documentsGot,
        );

      case 5:
        if (isSavingAccountSelected) {
          return SavingsAccountForm(
            onNext: () => setState(() => _currentStep++),
            onPrevious: () => setState(() => _currentStep--),
          );
        } else if (isTermDepositSelected) {
          return TermDepositForm(
            onNext: () => setState(() => _currentStep++),
            onPrevious: () => setState(() => _currentStep--),
          );
        } else {
          return LoanForm(
              onNext: () {
                setState(() => _currentStep++);
              },
              onPrevious: () {
                setState(() {
                  if (_currentStep > 0) _currentStep--;
                });
              },
              productId: widget.selectedProductId);
        }

      case 6:
        return DocumentDetails(
          onSubmit: () {
            if (widget.selectedSubOption == 'Retail Loan') {
              submitLoanApplication(context);
            } else if (widget.selectedSubOption == 'Term Deposit') {
              submitTdApplication(context);
            } else if (widget.selectedSubOption == 'Saving Account') {
              savingAccountApplication(context);
            }
          },
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          loginResponse: widget.loginResponse,
        );

      default:
        return StepPlaceholder(title: _steps[_currentStep]);
    }
  }
}
