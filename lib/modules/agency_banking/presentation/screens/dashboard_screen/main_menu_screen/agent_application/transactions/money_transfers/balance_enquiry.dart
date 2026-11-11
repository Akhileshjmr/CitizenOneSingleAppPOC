import 'package:citizenone_app/modules/agency_banking/data/models/CommWalletAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_state.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../../constants/ModuleCode.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../data/models/CommAccountRequest.dart';
import '../../../../../../../data/models/CommTransaction.dart';
import '../../../../../../../data/models/login_models/UserOtpValidationInfo.dart';
import '../../../../../../../data/services/AuthService.dart';
import '../../../../../../../utils/AESEncryption.dart';
import '../../../../../../../utils/CommDialog.dart';
import '../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../../utils/Loader.dart';
import '../../../../../../blocs/account_balance_bloc/account_balance_state.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_event.dart';
import '../../../../../../blocs/forgot_password_bloc/forgot_password_state.dart';
import '../../../../../../blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../../../../../../blocs/pin_validation_bloc/pin_validation_event.dart';
import '../../../../../Dashboard/widgets/BankSelectionScreen.dart';

class BalanceEnquiryScreen extends StatefulWidget {
  final CommWalletAccountRequest? commWalletAccountRequest;
  final CommAccountRequest? commAccountRequest;
  final LoginUserReqResInfo loginResponse;
  final dynamic itemKey;
  final BankOption selectedBank;
  final String transactionType;

  BalanceEnquiryScreen({
    this.commWalletAccountRequest,
    this.commAccountRequest,
    this.itemKey,
    required this.transactionType,
    required this.loginResponse,
    required this.selectedBank,
  });

  @override
  _BalanceEnquiryScreen createState() => _BalanceEnquiryScreen();
}

class _BalanceEnquiryScreen extends State<BalanceEnquiryScreen> {
  late String initial;
  bool isPinSelected = false;
  final AuthService authService = AuthService();
  final TextEditingController _pinController = TextEditingController();
  UserOTPValidationInfo otpValidationInfo = UserOTPValidationInfo();
  bool isPayButtonEnabled = false;

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

    String _decryptSafe(String? value) {
      if (value == null || value.isEmpty) return '';
      try {
        return AESEncryptionService.decrypt(value);
      } catch (e) {
        // In case value is already plain text or invalid base64
        return value;
      }
    }

