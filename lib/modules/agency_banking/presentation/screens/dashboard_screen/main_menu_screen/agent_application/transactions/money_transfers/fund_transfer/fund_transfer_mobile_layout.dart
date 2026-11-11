import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_text.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../../constants/AppStrings.dart';
import '../../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../../data/models/BannerContent.dart';
import '../../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../../data/services/AuthService.dart';
import '../../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../../utils/CommDialog.dart';
import '../../../../../../../../utils/Loader.dart';
import '../../../../../../../../utils/ResponsiveLeftBanner.dart';
import '../../../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../../../blocs/account_search_bloc/account_search_state.dart';
import '../../../../../../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../../../../../../blocs/charge_calculation_bloc/charge_calculation_state.dart';
import '../../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../../../../../../../ab/transactions/authorization/view/authentication_screen.dart';

class FundTransferMobileLayout extends StatefulWidget {
  final dynamic itemKey; // Add itemKey field
  final LoginUserReqResInfo loginResponse;
  final String transactionType;
  final BankOption selectedBank;
  FundTransferMobileLayout(
      {required this.loginResponse,
      required this.itemKey,
      required this.transactionType,
      required this.selectedBank});

  @override
  _FundTransferMobileLayout createState() => _FundTransferMobileLayout();
}

class _FundTransferMobileLayout extends State<FundTransferMobileLayout> {
  late AccountSearchBloc senderSearchBloc;
  late AccountSearchBloc receiverSearchBloc;
  late CommAccountRequest senderResponse;
  late CommAccountRequest receiverResponse;
  TextEditingController customerNameController = TextEditingController();
  TextEditingController enteredAmount = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountBranchController = TextEditingController();
  TextEditingController accountCurrencyController = TextEditingController();
  String customerName = '';
  String accountNumber = '';
  bool showSenderNumberError = false;
  bool showReceiverNumberError = false;
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

//  final CommWalletTransaction charges;
  TextEditingController benificarycustomerNameController =
      TextEditingController();
  TextEditingController benificaryaccountNumberController =
      TextEditingController();
  String benificarycustomerName = '';
  String benificaryaccountNumber = '';
  CommFeeCalculation response = CommFeeCalculation();
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();

  bool showNumberError = false;
  bool showNameError = false;
  bool showAccountError = false;
  bool showCurrencyError = false;
  bool showAmountError = false;
  bool showBranchError = false;
  bool showBeneficiaryAccountError = false;
  bool showBeneficiaryNameError = false;

  @override
  void dispose() {
    customerNameController.dispose();
    enteredAmount.dispose();
    accountNumberController.dispose();
    accountBranchController.dispose();
    accountCurrencyController.dispose();
    benificarycustomerNameController.dispose();
    benificaryaccountNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    senderSearchBloc = AccountSearchBloc(AuthService());
    receiverSearchBloc = AccountSearchBloc(AuthService());

    customerNameController.addListener(() {
      setState(() {
        showNameError = customerNameController.text.isEmpty;
      });
    });
    benificarycustomerNameController.addListener(() {
      setState(() {
        showBeneficiaryNameError =
            benificarycustomerNameController.text.isEmpty;
      });
    });

    accountNumberController.addListener(() {
      setState(() {
        showAccountError = accountNumberController.text.isEmpty;
      });
    });

    enteredAmount.addListener(() {
      setState(() {
        showAmountError = enteredAmount.text.isEmpty;
      });
    });

    accountCurrencyController.addListener(() {
      setState(() {
        showCurrencyError = accountCurrencyController.text.isEmpty;
      });
    });

    accountBranchController.addListener(() {
      setState(() {
        showBranchError = accountBranchController.text.isEmpty;
      });
    });

    benificaryaccountNumberController.addListener(() {
      setState(() {
        showBeneficiaryAccountError =
            benificaryaccountNumberController.text.isEmpty;
      });
    });
  }

