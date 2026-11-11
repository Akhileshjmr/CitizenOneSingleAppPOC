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

import 'package:citizenone_app/modules/agency_banking/constants/controllers.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/custom_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/CustDocument.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/CustDocumentResponse.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustGenDetForm.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlAddiInfoForm.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlCommDetForm.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlEmpDetForm.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/loan_product_models/GdbVendorProductDetails.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import '../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import '../../blocs/lms_blocs/customer_registration_bloc/customer_registration_state.dart';
import '../../blocs/lms_blocs/customer_search/customer_search_bloc.dart';
import '../../blocs/lms_blocs/customer_search/customer_search_state.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import 'application_form/widgets/additional_form.dart';
import 'application_form/widgets/communication_form.dart';
import 'application_form/widgets/document_details.dart';

class EKYCRegistration extends StatefulWidget {
  final String? selectedSubOption;
  final String? selectedProductGroup;
  final String? selectedProductId;
  final String? selectedVendor;
  final String? selectedStore;
  final List<GdbVendorProductDetails>? selectedProductDetails;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  _EKYCRegistrationState createState() => _EKYCRegistrationState();

  const EKYCRegistration({
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

class _EKYCRegistrationState extends State<EKYCRegistration> {
  int _currentStep = 0;
  bool isCommDataPreFetched = false;
  final List<String> _steps = [
    "General",
    "Communication",
    "Employment",
    "Additional",
    "Documents",
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
    clearAllControllers();
    AppLogger.debug('Initializing EKYC registration');
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
  }

  void clearAllControllers() {
    _isCustomerSearchSuccess = false;
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

  void customerRegistration(BuildContext context) {
    final req = GdbCustRtlAppRequest<GdbCustRtlFormResponse>();
    req.screenId = 'CLIENT_DATA';
    req.isDraft = false;
    GdbCustRtlFormResponse form = GdbCustRtlFormResponse();
    form.phone = mobileNoController.text;
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
                      "KYC",
                      widget.loginResponse,
                      widget.selectedBank);
                  //_currentStep++;
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
            } else if (state is CustomerSearchFailure) {
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
        title: "KYC Registration",
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
          eKyc: "KYC",
        );
      default:
        return StepPlaceholder(title: _steps[_currentStep]);
    }
  }
}
