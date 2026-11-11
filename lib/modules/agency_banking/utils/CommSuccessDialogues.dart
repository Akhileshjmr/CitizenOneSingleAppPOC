import 'package:citizenone_app/modules/agency_banking/constants/ABErrorCodes.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/web_popup_dialog.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/emi_calculation_models/L2lEmiCalculateResponse.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/repayment_models/L2lLoanRepayResponse.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/dashboard_entry.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/dashboard_mobile_layout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/left_menu_screen/profile/change_password_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/lms_models/casa_account_models/CasaAccountCreateResponse.dart';
import '../data/models/lms_models/customer_registration_models/GdbCustRtlAppResponse.dart';
import '../data/models/lms_models/emi_calculation_models/GdbChAppStatusReqRes.dart';
import '../data/models/lms_models/loan_product_models/GdbMerchantDisProductPurResponse.dart';
import '../data/models/lms_models/repayment_models/AccSpecificRepaymentResponse.dart';
import '../data/models/lms_models/term_deposit_models/TdAccOpeningResponse.dart';
import '../data/services/AuthService.dart';
import '../presentation/blocs/login_bloc/login_bloc.dart';
import '../presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'AESEncryption.dart';

Future<void> clearStoredLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("loginResponse"); // remove saved login data
  await prefs.remove("selectedBank"); // remove saved bank ((optional)
}

void showResetPasswordSuccessDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Reduced border radius for AlertDialog
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
                  color: AppColors.fbLiteDark.withOpacity(0.3),
                  // Light shade of myHexColor for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: Icon(
                Icons.check, // Single check mark icon
                size: 30,
                color: AppColors.fbLiteDark, // Tick mark in your myHexColor
              ),
            ),
            SizedBox(height: 20),
            Text(
              'SUCCESS',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Your password has been reset successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20), // Add some spacing between text and button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await clearStoredLoginData(); // <-- remove stored data
                await BankSelectionHelper.clearBankSelection();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(AuthService()),
                      child: LoginScreen(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void showWalletRegistrationSuccess(
    BuildContext context, String? walletAccNumber) {
  showDialog(
    context: context,
    barrierDismissible: false,
    // Prevents dismissing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 35,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Wallet Registration Success',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Wallet Account Number Is',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              walletAccNumber!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showDocumentUploadSuccess(BuildContext context, String? message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 35,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Good job!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message ?? 'Document Uploaded Succesfully',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void walletDocSuccess(BuildContext context, String? message,
    LoginUserReqResInfo loginResponse, BankOption selectedBank) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 35,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Good job!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message ?? 'Document Uploaded Succesfully',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showChangePasswordSuccess(
  BuildContext context,
  LoginUserReqResInfo loginResponse, {
  required bool isFirstTimeLogin,
}) {
  final String message = isFirstTimeLogin
      ? 'Your password has been successfully updated.'
      : 'Your password has been changed successfully.';
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
              'SUCCESS',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await clearStoredLoginData();
                await BankSelectionHelper.clearBankSelection();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(AuthService()),
                      child: LoginScreen(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void showPinSuccessDialog(
    BuildContext context, String managePin, LoginUserReqResInfo loginResponse) {
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
            Text(
              managePin == "Reset" ? "RESET SUCCESS" : "CHANGE SUCCESS",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              managePin == "Reset"
                  ? "Your PIN code reset successfully"
                  : "Your PIN code changed successfully",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await clearStoredLoginData(); // <-- remove stored data
                await BankSelectionHelper.clearBankSelection();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(AuthService()),
                      child: LoginScreen(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

void showBalanceEnquirySuccess(BuildContext context, String? msg,
    LoginUserReqResInfo loginResponse, BankOption selectedBank) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Reduced border radius for AlertDialog
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
                  color: AppColors.fbLiteDark.withOpacity(
                      0.3), // Light shade of myHexColor for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: Icon(
                Icons.check, // Single check mark icon
                size: 30,
                color: AppColors.fbLiteDark, // Tick mark in your myHexColor
              ),
            ),
            SizedBox(height: 20),
            Text(
              'SUCCESS',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              "Balance information has been sent to\n "
              "customer registered mobile number",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20), // Add some spacing between text and button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

bool isPopupOpen = false;

void showCustomBottomPopup(
  BuildContext context,
  String? message, {
  LoginUserReqResInfo? loginResponse,
}) {
  if (isPopupOpen) return;

  isPopupOpen = true;

  final bool isSessionError = message == AbErrorCodes.invalidSession;
  final bool isPasswordExpired = message == AbErrorCodes.passwordExpired;
  final bool isFirstTimeLogin = message == AbErrorCodes.firstTimeLogin;

  Future<void> onConfirm(BuildContext sheetContext) async {
    Navigator.of(sheetContext).pop();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // First-time login → Change Password
      if (isFirstTimeLogin) {
        if (loginResponse == null) {
          debugPrint("Missing loginResponse for first-time login flow");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(
              isFirstTimeLogin: true,
              loginResponse: loginResponse,
            ),
          ),
        );
        return;
      }

      // Session expired → Login Screen
      if (isSessionError) {
        await clearStoredLoginData();
        await BankSelectionHelper.clearBankSelection();

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BlocProvider<LoginBloc>(
              create: (_) => LoginBloc(AuthService()),
              child: LoginScreen(),
            ),
          ),
          (route) => false,
        );
        return;
      }

      // Password expired → Change Password
      if (isPasswordExpired) {
        if (loginResponse == null) {
          debugPrint("Missing loginResponse for password expired flow");
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangePasswordScreen(
              loginResponse: loginResponse,
              isPasswordExpired: true,
            ),
          ),
        );
        return;
      }
    });
  }

  final bool isMobile = MediaQuery.of(context).size.width < 600;

  if (isMobile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,

      // Block outside tap for session expiry
      isDismissible: !isSessionError,

      // Block swipe down for session expiry
      enableDrag: !isSessionError,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      builder: (BuildContext sheetContext) {
        return WillPopScope(
          onWillPop: () async => !isSessionError,
          child: SafeArea(
            top: false,
            child: _MobileBottomPopupContent(
              message: message,
              isSessionError: isSessionError,
              isPasswordExpired: isPasswordExpired,
              isFirstTimeLogin: isFirstTimeLogin,
              onConfirm: () => onConfirm(sheetContext),
              onClose: () => Navigator.of(sheetContext).pop(),
            ),
          ),
        );
      },
    ).whenComplete(() {
      isPopupOpen = false;
    });
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: !isSessionError,
    builder: (BuildContext dialogContext) {
      return WillPopScope(
        onWillPop: () async => !isSessionError,
        child: WebPopupDialog(
          message: message,
          isSessionError: isSessionError,
          isPasswordExpired: isPasswordExpired,
          isFirstTimeLogin: isFirstTimeLogin,
          onConfirm: () => onConfirm(dialogContext),
          onClose: () => Navigator.of(dialogContext).pop(),
        ),
      );
    },
  ).whenComplete(() {
    isPopupOpen = false;
  });
}

