import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../../../data/models/CommTransaction.dart';
import '../../../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/RandomNumberGenerator.dart';
import '../../../../../../blocs/account_wallet_transaction/account_wallet_transaction_bloc.dart';
import '../../../../../../blocs/account_wallet_transaction/account_wallet_transaction_state.dart';
import '../../../../../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../../../../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import '../../../../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import '../../../../../../blocs/wallet_transaction_bloc/wallet_transaction_bloc.dart';
import '../../../../../../blocs/wallet_transaction_bloc/wallet_transaction_state.dart';
import '../../../../../BaseScreen/base_screen.dart';
import '../download_receipt_screen.dart';

class SendMoneyAuthenticationScreen extends StatefulWidget {
  final String enteredAmount;
  final String paymentOption;
  final dynamic itemKey;
  final CommTransaction? commTransaction;
  final UserOTPValidationInfo? userOTPValidationInfo;
  final CommFeeCalculation charges;
  final LoginUserReqResInfo? loginResponse;
  final CommWalletTransaction? commWalletTransaction;
  final String transaction;
  final BankOption selectedBank;

  SendMoneyAuthenticationScreen({
    required this.enteredAmount,
    required this.paymentOption,
    this.itemKey,
    this.commTransaction,
    this.userOTPValidationInfo,
    required this.charges,
    this.loginResponse,
    this.commWalletTransaction,
    required this.transaction,
    required this.selectedBank,
  });

  @override
  _SendMoneyAuthenticationScreen createState() =>
      _SendMoneyAuthenticationScreen();
}

