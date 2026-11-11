import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbGenLovValDesc.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovs.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbLovsMaster.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/stepper_header.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/lms_models/customer_registration_models/CustDocument.dart';
import '../../../../data/models/lms_models/customer_registration_models/CustDocumentResponse.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustGenDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAddiInfoForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlCommDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlEmpDetForm.dart';
import '../../../../data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import '../../../../data/models/lms_models/loan_product_models/GdbVendorProductDetails.dart';
import '../../../../utils/CommSuccessDialogues.dart';
import '../../../../utils/Loader.dart';
import 'CashFlowStatementForm.dart';
import 'CompanyDetailsForm.dart';
import 'FinancialStatementForm.dart';
import 'RatioAnalysisForm.dart';
import 'WorkForceDetails.dart';

class CorporateFormWebLayout extends StatefulWidget {
  final String? selectedSubOption;
  final String? selectedProductGroup;
  final String? selectedProductId;
  final String? selectedVendor;
  final String? selectedStore;
  final List<GdbVendorProductDetails>? selectedProductDetails;

  _CorporateFormWebLayoutState createState() => _CorporateFormWebLayoutState();

  const CorporateFormWebLayout({
    super.key,
    this.selectedSubOption,
    this.selectedProductGroup,
    this.selectedProductId,
    this.selectedVendor,
    this.selectedStore,
    this.selectedProductDetails,
  });
}

class _CorporateFormWebLayoutState extends State<CorporateFormWebLayout> {
  int _currentStep = 0;

  final List<String> _steps = [
    "CompanyDetails",
    "FinancialStatement",
    "RatioAnalysis",
    "CashFlowStatement",
    "WorkForceDetails",
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
    AppLogger.debug('Initializing corporate form layout');
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
    }
  }

  /// --- Step Content Switcher ---
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return CompanyDetailsForm(
            onNext: () => _handleStepNext(0), lovValues: dropdownItems);
      case 1:
        return FinancialStatementForm(
            onNext: () => _handleStepNext(1),
            onPrevious: () {
              setState(() {
                if (_currentStep > 0) _currentStep--;
              });
            },
            lovValues: dropdownItems);
      case 2:
        return RatioAnalysisForm(
            onNext: () => _handleStepNext(2),
            onPrevious: () {
              setState(() {
                if (_currentStep > 0) _currentStep--;
              });
            },
            lovValues: dropdownItems);
      case 3:
        return CashFlowStatementForm(
          onNext: () => _handleStepNext(3),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: dropdownItems,
        );

      case 4:
        return WorkForceDetailsForm(
          onNext: () => _handleStepNext(4),
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: {},
        );

      case 5:
      case 6:
      default:
        return StepPlaceholder(title: _steps[_currentStep]);
    }
  }
}
