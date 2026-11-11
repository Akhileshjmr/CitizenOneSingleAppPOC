import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommRequestMoney.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommTransaction.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_transaction_bloc/account_transaction_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_state.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../constants/ModuleCode.dart';
import '../../../../../core/utils/otp_timer_controller.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../data/models/CommFeeCalulation.dart';
import '../../../../../data/models/CommTransactionDetails.dart';
import '../../../../../data/models/CommWalletTransaction.dart';
import '../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../data/services/AuthService.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../../utils/CommDialog.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../utils/Loader.dart';
import '../../../../blocs/account_transaction_bloc/account_transaction_bloc.dart';
import '../../../../blocs/account_transaction_bloc/account_transaction_event.dart';
import '../../../../blocs/account_wallet_transaction/account_wallet_transaction_bloc.dart';
import '../../../../blocs/account_wallet_transaction/account_wallet_transaction_event.dart';
import '../../../../blocs/account_wallet_transaction/account_wallet_transaction_state.dart';
import '../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../blocs/request_money_bloc/request_money_bloc.dart';
import '../../../../blocs/request_money_bloc/request_money_event.dart';
import '../../../../blocs/send_money_bloc/send_money_event.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_event.dart';
import '../../../../blocs/transaction_receipt_bloc/transaction_receipt_state.dart';
import '../../../../blocs/wallet_transaction_bloc/wallet_transaction_bloc.dart';
import '../../../../blocs/wallet_transaction_bloc/wallet_transaction_event.dart';
import '../../../../screens/Dashboard/dashboard_mobile_layout.dart';
import '../../../../screens/Dashboard/widgets/BankSelectionScreen.dart';
import '../../../../screens/dashboard_screen/main_menu_screen/agent_application/transactions/download_receipt_screen.dart';
import '../widgets/bloc_listener.dart';

class AuthenticationScreen2 extends StatefulWidget {
  final String enteredAmount;
  final dynamic itemKey;
  final CommTransaction? commTransaction;
  final UserOTPValidationInfo? userOTPValidationInfo;
  final CommFeeCalculation charges;
  final CommAccountRequest? senderResponse;
  final CommWalletAccountRequest? send;
  final CommAccountRequest? receiverResponse;
  final CommWalletAccountRequest? receive;
  final String? customerName;
  final String accountNumber;
  final String? mobileNumber;
  final String? transactionType;
  final CommWalletTransaction? commWalletTransaction;
  final CommWalletAccountRequest? commWalletAccountRequest;
  final CommAccountRequest? commAccountRequest;
  final LoginUserReqResInfo? loginResponse;
  final CommRequestMoney? requestList;
  final BankOption selectedBank;
  final String txnId; // pass original txnID

