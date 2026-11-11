import 'package:citizenone_app/modules/agency_banking/data/models/CommRequestMoney.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/request_money_bloc/request_money_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/request_money_bloc/request_money_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constants/AppStrings.dart';
import '../../../../../../constants/ModuleCode.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../data/models/BannerContent.dart';
import '../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../data/models/CommWalletTransaction.dart';
import '../../../../../../data/models/common_models/HeaderInfo.dart';
import '../../../../../../data/models/common_models/ServerMessage.dart';
import '../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../utils/AESEncryption.dart';
import '../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../utils/Loader.dart';
import '../../../../../../utils/RandomNumberGenerator.dart';
import '../../../../../blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../../../../../blocs/charge_calculation_bloc/charge_calculation_event.dart';
import '../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../../../../../blocs/pin_validation_bloc/pin_validation_state.dart';
import '../../../../../blocs/request_money_bloc/request_money_state.dart';
import '../../customer_application/customer_authentication_screen.dart';
import '../../../../../ab/transactions/authorization/view/authentication_screen.dart';

class TransactionScreen extends StatefulWidget {
  final dynamic loginResponse;
  final dynamic commAccountRequest;
  final dynamic commWalletAccountRequest;
  final dynamic searchResponse;
  final dynamic requestList;
  final String itemKey;
  final String transactionType;
  final BankOption selectedBank;
  final String? userType;

  TransactionScreen({
    super.key,
    this.loginResponse,
    this.commAccountRequest,
    this.commWalletAccountRequest,
    this.searchResponse,
    this.requestList,
    required this.itemKey,
    required this.transactionType,
    required this.selectedBank,
    this.userType,
  });

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  CommFeeCalculation response = CommFeeCalculation();
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
  String enteredAmount = "";
  late String mobileNumber;
  late String initial;
  late String customerName;
  late String accountNumber;
  late String? walletAccountNumber =
      widget.loginResponse?.loginUserInfo.wallet_acc_no;
  late UserOTPValidationInfo userOTPValidationInfo;

  String getInitial(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '';

    // Remove common salutations
    fullName = fullName
        .replaceAll(
            RegExp(r'^(MR\.?|MRS\.?|MS\.?|DR\.?)\s+', caseSensitive: false), '')
        .trim();

    // Take the first character of the first word
    return fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : '';
  }