    initial = getInitial(
      _decryptSafe(widget.commWalletAccountRequest?.customerName ??
              widget.commAccountRequest?.customerName) ??
          '',
    );
  }

  @override
  void dispose() {
    _pinController
        .dispose(); // Dispose the controller when the widget is removed from the widget tree
    super.dispose();
  }

  void checkBalance(BuildContext context) {
    if (widget.transactionType == 'Wallet') {
      CommWalletAccountRequest req = CommWalletAccountRequest();
      req.headerInfo = widget.commWalletAccountRequest!.headerInfo;
      req.selfAccountCheck = 'N';
      req.accountNum = widget.commWalletAccountRequest!.accountNum;
      req.moduleCode = ModuleCode.balanceEnquiry;
      req.mobileno = widget.commWalletAccountRequest!.mobileno;
      context.read<WalletBalanceBloc>().add(WalletBalanceSubmitted(req));
    } else {
      CommAccountRequest req = CommAccountRequest();
      req.headerInfo = widget.loginResponse.headerInfo;
      req.selfAccountCheck = 'N';
      req.accountNum = widget.commAccountRequest!.accountNum;
      req.phoneNum = widget.commAccountRequest!.phoneNum;
      req.customerName = widget.commAccountRequest!.customerName;
      //req.branch = "000";
      context.read<AccountBalanceBloc>().add(AccountBalanceSubmitted(req));
    }
  }

  void _validatePin(BuildContext context) async {
    final pin = _pinController.text; // Null-safe trim

    if (pin.isEmpty) {
      showCustomBottomPopup(context, "Pin is requiired");
      return;
    }
    if (pin.length != 6) {
      showCustomBottomPopup(context, 'Pin must be exactly 6 digits');
      return;
    }
    CommTransaction req = CommTransaction();
    req.custPin = _pinController.text;
    context.read<PinValidationBloc>().add(PinValidationSubmitted(req));
    final isSuccess = await _simulateApiCall(); // Simulated API call

    if (isSuccess) {
      setState(() {
        isPayButtonEnabled = true;
      });
    }
  }

  Future<bool> _simulateApiCall() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return true; // Simulate success response
  }

  void _submitOtp(BuildContext context) async {
    final otp = _pinController.text; // Null-safe trim

    if (otp.isEmpty) {
      showCustomBottomPopup(context, "OTP is required");
      return;
    }
    if (otp.length != 6) {
      showCustomBottomPopup(context, "OTP must be exactly 6 digits");
      return;
    }
    UserOTPValidationInfo req = UserOTPValidationInfo();
    req.headerInfo = otpValidationInfo.headerInfo;
    req.otpuniqueid = otpValidationInfo.otpuniqueid;
    req.mobileNo = otpValidationInfo.mobileNo;
    req.userName = otpValidationInfo.mobileNo;
    req.otp = _pinController.text;
    authService.otpFailedValidation(req);
    final isSuccess = await _simulateApiCall(); // Simulated API call

    if (isSuccess) {
      setState(() {
        isPayButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }
            if (state is ForgotPasswordSuccess) {
              otpValidationInfo = state.userOtp;
              _submitOtp(context);
            } else if (state is ForgotPasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
        BlocListener<AccountBalanceBloc, AccountBalanceState>(
          listener: (context, state) {
            if (state is AccountBalanceLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is AccountBalanceSuccess) {
              // Pass first API response to second API
              context.read<BalanceSmsBloc>().add(
                    BalanceSmsSubmitted(state.commAccountRequest),
                  );
            } else if (state is AccountBalanceFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<BalanceSmsBloc, BalanceSmsState>(
          listener: (context, state) {
            if (state is BalanceSmsLoading) {
              context.read<LoadingCubit>().show();
            } else {
              context.read<LoadingCubit>().hide();
            }

            if (state is BalanceSmsSuccess) {
              // Show success only after second API succeeds
              showBalanceEnquirySuccess(
                context,
                state.commAccountRequest.resMessage.errorDescription,
                widget.loginResponse,
                widget.selectedBank,
              );
            } else if (state is BalanceSmsFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
        BlocListener<WalletBalanceBloc, WalletBalanceState>(
          listener: (context, state) {
            if (state is WalletBalanceSuccess) {
              //showBalanceEnquirySuccess(context, state.commAccountRequest.resMessage.errorDescription);
            } else if (state is WalletBalanceFailure) {
              showCustomBottomPopup(context, state.error);
            }
          },
        ),
      ],
      child: Stack(
        children: [
          _buildScaffoldContent(context),
          const GlobalLoader(), // 👈 ADD THIS
        ],
      ),
    );
  }

  Widget _buildScaffoldContent(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
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
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.transactionType == "Wallet"
            ? "Wallet Balance Enquiry"
            : "Balance Enquiry",
      ),
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.teal,
                          radius: 20,
                          child: Text(
                            initial,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AESEncryptionService.decrypt(
                                widget.transactionType == 'Account'
                                    ? widget.commAccountRequest?.customerName ??
                                        ''
                                    : widget.commWalletAccountRequest
                                            ?.customerName ??
                                        '',
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AESEncryptionService.decrypt(
                                widget.transactionType == 'Account'
                                    ? widget.commAccountRequest?.phoneNum ?? ''
                                    : widget.commWalletAccountRequest
                                            ?.mobileno ??
                                        '',
                              ),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Text(
                              AESEncryptionService.decrypt(
                                widget.transactionType == 'Account'
                                    ? widget.commAccountRequest?.accountNum ??
                                        ''
                                    : widget.commWalletAccountRequest
                                            ?.accountNum ??
                                        '',
                              ),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Divider(
                      color: Colors.grey, // Color of the line
                      thickness: 1, // Thickness of the line
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            isPinSelected ? "ENTER PIN" : "ENTER OTP",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Pinput(
                            autofocus: false,
                            length: 6,
                            controller: _pinController,
                            // Attach the controller
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onCompleted: (pin) {
                              if (!isPinSelected) {
                                // Call your API only for OTP
                                final forgotPasswordBloc =
                                    context.read<ForgotPasswordBloc>();
                                UserOTPValidationInfo request =
                                    UserOTPValidationInfo();
                                if (widget.commAccountRequest?.headerInfo !=
                                    null) {
                                  request.headerInfo =
                                      widget.commAccountRequest!.headerInfo;
                                  request.mobileNo =
                                      widget.commAccountRequest!.mobileno;
                                  request.userName =
                                      widget.commAccountRequest!.mobileno;
                                } else {
                                  request.headerInfo = widget
                                      .commWalletAccountRequest!.headerInfo;
                                  request.mobileNo =
                                      widget.commWalletAccountRequest!.mobileno;
                                  request.userName =
                                      widget.commWalletAccountRequest!.mobileno;
                                }

                                // Add the OTP entered by the user
                                request.otp = pin;

                                // Trigger the Bloc event or call the API
                                forgotPasswordBloc
                                    .add(ForgotPasswordSubmitted(request));
                              } else {
                                _validatePin(context);
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              if (!isPayButtonEnabled) {
                                // Allow toggle only if Pay button is disabled
                                setState(() {
                                  isPinSelected =
                                      !isPinSelected; // Toggle between OTP and PIN
                                  _pinController
                                      .clear(); // Clear the Pinput field
                                });
                              }
                            },
                            child: Text(
                              'Authentication Type',
                              style: TextStyle(
                                color: isPayButtonEnabled
                                    ? Colors.grey
                                    : AppColors.fbLiteDark,
                                // Grey out text when disabled
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                buildActionButton(
                  label: "Proceed",
                  onPressed: isPayButtonEnabled
                      ? () {
                          checkBalance(context);
                        }
                      : null, // disables button automatically
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
