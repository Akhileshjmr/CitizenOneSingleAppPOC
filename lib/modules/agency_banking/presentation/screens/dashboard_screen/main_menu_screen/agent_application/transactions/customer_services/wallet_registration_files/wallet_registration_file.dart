import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/signature_image_upload.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_upload_bloc/kyc_upload_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_state.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../../data/models/CommCustDoc.dart';
import '../../../../../../../../data/models/WalletKycCustomerReq.dart';
import '../../../../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../../../../data/models/lov_models/AbLovs.dart';
import '../../../../../../../../data/models/lov_models/AbLovsMaster.dart';
import '../../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../../utils/Loader.dart';
import '../../../../../../../../utils/UICleanupHelper.dart';
import '../../../../../../../../widgets/web_custom_tool_bar.dart';
import '../../../../../../../blocs/get_lov_bloc/get_lov_bloc.dart';
import '../../../../../../../blocs/get_lov_bloc/get_lov_event.dart';
import '../../../../../../../blocs/get_lov_bloc/get_lov_state.dart';
import '../../../../../../../blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import '../../../../../../../blocs/wallet_registration_bloc/wallet_registration_event.dart';
import '../../../../../../BaseScreen/base_screen.dart';
import '../../../../../../Loans/application_form/widgets/step_placeholder.dart';
import '../../../../../../Loans/application_form/widgets/stepper_header.dart';
import 'Occupation_details.dart';
import 'address_details.dart';
import 'basic_details.dart';
import 'document_upload.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_controllers.dart';
import 'package:flutter/material.dart';

class WalletKYCReg extends StatefulWidget {
  final LoginUserReqResInfo? loginResponse;
  final dynamic itemKey;
  final BankOption selectedBank;
  const WalletKYCReg({super.key,  this.loginResponse, this.itemKey, required this.selectedBank,});
  @override
  _WalletKYCState createState() => _WalletKYCState();

}

class _WalletKYCState extends State<WalletKYCReg>
{
  int _currentStep = 0;
  Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> dropdownItems = {};
  Map<String, List<AbGenLovValDesc>> lovValues = {};
  late GetLovBloc lovBloc;
  String? customerId;
  final List<String> _steps = [
    "Basic Details",
    "Communication",
    "Employment",
    "Documents",
    "Image & Signature Upload",
  ];
  bool isWalletRegistrationSuccess = false;

  @override
  void initState()
  {
    super.initState();
    clearAllControllers();
    var permission = widget.loginResponse?.loginUserInfo.permission;
    permission?.remove('MAIN_MENU');
    // Initialize GetLovBloc once
    lovBloc = GetLovBloc(AuthService());
    AbLovsMaster request = AbLovsMaster();
    request.headerInfo = widget.loginResponse!.headerInfo;
    // Step 2: Create AbLovs instances for each module and add them to the request
    AbLovs smLov = AbLovs(module: "AB_LOV_WALLET", genLovs: null);
    request.abLovs = [smLov];
    // Step 3: Dispatch the GetLovSubmitted event with the combined request
    lovBloc.add(GetLovSubmitted(request));
  }

  void clearAllControllers() {
    // ✅ Basic name details
    fNameController.clear();
    mNameController.clear();
    lNameController.clear();
    dobController.clear();

    // ✅ Dropdowns
    selectedGender = null;
    selectedNationality = null;
    selectedCountryCode = null;
    selectedCountry = null;
    selectedCustType = null;
    selectedAccType = null;
    selectedIdType = null;

    // ✅ Contact numbers
    mobileNumberController.clear();
    residentialNumberController.clear();
    officeNumberController.clear();

    // ✅ Address details
    houseNoController.clear();
    subCityController.clear();
    cityController.clear();
    zipController.clear();

    // ✅ Employment / Financial
    designationController.clear();
    employerController.clear();
    monthlyIncomeController.clear();
    annualIncomeController.clear();

    // ✅ Identity details
    idNumberController.clear();
    issuedByController.clear();

    // ✅ Misc
    remarksController.clear();
  }