/// Mobile-only bottom sheet body matching the CitizenOne design: drag handle,
/// close button, icon in a soft tinted circle, title + description, and a
/// purple pill-outlined "Continue" button. Web keeps the original plain look.
class _MobileBottomPopupContent extends StatelessWidget {
  const _MobileBottomPopupContent({
    required this.message,
    required this.isSessionError,
    required this.isPasswordExpired,
    required this.isFirstTimeLogin,
    required this.onConfirm,
    required this.onClose,
  });

  final String? message;
  final bool isSessionError;
  final bool isPasswordExpired;
  final bool isFirstTimeLogin;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  ({IconData icon, Color iconColor, Color iconBg, String? title}) get _content {
    if (isPasswordExpired) {
      return (
        icon: Icons.shield_outlined,
        iconColor: AppColors.kF59E0B,
        iconBg: AppColors.kFFF8E1,
        title: "Password Expired",
      );
    }
    if (isSessionError) {
      return (
        icon: Icons.timer_off_outlined,
        iconColor: AppColors.k613AF5,
        iconBg: AppColors.kEEF2FF,
        title: "Session Expired",
      );
    }
    if (isFirstTimeLogin) {
      return (
        icon: Icons.shield_outlined,
        iconColor: AppColors.kF59E0B,
        iconBg: AppColors.kFFF8E1,
        title: "Password Setup Required",
      );
    }
    return (
      icon: Icons.error_outline,
      iconColor: AppColors.appPrimaryRedColor,
      iconBg: AppColors.kFEF2F2,
      title: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _content;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // Close button (hidden when the sheet can't be dismissed)
          if (!isSessionError)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close, size: 18),
                color: AppColors.textSecondary,
                style: IconButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderLight),
                  shape: const CircleBorder(),
                ),
              ),
            ),
          const SizedBox(height: 4),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: c.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(c.icon, size: 30, color: c.iconColor),
          ),
          const SizedBox(height: 16),
          if (c.title != null) ...[
            Text(
              c.title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            message ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: AppColors.k613AF5),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onConfirm,
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: AppColors.k613AF5,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

void showSendMoneySuccessDialog(
    BuildContext context, String? uniqueId, String? txnStatus) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Reduced border radius for AlertDialog
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Icon Background with lighter shade of AppColors.fbTooLite
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 50,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Request Submitted',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Unique Id is $uniqueId',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              txnStatus!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            // Add some spacing between text and button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fbTooLite,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

void showRequestMoneySuccess(
    BuildContext context,
    String? name,
    double? reqAmount,
    String? requestId,
    LoginUserReqResInfo loginResponse,
    String itemKey,
    BankOption selectedBank) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 50,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Request Submitted ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "Requesting ETB $reqAmount from $name ",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 4.0),
            Text(
              "Request Id is $requestId",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog first
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => buildDashboardEntry(
                      loginResponse: loginResponse,
                      selectedBank: selectedBank,
                    ),
                  ),
                );
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fbTooLite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showSMSuccessDialog(BuildContext context, String? uniqueId) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Reduced border radius for AlertDialog
        ),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circular Icon Background with lighter shade of AppColors.fbTooLite
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // Inner circle color
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.fbTooLite.withOpacity(0.3),
                  // Light shade of AppColors.fbTooLite for the border
                  width: 4.0, // Border thickness
                ),
              ),
              child: const Icon(
                Icons.check, // Single check mark icon
                size: 50,
                color: AppColors
                    .fbTooLite, // Tick mark in your AppColors.fbTooLite
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction Successful ',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Unique Id is $uniqueId',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            // Add some spacing between text and button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.fbTooLite,
              ),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