  @override
  void initState() {
    super.initState();
    amountController.addListener(() {
      setState(() {
        enteredAmount = amountController.text;
      });
    });
    String _decryptSafe(String? value) {
      if (value == null || value.isEmpty) return '';
      try {
        return AESEncryptionService.decrypt(value);
      } catch (e) {
        // In case value is already plain text or invalid base64
        return value;
      }
    }

    initial =
        ((widget.commWalletAccountRequest?.customerName.isNotEmpty ?? false)
            ? getInitial(
                _decryptSafe(widget.commWalletAccountRequest!.customerName),
              )
            : (widget.commAccountRequest?.customerName.isNotEmpty ?? false)
                ? getInitial(
                    _decryptSafe(widget.commAccountRequest!.customerName),
                  )
                : (widget.requestList?.requesterName?.isNotEmpty ?? false)
                    ? getInitial(
                        _decryptSafe(widget.requestList!.requesterName),
                      )
                    : '');
    customerName = _decryptSafe(widget.commWalletAccountRequest?.customerName ??
        widget.commAccountRequest?.customerName ??
        widget.requestList?.requesterName);

    if (customerName.isEmpty) {
      customerName = '';
    }
    mobileNumber = _decryptSafe(widget.commWalletAccountRequest?.mobileno ??
        widget.commAccountRequest?.phoneNum ??
        widget.requestList?.requesterMob);

    if (mobileNumber.isEmpty) {
      mobileNumber = '';
    }
    accountNumber = _decryptSafe(widget.commWalletAccountRequest?.accountNum ??
        widget.commAccountRequest?.accountNum);

    if (accountNumber.isEmpty) {
      accountNumber = '';
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  chargeCal() async {
    CommWalletTransaction req = CommWalletTransaction(
      headerInfo: widget.commWalletAccountRequest?.headerInfo ??
          widget.commAccountRequest?.headerInfo ??
          HeaderInfo(),
      resMessage: ServerMessage(),
    );
    context.read<ChargeCalculationBloc>().add(ChargeCalculationSubmitted(req));
  }

  void handleChargeCalculation() async {
    await chargeCal();
  }

  Future<void> submitRequestMoney() async {
    CommRequestMoney requestMoney = CommRequestMoney();
    requestMoney.headerInfo = widget.commWalletAccountRequest?.headerInfo;
    requestMoney.operation = 'SUBMIT_REQ_MONEY';
    requestMoney.requestId = txnRefNo;
    requestMoney.txntype = ModuleCode.requestMoney;
    requestMoney.reqAmount = double.tryParse(amountController.text);
    requestMoney.requesting_toMob = widget.commWalletAccountRequest?.mobileno;
    requestMoney.requesterName = widget.loginResponse?.loginUserInfo.firstName;
    requestMoney.requesterMob =
        widget.loginResponse?.loginUserInfo.userName ?? "";
    context.read<RequestMoneyBloc>().add(RequestMoneySubmitted(requestMoney));
  }

  Widget buildPayButton(
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.btnBackground,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingCubit, bool>(
      listener: (context, isLoading) {
        BlocListener<PinValidationBloc, PinValidationState>(
          listener: (context, state) {
            if (state is PinValidationLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is PinValidationSuccess) {
            } else if (state is PinValidationFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        );
      },
      child: Stack(
        children: [
          _buildTransactionScaffold(context),
          const GlobalLoader(),
        ],
      ),
    );
  }

  Widget _buildTransactionScaffold(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final banners = [
      BannerContent(
        imagePath: "assets/images/home_banner.jpg",
        title: AppStrings.bannerTitle,
        headline: AppStrings.bannerHeading,
        subtitle: AppStrings.bannerSubtitle,
        ctaText: AppStrings.bannerCreateText,
        onCtaPressed: () {},
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.itemKey == ModuleCode.withdrawal
            ? "Withdrawal"
            : widget.itemKey == ModuleCode.deposit
                ? "Deposit"
                : widget.itemKey == ModuleCode.requestMoney
                    ? "Request Money"
                    : widget.itemKey == ModuleCode.receiveRequest
                        ? "Request Money"
                        : widget.itemKey == ModuleCode.trustAccount
                            ? "Trust Account"
                            : widget.itemKey == ModuleCode.corporatePayment
                                ? "Corporate Payment"
                                : widget.itemKey == ModuleCode.walletToCbs
                                    ? "Wallet to Account Transfer"
                                    : widget.itemKey == ModuleCode.cbsToWallet
                                        ? "Account to Wallet Transfer"
                                        : widget.itemKey ==
                                                ModuleCode.fundTransfer
                                            ? "Fund Transfer"
                                            : "",
      ),
      body: Row(
        children: [
          //if (!isMobile) ResponsiveLeftBanner(banners: banners),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ForgotPasswordLoading) {
                        context.read<LoadingCubit>().show();
                      } else {
                        context.read<LoadingCubit>().hide();
                      }
                      if (state is ForgotPasswordSuccess &&
                          widget.userType != 'RC') {
                        userOTPValidationInfo = state.userOtp;
                      } else if (state is ForgotPasswordFailure) {
                        showCustomBottomPopup(context, state.error);
                      }
                    },
                  ),
                  BlocListener<RequestMoneyBloc, RequestMoneyState>(
                    listener: (context, state) {
                      if (state is RequestMoneyLoading) {
                        context.read<LoadingCubit>().show();
                      } else {
                        context.read<LoadingCubit>().hide();
                      }
                      if (state is RequestMoneySuccess) {
                        showRequestMoneySuccess(
                            context,
                            state.requestMoney.requesting_toName,
                            state.requestMoney.reqAmount,
                            state.requestMoney.requestId,
                            widget.loginResponse!,
                            widget.itemKey,
                            widget.selectedBank);
                      } else if (state is RequestMoneyFailure) {
                        showCustomBottomPopup(context, state.error);
                      }
                    },
                  ),
                ],
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Ensures vertical centering
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 20,
                                      child: Text(
                                        initial,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, // Vertically center text with avatar
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customerName,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (widget.itemKey !=
                                              ModuleCode.requestMoney)
                                            Text(
                                              accountNumber.length > 4
                                                  ? 'XXXX${accountNumber.substring(accountNumber.length - 4)}'
                                                  : accountNumber,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          if (mobileNumber.isNotEmpty) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              mobileNumber,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  maxLength: 10,
                                  inputFormatters: [
                                    // 1️⃣ FIRST: HARD BLOCK everything except digits and dot
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'[^0-9.]'),
                                    ),

                                    // 2️⃣ SECOND: Control dot count + decimal length
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
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
                                        if (parts.length > 1 &&
                                            parts[1].length > 2) {
                                          return oldValue;
                                        }
                                      }

                                      return newValue;
                                    }),
                                  ],
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    labelText: widget.itemKey ==
                                            ModuleCode.receiveRequest
                                        ? widget.requestList?.reqAmount
                                                ?.toString() ??
                                            ''
                                        : 'Enter Amount',
                                  ),
                                  enabled: widget.itemKey !=
                                      ModuleCode.receiveRequest,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: noteController,
                                  maxLength: 30,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    labelText: 'Add A Note',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      /// ✅ FIXED BOTTOM BAR
      /*bottomNavigationBar: enteredAmount.isNotEmpty
          ? SafeArea(
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        "${widget.loginResponse?.headerInfo.currency ?? ''} $enteredAmount",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.fbLiteDark,
                        ),
                      ),
                    ),
                    if (widget.itemKey != ModuleCode.requestMoney) ...[
                      const SizedBox(width: 50.0),
                      Container(height: 24.0, width: 1.0, color: Colors.black),
                      const SizedBox(width: 12.0),
                      Flexible(
                        child: Text(
                          widget.itemKey == ModuleCode.receiveRequest
                              ? (walletAccountNumber?.length ?? 0) > 4
                              ? 'XXXX${walletAccountNumber!.substring(walletAccountNumber!.length - 4)}'
                              : (walletAccountNumber ?? '')
                              : (accountNumber.length > 4
                              ? 'XXXX${accountNumber.substring(accountNumber.length - 4)}'
                              : (accountNumber)),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              buildPayButton(
                label: widget.itemKey == ModuleCode.requestMoney ? "Submit" : "Pay",
                onPressed: () {
                  final double amount =
                      double.tryParse(amountController.text.trim()) ?? 0;

                  // ❌ Block zero or invalid amount
                  if (amount <= 0) {
                    showCustomBottomPopup(context, "Entered amount cannot be 0");
                    return; // ⛔ Stop navigation
                  }
                  if (widget.itemKey == ModuleCode.requestMoney) {
                    submitRequestMoney();
                  } else if (widget.itemKey == ModuleCode.cbsToWallet ||
                      widget.itemKey == ModuleCode.walletToCbs ||
                      widget.itemKey == ModuleCode.fundTransfer) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthenticationScreen(
                          loginResponse: widget.loginResponse,
                          commAccountRequest: widget.commAccountRequest,
                          searchResponse: widget.searchResponse,
                          transactionType: widget.transactionType,
                          itemKey: widget.itemKey,
                          commWalletAccountRequest:
                          widget.commWalletAccountRequest,
                          enteredAmount: amountController.text,
                          selectedBank: widget.selectedBank,
                        ),
                      ),
                    );
                  } else {
                    handleChargeCalculation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthenticationScreen2(
                          customerName: customerName,
                          enteredAmount: enteredAmount,
                          transactionType: widget.transactionType,
                          itemKey: widget.itemKey,
                          accountNumber: accountNumber,
                          commWalletAccountRequest:
                          widget.commWalletAccountRequest,
                          commAccountRequest: widget.commAccountRequest,
                          charges: response,
                          loginResponse: widget.loginResponse,
                          requestList: widget.requestList,
                          selectedBank: widget.selectedBank,
                          mobileNumber: mobileNumber,
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
      )
          : null,*/
      bottomNavigationBar: enteredAmount.isNotEmpty
          ? AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                "${AESEncryptionService.decrypt(widget.loginResponse?.headerInfo.currency ?? '')} $enteredAmount",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.fbLiteDark,
                                ),
                              ),
                            ),
                            if (widget.itemKey != ModuleCode.requestMoney) ...[
                              const SizedBox(width: 50),
                              Container(
                                  height: 24, width: 1, color: Colors.black),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  accountNumber.length > 4
                                      ? 'XXXX${accountNumber.substring(accountNumber.length - 4)}'
                                      : accountNumber,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      buildPayButton(
                        label: widget.itemKey == ModuleCode.requestMoney
                            ? "Submit"
                            : "Pay",
                        onPressed: () {
                          final double amount =
                              double.tryParse(amountController.text.trim()) ??
                                  0;

                          // ❌ Block zero or invalid amount
                          if (amount <= 0) {
                            showCustomBottomPopup(
                                context, "Entered amount cannot be 0");
                            return; // ⛔ Stop navigation
                          }
                          if (widget.itemKey == ModuleCode.requestMoney) {
                            submitRequestMoney();
                          } else if (widget.itemKey == ModuleCode.cbsToWallet ||
                              widget.itemKey == ModuleCode.walletToCbs ||
                              widget.itemKey == ModuleCode.fundTransfer) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthenticationScreen(
                                  loginResponse: widget.loginResponse,
                                  commAccountRequest: widget.commAccountRequest,
                                  searchResponse: widget.searchResponse,
                                  transactionType: widget.transactionType,
                                  itemKey: widget.itemKey,
                                  commWalletAccountRequest:
                                      widget.commWalletAccountRequest,
                                  enteredAmount: amountController.text,
                                  selectedBank: widget.selectedBank,
                                ),
                              ),
                            );
                          } else {
                            handleChargeCalculation();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AuthenticationScreen2(
                                  customerName: customerName,
                                  enteredAmount: enteredAmount,
                                  transactionType: widget.transactionType,
                                  itemKey: widget.itemKey,
                                  accountNumber: accountNumber,
                                  commWalletAccountRequest:
                                      widget.commWalletAccountRequest,
                                  commAccountRequest: widget.commAccountRequest,
                                  charges: response,
                                  loginResponse: widget.loginResponse,
                                  requestList: widget.requestList,
                                  selectedBank: widget.selectedBank,
                                  mobileNumber: mobileNumber,
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
            )
          : null,
    );
  }
}