  AuthenticationScreen2({
    required this.enteredAmount,
    this.itemKey,
    this.commTransaction,
    this.userOTPValidationInfo,
    required this.charges,
    this.senderResponse,
    this.receiverResponse,
    this.send,
    this.receive,
    this.customerName,
    required this.accountNumber,
    this.mobileNumber,
    this.transactionType,
    this.commWalletTransaction,
    this.commWalletAccountRequest,
    this.commAccountRequest,
    this.loginResponse,
    this.requestList,
    required this.selectedBank,
    required this.txnId,
  });

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen2> {
  final Color disabledButtonColor = Colors.grey;
  TextEditingController _pinController = TextEditingController();
  final AuthService authService = AuthService();

  //String txnRefNo=RandomNumberGenerator.generateId('AGB', 13);
  late String transactionPdf;
  String otpId = "";
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();
  static const int _maxOtpAttempts = 2; // TOTAL including first
  int _otpAttemptCount = 0;

  /* bool _canResendOtp = false;
  bool _timerStarted = false;
  bool _showLimitMessage = false;

  int _resendSeconds = 30;
  Timer? _resendTimer;
*/
  bool _otpSheetOpen = false;
  bool _isProcessingPayment = false;
  final OtpTimerController _otpTimerController = OtpTimerController(
    totalSeconds: 30,
    maxAttempts: 3,
  );

  @override
  void initState() {
    _otpTimerController.startTimer(countAttempt: false);
    super.initState();
  }

  @override
  void dispose() {
    _otpTimerController.dispose();
    //_resendTimer?.cancel();
    super.dispose();
  }

  /*void _startResendTimer(void Function(void Function()) setDialogState) {
    _resendTimer?.cancel();

    setDialogState(() {
      _resendSeconds = 30;
      _canResendOtp = false;
      _showLimitMessage = false; // reset every cycle
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();

        setDialogState(() {
          if (_otpAttemptCount >= _maxOtpAttempts) {
            // 🔥 SHOW ONLY AFTER TIMER
            _showLimitMessage = true;
            _canResendOtp = false;
          } else {
            _canResendOtp = true;
          }
        });
      } else {
        setDialogState(() {
          _resendSeconds--;
        });
      }
    });
  }*/

  void _resendOtp(BuildContext context) {
    if (_otpAttemptCount >= _maxOtpAttempts) return;

    _otpAttemptCount++; // ✅ increment here ONLY

    UserOTPValidationInfo request = UserOTPValidationInfo();
    if (widget.itemKey == ModuleCode.withdrawal) {
      if (widget.commWalletAccountRequest != null) {
        request.headerInfo = (widget.commWalletAccountRequest?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.commWalletAccountRequest?.mobileno ?? " ";
        request.userName = widget.commWalletAccountRequest?.mobileno ?? "";
      } else {
        request.headerInfo = widget.loginResponse!.headerInfo;
        request.mobileNo = widget.loginResponse?.headerInfo.userName ?? "";
        request.userName = widget.loginResponse?.headerInfo.userName ?? "";
      }
    } else if (widget.itemKey == ModuleCode.deposit) {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? "";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    } else if (widget.itemKey == ModuleCode.fundTransfer ||
        widget.itemKey == ModuleCode.cbsToWallet ||
        widget.itemKey == ModuleCode.walletToCbs) {
      if (widget.send != null) {
        request.headerInfo = widget.send!.headerInfo;
        request.mobileNo = widget.send?.mobileno ?? "";
        request.userName = widget.send?.mobileno ?? "";
      } else {
        request.headerInfo = (widget.senderResponse?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.loginResponse?.headerInfo.userName ?? " ";
        request.userName = widget.loginResponse?.headerInfo.userName ?? "";
      }
    } else if (widget.requestList != null) {
      request.headerInfo = widget.loginResponse!.headerInfo;
    } else {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? " ";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    }

    context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(request));
  }

  bool isPayButtonEnabled = false;

  String _getTransactionType(String? itemKey) {
    switch (itemKey) {
      case ModuleCode.deposit:
        return 'Deposit';
      case ModuleCode.withdrawal:
        return 'Withdrawal';
      case ModuleCode.fundTransfer:
        return 'Fund Transfer';
      case ModuleCode.cbsToWallet:
        return 'Wallet Topup';
      case ModuleCode.walletToCbs:
        return 'Wallet Redeem';
      default:
        return '';
    }
  }

  void _sendOtpAndOpenPopup(BuildContext context) {
    UserOTPValidationInfo request = UserOTPValidationInfo();

    if (widget.itemKey == ModuleCode.withdrawal) {
      if (widget.commWalletAccountRequest != null) {
        request.headerInfo = (widget.commWalletAccountRequest?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.commWalletAccountRequest?.mobileno ?? "";
        request.userName = widget.commWalletAccountRequest?.mobileno ?? "";
      } else {
        request.headerInfo = widget.loginResponse!.headerInfo;
        request.mobileNo = widget.commAccountRequest?.phoneNum ?? "";
        request.userName = widget.commAccountRequest?.phoneNum ?? "";
      }
    } else if (widget.itemKey == ModuleCode.deposit) {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? "";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    } else if (widget.itemKey == ModuleCode.fundTransfer ||
        widget.itemKey == ModuleCode.cbsToWallet ||
        widget.itemKey == ModuleCode.walletToCbs) {
      if (widget.send != null) {
        request.headerInfo = widget.send!.headerInfo;
        request.mobileNo = widget.send?.mobileno ?? "";
        request.userName = widget.send?.mobileno ?? "";
      } else {
        request.headerInfo = (widget.senderResponse?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.senderResponse?.phoneNum ?? "";
        request.userName = widget.senderResponse?.phoneNum ?? "";
      }
    } else {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? "";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    }

    // Call OTP API
    context.read<ForgotPasswordBloc>().add(
          ForgotPasswordSubmitted(request),
        );
  }

  /* void _showBottomPopupWithInput(BuildContext context, String paymentOption) {
    context.read<PinValidationBloc>().add(ResetPinValidationState());
    //context.read<ForgotPasswordBloc>().add(ResetForgotPasswordState());

    _pinController.clear();
    _timerStarted = false;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fbLiteDark),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 🔥 start resend timer ONLY ONCE
            if (paymentOption == "OTP" && !_timerStarted) {
              _timerStarted = true;
              _startResendTimer(setState);
            }

            return SafeArea(
              child: MultiBlocListener(
                listeners: [
                  BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is OtpValidationFailure) {
                        showCustomBottomPopup(context, "Invalid OTP");
                      }
                    },
                  ),
                ],
                child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                  builder: (context, forgotState) {
                    return BlocBuilder<PinValidationBloc, PinValidationState>(
                      builder: (context, pinState) {
                        bool isPayEnabled = pinState is PinValidationSuccess ||
                            forgotState is OtpValidationSuccess;

                        return SingleChildScrollView(
                          child: Container(
                            key: ValueKey(
                              paymentOption == "OTP"
                                  ? 'bottomsheet_otp'
                                  : 'bottomsheet_pin',
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 24,
                              top: 20,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Enter $paymentOption",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Pinput(
                                  autofocus: false,
                                  key: ValueKey(
                                    paymentOption == "OTP"
                                        ? 'input_otp'
                                        : 'input_pin',
                                  ),
                                  controller: _pinController,
                                  length: 6,
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  showCursor: true,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  onCompleted: (value) {
                                    if (paymentOption == "PIN") {
                                      _validatePin(context);
                                    } else {
                                      _submitOtp(context);
                                    }
                                  },
                                ),

                                /// 🔁 RESEND OTP UI (ONLY FOR OTP)
                                if (paymentOption == "OTP") ...[
                                  const SizedBox(height: 12),

                                  /// 🚫 LIMIT MESSAGE — only AFTER last timer finishes
                                  if (_showLimitMessage)
                                    const Text(
                                      "Resend OTP limit reached",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )

                                  /// 🔁 RESEND BUTTON — timer finished & attempts left
                                  else if (_canResendOtp)
                                    TextButton(
                                      onPressed: () {
                                        _resendOtp(context);
                                        _startResendTimer(setState);
                                      },
                                      child: Text(
                                        "Resend OTP (${_maxOtpAttempts - _otpAttemptCount} attempts left)",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    )

                                  /// ⏳ TIMER — default state
                                  else
                                    Text(
                                      "Resend OTP in $_resendSeconds sec",
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                ],

                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: buildActionButton(
                                    label: 'Pay',
                                    onPressed: isPayEnabled
                                        ? () {
                                            _handlePayButton(context);
                                            //Navigator.pop(context);
                                          }
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      context.read<ForgotPasswordBloc>().add(
            ResetForgotPasswordState(),
          );
    });
  }*/

  void _showBottomPopupWithInput(BuildContext context, String paymentOption) {
    if (_otpSheetOpen) return; // 🔒 prevent duplicate sheet (e.g. on resend)
    _otpSheetOpen = true;

    context.read<PinValidationBloc>().add(ResetPinValidationState());
    _pinController.clear();
    //_timerStarted = false;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.fbLiteDark),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      // 🔒 stop tap-outside / swipe-down from closing the sheet
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            if (paymentOption == "OTP" /*&& !_timerStarted*/) {
              /* _timerStarted = true;
              _startResendTimer(setState);*/
              _otpTimerController.startTimer();
            }

            return PopScope(
              // 🔒 block Android back button too
              canPop: false,
              child: SafeArea(
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
                      listener: (context, state) {
                        if (state is OtpValidationFailure) {
                          isDismissible:
                          true;
                          enableDrag:
                          true;
                          //showCustomBottomPopup(context, "Invalid OTP");
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, forgotState) {
                      return BlocBuilder<PinValidationBloc, PinValidationState>(
                        builder: (context, pinState) {
                          bool isPayEnabled =
                              pinState is PinValidationSuccess ||
                                  forgotState is OtpValidationSuccess;

                          // 🔒 loading = waiting for server response
                          // Replace these with your actual loading state classes
                          bool isLoading = pinState is PinValidationLoading ||
                              forgotState is ForgotPasswordLoading;

                          return AbsorbPointer(
                            absorbing: isLoading,
                            // 🔒 blocks all taps while loading
                            child: SingleChildScrollView(
                              child: Container(
                                key: ValueKey(
                                  paymentOption == "OTP"
                                      ? 'bottomsheet_otp'
                                      : 'bottomsheet_pin',
                                ),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          24,
                                  top: 20,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Enter $paymentOption",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Pinput(
                                      autofocus: false,
                                      key: ValueKey(
                                        paymentOption == "OTP"
                                            ? 'input_otp'
                                            : 'input_pin',
                                      ),
                                      controller: _pinController,
                                      length: 6,
                                      defaultPinTheme: defaultPinTheme,
                                      focusedPinTheme: focusedPinTheme,
                                      submittedPinTheme: submittedPinTheme,
                                      showCursor: true,
                                      obscureText: true,
                                      obscuringCharacter: "*",
                                      onCompleted: (value) {
                                        if (paymentOption == "PIN") {
                                          _validatePin(context);
                                        } else {
                                          _submitOtp(context);
                                        }
                                      },
                                    ),
                                    /* if (paymentOption == "OTP") ...[
                                      const SizedBox(height: 12),
                                      if (_showLimitMessage)
                                        const Text(
                                          "Resend OTP limit reached",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      else if (_canResendOtp)
                                        TextButton(
                                          onPressed: () {
                                            _resendOtp(context);
                                            _startResendTimer(setState);
                                          },
                                          child: Text(
                                            "Resend OTP (${_maxOtpAttempts - _otpAttemptCount} attempts left)",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        )
                                      else
                                        */ /*Text(
                                          "Resend OTP in $_resendSeconds sec",
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),*/ /*
                                        ValueListenableBuilder<String>(
                                          valueListenable: _otpTimerController.displayText,
                                          builder: (context, text, _) {
                                            return ValueListenableBuilder<Color>(
                                              valueListenable: _otpTimerController.textColor,
                                              builder: (context, color, __) {
                                                return Text(
                                                  text,
                                                  style: TextStyle(color: color),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                    ],*/
                                    if (paymentOption == "OTP") ...[
                                      const SizedBox(height: 12),
                                      ValueListenableBuilder<bool>(
                                        valueListenable:
                                            _otpTimerController.isEnabled,
                                        builder: (context, enabled, _) {
                                          return ValueListenableBuilder<String>(
                                            valueListenable:
                                                _otpTimerController.displayText,
                                            builder: (context, text, __) {
                                              return ValueListenableBuilder<
                                                  Color>(
                                                valueListenable:
                                                    _otpTimerController
                                                        .textColor,
                                                builder: (context, color, ___) {
                                                  // Case 1: max attempts reached
                                                  if (_otpTimerController
                                                      .hasReachedMaxAttempts) {
                                                    return Text(
                                                      text,
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    );
                                                  }

                                                  // Case 2: countdown running (disabled state)
                                                  if (!enabled) {
                                                    return Text(
                                                      text,
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    );
                                                  }

                                                  // Case 3: ready to resend (enabled, tappable)
                                                  return TextButton(
                                                    onPressed: () {
                                                      _resendOtp(context);
                                                      _otpTimerController
                                                          .startTimer();
                                                    },
                                                    child: Text(
                                                      "Resend OTP (${_otpTimerController.attemptsLeft} attempts left)",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: isLoading
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          : buildActionButton(
                                              label: 'Pay',
                                              onPressed: isPayEnabled
                                                  ? () {
                                                      _handlePayButton(context);
                                                    }
                                                  : null,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _otpSheetOpen = false; // 🔒 reset flag once sheet actually closes
      context.read<ForgotPasswordBloc>().add(
            ResetForgotPasswordState(),
          );
    });
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
    CommTransaction req = CommTransaction();
    if (widget.itemKey == ModuleCode.fundTransfer) {
      if (widget.senderResponse != null) {
        // req.headerInfo = widget.senderResponse?.headerInfo;
        req.dMob = widget.senderResponse?.headerInfo.userName;
      } else {
        // req.headerInfo = widget.send?.headerInfo;
        req.dMob = widget.send?.headerInfo.userName;
      }
    }
    if (widget.itemKey == ModuleCode.walletToCbs) {
      req.headerInfo = widget.send?.headerInfo;
      req.dMob = widget.send?.mobileno;
    }
    if (widget.itemKey == ModuleCode.cbsToWallet) {
      req.headerInfo = widget.senderResponse?.headerInfo;
      req.dMob = widget.senderResponse?.headerInfo.userName;
    }

    if (widget.itemKey == ModuleCode.withdrawal ||
        widget.itemKey == ModuleCode.deposit ||
        widget.itemKey == ModuleCode.receiveRequest) {
      if (widget.commAccountRequest != null) {
        req.headerInfo = widget.commAccountRequest?.headerInfo;
        req.dMob = widget.commAccountRequest?.headerInfo.userName;
      } else if (widget.requestList != null) {
        req.headerInfo = widget.userOTPValidationInfo?.headerInfo;
        req.dMob = widget.commWalletAccountRequest?.headerInfo.userName;
      } else {
        req.headerInfo = widget.commWalletAccountRequest?.headerInfo;
        req.dMob = widget.commWalletAccountRequest?.headerInfo.userName;
      }
    }
    req.custPin = AESEncryptionService.encrypt(_pinController.text);
    context.read<PinValidationBloc>().add(PinValidationSubmitted(req));
  }

  void _submitOtp(BuildContext context) {
    final otp = _pinController.text; // Null-safe trim

    if (otp.isEmpty) {
      showCustomBottomPopup(context, "Enter OTP");
      return;
    }
    if (otp.length != 6) {
      showCustomBottomPopup(context, "OTP must be exactly 6 digits");
      return;
    }
    UserOTPValidationInfo request = UserOTPValidationInfo();
    request.otpuniqueid = otpValidationInfo.otpuniqueid;
    request.otp = _pinController.text;
    if (widget.itemKey == ModuleCode.withdrawal) {
      if (widget.commWalletAccountRequest != null) {
        request.headerInfo = (widget.commWalletAccountRequest?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.commWalletAccountRequest?.mobileno ?? " ";
        request.userName = widget.commWalletAccountRequest?.mobileno ?? "";
      } else {
        request.headerInfo = widget.loginResponse!.headerInfo;
        request.mobileNo = widget.commAccountRequest?.phoneNum ?? "";
        request.userName = widget.commAccountRequest?.phoneNum ?? "";
      }
    } else if (widget.itemKey == ModuleCode.deposit) {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? "";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    } else if (widget.itemKey == ModuleCode.fundTransfer ||
        widget.itemKey == ModuleCode.cbsToWallet ||
        widget.itemKey == ModuleCode.walletToCbs) {
      if (widget.send != null) {
        request.headerInfo = widget.send!.headerInfo;
        request.mobileNo = widget.send?.mobileno ?? "";
        request.userName = widget.send?.mobileno ?? "";
      } else {
        request.headerInfo = (widget.senderResponse?.headerInfo ??
            widget.loginResponse?.headerInfo)!;
        request.mobileNo = widget.senderResponse?.phoneNum ?? " ";
        request.userName = widget.senderResponse?.phoneNum ?? "";
      }
    } else if (widget.requestList != null) {
      request.headerInfo = widget.loginResponse!.headerInfo;
    } else {
      request.headerInfo = widget.loginResponse!.headerInfo;
      request.mobileNo = widget.loginResponse?.headerInfo.userName ?? " ";
      request.userName = widget.loginResponse?.headerInfo.userName ?? "";
    }

    context.read<ForgotPasswordBloc>().add(ValidateOtpSubmitted(request));
  }

  void _showTransactionSuccessDialog(
    BuildContext context,
    String txnRefNo,
    String moduleType,
    BankOption selectedBank,
  ) {
    final isFundTransfer = moduleType == ModuleCode.domesticFt ||
        moduleType == ModuleCode.internationalFt;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.fbTooLite.withOpacity(0.3),
                    width: 4.0,
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 30,
                  color: AppColors.fbTooLite,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Transaction Successful',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                'TRANSACTION DONE SUCCESSFULLY\nYour Txn Ref No is $txnRefNo',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              if (isFundTransfer)
                // Fund Transfer: Only show OK button
                SizedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnBackground,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashBoardMobileLayout(
                            loginResponse: widget.loginResponse ??
                                LoginUserReqResInfo(), // ✅ FIXED
                            selectedBank: widget.selectedBank, // ✅ FIXED
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              else
                // Non-Fund Transfer: Show OK and View Receipt buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DashBoardMobileLayout(
                                loginResponse: widget.loginResponse ??
                                    LoginUserReqResInfo(), // ✅ FIXED
                                selectedBank: widget.selectedBank, // ✅ FIXED
                              ),
                            ),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnBackground,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          CommTransactionDetails transactionDetails =
                              CommTransactionDetails();
                          transactionDetails.headerInfo =
                              widget.loginResponse!.headerInfo; // ✅ FIXED
                          transactionDetails.transId = txnRefNo;
                          context.read<TransactionReceiptBloc>().add(
                                TransactionReceiptSubmitted(transactionDetails),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnBackground,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'View Receipt',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInformationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // fixed width for labels (adjust as needed)
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            ':',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10), // small space after colon
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

  void _handlePayButton(BuildContext context) {
    final isLoading = context.read<LoadingCubit>().state;
    if (isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transaction is already in progress. Please wait...',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    //context.read<LoadingCubit>().show();

    if (widget.itemKey == ModuleCode.domesticFt ||
        widget.itemKey == ModuleCode.internationalFt) {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.dAccountNo = 'CASA2007187';
      commTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = widget.txnId;
      commTransaction.bAccountNo = 'CASA2007185';
      commTransaction.initTime = DateTime(2025, 8, 5);
      context.read<AccountTransactionBloc>().add(
            AccountTransactionSubmitted(commTransaction),
          );
    }
    if (widget.itemKey == ModuleCode.receiveRequest) {
      CommRequestMoney requestMoney = CommRequestMoney();
      requestMoney.headerInfo = widget.loginResponse?.headerInfo;
      requestMoney.reqAmount = widget.requestList?.reqAmount;
      requestMoney.operation = "PAYMENT_REQ";
      requestMoney.txntype = ModuleCode.requestMoney;
      requestMoney.requesterMob = widget.requestList?.requesterMob;
      requestMoney.requesterName = widget.requestList?.requesterName;
      requestMoney.requesting_toMob = widget.requestList?.requesting_toMob;
      requestMoney.requesting_toName = widget.requestList?.requesting_toName;
      requestMoney.requestId = widget.requestList?.requestId;
      requestMoney.usertype = widget.loginResponse?.headerInfo.userType;
      context.read<RequestMoneyBloc>().add(RequestMoneySubmitted(requestMoney));
    }
    if (widget.itemKey == ModuleCode.fundTransfer &&
        widget.senderResponse != null) {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.dAccountNo = widget.senderResponse?.accountNum;
      commTransaction.headerInfo = widget.senderResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmt =
          AESEncryptionService.encrypt(widget.enteredAmount);
      commTransaction.transId = AESEncryptionService.encrypt(widget.txnId);
      commTransaction.dMob = widget.senderResponse?.phoneNum ?? "";
      commTransaction.initTime = DateTime(2025, 8, 5);
      if (widget.receiverResponse != null) {
        commTransaction.bAccountNo = widget.receiverResponse?.accountNum;
        commTransaction.bMob = widget.receiverResponse?.phoneNum ?? '';
      } else {
        commTransaction.bAccountNo = widget.receive?.accountNum;
        commTransaction.bMob = widget.receive?.mobileno;
      }

      context
          .read<AccountTransactionBloc>()
          .add(AccountTransactionSubmitted(commTransaction));
    }

    if (widget.itemKey == ModuleCode.fundTransfer && widget.send != null) {
      CommWalletTransaction commTransaction = CommWalletTransaction();
      commTransaction.dAccountNo = widget.send?.accountNum;
      commTransaction.headerInfo = widget.send?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = AESEncryptionService.encrypt(widget.txnId);
      commTransaction.dMob = widget.send?.mobileno;
      commTransaction.dwalltyp =
          AESEncryptionService.safeDecrypt(widget.send?.accountType);
      commTransaction.initTime = DateTime(2025, 8, 5);
      if (widget.receiverResponse != null) {
        commTransaction.bAccountNo = widget.receiverResponse?.accountNum;
        commTransaction.bMob = widget.receiverResponse?.phoneNum;
      } else {
        commTransaction.bAccountNo = widget.receive?.accountNum;
        commTransaction.bMob =
            AESEncryptionService.safeDecrypt(widget.receive?.mobileno);
      }

      context.read<WalletTransactionBloc>().add(
            WalletTransactionSubmitted(commTransaction),
          );
    }

    if (widget.transactionType == "Account") {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.headerInfo = widget.commAccountRequest?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmt =
          AESEncryptionService.encrypt(widget.enteredAmount);
      commTransaction.transId = AESEncryptionService.encrypt(widget.txnId);
      commTransaction.initTime = DateTime(2025, 8, 5);

      if (widget.itemKey == ModuleCode.deposit) {
/*        commTransaction.dMob = widget.loginResponse?.headerInfo.userName;
        commTransaction.dAccountNo = widget.loginResponse?.headerInfo.cb_account_no;*/
        commTransaction.bMob =
            AESEncryptionService.encrypt(widget.mobileNumber ?? '');
        commTransaction.bAccountNo =
            AESEncryptionService.encrypt(widget.accountNumber);
      }
      if (widget.itemKey == ModuleCode.withdrawal) {
        commTransaction.dMob =
            AESEncryptionService.encrypt(widget.mobileNumber ?? '');
        commTransaction.dAccountNo =
            AESEncryptionService.encrypt(widget.accountNumber);
        /*  commTransaction.bMob = widget.loginResponse?.headerInfo.userName;
        commTransaction.bAccountNo = widget.loginResponse?.headerInfo.cb_account_no;*/
      }

      context.read<AccountTransactionBloc>().add(
            AccountTransactionSubmitted(commTransaction),
          );
    } else if (widget.transactionType == "Wallet" &&
        widget.itemKey != ModuleCode.receiveRequest) {
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.headerInfo =
          widget.commWalletAccountRequest?.headerInfo;
      commWalletTransaction.moduleType = widget.itemKey;
      commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commWalletTransaction.transId =
          AESEncryptionService.encrypt(widget.txnId);
      // commWalletTransaction.dMob = widget.mobileNumber;
      commWalletTransaction.cwalltype = "L2024022221";
      // commWalletTransaction.dwalltyp = "L2024022221";
      commWalletTransaction.dIdType = "RC";
      if (widget.itemKey == ModuleCode.deposit) {
        commWalletTransaction.dMob = widget.loginResponse?.headerInfo.userName;
        commWalletTransaction.dAccountNo =
            widget.loginResponse?.headerInfo.wallet_account_no;
        commWalletTransaction.bMob = widget.mobileNumber;
        commWalletTransaction.bAccountNo =
            AESEncryptionService.encrypt(widget.accountNumber);
      }
      if (widget.itemKey == ModuleCode.withdrawal) {
        commWalletTransaction.dwalltyp = "L2024022221";
        commWalletTransaction.dMob =
            AESEncryptionService.encrypt(widget.mobileNumber ?? '');
        commWalletTransaction.dAccountNo =
            AESEncryptionService.encrypt(widget.accountNumber);
        commWalletTransaction.bMob = widget.loginResponse?.headerInfo.userName;
        commWalletTransaction.bAccountNo =
            widget.loginResponse?.headerInfo.wallet_account_no;
      }
      context.read<WalletTransactionBloc>().add(
            WalletTransactionSubmitted(commWalletTransaction),
          );
    }
    //  WAL - CBS Working
    // New conditions for CBS_WALL and WALL_CBS
    if ((widget.itemKey == ModuleCode.cbsToWallet ||
            widget.itemKey == ModuleCode.walletToCbs) &&
        widget.send != null) {
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.dAccountNo = widget.send?.accountNum;
      commWalletTransaction.dMob =
          AESEncryptionService.safeDecrypt(widget.send?.mobileno);
      commWalletTransaction.headerInfo = widget.send?.headerInfo;
      commWalletTransaction.moduleType = widget.itemKey;
      commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commWalletTransaction.transId =
          AESEncryptionService.encrypt(widget.txnId);
      commWalletTransaction.dwalltyp =
          AESEncryptionService.safeDecrypt(widget.send?.accountType);
      commWalletTransaction.dIdType = widget.send?.custType;

      if (widget.receiverResponse != null) {
        commWalletTransaction.bAccountNo = widget.receiverResponse?.accountNum;
        commWalletTransaction.bMob = AESEncryptionService.encrypt(
            widget.receiverResponse?.phoneNum ?? '');
        commWalletTransaction.lnBrn = "000";
        commWalletTransaction.bCurrency = widget.receiverResponse?.accCcy;
      } else {
        commWalletTransaction.bAccountNo = widget.receive?.accountNum;
        commWalletTransaction.bMob = widget.receive?.mobileno;
      }

      context.read<AccountWalletTransactionBloc>().add(
            AccountWalletTransactionSubmitted(commWalletTransaction),
          );
    } else if ((widget.itemKey == ModuleCode.cbsToWallet ||
            widget.itemKey == ModuleCode.walletToCbs) &&
        widget.senderResponse != null) {
      CommWalletTransaction commTransaction = CommWalletTransaction();
      commTransaction.dAccountNo = widget.senderResponse?.accountNum;
      commTransaction.dMob = widget.senderResponse?.phoneNum;
      commTransaction.headerInfo = widget.senderResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      // commTransaction.cwalltype = widget.senderResponse?.accountType;

      commTransaction.lnBrn =
          AESEncryptionService.decrypt(widget.senderResponse?.branch ?? '');
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = AESEncryptionService.encrypt(widget.txnId);
      commTransaction.dBranch =
          AESEncryptionService.decrypt(widget.senderResponse?.branch ?? '');
      commTransaction.dCurrency = widget.senderResponse?.accCcy;
      commTransaction.dName = widget.senderResponse?.customerName;
      if (widget.receiverResponse != null) {
        commTransaction.bAccountNo = widget.receiverResponse?.accountNum;
        // commTransaction.bIdType=widget.receiverResponse?.custType;
        commTransaction.cwalltype = AESEncryptionService.decrypt(
            widget.receiverResponse?.accountType ?? '');
        commTransaction.bMob = widget.receiverResponse?.phoneNum;
        commTransaction.bCurrency = widget.receiverResponse?.accCcy;
        commTransaction.bName = widget.receiverResponse?.customerName;
        // commTransaction.bIdType=widget.receiverResponse?.custType;
        //9535347309
      } else {
        commTransaction.bAccountNo = widget.receive?.accountNum;
        commTransaction.bIdType = widget.receive?.custType;
        commTransaction.cwalltype =
            AESEncryptionService.decrypt(widget.receive?.accountType ?? '');
        commTransaction.bMob = widget.receive?.mobileno;
        // commTransaction.bCurrency=widget.receive?.accCcy;
        commTransaction.bCurrency = "USD";
        commTransaction.bName = widget.receive?.customerName;
      }
      context.read<AccountWalletTransactionBloc>().add(
            AccountWalletTransactionSubmitted(commTransaction),
          );
    }

    if (widget.itemKey == "SM") {
      CommTransaction commTransaction = CommTransaction();
      commTransaction.dAccountNo = widget.senderResponse?.accountNum;
      commTransaction.headerInfo = widget.senderResponse?.headerInfo;
      commTransaction.moduleType = widget.itemKey;
      commTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commTransaction.transId = widget.txnId;
      commTransaction.dMob = widget.senderResponse?.mobileno;
      context.read<SendMoneyBloc>().add(SendMoneySubmitted(commTransaction));
    }
    if (widget.itemKey == ModuleCode.trustAccount ||
        widget.itemKey == ModuleCode.corporatePayment) {
      CommWalletTransaction commWalletTransaction = CommWalletTransaction();
      commWalletTransaction.bAccountNo = widget.accountNumber;
      commWalletTransaction.bMob = widget.mobileNumber;
      commWalletTransaction.bName = widget.customerName;
      commWalletTransaction.dAccountNo =
          widget.loginResponse?.headerInfo.wallet_account_no;
      commWalletTransaction.dMob =
          widget.loginResponse?.loginUserInfo.userName ?? "";
      commWalletTransaction.headerInfo = widget.loginResponse?.headerInfo;
      commWalletTransaction.moduleType = widget.itemKey;
      commWalletTransaction.txnAmount = double.tryParse(widget.enteredAmount);
      commWalletTransaction.transId = widget.txnId;

      context
          .read<TrustaccountWallettransactionBloc>()
          .add(TrustaccountWallettransactionSubmitted(commWalletTransaction));
    }
  }

  /* @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PinValidationBloc, PinValidationState>(
          listener: (context, state) {
            if (state is PinValidationLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is PinValidationFailure) {
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
              if (state.userOtp.otpuniqueid != null) {
                otpValidationInfo = state.userOtp;
                _showBottomPopupWithInput(context, "OTP");
              }
            }

            if (state is ForgotPasswordFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<AccountTransactionBloc, AccountTransactionState>(
          listener: (context, state) {
            if (state is AccountTransactionLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is AccountTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              AppLogger.error(
                'Transaction error',
                state.commTransaction.resMessage?.fcError,
              );
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
              AppLogger.info('Transaction message: ${state.message}');
              AppLogger.network(
                  'Transaction response: ${state.commTransaction.resMessage?.toJson()}');
            } else if (state is AccountTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<WalletTransactionBloc, WalletTransactionState>(
          listener: (context, state) {
            if (state is WalletTransactionLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is WalletTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
            } else if (state is WalletTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<AccountWalletTransactionBloc,
            AccountWalletTransactionState>(
          listener: (context, state) {
            if (state is AccountWalletTransactionLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is AccountWalletTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              AppLogger.info(
                  'Wallet transaction ID: ${state.commwalletTransaction.transId}');
              _showTransactionSuccessDialog(
                  context,
                  state.commwalletTransaction.transId ?? widget.txnId,
                  widget.itemKey,
                  widget.selectedBank);
              AppLogger.info('Transaction message: ${state.message}');
            } else if (state is AccountWalletTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<TrustaccountWallettransactionBloc,
            TrustaccountWallettransactionState>(
          listener: (context, state) {
            if (state is TrustaccountWallettransactionLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is TrustaccountWallettransactionSuccess) {
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
            } else if (state is TrustaccountWallettransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<TransactionReceiptBloc, TransactionReceiptState>(
          listener: (context, state) {
            if (state is TransactionReceiptLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is TransactionReceiptSuccess) {
              transactionPdf = state.transactionDetails.transactionPdf!;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadReceiptScreen(
                    transactionPdf: transactionPdf,
                    selectedBank: widget.selectedBank,
                    loginResponse: widget.loginResponse,
                    fromSucess: true,
                  ),
                ),
              );
            } else if (state is TransactionReceiptFailure) {
              showCustomBottomPopup(context, state.error);
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
  }*/

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        loadingAwareListener<PinValidationBloc, PinValidationState>(
          isLoading: (state) => state is PinValidationLoading,
          onState: (context, state) {
            if (state is PinValidationFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<ForgotPasswordBloc, ForgotPasswordState>(
          isLoading: (state) => state is ForgotPasswordLoading,
          onState: (context, state) {
            if (state is ForgotPasswordSuccess) {
              if (state.userOtp.otpuniqueid != null) {
                otpValidationInfo = state.userOtp;
                _showBottomPopupWithInput(context, "OTP");
              }
            }
            if (state is ForgotPasswordFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<AccountTransactionBloc, AccountTransactionState>(
          isLoading: (state) => state is AccountTransactionLoading,
          onState: (context, state) {
            if (state is AccountTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              AppLogger.error(
                'Transaction error',
                state.commTransaction.resMessage?.fcError,
              );
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
              AppLogger.info('Transaction message: ${state.message}');
              AppLogger.network(
                  'Transaction response: ${state.commTransaction.resMessage?.toJson()}');
            } else if (state is AccountTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<WalletTransactionBloc, WalletTransactionState>(
          isLoading: (state) => state is WalletTransactionLoading,
          onState: (context, state) {
            if (state is WalletTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
            } else if (state is WalletTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<AccountWalletTransactionBloc,
            AccountWalletTransactionState>(
          isLoading: (state) => state is AccountWalletTransactionLoading,
          onState: (context, state) {
            if (state is AccountWalletTransactionSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pop(); // close OTP sheet
              AppLogger.info(
                  'Wallet transaction ID: ${state.commwalletTransaction.transId}');
              _showTransactionSuccessDialog(
                  context,
                  state.commwalletTransaction.transId ?? widget.txnId,
                  widget.itemKey,
                  widget.selectedBank);
              AppLogger.info('Transaction message: ${state.message}');
            } else if (state is AccountWalletTransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<TrustaccountWallettransactionBloc,
            TrustaccountWallettransactionState>(
          isLoading: (state) => state is TrustaccountWallettransactionLoading,
          onState: (context, state) {
            if (state is TrustaccountWallettransactionSuccess) {
              _showTransactionSuccessDialog(
                  context, widget.txnId, widget.itemKey, widget.selectedBank);
            } else if (state is TrustaccountWallettransactionFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        loadingAwareListener<TransactionReceiptBloc, TransactionReceiptState>(
          isLoading: (state) => state is TransactionReceiptLoading,
          onState: (context, state) {
            if (state is TransactionReceiptSuccess) {
              transactionPdf = state.transactionDetails.transactionPdf!;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DownloadReceiptScreen(
                    transactionPdf: transactionPdf,
                    selectedBank: widget.selectedBank,
                    loginResponse: widget.loginResponse,
                    fromSucess: true,
                  ),
                ),
              );
            } else if (state is TransactionReceiptFailure) {
              showCustomBottomPopup(context, state.error);
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
      appBar: const CustomAppBar(
        title: "Review Screen",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Transaction Type : ${_getTransactionType(widget.itemKey)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Transaction Details Container
            Container(
              width: double.infinity,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Reference ID : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Total Amount:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.txnId,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      const SizedBox(height: 4),
                      Text(
                        '${AESEncryptionService.decrypt(widget.loginResponse?.headerInfo.currency ?? '')} '
                        '${((double.tryParse(widget.enteredAmount.toString()) ?? 0.0).toStringAsFixed(2))}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            if (widget.itemKey == ModuleCode.domesticFt ||
                widget.itemKey == ModuleCode.internationalFt) ...[
              const SizedBox(height: 10),
              const Text('Sender Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              buildInformationRow('Name', 'MRS. Ankitha  Sreedhara'),
              buildInformationRow('Account Number', 'CASA2007187' ?? ''),
              buildInformationRow('Currency', 'US Dollar'),
              buildInformationRow(
                'Amount',
                ((double.tryParse(widget.enteredAmount.toString()) ?? 0.0)
                    .toStringAsFixed(2)),
              ),
              buildInformationRow(
                'Tax',
                (double.tryParse('${widget.charges.txnWalletTax ?? 0}') ?? 0.0)
                    .toStringAsFixed(2),
              ),
              const SizedBox(height: 15),
              const Text('Receiver Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              buildInformationRow('Name', 'MR. AKKR  KR'),
              buildInformationRow('Account Number', 'CASA2007185'),
              buildInformationRow('Currency', 'US Dollar'),
            ],

            // Conditional Sender/Receiver Section
            if (widget.itemKey == ModuleCode.fundTransfer ||
                widget.itemKey == ModuleCode.walletToCbs ||
                widget.itemKey == ModuleCode.cbsToWallet ||
                widget.itemKey == 'SM' ||
                widget.itemKey == 'SM_CASH') ...[
              const SizedBox(height: 10),
              const Text('Sender Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              buildInformationRow(
                  'Name',
                  AESEncryptionService.decrypt(widget.send?.customerName ??
                      widget.senderResponse?.customerName ??
                      '')),
              buildInformationRow(
                  'Account Number',
                  AESEncryptionService.decrypt(widget.send?.accountNum ??
                      widget.senderResponse?.accountNum ??
                      '')),
              if ((widget.send?.mobileno?.trim().isNotEmpty ?? false) ||
                  (widget.senderResponse?.phoneNum?.trim().isNotEmpty ?? false))
                buildInformationRow(
                  'Mobile Number',
                  AESEncryptionService.safeDecrypt(
                      widget.send?.mobileno ?? widget.senderResponse?.phoneNum),
                ),
              buildInformationRow(
                'Amount',
                ((double.tryParse(widget.enteredAmount.toString()) ?? 0.0)
                    .toStringAsFixed(2)),
              ),
              buildInformationRow(
                'Tax',
                (double.tryParse('${widget.charges.txnWalletTax ?? 0}') ?? 0.0)
                    .toStringAsFixed(2),
              ),
              const SizedBox(height: 15),
              const Text('Receiver Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              buildInformationRow(
                  'Name',
                  AESEncryptionService.decrypt(widget.receive?.customerName ??
                      widget.receiverResponse?.customerName ??
                      '')),
              buildInformationRow(
                  'Account Number',
                  AESEncryptionService.decrypt(widget.receive?.accountNum ??
                      widget.receiverResponse?.accountNum ??
                      '')),
              if ((widget.receive?.mobileno?.trim().isNotEmpty ?? false) ||
                  (widget.receiverResponse?.phoneNum?.trim().isNotEmpty ??
                      false))
                buildInformationRow(
                  'Mobile Number',
                  AESEncryptionService.safeDecrypt(
                    widget.receive?.mobileno?.trim() ??
                        widget.receiverResponse?.phoneNum?.trim() ??
                        '',
                  ),
                ),
            ],

            if (widget.itemKey == ModuleCode.withdrawal ||
                widget.itemKey == ModuleCode.deposit ||
                widget.itemKey == ModuleCode.trustAccount ||
                widget.itemKey == ModuleCode.corporatePayment ||
                widget.itemKey == ModuleCode.receiveRequest) ...[
              buildInformationRow('Name', widget.customerName ?? ''),
              buildInformationRow('Account Number', widget.accountNumber ?? ''),
              if (widget.mobileNumber != null &&
                  widget.mobileNumber!.trim().isNotEmpty)
                buildInformationRow('Mobile Number', widget.mobileNumber!),
              buildInformationRow(
                'Amount',
                ((double.tryParse(widget.enteredAmount.toString()) ?? 0.0)
                    .toStringAsFixed(2)),
              ),
              buildInformationRow(
                'Tax',
                (double.tryParse('${widget.charges.txnWalletTax ?? 0}') ?? 0.0)
                    .toStringAsFixed(2),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Fixed bottom button
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: buildActionButton(
            label: 'Proceed',
            onPressed: () => _sendOtpAndOpenPopup(context),
          ),
        ),
      ),
    );
  }
}
