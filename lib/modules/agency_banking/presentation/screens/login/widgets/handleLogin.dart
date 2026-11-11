import 'dart:convert';
import 'dart:typed_data';

import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/password/forgot_password_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/login_models/TenantDetails.dart';
import '../../../../utils/AESEncryption.dart';
import '../../Dashboard/widgets/BankSelectionScreen.dart';
import '../../Dashboard/widgets/account_desktop_shell.dart';

/// Handles the login process and dispatches the `LoginSubmitted` event.
void handleLogin(BuildContext context, String mobileNumber, String password) {
  FocusScope.of(context).unfocus();
  // hideKeyboard();
  if (mobileNumber.isEmpty && password.isEmpty) {
    showCustomBottomPopup(
      context,
      'Mobile Number and Password are required',
    );
    return;
  }
  // ✅ Mobile Number Validation
  if (mobileNumber.isEmpty || mobileNumber.length < 9) {
    showCustomBottomPopup(
      context,
      mobileNumber.isEmpty
          ? 'Mobile Number is required'
          : 'Enter a valid 9 digit mobile number',
    );
    return;
  }

  // ✅ Password Validation
  if (password.isEmpty) {
    showCustomBottomPopup(
      context,
      'Password is required',
    );
    return;
  }

  final test1 = AESEncryptionService.encrypt('hello');
  final test2 = AESEncryptionService.encrypt('hello');
  print('Test1: $test1');
  print('Test2: $test2');
  print('Different: ${test1 != test2}');

  // ✅ If validation passes → continue login flow
  final encryptedMobileNumber = AESEncryptionService.encrypt(mobileNumber);
  final encryptedPassword = AESEncryptionService.encrypt(password);
  final loginUserReqResInfo = LoginUserReqResInfo()
    ..headerInfo.initialAccess = true
    ..loginUserInfo = (LoginUserInfo()
      ..userName = encryptedMobileNumber
      ..password = encryptedPassword
      ..deviceID = AESEncryptionService.encrypt('Bindu12334'));

  context.read<LoginBloc>().add(LoginSubmitted(loginUserReqResInfo));
}

/// Handles the state changes after login.
Future<void> handleLoginState(BuildContext context, LoginState state) async {
  if (state is LoginSuccess) {
    final List<TenantDetails>? accounts =
        state.user.loginUserInfo.tenantDetails ?? [];
    showAccountDialog(context, state.user, accounts!,
        (state.user.loginUserInfo.mobileno ?? '').toString());
    //showAccountDialog(context, state.user);
  } else if (state is LoginFailure) {
    FocusScope.of(context).unfocus();
    showCustomBottomPopup(context, state.error, loginResponse: state.user);
  }
}

void showAccountDialog(
  BuildContext context,
  LoginUserReqResInfo loginResponse,
  List<TenantDetails> tenants,
  String? agentPhoneNumber,
) {
  final accounts = tenants.map((tenant) {
        // Decode logo safely
        Uint8List? logoBytes;
        if (tenant.logoImage != null) {
          if (tenant.logoImage is String) {
            try {
              logoBytes = base64Decode(tenant.logoImage as String);
            } catch (e) {
              AppLogger.debug("Error decoding logo for ${tenant.bankcode}: $e");
            }
          } else if (tenant.logoImage is Uint8List) {
            logoBytes = tenant.logoImage as Uint8List;
          }
        }

        // Parse theme color safely
        Color? themeColor;
        final encryptedColor = tenant.bankthemeColor;

        if (encryptedColor != null && encryptedColor.isNotEmpty) {
          try {
            // Decrypt the color string
            String decryptedColor =
                AESEncryptionService.decrypt(encryptedColor).trim();

            // Example: "0xFFE2E8F0"
            themeColor = Color(int.parse(decryptedColor));
          } catch (e) {
            AppLogger.warning(
              "Invalid theme color for ${tenant.bankcode}: $encryptedColor",
            );
          }
        }

        return BankOption(
          bankName: tenant.bankName ?? '',
          accountNumber: '',
          logoBytes: logoBytes,
          themeColor: themeColor,
          buttonBackground: themeColor,
          orgCode: tenant.bankcode,
        );
      }).toList() ??
      [];

  FocusScope.of(context).unfocus();

  Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: accountSelectPartnerRouteName),
      builder: (_) => BankSelectionScreen(
        tenants: tenants,
        loginResponse: loginResponse,
        onSelected: (BankOption selectedBank) {},
        accounts: accounts, // Can be empty
        agentPhoneNumber: agentPhoneNumber,
      ),
    ),
  );
}

/// Navigates to the Forgot Password screen.
void navigateToForgotPasswordScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
  );
}

/// Navigates to the Sign-Up screen.
void navigateToSignUpScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => WalletKYC()));
}
