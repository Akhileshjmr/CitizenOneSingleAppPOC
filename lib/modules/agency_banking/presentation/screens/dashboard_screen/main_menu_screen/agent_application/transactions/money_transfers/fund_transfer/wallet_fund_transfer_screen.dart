import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/RandomNumberGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../../constants/AppStrings.dart';
import '../../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../../data/models/BannerContent.dart';
import '../../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../../data/models/CommWalletAccountRequest.dart';
import '../../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../../data/services/AuthService.dart';
import '../../../../../../../../theme/colors/Appcolors.dart';
import '../../../../../../../../utils/AESEncryption.dart';
import '../../../../../../../../utils/CommDialog.dart';
import '../../../../../../../../utils/Loader.dart';
import '../../../../../../../../utils/ResponsiveLeftBanner.dart';
import '../../../../../../../blocs/account_search_bloc/account_search_bloc.dart';
import '../../../../../../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../../../../../../blocs/charge_calculation_bloc/charge_calculation_state.dart';
import '../../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../../blocs/wallet_account_search/wallet_account_search_bloc.dart';
import '../../../../../../../blocs/wallet_account_search/wallet_account_search_event.dart';
import '../../../../../../../blocs/wallet_account_search/wallet_account_search_state.dart';
import '../../../../../../../ab/transactions/authorization/view/authentication_screen.dart';

class WalletFundTransfer extends StatefulWidget {
  final dynamic itemKey;
  final LoginUserReqResInfo loginResponse;
  final String transactionType;
  final BankOption selectedBank;
  WalletFundTransfer(
      {required this.loginResponse,
      required this.itemKey,
      required this.transactionType,
      required this.selectedBank});

  @override
  _WalletFundTransferState createState() => _WalletFundTransferState();
}