void loanApplySuccessDialog(
    BuildContext context,
    GdbMerchantDisProductPurResponse? response,
    LoginUserReqResInfo loginResponse,
    BankOption selectedBank) {
  final product = response?.productPurchaseList?.isNotEmpty == true
      ? response!.productPurchaseList!.first
      : null;

  final loanNumber = product?.loanNumber ?? '-';
  final dueAmount = product?.dueAmount?.toStringAsFixed(2) ?? '-';
  /* final firstEmiDate = product?.firstEmiDueDate ?? '-';*/
  final emi = product?.emi?.toStringAsFixed(2) ?? '-';

  final rawEmiDate = product?.firstEmiDueDate;
  String formattedEmiDate = '-';
  if (rawEmiDate != null && rawEmiDate != '-') {
    try {
      final parsedDate =
          DateFormat("EEE MMM dd HH:mm:ss 'IST' yyyy").parse(rawEmiDate);
      formattedEmiDate =
          DateFormat('dd MMM yyyy').format(parsedDate); // ➜ e.g., 05 Aug 2025
    } catch (e) {
      AppLogger.error(
        'Date parsing error',
        e,
      );
    }
  }

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
              'Loan Applied Successfully',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              /* 'Loan Reference Number: $loanNumber\n'
              'First EMI Date: $firstEmiDate\n'
              'EMI: $emi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),*/
              'Loan Reference Number: ${AESEncryptionService.safeDecrypt(loanNumber)}\n'
              'First EMI Date: $formattedEmiDate\n'
              'Loan Amount: ${product?.productPrice ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void tdApplySuccessDialog(
    BuildContext context, TdAccOpeningResponse? response) {
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
            Text(
              response?.responseMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'TD Account Number: ${AESEncryptionService.safeDecrypt(response?.tdAccNo ?? '')}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void casaApplySuccessDialog(
    BuildContext context,
    CasaAccountCreateResponse? response,
    LoginUserReqResInfo loginResponse,
    BankOption selectedBank) {
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
            Text(
              response?.responseMessage ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Account Number: ${AESEncryptionService.decrypt(response?.accountNumber ?? '')}'
              '\nAccount Id: ${response?.accountId ?? ''}'
              '\nOpening balance: ${response?.openingBalance ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void photoAndImageUploadSuccess(BuildContext context) {
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
              'SUCCESS',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Image and Signature uploaded Successfully\n Please click Next button to create Customer',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void kycVerificationSuccess(BuildContext context) {
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
              'SUCCESS',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your KYC Verification is Success\n Please submit the form',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void emiSuccessDialog(BuildContext context, L2lEmiCalculateResponse response) {
  showDialog(
    context: context,
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
              'EMI DETAILS',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Loan EMI List: ${response.loanEmiList ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void customerRegistrationSuccessDialog(
    BuildContext context,
    GdbCustRtlAppResponse? response,
    String? customerCode,
    String? eKyc,
    LoginUserReqResInfo loginResponse,
    BankOption selectedBank) {
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
            Text(
              eKyc == "KYC"
                  ? "KYC Registered successfully"
                  : "Customer created successfully",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              eKyc == "KYC"
                  ? "KYC Id: ${customerCode ?? ''}"
                  : "Customer code: ${customerCode ?? ''}",
              //'\nInitial Limit: ${response?.initLimitVal ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                if (eKyc == "KYC") {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => buildDashboardEntry(
                              loginResponse: loginResponse,
                              selectedBank: selectedBank,
                            )),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showApplicationSuccess(BuildContext context, GdbChAppStatusReqRes response,
    LoginUserReqResInfo loginResponse, BankOption selectedBank) {
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
              'Application Status',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Applicant Id: ${response.applicantId ?? ''}'
              '\nStatus: ${response.applicationStatus ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showAccountSpecificSuccess(
    BuildContext context,
    AccSpecificRepaymentResponse response,
    LoginUserReqResInfo loginResponse,
    BankOption selectedBank) {
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
            Text(
              response.responseMessage ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showCustomerSpecificSuccess(
    BuildContext context,
    L2lLoanRepayResponse response,
    LoginUserReqResInfo loginResponse,
    BankOption selectedBank) {
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
            Text(
              response.message ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Payment Reference No: ${response.paymentReffNo ?? ''}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBackground,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildDashboardEntry(
                            loginResponse: loginResponse,
                            selectedBank: selectedBank,
                          )),
                  (route) => false,
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
