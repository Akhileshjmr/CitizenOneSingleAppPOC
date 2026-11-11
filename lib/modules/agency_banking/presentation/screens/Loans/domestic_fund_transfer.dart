import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/AppStrings.dart';
import '../../../constants/ModuleCode.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../data/models/BannerContent.dart';
import '../../../data/models/CommFeeCalulation.dart';
import '../../../data/models/CommWalletTransaction.dart';
import '../../../data/models/common_models/ServerMessage.dart';
import '../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../data/services/AuthService.dart';
import '../../../theme/colors/Appcolors.dart';
import '../../../utils/CommDialog.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../../utils/Loader.dart';
import '../../../utils/ResponsiveLeftBanner.dart';
import '../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../blocs/charge_calculation_bloc/charge_calculation_event.dart';
import '../../blocs/charge_calculation_bloc/charge_calculation_state.dart';
import '../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import '../../ab/transactions/authorization/view/authentication_screen.dart';

class DomesticFundTransfer extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  DomesticFundTransfer(
      {required this.loginResponse,
      required this.itemKey,
      required this.selectedBank});

  @override
  _DomesticFundTransferState createState() => _DomesticFundTransferState();
}

class _DomesticFundTransferState extends State<DomesticFundTransfer> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController enteredAmount = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController benificarymobileNumberController =
      TextEditingController();
  TextEditingController benificarycustomerNameController =
      TextEditingController();
  TextEditingController benificaryaccountNumberController =
      TextEditingController();
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();
  CommFeeCalculation response = CommFeeCalculation();
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountBranchController = TextEditingController();
  TextEditingController accountCurrencyController = TextEditingController();
  String accountCustomerName = '';
  String accountNumber = '';

  bool showNumberError = false;
  bool showNameError = false;
  bool showAccountError = false;
  bool showAmountError = false;

  void showPaymentOptionsDomestic({
    required BuildContext context,
    required dynamic itemKey,
    required TextEditingController enteredAmount,
    required LoginUserReqResInfo loginResponse,
    required CommFeeCalculation response,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is ForgotPasswordSuccess) {
            } else if (state is ForgotPasswordFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text(
                    'Choose Payment Method',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.lock, color: AppColors.fbTooLite),
                  title: const Center(
                    child: Text(
                      'Pay using OTP',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    UserOTPValidationInfo request = UserOTPValidationInfo()
                      ..headerInfo = loginResponse.headerInfo
                      ..mobileNo = loginResponse.loginUserInfo.userName ?? ""
                      ..userName = loginResponse.loginUserInfo.userName ?? "";

                    context.read<ForgotPasswordBloc>().add(
                          ForgotPasswordSubmitted(request),
                        );

                    Navigator.pop(
                        context); // Or keep it open if OTP screen is shown after state
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pin, color: AppColors.fbTooLite),
                  title: const Center(
                    child: Text(
                      'Pay using PIN',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) => PinValidationBloc(AuthService()),
                          child: AuthenticationScreen2(
                            enteredAmount: enteredAmount.text,
                            //paymentOption: "PIN",
                            itemKey: itemKey,
                            charges: response,
                            loginResponse: loginResponse,
                            accountNumber: accountNumber,
                            txnId: txnRefNo,
                            selectedBank: widget.selectedBank,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> chargeCal({
    required BuildContext context,
  }) async {
    CommWalletTransaction req = CommWalletTransaction(
      headerInfo: widget.loginResponse.headerInfo,
      resMessage: ServerMessage(),
    );

    context.read<ChargeCalculationBloc>().add(ChargeCalculationSubmitted(req));
  }

  @override
  void initState() {
    super.initState();

    customerNameController.addListener(() {
      setState(() {
        showNameError = customerNameController.text.isEmpty;
      });
    });

    mobileNumberController.addListener(() {
      setState(() {
        showNumberError = mobileNumberController.text.isEmpty;
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
  }

  Widget _buildInfoSection({
    required String title,
    required TextEditingController mobileNumberController,
    required TextEditingController customerNameController,
    required TextEditingController accountNumberController,
    required VoidCallback onSearchPressed,
  }) {
    return SizedBox(); // or any other placeholder widget
  }

  Widget _buildSenderInfoSection() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 5),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sender Information',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: AppColors.fbLiteDark),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: accountNumberController,
                    decoration: InputDecoration(
                      labelText: 'Account Number',
                      suffixIcon: showAccountError
                          ? Icon(Icons.error,
                              color: Colors.red) // Show error icon when empty
                          : null,
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.search, color: Colors.black),
                //   onPressed: () {
                //     final mobileNumber = mobileNumberController.text;
                //     if (mobileNumber.length == 9) {
                //       final request = CommWalletAccountRequest(
                //         mobileno: mobileNumber,
                //         headerInfo: widget.loginResponse.headerInfo,
                //         moduleCode: widget.itemKey,
                //       );
                //       senderSearchBloc?.add(WalletSearchSubmitted(request));
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text("Please Check Mobile Number must be of 9 digits...!")),
                //       );
                //     }
                //   },
                // ),
                // IconButton(
                //   icon: Image.asset(
                //     'assets/images/img.png',
                //     height: 30,
                //     fit: BoxFit.cover,
                //   ),
                //   onPressed: () {
                //     requestContactPermission(context);
                //     _pickContact();
                //   },
                // ),
              ],
            ),
            TextField(
              controller: customerNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                suffixIcon:
                    showNameError ? Icon(Icons.error, color: Colors.red) : null,
              ),
            ),
            TextField(
              controller: currencyController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Currency',
              ),
            ),
            TextField(
              controller: enteredAmount,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                suffixIcon: showAmountError
                    ? Icon(Icons.error,
                        color: Colors.red) // Show error icon when empty
                    : null,
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Add a Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverInfoSection() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Receiver Information',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: AppColors.fbLiteDark),

            // Mobile Number input (no search icon)
            TextField(
              controller: benificaryaccountNumberController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Account Number',
                suffixIcon: showAccountError
                    ? Icon(Icons.error, color: Colors.red)
                    : null,
              ),
            ),

            // Customer Name input
            TextField(
              controller: benificarycustomerNameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Customer Name',
                suffixIcon:
                    showNameError ? Icon(Icons.error, color: Colors.red) : null,
              ),
            ),
            TextField(
              controller: currencyController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Currency',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final List<BannerContent> banners = [
      BannerContent(
        imagePath: "assets/images/home_loan.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {
          AppLogger.debug('Banner CTA pressed');
        },
      ),
    ];
    return Scaffold(
        appBar: CustomAppBar(
          title: widget.itemKey == ModuleCode.domesticFt
              ? 'Domestic Fund Transfer'
              : 'International Fund Transfer',
        ),
        body: Row(children: [
          if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
              child: MultiBlocListener(
            listeners: [
              BlocListener<ChargeCalculationBloc, ChargeCalculationState>(
                listener: (context, state) {
                  if (state is ChargeCalculationSuccess) {
                    setState(() {
                      response = state.user;
                      AppLogger.debug('Charge calculation successful');
                    });
                  } else if (state is ChargeCalculationFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
              ),
              BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    otpValidationInfo = state.userOtp;
                    // Navigate to AuthenticationScreen on success
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              ForgotPasswordBloc(AuthService()),
                          child: AuthenticationScreen2(
                            // customerName: customerName,
                            enteredAmount: enteredAmount.text,
                            //paymentOption: "OTP",
                            itemKey: widget.itemKey,
                            // accountNumber: accountNumber,
                            charges: response,
                            userOTPValidationInfo: otpValidationInfo,
                            loginResponse: widget.loginResponse,
                            accountNumber: accountNumber,
                            txnId: txnRefNo,
                            selectedBank: widget.selectedBank,
                          ),
                        ),
                      ),
                    );
                  } else if (state is ForgotPasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                        state.error,
                        textAlign: TextAlign.center,
                      )),
                    );
                  }
                },
              ),
            ],
            child: Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSenderInfoSection(),
                    SizedBox(height: 20),
                    _buildReceiverInfoSection(),
                    SizedBox(height: 20),
                    Center(
                      child: buildActionButton(
                        label: 'Next',
                        onPressed: () async {
                          setState(() {
                            showNameError = customerNameController.text.isEmpty;
                            showAmountError = enteredAmount.text.isEmpty;
                            showAccountError =
                                accountNumberController.text.isEmpty;
                          });

                          if (!showNameError &&
                              !showAmountError &&
                              !showAccountError) {
                            double enteredAmountValue =
                                double.tryParse(enteredAmount.text) ?? 0.0;

                            if (enteredAmountValue < 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Entered Amount should not be 0 !!! ',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                              return;
                            }

                            await chargeCal(
                              context: context,
                            );

                            showPaymentOptionsDomestic(
                              context: context,
                              itemKey: widget.itemKey,
                              enteredAmount: enteredAmount,
                              loginResponse: widget.loginResponse,
                              response: response,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ]));
  }
}
