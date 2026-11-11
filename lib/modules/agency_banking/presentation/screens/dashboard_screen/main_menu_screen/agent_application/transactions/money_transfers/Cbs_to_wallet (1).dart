import 'package:citizenone_app/modules/agency_banking/data/models/login_models/UserOtpValidationInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_search_bloc/account_search_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_search_bloc/account_search_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../data/models/CommWalletAccountRequest.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../utils/AESEncryption.dart';
import '../../../../../../../utils/CommDialog.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/Loader.dart';
import '../../../../../../blocs/account_search_bloc/account_search_event.dart';
import '../../../../../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../../../../../blocs/charge_calculation_bloc/charge_calculation_state.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../../../../../BaseScreen/base_screen.dart';
import '../../../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../../../../../../ab/transactions/authorization/view/authentication_screen.dart';

class CbsToWallet extends StatefulWidget {
  final dynamic itemKey; // Add itemKey field
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank;

  CbsToWallet({required this.loginResponse, required this.itemKey, required this.selectedBank});

  @override
  _CbsToWalletScreenState createState() => _CbsToWalletScreenState();
}

class _CbsToWalletScreenState extends State<CbsToWallet> {
  late AccountSearchBloc senderSearchBloc;
  late WalletSearchBloc receiverSearchBloc;
  late CommAccountRequest senderResponse;
  late CommWalletAccountRequest receiverResponse;
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController enteredAmount=TextEditingController();
  TextEditingController accountBranchController=TextEditingController();
  TextEditingController accountCurrencyController=TextEditingController();
  String customerName = '';
  String accountNumber = '';
  bool showAccountError = false;
  bool showBranchError = false;
  bool showCurrencyError = false;
  bool showNameError = false;
  bool showAmountError = false;
  bool showNumberError = false;


  bool showReceiverNameError = false;
  bool showReceiverAccountError = false;


  CommFeeCalculation response = CommFeeCalculation();
  UserOTPValidationInfo otpValidationInfo=UserOTPValidationInfo();
//  final CommWalletTransaction charges;
  TextEditingController benificaryaccountCurrecyController = TextEditingController();
  TextEditingController benificarycustomerNameController = TextEditingController();
  TextEditingController benificaryaccountNumberController = TextEditingController();
  String benificarycustomerName = '';
  String benificaryaccountNumber = '';
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

  @override
  void initState() {
    super.initState();
    senderSearchBloc = AccountSearchBloc(AuthService());
    receiverSearchBloc = WalletSearchBloc(AuthService());
    benificarycustomerNameController.addListener(() {
      setState(() {
        showReceiverNameError = benificarycustomerNameController.text.isEmpty;
      });
    });

    benificaryaccountNumberController.addListener(() {
      setState(() {
        showReceiverAccountError = benificaryaccountNumberController.text.isEmpty;
      });
    });

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

    accountBranchController.addListener(() {
      setState(() {
        showBranchError = accountBranchController.text.isEmpty;
      });
    });

    accountCurrencyController.addListener(() {
      setState(() {
        showCurrencyError = accountCurrencyController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    senderSearchBloc.close();
    receiverSearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountSearchBloc>.value(value: senderSearchBloc),
        BlocProvider<WalletSearchBloc>.value(value: receiverSearchBloc),
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
                  otpValidationInfo=state.userOtp;
                  // Navigate to AuthenticationScreen on success
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (context) => ForgotPasswordBloc(AuthService()),
                        child: AuthenticationScreen2(
                          // customerName: customerName,
                          enteredAmount: enteredAmount.text,
                          //paymentOption: "OTP",
                          itemKey: widget.itemKey,
                          // accountNumber: accountNumber,
                          charges: response,
                          senderResponse: senderResponse,
                          receive: receiverResponse,
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
          )
      ),
    );
  }

  Widget _buildTransactionScaffold(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Wallet Top-Up",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSenderInfoSection(),
              const SizedBox(height: 10),
              _buildReceiverInfoSection(),
              const SizedBox(height: 100), // space for bottom button
            ],
          ),
        ),
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
                    showNumberError = mobileNumberController.text.isEmpty;
                    showAmountError = enteredAmount.text.isEmpty;
                    showAccountError = accountNumberController.text.isEmpty;
                    showBranchError = accountBranchController.text.isEmpty;
                    showCurrencyError = accountCurrencyController.text.isEmpty;

