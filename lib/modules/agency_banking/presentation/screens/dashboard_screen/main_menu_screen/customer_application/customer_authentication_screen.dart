import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/EstatementEntity.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/UserOtpValidationInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_wallet_transaction/account_wallet_transaction_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../../constants/ModuleCode.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/CommAccountRequest.dart';
import '../../../../../data/models/CommTransaction.dart';
import '../../../../../data/models/CommTransactionDetails.dart';
import '../../../../../data/models/CommWalletTransaction.dart';
import '../../../../../data/models/login_models/LoginUserReqResInfo.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../utils/RandomNumberGenerator.dart';
import '../../../../blocs/account_transaction_bloc/account_transaction_bloc.dart';
import '../../../../blocs/account_transaction_bloc/account_transaction_event.dart';
import '../../../../blocs/account_transaction_bloc/account_transaction_state.dart';
import '../../../../blocs/account_wallet_transaction/account_wallet_transaction_bloc.dart';
import '../../../../blocs/account_wallet_transaction/account_wallet_transaction_event.dart';
import '../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../../../../blocs/pin_validation_bloc/pin_validation_event.dart';
import '../../../../blocs/send_money_bloc/send_money_bloc.dart';
import '../../../../blocs/send_money_bloc/send_money_event.dart';
import '../../../../blocs/send_money_bloc/send_money_state.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import '../../../../blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_bloc.dart';
import '../../../../blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_event.dart';
import '../../../../blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_state.dart';
import '../../../../blocs/wallet_receive_payment_bloc/wallet_receive_payment_bloc.dart';
import '../../../../blocs/wallet_receive_payment_bloc/wallet_receive_payment_event.dart';
import '../../../../blocs/wallet_receive_payment_bloc/wallet_receive_payment_state.dart';
import '../../../../blocs/wallet_transaction_bloc/wallet_transaction_bloc.dart';
import '../../../../blocs/wallet_transaction_bloc/wallet_transaction_event.dart';
import '../../../../blocs/wallet_transaction_bloc/wallet_transaction_state.dart';
import '../../../BaseScreen/base_screen.dart';
import '../../../Dashboard/widgets/BankSelectionScreen.dart';
import '../agent_application/transactions/download_receipt_screen.dart';

class AuthenticationScreen extends StatefulWidget
{
  final CommAccountRequest? commAccountRequest;
  final CommWalletAccountRequest? commWalletAccountRequest;
  final dynamic itemKey;
  final LoginUserReqResInfo? loginResponse;
  final CommAccountRequest? searchResponse;
  final String? transactionType;
  final String enteredAmount;
  final EstatementEntity? transaction;
  final String? name;
  final String? mobileNumber;
  final String? idType;
  final String? idNumber;
  final BankOption selectedBank;

