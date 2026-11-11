import 'package:citizenone_app/modules/agency_banking/presentation/screens/password/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/common_models/HeaderInfo.dart';
import '../data/models/login_models/UserOtpValidationInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import '../presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import '../presentation/blocs/forgot_password_bloc/forgot_password_event.dart';
import '../presentation/blocs/reset_password_bloc/reset_password_bloc.dart';




/// Handles the submission of the mobile number for OTP verification.
void handleForgotPasswordSubmit(
    BuildContext context,
    TextEditingController mobileController,
    GlobalKey<FormState> formKey,
    void Function(String) setOtpUniqueId) {
  String mobileNumber = mobileController.text;

  if (mobileNumber.length < 9) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please check Mobile Number, it must be 9 digits.',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
      ),
    );
    return;
  }

  UserOTPValidationInfo otpRequest = UserOTPValidationInfo();
  otpRequest.mobileNo = mobileNumber;
  otpRequest.userName = mobileNumber;
  otpRequest.headerInfo = HeaderInfo()..message = "SKIP_SESSION";

  context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted(otpRequest));
}

/// Shows a dialog to enter and verify the password.
void showPasswordDialog(
    BuildContext context, AuthService authService, String otpUniqueId, String mobileNumber) {
  TextEditingController passwordController = TextEditingController();
  Color myHexColor = const Color(0xff5c7d33);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Customer Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => _verifyPassword(
                context, authService, otpUniqueId, mobileNumber, passwordController.text),
            style: ElevatedButton.styleFrom(backgroundColor: myHexColor),
            child: const Text('Verify', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// Verifies the password and navigates to the reset password screen if successful.
void _verifyPassword(BuildContext context, AuthService authService, String otpUniqueId,
    String mobileNumber, String password) async {
  UserOTPValidationInfo otpInfo = UserOTPValidationInfo();
  otpInfo.otp = password;
  otpInfo.otpuniqueid = otpUniqueId;
  otpInfo.mobileNo = mobileNumber;
  otpInfo.userName = mobileNumber;
  otpInfo.headerInfo.message = "SKIP_SESSION";

  final response = await authService.otpFailedValidation(otpInfo);

  if (response != null && response.resMessage.errorCode == "AB-ATTEMPT-100") {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ResetPasswordBloc(authService),
          child: ResetPasswordScreen(mobileNumber: mobileNumber),
        ),
      ),
    );
  }
  else
  {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to verify password',style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,)
    );
  }
}