  void walletCreation(BuildContext context) {
    WalletKycCustomerReq request = WalletKycCustomerReq();
    request.headerInfo = widget.loginResponse?.headerInfo;

    //  Basic Details
    request.fname = fNameController.text;
    request.mname = mNameController.text;
    request.lname = lNameController.text;
    request.dob = dobController.text;
    request.gender = selectedGender?.val;
    request.nlty = selectedNationality?.val;

    // Residential Address
    request.custAddress1 = houseNoController.text;
    request.custAddress2 = subCityController.text;
    request.custAddress3 = cityController.text;
    request.city = cityController.text;
    // request.zip = zipController.text;
    request.country = selectedCountry?.val;

    //  Contact Details
    request.officeNo = officeNumberController.text.isNotEmpty
        ? int.parse(officeNumberController.text)
        : 0;
    request.mobNo = mobileNumberController.text.isNotEmpty
        ? int.parse(mobileNumberController.text)
        : 0;

    request.resNo = residentialNumberController.text.isNotEmpty
        ? int.parse(residentialNumberController.text)
        : 0;

    request.zip = zipController.text.isNotEmpty
        ? int.parse(zipController.text)
        : 0;

    // request. = selectedCountryCode;

    //  Occupation
    request. custDesig= designationController.text;
    request.custEmployer = employerController.text;
    request.custAvgMonthlyIncome = monthlyIncomeController.text.isNotEmpty
        ? int.parse(monthlyIncomeController.text)
        : 0;

    request.custAvgAnnualIncome = annualIncomeController.text.isNotEmpty
        ? int.parse(annualIncomeController.text)
        : 0;

    request.custType = selectedCustType?.val;
    request.acType = selectedAccType?.val;

    // ID Details
    request.idType = selectedIdType?.val;
    request.idNo = idNumberController.text;
    request.idIssueby = issuedByController.text;

    // KYC Document Upload
    CommCustDoc custDoc = CommCustDoc();
    custDoc.docUniqueNum = res.docUniqueNum;
    custDoc.documentName = res.documentType;
    custDoc.documentType =res.documentType;
    custDoc.remarks = remarksController.text;
    custDoc.imgPath = res.imgPath;
    request.custDoc = [custDoc];

    //  Flags
    request.walletAccEnable = "Y";
    request.cbsAccEnable = "N";
    request.beforeorAfterlogin = "N";
    request.currency = "Currency";
    request.customerId = "Customer Id";

    // 🔹 Trigger Bloc Event
    context.read<WalletRegistrationBloc>().add(
      WalletRegistrationSubmitted(request),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetLovBloc, GetLovState>
          (
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
                          displayText = rawVal ?? rawVal;
                        } else {
                          // val is string → show val
                          displayText = desc ?? '';
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
              }
              else if (state is GetLovFailure)
              {
                showCustomBottomPopup(context, state.error);
              }
            }
        ),
        BlocListener<WalletRegistrationBloc, WalletRegistrationState>(
          listener: (context, state) {
            if (state is WalletRegistrationLoading) {
              context.read<LoadingCubit>().show();
            }

            if (state is WalletRegistrationSuccess) {
              context.read<LoadingCubit>().hide();
              isWalletRegistrationSuccess = true;
              customerId= state.walletRequest.walletAccountNo;
              showWalletRegistrationSuccess(context, customerId);
            } else if (state is WalletRegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<KycUploadBloc, KycUploadState>(
          listener: (context, state) {
            if (state is KycUploadSuccess) {
              showDocumentUploadSuccess(context,state.user.documentName);
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Document Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.user.documentName ?? "N/A",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Remarks:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    state.user.remarks ?? "N/A",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  if (state.user.image != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Uploaded Document:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Image.memory(
                          base64.decode(state.user.image!),
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                  else
                    Text(
                      "No image uploaded.",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                ],
              );

            } else if (state is KycUploadFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
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
      appBar:  const CustomAppBar(title: "Agent Registration"),
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
  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return BasicDetails(
            onNext: () => setState(() => _currentStep++),
            lovValues: dropdownItems
        );
      case 1:
        return AddressDetails(
            onNext: () => setState(() => _currentStep++),
            onPrevious: () {
              setState(() {
                if (_currentStep > 0) _currentStep--;
              });
            },
            lovValues: dropdownItems
        );
      case 2:
        return OccupationDetails
          (
            onNext: () => setState(() => _currentStep++),
            onPrevious: () {
              setState(() {
                if (_currentStep > 0) _currentStep--;
              });
            },
            lovValues: dropdownItems
        );
        case 3:
        return KycDocument(
          onNext: () {
            if (!isWalletRegistrationSuccess) {
              walletCreation(context);
            } else {
              setState(() => _currentStep++);
            }
          },
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          lovValues: dropdownItems,
          loginResponse: widget.loginResponse,
        );
      case 4:
        return ImageUploadPage(
          onPrevious: () {
            setState(() {
              if (_currentStep > 0) _currentStep--;
            });
          },
          loginResponse: widget.loginResponse ?? LoginUserReqResInfo(),
          customerId: customerId,
          selectedBank: widget.selectedBank,

        );

        default:
        return StepPlaceholder(title: _steps[_currentStep]);
    }
  }
}