                    // Receiver validation
                    showReceiverNameError = benificarycustomerNameController.text.isEmpty;
                    showReceiverAccountError = benificaryaccountNumberController.text.isEmpty;
                  });

                  if (!showNameError &&
                      !showCurrencyError &&
                      !showNumberError &&
                      !showAmountError &&
                      !showBranchError &&
                      !showReceiverNameError &&
                      !showReceiverAccountError &&
                      !showAccountError) {
                    double enteredAmountValue =
                        double.tryParse(enteredAmount.text) ?? 0.0;

                    if (enteredAmountValue < 1) {
                      showCustomBottomPopup(context, "Entered amount should not be 0");
                      return;
                    }

                    await chargeCal(
                      context: context,
                      senderResponse: senderResponse,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthenticationScreen2(
                        itemKey: widget.itemKey,
                        receive: receiverResponse,
                        enteredAmount: enteredAmount.text,
                        senderResponse: senderResponse,
                        loginResponse: widget.loginResponse,
                        selectedBank: widget.selectedBank,
                        charges: response,
                        accountNumber: '',
                        txnId: txnRefNo,
                      )),
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

  Widget _buildSenderInfoSection() {
    return BlocConsumer<AccountSearchBloc, AccountSearchState>(
      bloc: senderSearchBloc,
      listener: (context, state) {
        if (state is AccountSearchSuccess) {
          senderResponse=state.commAccountRequest ;
          accountBranchController.text=AESEncryptionService.safeDecrypt(state.commAccountRequest.branch);
          accountCurrencyController.text=AESEncryptionService.safeDecrypt(state.commAccountRequest.accCcy);
          customerNameController.text = AESEncryptionService.safeDecrypt(state.commAccountRequest.customerName);
          accountNumberController.text = state.commAccountRequest.accountNum;
        } else if (state is AccountSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        return Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Depositor Detail',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(color: Colors.black),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: accountNumberController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                          ],
                          maxLength: 30,
                          decoration: InputDecoration(
                            labelText: 'Enter Account Number',
                            counterText: "",
                            suffixIcon: showAccountError
                                ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          if(accountNumberController.text.isEmpty)
                          {
                            showCustomBottomPopup(context, "Account number is required");
                            return ;
                          }
                          // CLEAR OLD DATA
                          customerNameController.clear();
                          accountBranchController.clear();
                          accountCurrencyController.clear();

                          setState(() {}); // force UI refresh
                          CommAccountRequest accRequest=CommAccountRequest();
                          accRequest.headerInfo=widget.loginResponse.headerInfo;
                          accRequest.service_id="ACC_SEARCH";
                          accRequest.accountNum=AESEncryptionService.encrypt(accountNumberController.text);
                          senderSearchBloc.add(AccountSearchSubmitted(accRequest));
                        },
                      ),
                    ],
                  ),
                  TextField(
                    controller: accountBranchController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Branch',
                      suffixIcon: showBranchError
                          ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                          : null,
                    ),
                  ),
                  TextField(
                    controller: accountCurrencyController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Currency',
                      suffixIcon: showCurrencyError
                          ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                          : null,
                    ),
                  ),
                  TextField(
                    controller: customerNameController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      suffixIcon: showNameError
                          ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                          : null,
                    ),
                  ),

                  TextField(
                    controller: enteredAmount,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    maxLength: 10,
                    inputFormatters: [
                      // 1️⃣ FIRST: HARD BLOCK everything except digits and dot
                      FilteringTextInputFormatter.deny(
                        RegExp(r'[^0-9.]'),
                      ),

                      // 2️⃣ SECOND: Control dot count + decimal length
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text;

                        // allow empty
                        if (text.isEmpty) return newValue;

                        // only one dot allowed
                        if ('.'.allMatches(text).length > 1) {
                          return oldValue;
                        }

                        // max 2 decimal places
                        if (text.contains('.')) {
                          final parts = text.split('.');
                          if (parts.length > 1 && parts[1].length > 2) {
                            return oldValue;
                          }
                        }

                        return newValue;
                      }),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Enter Amount',
                      counterText: "",
                      suffixIcon: showAmountError
                          ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                          : null,
                    ),
                    onChanged: (value) {
                      // Logic to handle the amount entered
                    },
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      maxLength: 30,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: 'Add a Note',
                        labelStyle: TextStyle(color: AppColors.black),
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 2,
                      onChanged: (value) {
                        // Logic to handle the note entered
                      },
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }

  Widget _buildReceiverInfoSection() {
    return BlocConsumer<WalletSearchBloc, WalletSearchState>(
      bloc: receiverSearchBloc,
      listener: (context, state) {
        if (state is WalletSearchSuccess) {
          receiverResponse=state.commWalletAccountRequest;
          benificarycustomerNameController.text = AESEncryptionService.safeDecrypt(state.commWalletAccountRequest.customerName);
          benificaryaccountNumberController.text =AESEncryptionService.safeDecrypt( state.commWalletAccountRequest.accountNum);
        } else if (state is WalletSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        return _buildInfoSection(
          title: 'Receiver Information',
          mobileNumberController: mobileNumberController,
          customerNameController: benificarycustomerNameController,
          accountNumberController: benificaryaccountNumberController,
          onSearchPressed: () {
            final mobileNumber = mobileNumberController.text;
            benificaryaccountNumberController.clear();
            benificarycustomerNameController.clear();
            if(mobileNumberController.text.isEmpty)
            {
              showCustomBottomPopup(context, "Mobile number is required");
              return ;
            }
            if (mobileNumber.length == 9) {
              final request = CommWalletAccountRequest(
                mobileno: AESEncryptionService.encrypt(mobileNumber),
                headerInfo: widget.loginResponse.headerInfo,
                moduleCode: AESEncryptionService.encrypt(widget.itemKey),
              );
              receiverSearchBloc.add(WalletSearchSubmitted(request));
            }
            else{
              showCustomBottomPopup(context, "Enter a valid 9 digit mobile number");
            }
          },
        );
      },
    );
  }

  Widget _buildInfoSection({
    required String title,
    required TextEditingController mobileNumberController,
    required TextEditingController customerNameController,
    required TextEditingController accountNumberController,
    required VoidCallback onSearchPressed,
  }) {
    return Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Padding(
          padding: EdgeInsets.all(10),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: AppColors.black),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: mobileNumberController,
                      maxLength: 9,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 👈 ONLY 0–9
                      ],
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        counterText: "",
                        suffixIcon: showNumberError
                            ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.black),
                    onPressed: onSearchPressed,
                  ),
                ],
              ),
              TextField(
                controller: customerNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  suffixIcon: showReceiverNameError
                      ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                      : null,
                ),
              ),
              TextField(
                controller: accountNumberController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Wallet Account Number',
                  suffixIcon: showReceiverAccountError
                      ? Icon(Icons.error, color: Colors.red) // Show error icon when empty
                      : null,
                ),
              ),
            ],
          ),
        )
    );
  }
}