  Widget _buildSenderInfoSection() {
    return BlocConsumer<AccountSearchBloc, AccountSearchState>(
      bloc: senderSearchBloc,
      listener: (context, state) {
        if (state is AccountSearchSuccess) {
          senderResponse = state.commAccountRequest;
          accountBranchController.text = senderResponse.branch;
          accountCurrencyController.text = senderResponse.accCcy;
          customerNameController.text = senderResponse.customerName;
          accountNumberController.text = senderResponse.accountNum;
        } else if (state is AccountSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: AppText(
                  "Depositor Details",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const Divider(),

              /// Account Number + Search
              Row(
                children: [
                  /* Expanded(
                    child: AppTextField(
                      label: "Account Number",
                      controller: accountNumberController,
                      isMandatory: true,
                      maxLength: 30,
                      isValid: !showAccountError,
                      errorText: "Account number required",
                    ),
                  ),*/
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (accountNumberController.text.isEmpty) {
                        showCustomBottomPopup(
                            context, "Account Number is required");
                        return;
                      }

                      final req = CommAccountRequest()
                        ..headerInfo = widget.loginResponse.headerInfo
                        ..service_id = "ACC_SEARCH"
                        ..accountNum = accountNumberController.text;

                      senderSearchBloc.add(AccountSearchSubmitted(req));
                    },
                  ),
                ],
              ),

              // AppTextField(
              //   label: "Branch",
              //   controller: accountBranchController,
              //   isFocus: false,
              //   isValid: !showBranchError,
              // ),

              // AppTextField(
              //   label: "Currency",
              //   controller: accountCurrencyController,
              //   isFocus: false,
              //   isValid: !showCurrencyError,
              // ),

              // AppTextField(
              //   label: "Customer Name",
              //   controller: customerNameController,
              //   isFocus: false,
              //   isValid: !showNameError,
              // ),

              // AppTextField(
              //   label: "Amount",
              //   controller: enteredAmount,
              //   inputType: TextInputType.number,
              //   maxLength: 10,
              //   isMandatory: true,
              //   isValid: !showAmountError,
              //   errorText: "Enter amount",
              // ),
              //
              // AppTextField(
              //   label: "Note",
              //   hintText: "Add a note",
              //   maxLength: 30,
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReceiverInfoSection() {
    return BlocConsumer<AccountSearchBloc, AccountSearchState>(
      bloc: receiverSearchBloc,
      listener: (context, state) {
        if (state is AccountSearchSuccess) {
          receiverResponse = state.commAccountRequest;
          benificarycustomerNameController.text = receiverResponse.customerName;
        } else if (state is AccountSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: AppText(
                  "Beneficiary Details",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
              ),
              const Divider(),

              /// Beneficiary Account Number + Search
              Row(
                children: [
                  // Expanded(
                  //   child: AppTextField(
                  //     label: "Beneficiary Account Number",
                  //     controller: benificaryaccountNumberController,
                  //     isMandatory: true,
                  //     maxLength: 30,
                  //     isValid: !showBeneficiaryAccountError,
                  //     errorText: "Account number required",
                  //   ),
                  // ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      if (benificaryaccountNumberController.text.isEmpty) {
                        showCustomBottomPopup(
                            context, "Account Number is required");
                        return;
                      }

                      final req = CommAccountRequest()
                        ..headerInfo = widget.loginResponse.headerInfo
                        ..service_id = "ACC_SEARCH"
                        ..accountNum = benificaryaccountNumberController.text;

                      receiverSearchBloc.add(AccountSearchSubmitted(req));
                    },
                  ),
                ],
              ),

              // AppTextField(
              //   label: "Beneficiary Name",
              //   controller: benificarycustomerNameController,
              //   isFocus: false,
              //   isValid: !showBeneficiaryNameError,
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection({
    required String title,
    required TextEditingController customerNameController,
    required TextEditingController accountNumberController,
    required VoidCallback onSearchPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.orange,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(color: AppColors.fbLiteDark),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: benificaryaccountNumberController,
                maxLength: 30,
                decoration: InputDecoration(
                  labelText: 'Enter Account Number',
                  counterText: "",
                  suffixIcon: showBeneficiaryAccountError
                      ? Icon(Icons.error,
                          color: Colors.red) // Show error icon when empty
                      : null,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: onSearchPressed,
              ),
            ),
          ],
        ),
        TextField(
          controller: customerNameController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Beneficiary Name',
            suffixIcon: showBeneficiaryNameError
                ? Icon(Icons.error,
                    color: Colors.red) // Show error icon when empty
                : null,
          ),
        ),
        /*TextField(
          controller: mobileNumberController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            suffixIcon: showReceiverNumberError
                ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                : null,
          ),
        ),*/
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountSearchBloc>.value(value: senderSearchBloc),
        BlocProvider<AccountSearchBloc>.value(value: receiverSearchBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChargeCalculationBloc, ChargeCalculationState>(
            listener: (context, state) {
              if (state is ChargeCalculationSuccess) {
                setState(() {
                  response = state.user;
                });
              } else if (state is ChargeCalculationFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLoading) {
                context.read<LoadingCubit>().show();
              } else {
                context.read<LoadingCubit>().hide();
              }

              if (state is ForgotPasswordSuccess) {
                otpValidationInfo = state.userOtp;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => ForgotPasswordBloc(AuthService()),
                      child: AuthenticationScreen2(
                        customerName: customerName,
                        enteredAmount: enteredAmount.text,
                        itemKey: widget.itemKey,
                        charges: response,
                        senderResponse: senderResponse,
                        receiverResponse: receiverResponse,
                        userOTPValidationInfo: otpValidationInfo,
                        loginResponse: widget.loginResponse,
                        selectedBank: widget.selectedBank,
                        accountNumber: accountNumber,
                        txnId: txnRefNo,
                      ),
                    ),
                  ),
                );
              } else if (state is ForgotPasswordFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
        ],
        child: Stack(
          children: [
            _buildTransactionScaffold(context),
            const GlobalLoader(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionScaffold(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_banner.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA clicked');
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Account Fund Transfer"),
      body: Row(
        children: [
          if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSenderInfoSection(),
                    const SizedBox(height: 10),
                    _buildReceiverInfoSection(),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildActionButton(
                label: "Next",
                onPressed: () async {
                  setState(() {
                    showNameError = customerNameController.text.isEmpty;
                    showAmountError = enteredAmount.text.isEmpty;
                    showAccountError = accountNumberController.text.isEmpty;
                    showCurrencyError = accountCurrencyController.text.isEmpty;
                    showBranchError = accountBranchController.text.isEmpty;
                    showBeneficiaryAccountError =
                        benificaryaccountNumberController.text.isEmpty;
                    showBeneficiaryNameError =
                        benificarycustomerNameController.text.isEmpty;
                  });

                  if (!showNameError &&
                      !showAmountError &&
                      !showAccountError &&
                      !showCurrencyError &&
                      !showBranchError &&
                      !showBeneficiaryNameError &&
                      !showBeneficiaryAccountError) {
                    double amount = double.tryParse(enteredAmount.text) ?? 0.0;

                    if (amount < 1) {
                      showCustomBottomPopup(
                          context, "Entered Amount should not be 0");
                      return;
                    }
                    if (accountNumberController.text ==
                        benificaryaccountNumberController.text) {
                      showCustomBottomPopup(context,
                          "Debit and Credit Accounts should not be same");
                      return;
                    }

                    await chargeCal(
                      context: context,
                      senderResponse: senderResponse,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthenticationScreen2(
                          itemKey: widget.itemKey,
                          receiverResponse: receiverResponse,
                          enteredAmount: enteredAmount.text,
                          senderResponse: senderResponse,
                          loginResponse: widget.loginResponse,
                          selectedBank: widget.selectedBank,
                          charges: response,
                          accountNumber: '',
                          txnId: txnRefNo,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