  const AuthenticationScreen(
      {
        this.commAccountRequest, this.itemKey, this.loginResponse, this.searchResponse, this.transactionType,
        required this.commWalletAccountRequest, required this.enteredAmount, this.transaction, this.name, this.mobileNumber, this.idType, this.idNumber, required this.selectedBank,
      });

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends BaseScreenState<AuthenticationScreen> {
  TextEditingController _pinController = TextEditingController();
  String txnRefNo=RandomNumberGenerator.generateId('AGB', 13);
  bool _isExpanded = false;
  String? senderName;
  String? senderAcc;
  String? receiverName;
  String? receiverAcc;
  bool isOtpMode = true; // Toggle between OTP and PIN
  UserOTPValidationInfo? getOtp;
  bool isPayButtonEnabled = false;
  late String transactionPdf;
  void toggleAuthMode() {
    setState(() {
      isOtpMode = !isOtpMode;
      _pinController.clear(); // Clear input field when switching modes
    });
  }

  @override
  void initState() {
    super.initState();
    AppLogger.debug('CustomerAuthScreen initState - transaction: ${widget.transaction}');
    UserOTPValidationInfo otpIfo = UserOTPValidationInfo();
    otpIfo.headerInfo = widget.loginResponse!.headerInfo;
    otpIfo.mobileNo = widget.loginResponse!.loginUserInfo.userName ?? "";
    otpIfo.userName = widget.loginResponse!.loginUserInfo.userName ?? "";

    context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(otpIfo));

    if(widget.itemKey==ModuleCode.cbsToWallet)
    {
      senderName=widget.commAccountRequest?.customerName;
      senderAcc=widget.commAccountRequest!.accountNum;
      receiverName= widget.loginResponse?.loginUserInfo.firstName;
      receiverAcc=widget.loginResponse?.headerInfo.wallet_account_no;
    }
    if(widget.itemKey==ModuleCode.walletToCbs)
    {
      senderName=widget.loginResponse?.loginUserInfo.firstName;
      senderAcc=widget.loginResponse?.headerInfo.wallet_account_no;
      receiverName= widget.commAccountRequest?.customerName;
      receiverAcc=widget.commAccountRequest!.accountNum;
    }
    if(widget.itemKey == ModuleCode.fundTransfer )
    {
      if(widget.transaction==null)
      {
        if(widget.transactionType=='Account')
        {
          senderName=widget.commAccountRequest?.customerName;
          senderAcc=widget.commAccountRequest!.accountNum;
          receiverName= widget.searchResponse?.customerName;
          receiverAcc=widget.searchResponse?.accountNum;
        }
        else
        {
          senderName=widget.loginResponse?.loginUserInfo.firstName;
          senderAcc=widget.loginResponse?.headerInfo.wallet_account_no;
          receiverName= widget.commWalletAccountRequest?.customerName;
          receiverAcc=widget.commWalletAccountRequest?.accountNum;
        }
      }
      else
      {
        senderName=widget.transaction?.dCustomerName;
        senderAcc=widget.transaction?.dAccountNo;
        receiverName= widget.transaction?.cCustomerName;
        receiverAcc=widget.transaction?.cAccountNo;
      }
    }
    if(widget.itemKey == 'REC_PAY' )
    {
      if(widget.transaction == null){
        if(widget.transactionType=='Account')
        {
          senderName=widget.searchResponse?.customerName;
          senderAcc=widget.searchResponse!.accountNum;
          receiverName= widget.loginResponse?.loginUserInfo.firstName;
          receiverAcc=widget.loginResponse?.headerInfo.wallet_account_no;
        }
        else
        {
          senderName=widget.commWalletAccountRequest?.customerName;
          senderAcc=widget.commWalletAccountRequest?.accountNum;
          receiverName= widget.loginResponse?.loginUserInfo.firstName;
          receiverAcc=widget.loginResponse?.headerInfo.wallet_account_no;
        }
      }
      else{
        senderName=widget.transaction?.dCustomerName;
        senderAcc=widget.transaction?.dAccountNo;
        receiverName= widget.transaction?.cCustomerName;
        receiverAcc=widget.transaction?.cAccountNo;
      }
    }

    if(widget.itemKey==ModuleCode.corporatePayment)
    {
      if(widget.transaction==null)
      {
        senderName=widget.loginResponse?.loginUserInfo.firstName ;
        senderAcc=widget.loginResponse?.headerInfo.wallet_account_no ;
        receiverName= widget.commWalletAccountRequest?.customerName;
        receiverAcc=widget.commWalletAccountRequest?.accountNum ;
      }
      else
      {
        senderName=widget.transaction?.dCustomerName ;
        senderAcc= widget.transaction?.dAccountNo;
        receiverName=  widget.transaction?.cCustomerName;
        receiverAcc=widget.transaction?.cAccountNo;
      }
    }

    if(widget.itemKey == 'SM' && widget.transactionType == 'Account'){
      senderName=widget.commAccountRequest?.customerName;
      senderAcc=widget.loginResponse?.headerInfo.cb_account_no;
      receiverName = widget.name;
    }
    if(widget.itemKey == 'SM' && widget.transactionType == 'Wallet'){
      senderName=widget.loginResponse?.loginUserInfo.firstName;
      senderAcc=widget.loginResponse?.headerInfo.wallet_account_no;
      receiverName = widget.name;
    }
  }
  void _showTransactionSuccessDialog(BuildContext context, String txnRefNo) {
    showDialog(
      context: context,
      // barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Reduced border radius for AlertDialog
          ),
          contentPadding: EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Icon Background with lighter shade of myHexColor
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Inner circle color
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: myHexColor.withOpacity(0.3), // Light shade of myHexColor for the border
                    width: 4.0, // Border thickness
                  ),
                ),
                child: Icon(
                  Icons.check, // Single check mark icon
                  size: 60,
                  color: myHexColor, // Tick mark in your myHexColor
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Transaction Successful',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'TRANSACTION DONE SUCCESSFULLY\nYour Txn Ref No is $txnRefNo',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: myHexColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      CommTransactionDetails transactionDetails = CommTransactionDetails();
                      transactionDetails.headerInfo = widget.loginResponse!.headerInfo;
                      transactionDetails.transId = txnRefNo;
                      context.read<TransactionReceiptBloc>().add(
                        TransactionReceiptSubmitted(transactionDetails),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: myHexColor,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'View receipt',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
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
    if (pin.length !=6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pin must be exactly 6 digits')),
      );
      return;
    }
    CommTransaction req = CommTransaction();
    req.headerInfo=getOtp?.headerInfo;
    req.custPin = _pinController.text;
    context.read<PinValidationBloc>().add(
        PinValidationSubmitted(req));
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
    req.headerInfo =getOtp!.headerInfo;
    req.otpuniqueid = getOtp?.otpuniqueid;
    req.mobileNo =getOtp!.mobileNo;
    req.userName = getOtp!.mobileNo;
    req.otp = _pinController.text;
    AuthService().otpFailedValidation(req);
    final isSuccess = await _simulateApiCall(); // Simulated API call

    if (isSuccess) {
      setState(() {
        isPayButtonEnabled = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          title: "Authentication Screen",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          child: MultiBlocListener(
            listeners: [
              // Listener for ForgotPasswordBloc
              BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordSuccess) {
                    setState(() {
                      getOtp = state.userOtp;
                    });
                  } else if (state is ForgotPasswordFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
              BlocListener<WalletTransactionBloc, WalletTransactionState>(
                listener: (context, state) {
                  if (state is WalletTransactionSuccess) {
                    if (widget.itemKey == 'SM') {
                      // Show a different dialog for sending money
                      showSendMoneySuccessDialog(context, state.commWalletTransaction.uniqueId,
                          state.commWalletTransaction.txnStatus);
                    } else {
                      // Default success dialog
                      _showTransactionSuccessDialog(context, txnRefNo);
                    }
                  } else if (state is WalletTransactionFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),

              BlocListener<SendMoneyBloc, SendMoneyState>(
                listener: (context, state) {
                  if (state is SendMoneySuccess) {
                    showSendMoneySuccessDialog(context, state.commTransaction.uniqueId, state.commTransaction.txnStatus);
                  } else if (state is SendMoneyFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
              BlocListener<AccountTransactionBloc, AccountTransactionState>(
                listener: (context, state) {
                  if (state is AccountTransactionSuccess) {
                    AppLogger.info('Customer account transaction completed successfully');
                    _showTransactionSuccessDialog(context,txnRefNo);
                  } else if (state is AccountTransactionFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },

              ),
              BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
                listener: (context, state) {
                  if (state is TransactionReceiptSuccess) {
                    transactionPdf = state.transactionDetails.transactionPdf!;
                    AppLogger.debug('Transaction receipt PDF received');
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadReceiptScreen(transactionPdf: transactionPdf, selectedBank: widget.selectedBank,)));
                  } else if (state is TransactionReceiptFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
              BlocListener<WalletTransactionBloc, WalletTransactionState>(
                listener: (context, state) {
                  if (state is WalletTransactionSuccess) {
                    if(widget.itemKey!='SM')
                    {
                      _showTransactionSuccessDialog(context,txnRefNo);
                    }
                  } else if (state is WalletTransactionFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
              BlocListener<TrustaccountWallettransactionBloc, TrustaccountWallettransactionState>(
                listener: (context, state) {
                  if (state is TrustaccountWallettransactionSuccess) {
                    _showTransactionSuccessDialog(context,txnRefNo);
                  } else if (state is TrustaccountWallettransactionFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
              BlocListener<WalletReceivePaymentBloc, WalletReceivePaymentState>(
                listener: (context, state) {
                  if (state is WalletReceivePaymentSuccess) {
                    _showTransactionSuccessDialog(context,txnRefNo);
                  } else if (state is WalletReceivePaymentFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },

              ),
              BlocListener<AccountWalletTransactionBloc, AccountWalletTransactionState>(
                listener: (context, state) {
                  if (state is AccountWalletTransactionSuccess) {
                    _showTransactionSuccessDialog(context,txnRefNo);
                  } else if (state is AccountWalletTransactionFailure) {
                    showCustomBottomPopup(context, state.error);
                  }
                },
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  senderName?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  senderAcc!.length > 4
                      ? 'XXXX' + senderAcc!.substring(
                      senderAcc!.length - 4)
                      : senderAcc! ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                SizedBox(height: 20),

                /// **Main Transaction Container**
                Container(
                  width: double.infinity, // Ensures full width
                  color: Colors.grey.shade200,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Sending',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 180),  // Adjust the width as needed
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                receiverName ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ETB 1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                /// **Expanded Details (Completely Separate)**
                if (_isExpanded)
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Paying To:", receiverName?? ''),
                        _buildDetailRow("Amount:", "₹1.00"),
                        _buildDetailRow("Account:", senderAcc!.length > 4
                            ? 'XXXX' + senderAcc!.substring(
                            senderAcc!.length - 4)
                            : senderAcc! ?? "",),
                        _buildDetailRow("Ref ID:", txnRefNo),
                      ],
                    ),
                  ),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    isOtpMode ? "ENTER OTP" : "ENTER PIN",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: 240, // Set an appropriate width
                    child: Pinput(
                      autofocus: false,
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: PinTheme(
                        width: 40,
                        height: 40,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                      obscureText: !isOtpMode, // Hide text for PIN input
                      keyboardType: TextInputType.number,
                      onCompleted: (pin) {
                        if (isOtpMode) {
                          // Submit OTP if in OTP mode
                          _submitOtp(context);
                        } else {
                          // Validate PIN if in PIN mode
                          _validatePin(context);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: toggleAuthMode, // Toggle between OTP and PIN
                  child: Center(
                    child: Text(
                      "Authentication Type",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: isPayButtonEnabled
                          ? () {
                        handlePayButton(context);  // Call the method if enabled
                      }
                          : null, // Disable button if not enabled
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPayButtonEnabled
                            ? myHexColor  // Use custom color when enabled
                            : Colors.grey,  // Use grey when disabled
                        padding: EdgeInsets.symmetric(horizontal: 170, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Pay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3, // More space for the label
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(width: 5), // Small gap for better spacing
          Text(
            ":",
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(width: 10), // Add some space after the colon
          Expanded(
            flex: 5, // More space for values but keeping left alignment
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void handlePayButton(BuildContext context)
  {
    if(widget.itemKey==ModuleCode.cbsToWallet)
    {
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.headerInfo=widget.loginResponse?.headerInfo;
      commWalletTransaction.transId=txnRefNo;
      commWalletTransaction.txnAmount=double.tryParse(widget.enteredAmount);
      commWalletTransaction.moduleType=widget.itemKey;
      commWalletTransaction.bAccountNo=widget.loginResponse?.headerInfo.wallet_account_no;
      commWalletTransaction.dAccountNo=widget.commAccountRequest?.accountNum;
      commWalletTransaction.dCurrency="USD";
      commWalletTransaction.lnBrn="000";
      commWalletTransaction.dName=widget.commAccountRequest?.customerName;
      commWalletTransaction.dMob=widget.commAccountRequest?.mobileno;
      commWalletTransaction.bName=widget.loginResponse?.loginUserInfo.firstName;
      commWalletTransaction.bMob=widget.loginResponse?.headerInfo.userName;
      commWalletTransaction.bIdType=widget.loginResponse?.headerInfo.userType;
      commWalletTransaction.cwalltype="L2024022221";
      commWalletTransaction.cBranch="000";
      commWalletTransaction.dBranch="000";
      commWalletTransaction.bCurrency="USD";
      context.read<AccountWalletTransactionBloc>().add(
          AccountWalletTransactionSubmitted(commWalletTransaction)
      );
    }
    if(widget.itemKey==ModuleCode.walletToCbs)
    {
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.dAccountNo =  widget.loginResponse?.headerInfo.wallet_account_no;
      commWalletTransaction.headerInfo = widget.commAccountRequest?.headerInfo;
      commWalletTransaction.moduleType = widget.itemKey;
      commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commWalletTransaction.transId = txnRefNo;
      commWalletTransaction.dwalltyp = "L2024022221";
      commWalletTransaction.dIdType = widget.loginResponse?.headerInfo.userType;
      commWalletTransaction.bAccountNo =widget.commAccountRequest?.accountNum;
      commWalletTransaction.lnBrn="000";
      commWalletTransaction.bCurrency=widget.commAccountRequest?.accCcy;
      context.read<AccountWalletTransactionBloc>().add(
        AccountWalletTransactionSubmitted(commWalletTransaction),
      );
    }
    if (widget.itemKey == ModuleCode.fundTransfer && widget.transactionType=='Account') {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.dAccountNo =senderAcc;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = txnRefNo;
      commTransaction.bAccountNo = receiverAcc;
      if(widget.transaction==null)
      {
        commTransaction.headerInfo = widget.commAccountRequest?.headerInfo;
        commTransaction.dMob = widget.commAccountRequest?.mobileno;
      }
      else
      {
        commTransaction.headerInfo = widget.loginResponse?.headerInfo;
        commTransaction.dMob = widget.transaction?.cMobileNo;
      }
      context.read<AccountTransactionBloc>().add(
        AccountTransactionSubmitted(commTransaction),
      );
    }
    if (widget.itemKey == ModuleCode.fundTransfer && widget.transactionType=='Wallet') {
      CommWalletTransaction commTransaction = CommWalletTransaction();
      commTransaction.dAccountNo = senderAcc;
      commTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = txnRefNo;
      commTransaction.dMob = widget.loginResponse?.headerInfo.userName;
      commTransaction.dwalltyp = "L2024022221";
      commTransaction.bAccountNo = receiverAcc;
      context.read<WalletTransactionBloc>().add(
        WalletTransactionSubmitted(commTransaction),
      );
    }
    if( widget.itemKey == ModuleCode.corporatePayment){
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.bAccountNo = receiverAcc;
      commWalletTransaction.bMob = widget.searchResponse?.mobileno;
      commWalletTransaction.bName = receiverName;
      commWalletTransaction.dAccountNo = widget.loginResponse?.headerInfo.wallet_account_no;
      commWalletTransaction.dMob = widget.loginResponse?.loginUserInfo.userName;
      commWalletTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commWalletTransaction.moduleType = widget.itemKey;
      commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commWalletTransaction.transId = txnRefNo;
      context.read<TrustaccountWallettransactionBloc>().add(
          TrustaccountWallettransactionSubmitted(commWalletTransaction));
    }
    if(widget.itemKey=='REC_PAY')
    {
      if(widget.transactionType=='Wallet')
      {
        CommWalletTransaction commWalletTransaction = CommWalletTransaction();
        commWalletTransaction.bAccountNo = receiverAcc;
        commWalletTransaction.bMob = widget.loginResponse?.headerInfo.userName;
        commWalletTransaction.bName = receiverName;
        commWalletTransaction.dAccountNo = senderAcc;
        commWalletTransaction.dMob = widget.searchResponse?.mobileno;
        commWalletTransaction.headerInfo = widget.loginResponse?.headerInfo;
        commWalletTransaction.moduleType = widget.itemKey;
        commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
        commWalletTransaction.transId = txnRefNo;
        commWalletTransaction.dwalltyp="L2024022221";
        context.read<WalletReceivePaymentBloc>().add(
            WalletReceivePaymentSubmitted(commWalletTransaction));
      }
      else
      {
        CommTransaction commTransaction=CommTransaction();
        commTransaction.headerInfo=widget.loginResponse?.headerInfo;
        commTransaction.bAccountNo=widget.loginResponse?.headerInfo.cb_account_no;
        commTransaction.initTime = DateTime(2025, 8, 5);
        AppLogger.debug('Processing customer CBS to wallet transaction');
        commTransaction.bMob=widget.loginResponse?.headerInfo.userName;
        commTransaction.dAccountNo=senderAcc;
        commTransaction.moduleType=widget.itemKey;
        commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
        commTransaction.transId = txnRefNo;
        commTransaction.lnBrn='000';
        context.read<AccountTransactionBloc>().add(
          AccountTransactionSubmitted(commTransaction),
        );
      }
    }
    if(widget.itemKey == 'SM' && widget.transactionType == 'Wallet'){
      CommWalletTransaction commTransaction = CommWalletTransaction();
      commTransaction.dAccountNo = widget.loginResponse?.headerInfo.wallet_account_no;
      commTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = txnRefNo;
      commTransaction.dMob = widget.loginResponse?.headerInfo.userName;
      commTransaction.bAccountNo = widget.commWalletAccountRequest?.accountNum;
      context.read<WalletTransactionBloc>().add(
        WalletTransactionSubmitted(commTransaction),
      );
    }

    if(widget.itemKey == 'SM' && widget.transactionType == 'Account'){
      CommTransaction commTransaction = CommTransaction();
      commTransaction.bIdNum = widget.idNumber;
      commTransaction.bIdType = widget.idType;
      commTransaction.bMob = widget.mobileNumber;
      commTransaction.bName = widget.name;
      commTransaction.dAccountNo =widget.loginResponse?.headerInfo.cb_account_no;
      commTransaction.dBranch = widget.loginResponse?.headerInfo.branchCode;
      commTransaction.dCurrency = widget.loginResponse?.headerInfo.currency;
      commTransaction.dMob = widget.loginResponse?.headerInfo.userName;
      commTransaction.dName = widget.loginResponse?.loginUserInfo.firstName;
      commTransaction.secType = 'ID_VAL';
      commTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = txnRefNo;
      commTransaction.dMob = widget.loginResponse?.headerInfo.userName;
      commTransaction.bAccountNo = widget.commAccountRequest?.accountNum;
      context.read<SendMoneyBloc>().add(
        SendMoneySubmitted(commTransaction),
      );
    }
  }
}