class _SendMoneyAuthenticationScreen
    extends BaseScreenState<SendMoneyAuthenticationScreen> {
  final Color myHexColor = Color(0xff5c7d33);
  final Color disabledButtonColor = Colors.grey;
  TextEditingController _pinController = TextEditingController();
  final AuthService authService = AuthService();
  String txnRefNo = RandomNumberGenerator.generateId('AGB', 13);
  late String transactionPdf;

  @override
  void initState() {
    super.initState();
    AppLogger.debug(
        'SendMoneyConfirmation initState - itemKey: ${widget.itemKey}');
  }

  bool isPayButtonEnabled = false;
  Future<bool> _simulateApiCall() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return true; // Simulate success response
  }

  void _validatePin(BuildContext context) async {
    final pin = _pinController.text; // Null-safe trim

    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter Pin')),
      );
      return;
    }
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pin must be exactly 6 digits')),
      );
      return;
    }
    // Simulate API response success (adjust based on your Bloc implementation)
    final isSuccess = await _simulateApiCall(); // Simulated API call

    if (isSuccess) {
      setState(() {
        isPayButtonEnabled = true;
      });
    }
  }

  void _submitOtp(BuildContext context) async {
    final otp = _pinController.text; // Null-safe trim

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter OTP')),
      );
      return;
    }
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP must be exactly 6 digits')),
      );
      return;
    }
    UserOTPValidationInfo req = UserOTPValidationInfo();
    req.headerInfo = widget.userOTPValidationInfo!.headerInfo;
    req.otpuniqueid = widget.userOTPValidationInfo!.otpuniqueid;
    req.mobileNo = widget.userOTPValidationInfo!.mobileNo;
    req.userName = widget.userOTPValidationInfo!.mobileNo;
    req.otp = _pinController.text;
    authService.otpFailedValidation(req);

    // Simulate OTP validation process
    final isSuccess = await _simulateApiCall(); // Simulated API call

    if (isSuccess) {
      setState(() {
        isPayButtonEnabled = true;
      });
    }
  }

  Widget buildInformationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            // Fixed width for labels to ensure alignment
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              ' :',
              style: TextStyle(fontSize: 17),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomPopupWithInput(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: myHexColor),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    bool isPayButtonEnabled = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                top: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title Text
                  Text(
                    'Enter ${widget.paymentOption}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // PIN/OTP Input Field
                  Pinput(
                    autofocus: false,
                    controller: _pinController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      if (widget.paymentOption == "PIN") {
                        _validatePin(context);
                      } else if (widget.paymentOption == "OTP") {
                        _submitOtp(context);
                      }

                      setState(() {
                        isPayButtonEnabled =
                            true; // Enable button after validation
                      });
                    },
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Authentication Type',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Pay Button
                  ElevatedButton(
                    onPressed: isPayButtonEnabled
                        ? () {
                            _handlePayButton(context);
                            Navigator.pop(context);
                          }
                        : null, // Disabled when false
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPayButtonEnabled
                          ? myHexColor
                          : Colors.grey, // Change color
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handlePayButton(BuildContext context) {
    if (widget.transaction == 'Wallet') {
      CommWalletTransaction req = CommWalletTransaction();
      req.bCurrency = widget.commWalletTransaction?.bCurrency;
      req.bName = widget.commWalletTransaction?.bName;
      req.bMob = widget.commWalletTransaction?.bMob;
      req.dCurrency = widget.commWalletTransaction?.dCurrency;
      req.dName = widget.commWalletTransaction?.dName;
      req.dMob = widget.commWalletTransaction?.dMob;
      req.dAccountNo = widget.commWalletTransaction?.dAccountNo;
      req.txnAmount = widget.commWalletTransaction?.txnAmount;
      req.remarks = widget.commWalletTransaction?.remarks;
      req.bIdNum = widget.commWalletTransaction?.bIdNum;
      req.dIdNum = widget.commWalletTransaction?.dIdNum;
      req.moduleType = widget.commWalletTransaction?.moduleType;
      req.crIdType = widget.commWalletTransaction?.crIdType;
      req.drIdType = widget.commWalletTransaction?.drIdType;
      req.securirityQuestion = widget.commWalletTransaction?.securirityQuestion;
      req.transId = txnRefNo;
      req.headerInfo = widget.loginResponse?.headerInfo;
      context
          .read<WalletTransactionBloc>()
          .add(WalletTransactionSubmitted(req));
    } else {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.bCurrency = widget.commTransaction?.bCurrency;
      commTransaction.bName = widget.commTransaction?.bName;
      commTransaction.bMob = widget.commTransaction?.bMob;
      commTransaction.dCurrency = widget.commTransaction?.dCurrency;
      commTransaction.dName = widget.commTransaction?.dName;
      commTransaction.dMob = widget.commTransaction?.dMob;
      commTransaction.txnAmount = widget.commTransaction?.txnAmount;
      commTransaction.remarks = widget.commTransaction?.remarks;
      commTransaction.bIdNum = widget.commTransaction?.bIdNum;
      commTransaction.dIdNum = widget.commTransaction?.dIdNum;
      commTransaction.moduleType = widget.commTransaction?.moduleType;
      commTransaction.securirityQuestion =
          widget.commTransaction?.securirityQuestion;
      commTransaction.transId = txnRefNo;
      commTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commTransaction.secType = "SEQ_VAL";
      commTransaction.bCurrency = 'USD';
      commTransaction.dCurrency = 'USD';
      commTransaction.securirityAns = 'sweert';
      context.read<SendMoneyBloc>().add(SendMoneySubmitted(commTransaction));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinValidationBloc(authService),
      child: MultiBlocListener(
        listeners: [
          BlocListener<WalletTransactionBloc, WalletTransactionState>(
            listener: (context, state) {
              if (state is WalletTransactionSuccess) {
                showSMSuccessDialog(
                    context, state.commWalletTransaction.uniqueId);
                AppLogger.info('Wallet transaction completed successfully');
              } else if (state is WalletTransactionFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<AccountWalletTransactionBloc,
              AccountWalletTransactionState>(
            listener: (context, state) {
              if (state is AccountWalletTransactionSuccess) {
                AppLogger.info(
                    'Account wallet transaction completed successfully');
              } else if (state is AccountWalletTransactionFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<SendMoneyBloc, SendMoneyState>(
            listener: (context, state) {
              if (state is SendMoneySuccess) {
                showSMSuccessDialog(context, state.commTransaction.uniqueId);
              } else if (state is SendMoneyFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
          BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
            listener: (context, state) {
              if (state is TransactionReceiptSuccess) {
                transactionPdf = state.transactionDetails.transactionPdf!;
                AppLogger.debug('Transaction receipt PDF received');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DownloadReceiptScreen(
                              transactionPdf: transactionPdf,
                              selectedBank: widget.selectedBank,
                            )));
              } else if (state is TransactionReceiptFailure) {
                showCustomBottomPopup(context, state.error);
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(
            title: "Authentication Screen",
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                SizedBox(height: 10),
                Text(
                  'Transaction Type : ', // Conditional check
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // Container for Transaction Details
                Container(
                  width: double.infinity, // Ensures full width
                  color: Colors.grey.shade300,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: 25),
                          Text(
                            'Reference ID : ', // Conditional check
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            txnRefNo,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${"ETB"} ${widget.enteredAmount}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Enter OTP Section
                SizedBox(height: 20),
                // Conditional display for Sender and Receiver Information
                if (widget.itemKey == 'SM' || widget.itemKey == 'SM_CASH') ...[
                  SizedBox(height: 10),
                  Text('Sender Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 10),
                  buildInformationRow(
                      'Name',
                      widget.commWalletTransaction?.dName ??
                          widget.commTransaction?.dName ??
                          'N/A'),
                  buildInformationRow(
                      'Account Number',
                      widget.commWalletTransaction?.dAccountNo ??
                          widget.commTransaction?.dAccountNo ??
                          'N/A'),
                  buildInformationRow(
                      'Mobile Number',
                      widget.commWalletTransaction?.dMob ??
                          widget.commTransaction?.dMob ??
                          'N/A'),
                  buildInformationRow(
                      'Amount',
                      widget.commWalletTransaction?.txnAmount.toString() ??
                          'N/A'),
                  buildInformationRow('Tax', ''),
                  buildInformationRow('Fee', ''),
                  SizedBox(height: 15),
                  Text('Receiver Information',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 10),
                  buildInformationRow(
                      'Name',
                      widget.commWalletTransaction?.bName ??
                          widget.commTransaction?.bName ??
                          'N/A'),
                  buildInformationRow(
                      'Account Number',
                      widget.commWalletTransaction?.bAccountNo ??
                          widget.commTransaction?.bAccountNo ??
                          ''),
                  buildInformationRow(
                      'Mobile Number',
                      widget.commWalletTransaction?.bMob ??
                          widget.commTransaction?.bMob ??
                          'N/A'),
                ],
                Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showBottomPopupWithInput(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myHexColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Proceed',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
