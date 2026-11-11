import 'package:citizenone_app/modules/agency_banking/data/models/CommAccountRequest.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/CommFeeCalulation.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderStore.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/widgets/dialogs/sign_out_dialog.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/widgets/agency_banking_host_callbacks.dart';
import '../data/models/CommWalletAccountRequest.dart';
import '../data/models/CommWalletTransaction.dart';
import '../data/models/common_models/HeaderInfo.dart';
import '../data/models/common_models/ServerMessage.dart';
import '../data/models/login_models/UserOtpValidationInfo.dart';
import '../data/services/AuthService.dart';
import '../presentation/ab/transactions/authorization/view/authentication_screen.dart';
import '../presentation/blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import '../presentation/blocs/charge_calculation_bloc/charge_calculation_event.dart';
import '../presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../presentation/blocs/forgot_password_bloc/forgot_password_event.dart';
import '../presentation/blocs/forgot_password_bloc/forgot_password_state.dart';
import '../presentation/blocs/login_bloc/login_bloc.dart';
import '../presentation/blocs/pin_validation_bloc/pin_validation_bloc.dart';
import '../presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import '../theme/app_gradients.dart';
import 'Loader.dart';

Future<void> clearStoredLoginData() async {
  await SecureStorageHelper.removeLoginResponse();
  await SecureStorageHelper.removeSelectedBank();
  HeaderStore.clearHeader();
}

Future<void> showLogoutDialog(BuildContext context) async {
  final confirmed = await showSignOutDialog(context);
  if (confirmed != true) return;
  if (!context.mounted) return;

  // 🔹 Create logout request object
  LoginUserReqResInfo request = LoginUserReqResInfo();
  HeaderInfo headerInfo = new HeaderInfo();
  headerInfo.logout = 'Y';
  request.headerInfo = headerInfo;

              AppLogger.debug('Logout request initiated');
              // Call logout API
              final response = await AuthService().logout(request);

              if (response != null) {
                AppLogger.debug('Logout response received');
                // 🔹 Clear local storage
                await clearStoredLoginData();
                await BankSelectionHelper.clearBankSelection();

    if (!context.mounted) return;

    // Embedded inside a host app (e.g. Citizen One) — let the host handle
    // sign-out/navigation instead of showing this app's own login screen.
    final hostCallbacks = AgencyBankingHostCallbacks.maybeOf(context);
    if (hostCallbacks?.onSignOut != null) {
      hostCallbacks!.onSignOut!();
      return;
    }

    // 🔹 Navigate to Login screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(AuthService()),
          child: LoginScreen(),
        ),
      ),
      (route) => false,
    );
  } else {
    // Optional: Show error message
    showCustomBottomPopup(context, "Logout Failed");
  }
}

/// A function to show payment options modal

void showPaymentOptions({
  required BuildContext context,
  required dynamic itemKey,
  required TextEditingController enteredAmount,
  required LoginUserReqResInfo loginResponse,
  required CommFeeCalculation response,
  CommAccountRequest? senderResponse,

  ///
  CommWalletAccountRequest? send,
  CommAccountRequest? receiverResponse,
  CommWalletAccountRequest? receive,
  required BankOption selectedBank,
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
                          senderResponse: senderResponse,
                          receiverResponse: receiverResponse,
                          send: send,
                          receive: receive,
                          loginResponse: loginResponse,
                          selectedBank: selectedBank,
                          accountNumber: "",
                          txnId: "",
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
  required dynamic senderResponse,
}) async {
  CommWalletTransaction req = CommWalletTransaction(
    headerInfo: senderResponse.headerInfo,
    resMessage: ServerMessage(),
  );

  context.read<ChargeCalculationBloc>().add(ChargeCalculationSubmitted(req));
}

Future<void> requestContactPermission(BuildContext context) async {
  final status = await Permission.contacts.request();

  if (status.isGranted) {
    AppLogger.debug('Contact permission granted');
  } else if (status.isDenied) {
    AppLogger.debug('Contact permission denied');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Contact permission is required to pick a contact.")),
    );
  } else if (status.isPermanentlyDenied) {
    AppLogger.warning('Contact permission permanently denied');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enable contact permission in settings.")),
    );
    await openAppSettings();
  }
}

Widget buildActionButton({
  required String label,
  required VoidCallback? onPressed,
}) {
  return Opacity(
    opacity: onPressed == null ? 0.5 : 1.0,
    child: SizedBox(
      height: 55,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppBackgrounds.widgetsBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildPayButton({
  required String label,
  required VoidCallback? onPressed, // Nullable to support disabling
}) {
  return Opacity(
    opacity: onPressed == null ? 0.5 : 1.0, // Optional fade effect for disabled
    child: Container(
      decoration: BoxDecoration(
        gradient: AppBackgrounds.widgetsBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    ),
  );
}