class _WalletFundTransferState extends State<WalletFundTransfer> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController enteredAmount = TextEditingController();
  TextEditingController benificarymobileNumberController =
      TextEditingController();
  TextEditingController benificarycustomerNameController =
      TextEditingController();
  TextEditingController benificaryaccountNumberController =
      TextEditingController();
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();
  CommFeeCalculation response = CommFeeCalculation();

  // Wallet-specific variables (nullable)
  WalletSearchBloc? senderSearchBloc;
  WalletSearchBloc? receiverSearchBloc;
  CommWalletAccountRequest? senderResponse;
  CommWalletAccountRequest? receiverResponse;

  // Account-specific variables (nullable)
  AccountSearchBloc? accountSenderSearchBloc;
  AccountSearchBloc? accountReceiverSearchBloc;
  CommAccountRequest? accountSenderResponse;
  CommAccountRequest? accountReceiverResponse;
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController accountBranchController = TextEditingController();
  TextEditingController accountCurrencyController = TextEditingController();
  String accountCustomerName = '';
  String accountNumber = '';
  List<Contact> contacts = []; // Store contacts
  List<Contact> filteredContacts = []; // Store filtered contacts

  bool showNumberError = false;
  bool showNameError = false;
  bool showAccountError = false;
  bool showAmountError = false;
  bool showReceiverNumberError = false;
  bool showReceiverNameError = false;
  bool showReceiverAccountError = false;
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);

  @override
  void initState() {
    super.initState();
    if (widget.transactionType == 'Wallet') {
      // Initialize Wallet-specific variables
      senderSearchBloc = WalletSearchBloc(AuthService());
      receiverSearchBloc = WalletSearchBloc(AuthService());
      senderResponse = CommWalletAccountRequest();
      receiverResponse = CommWalletAccountRequest();
    } else if (widget.transactionType == 'Account') {
      // Initialize Account-specific variables
      accountSenderSearchBloc = AccountSearchBloc(AuthService());
      accountReceiverSearchBloc = AccountSearchBloc(AuthService());
      accountSenderResponse = CommAccountRequest();
      accountReceiverResponse = CommAccountRequest();
    }
    benificarycustomerNameController.addListener(() {
      setState(() {
        showReceiverAccountError =
            benificarycustomerNameController.text.isEmpty;
      });
    });

    benificaryaccountNumberController.addListener(() {
      setState(() {
        showReceiverNameError = benificaryaccountNumberController.text.isEmpty;
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

    benificarymobileNumberController.addListener(() {
      setState(() {
        showReceiverNumberError = benificarymobileNumberController.text.isEmpty;
      });
    });
  }

  void requestContactPermission(BuildContext context) async {
    PermissionStatus permission = await Permission.contacts.status;

    if (permission.isDenied) {
      permission = await Permission.contacts.request();
    }

    if (!permission.isGranted) {
      showCustomBottomPopup(context, "Permission to access contacts denied");
    }
  }

  Future<void> _pickContact({required bool isSender}) async {
    try {
      // Request Permission
      if (await FlutterContacts.requestPermission()) {
        final Contact? contact = await FlutterContacts.openExternalPick();

        if (contact != null && contact.phones.isNotEmpty) {
          // Extract first valid phone number
          String mobileNumber =
              contact.phones.first.number.replaceAll(RegExp(r'\D'), '');

          // If number is more than 9 digits, take last 9 (common case)
          if (mobileNumber.length > 9) {
            mobileNumber = mobileNumber.substring(mobileNumber.length - 9);
          }

          if (isSender) {
            mobileNumberController.text = mobileNumber;

            // Trigger API call
            final request = CommWalletAccountRequest(
              mobileno: AESEncryptionService.encrypt(mobileNumber),
              headerInfo: widget.loginResponse.headerInfo,
              moduleCode: AESEncryptionService.encrypt(widget.itemKey),
            );
            senderSearchBloc?.add(WalletSearchSubmitted(request));
          } else {
            benificarymobileNumberController.text = mobileNumber;

            final request = CommWalletAccountRequest(
              mobileno: AESEncryptionService.encrypt(mobileNumber),
              headerInfo: widget.loginResponse.headerInfo,
              moduleCode: AESEncryptionService.encrypt(widget.itemKey),
            );
            receiverSearchBloc?.add(WalletSearchSubmitted(request));
          }
        }
      } else {
        showCustomBottomPopup(context, "Contact permission denied");
      }
    } catch (e) {
      AppLogger.error('Failed to pick contact', e);
      showCustomBottomPopup(context, "Failed to pick contact");
    }
  }

  Widget _buildSenderInfoSection() {
    return BlocConsumer<WalletSearchBloc, WalletSearchState>(
      bloc: senderSearchBloc,
      listener: (context, state) {
        if (state is WalletSearchSuccess) {
          senderResponse = state.commWalletAccountRequest;
          customerNameController.text = AESEncryptionService.decrypt(
              state.commWalletAccountRequest.customerName);
          accountNumberController.text = AESEncryptionService.decrypt(
              state.commWalletAccountRequest.accountNum);
        } else if (state is WalletSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
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
                              ? Icon(Icons.error,
                                  color:
                                      Colors.red) // Show error icon when empty
                              : null,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        final mobileNumber = mobileNumberController.text;
                        accountNumberController.clear();
                        customerNameController.clear();
                        if (mobileNumber.isEmpty) {
                          showCustomBottomPopup(
                              context, "Mobile Number is required");
                          return;
                        }
                        if (mobileNumber.length == 9) {
                          final request = CommWalletAccountRequest(
                            mobileno:
                                AESEncryptionService.encrypt(mobileNumber),
                            headerInfo: widget.loginResponse.headerInfo,
                            moduleCode:
                                AESEncryptionService.encrypt(widget.itemKey),
                          );
                          senderSearchBloc?.add(WalletSearchSubmitted(request));
                        } else {
                          showCustomBottomPopup(
                              context, "Enter a valid 9 digit mobile number");
                        }
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/img.png',
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                      onPressed: () async {
                        requestContactPermission(context);
                        await _pickContact(isSender: true);
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: customerNameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Customer Name',
                    suffixIcon: showNameError
                        ? Icon(Icons.error,
                            color: Colors.red) // Show error icon when empty
                        : null,
                  ),
                ),
                TextField(
                  controller: accountNumberController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Wallet Account Number',
                    suffixIcon: showAccountError
                        ? Icon(Icons.error,
                            color: Colors.red) // Show error icon when empty
                        : null,
                  ),
                ),
                TextField(
                  controller: enteredAmount,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                        ? Icon(Icons.error,
                            color: Colors.red) // Show error icon when empty
                        : null,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  maxLength: 30,
                  decoration: InputDecoration(
                    counterText: "",
                    labelText: 'Add a Note',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiverInfoSection() {
    return BlocConsumer<WalletSearchBloc, WalletSearchState>(
      bloc: receiverSearchBloc,
      listener: (context, state) {
        if (state is WalletSearchSuccess) {
          receiverResponse = state.commWalletAccountRequest;
          benificarycustomerNameController.text = AESEncryptionService.decrypt(
              state.commWalletAccountRequest.customerName);
          benificaryaccountNumberController.text = AESEncryptionService.decrypt(
              state.commWalletAccountRequest.accountNum);
        } else if (state is WalletSearchFailure) {
          showCustomBottomPopup(context, state.error);
        }
      },
      builder: (context, state) {
        return Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: _buildInfoSection(
              title: 'Receiver Information',
              mobileNumberController: benificarymobileNumberController,
              customerNameController: benificarycustomerNameController,
              accountNumberController: benificaryaccountNumberController,
              onSearchPressed: () {
                final mobileNumber = benificarymobileNumberController.text;
                benificarycustomerNameController.clear();
                benificaryaccountNumberController.clear();

                if (mobileNumber.isEmpty) {
                  showCustomBottomPopup(context, "Mobile Number is required");
                  return;
                }
                if (mobileNumber.length == 9) {
                  final request = CommWalletAccountRequest(
                    mobileno: AESEncryptionService.encrypt(mobileNumber),
                    headerInfo: widget.loginResponse.headerInfo,
                    moduleCode: AESEncryptionService.encrypt(widget.itemKey),
                  );
                  receiverSearchBloc?.add(WalletSearchSubmitted(request));
                } else {
                  showCustomBottomPopup(
                      context, "Enter a valid 9 digit mobile number");
                }
              },
            ),
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.deepOrange,
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
                keyboardType: TextInputType.number,
                controller: mobileNumberController,
                maxLength: 9,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 👈 ONLY 0–9
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  counterText: "",
                  suffixIcon: showReceiverNumberError
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
            labelText: 'Customer Name',
            suffixIcon: showReceiverNameError
                ? Icon(Icons.error,
                    color: Colors.red) // Show error icon when empty
                : null,
          ),
        ),
        TextField(
          controller: accountNumberController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Wallet Account Number',
            suffixIcon: showReceiverAccountError
                ? Icon(Icons.error,
                    color: Colors.red) // Show error icon when empty
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<ChargeCalculationBloc, ChargeCalculationState>(
            listener: (context, state) {
              if (state is ChargeCalculationSuccess) {
                setState(() {
                  response = state.user;
                  AppLogger.debug('Charge calculation successful');
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
                        send: senderResponse,
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
        ));
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
      appBar: const CustomAppBar(title: "Wallet Fund Transfer"),
      body: Row(
        children: [
          if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSenderInfoSection(),
                    const SizedBox(height: 20),
                    _buildReceiverInfoSection(),
                    const SizedBox(
                        height: 100), // leave space for bottom button
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
                    showNumberError = mobileNumberController.text.isEmpty;
                    showAmountError = enteredAmount.text.isEmpty;
                    showAccountError = accountNumberController.text.isEmpty;
                    showReceiverNumberError =
                        benificarymobileNumberController.text.isEmpty;
                    showReceiverNameError =
                        benificarycustomerNameController.text.isEmpty;
                    showReceiverAccountError =
                        benificaryaccountNumberController.text.isEmpty;
                  });

                  if (!showNameError &&
                      !showNumberError &&
                      !showAmountError &&
                      !showAccountError &&
                      !showReceiverNumberError &&
                      !showReceiverAccountError &&
                      !showReceiverNameError) {
                    double enteredAmountValue =
                        double.tryParse(enteredAmount.text) ?? 0.0;

                    if (enteredAmountValue < 1) {
                      showCustomBottomPopup(
                          context, 'Entered amount should not be 0');
                      return;
                    }
                    if (mobileNumberController.text ==
                        benificarymobileNumberController.text) {
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
                          builder: (context) => AuthenticationScreen2(
                                itemKey: widget.itemKey,
                                receive: receiverResponse,
                                enteredAmount: enteredAmount.text,
                                send: senderResponse,
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
}
