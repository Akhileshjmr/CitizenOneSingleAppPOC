import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_success_screen.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AESEncryption.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../data/models/common_models/HeaderInfo.dart';
import '../../../data/models/login_models/AbAgentForgotChangePwd.dart';
import '../../../data/services/AuthService.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../blocs/reset_password_bloc/reset_password_bloc.dart';
import '../../blocs/reset_password_bloc/reset_password_event.dart';
import '../../blocs/reset_password_bloc/reset_password_state.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import 'widgets/reset_password_web_view.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobileNumber; // Accept mobile number as parameter
  final bool isFirstTimeLogin;
  final LoginUserReqResInfo? loginResponse;

  ResetPasswordScreen({
    required this.mobileNumber,
    this.loginResponse,
    this.isFirstTimeLogin = false,
  });

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  late TextEditingController _mobileNumberController; // Initialize in initState

  // Formatter for New Password
  late final PasswordMaskingFormatter _passwordFormatter =
      PasswordMaskingFormatter(
    getObscure: () => _isObscureNewPassword,
  );

// Formatter for Confirm Password
  late final PasswordMaskingFormatter _confirmPasswordFormatter =
      PasswordMaskingFormatter(
    getObscure: () => _isObscureConfirmPassword,
  );

  @override
  void initState() {
    super.initState();

    _mobileNumberController = TextEditingController(
      text: widget.isFirstTimeLogin
          ? AESEncryptionService.decrypt(
              widget.loginResponse?.loginUserInfo.userName ?? "",
            )
          : widget.mobileNumber,
    );

    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() => setState(() {});

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _toggleNewPassword() {
    setState(() {
      _isObscureNewPassword = !_isObscureNewPassword;

      final display = _isObscureNewPassword
          ? '•' * _passwordFormatter.realValue.length
          : _passwordFormatter.realValue;

      _passwordController.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _isObscureConfirmPassword = !_isObscureConfirmPassword;

      final display = _isObscureConfirmPassword
          ? '•' * _confirmPasswordFormatter.realValue.length
          : _confirmPasswordFormatter.realValue;

      _confirmPasswordController.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
    });
  }

  // ---------------- PASSWORD REQUIREMENTS (mobile checklist, presentational) ----------------
  bool get _hasValidLength =>
      _passwordController.text.length >= 8 &&
      _passwordController.text.length <= 30;
  bool get _hasUpperCase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get _hasLowerCase => RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSpecialChar =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);
  bool get _noSuccessiveChars =>
      !RegExp(r'(.)\1{3,}').hasMatch(_passwordController.text);
  bool get _noExcessRepeatedChars {
    final counts = <String, int>{};
    for (final ch in _passwordController.text.split('')) {
      counts[ch] = (counts[ch] ?? 0) + 1;
      if (counts[ch]! > 3) return false;
    }
    return true;
  }

  bool get _isMobileButtonEnabled =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  Future<void> _navigateToLoginMobile(BuildContext context) async {
    await clearStoredLoginData();
    await BankSelectionHelper.clearBankSelection();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(AuthService()),
            child: const LoginScreen(),
          ),
        ),
        (route) => false,
      );
    }
  }

  void _handleSubmit() {
    // Mobile masks input via _passwordFormatter/_confirmPasswordFormatter,
    // so the real value lives in formatter.realValue (controller.text holds
    // the masked dots). Web uses the field's built-in obscureText instead —
    // no formatter is attached there — so controller.text already holds the
    // real value.
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    String newPassword =
        isMobile ? _passwordFormatter.realValue : _passwordController.text;
    String confirmPassword = isMobile
        ? _confirmPasswordFormatter.realValue
        : _confirmPasswordController.text;

    if (newPassword.isEmpty && confirmPassword.isEmpty) {
      showCustomBottomPopup(
          context, "New Password and Confirm Password are required");
      return;
    }

    if (newPassword.isEmpty) {
      showCustomBottomPopup(context, "New Password is required");
      return;
    }

    if (confirmPassword.isEmpty) {
      showCustomBottomPopup(context, "Confirm Password is required");
      return;
    }

    if (newPassword != confirmPassword) {
      showCustomBottomPopup(context, "Passwords do not match");
      return;
    }

    // Prepare the Reset Password request
    AbAgentForgetChangePwd resetRequest = AbAgentForgetChangePwd(
      headerInfo: HeaderInfo(message: "SKIP_SESSION", initialAccess: true),
      userName: widget.isFirstTimeLogin
          ? (widget.loginResponse?.loginUserInfo.userName ?? "")
          : AESEncryptionService.encrypt(_mobileNumberController.text),
      // Use the mobile number
      status: "",
      newPwd: AESEncryptionService.encrypt(newPassword),
      pwd: "",
      agentCode: "",
      deviceId: AESEncryptionService.encrypt("3704e319b72f9d3e"),
      otp: "",
      email: "",
      ph_no: "",
      confPword: '',
    );

    // Trigger BLoC event
    context.read<ResetPasswordBloc>().add(ResetPasswordSubmitted(resetRequest));
  }

  Widget _buildRequirementRow(String label, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isMet ? AppColors.k613AF5 : AppColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 13,
              color: isMet ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isMet ? AppColors.k613AF5 : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody(BuildContext context, ResetPasswordState state) {
    final bool isLoading = state is ResetPasswordLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        Backgroundcomponent(
          // Container(
          //   width: double.infinity,
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(18),
          //   ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: "New Password",
                hintText: "Enter Your New Password",
                controller: _passwordController,
                obscureText: false, // ALWAYS false — masking is manual now
                inputFormatters: [_passwordFormatter], // does the masking
                enabled: !isLoading,
                maxLength: 30,
                fillColor: AppColors.primaryInputBackground,
                prefixIcon: "assets/icons/lock_outline.svg",
                suffixIcon: IconButton(
                  icon: _isObscureNewPassword
                      ? SvgPicture.asset(
                          "assets/icons/remove_red_eye.svg",
                          width: 18,
                          height: 18,
                        )
                      : const Icon(Icons.visibility_off_outlined,
                          size: 20, color: AppColors.k613AF5),
                  onPressed: () {
                    _toggleNewPassword();
                  },
                ),
              ),
              const SizedBox(height: 8),
              AppTextField(
                label: "Confirm Password",
                hintText: "Enter Your Confirm Password",
                controller: _confirmPasswordController,
                obscureText: false, // ALWAYS false — masking is manual now
                inputFormatters: [
                  _confirmPasswordFormatter
                ], // does the masking
                enabled: !isLoading,
                maxLength: 30,
                fillColor: AppColors.primaryInputBackground,
                prefixIcon: "assets/icons/lock_outline.svg",
                suffixIcon: IconButton(
                  icon: _isObscureConfirmPassword
                      ? SvgPicture.asset(
                          "assets/icons/remove_red_eye.svg",
                          width: 18,
                          height: 18,
                        )
                      : const Icon(Icons.visibility_off_outlined,
                          size: 20, color: AppColors.k613AF5),
                  onPressed: () {
                    _toggleConfirmPassword();
                  },
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        const SizedBox(height: 16),
        /*Backgroundcomponent(
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(18),
        //   ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Your password must contain:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildRequirementRow("8 - 30 characters", _hasValidLength),
              _buildRequirementRow("an upper case", _hasUpperCase),
              _buildRequirementRow("a lower case", _hasLowerCase),
              _buildRequirementRow("a number", _hasNumber),
              _buildRequirementRow("a special character", _hasSpecialChar),
              _buildRequirementRow(
                  "No successive characters over 3.", _noSuccessiveChars),
              _buildRequirementRow(
                  "Not contain characters more than 3", _noExcessRepeatedChars),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),*/
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWebBody(BuildContext context, ResetPasswordState state) {
    final bool isLoading = state is ResetPasswordLoading;

    return ResetPasswordWebView(
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      passwordFormatter: _passwordFormatter,
      confirmPasswordFormatter: _confirmPasswordFormatter,
      obscureNewPassword: _isObscureNewPassword,
      obscureConfirmPassword: _isObscureConfirmPassword,
      onToggleNewPasswordVisibility: _toggleNewPassword,
      onToggleConfirmPasswordVisibility: _toggleConfirmPassword,
      hasValidLength: _hasValidLength,
      hasUpperCase: _hasUpperCase,
      hasLowerCase: _hasLowerCase,
      hasNumber: _hasNumber,
      hasSpecialChar: _hasSpecialChar,
      noSuccessiveChars: _noSuccessiveChars,
      noExcessRepeatedChars: _noExcessRepeatedChars,
      isButtonEnabled: _isMobileButtonEnabled,
      isLoading: isLoading,
      onSubmit: _handleSubmit,
      onCancel: () => Navigator.pop(context),
    );
  }

  PreferredSizeWidget? _buildAppBar(bool isMobile) {
    if (!isMobile) {
      return null;
    }
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create Password",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Set a strong password for your account",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isLoading =
        context.watch<ResetPasswordBloc>().state is ResetPasswordLoading;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: _buildAppBar(isMobile),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 16.0 : 0),
            child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
              listener: (context, state) {
                if (state is ResetPasswordLoading) {
                  context.read<LoadingCubit>().show();
                } else {
                  context.read<LoadingCubit>().hide();
                }
                if (state is ResetPasswordSuccess) {
                  if (isMobile) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (routeContext) => WillPopScope(
                          onWillPop: () async {
                            await _navigateToLoginMobile(routeContext);
                            return false;
                          },
                          child: AppSuccessScreen(
                            message:
                                "Your Password has been\nSuccessfully Updated.",
                            buttonText: "Login Now",
                            onButtonPressed: () =>
                                _navigateToLoginMobile(routeContext),
                          ),
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (routeContext) => WillPopScope(
                          onWillPop: () async {
                            await _navigateToLoginMobile(routeContext);
                            return false;
                          },
                          child: AppSuccessScreen(
                            message:
                                "Your Password has been Successfully Updated.",
                            buttonText: "Login Now",
                            onButtonPressed: () =>
                                _navigateToLoginMobile(routeContext),
                            useWebLayout: true,
                          ),
                        ),
                      ),
                    );
                  }
                } else if (state is ResetPasswordFailure) {
                  showCustomBottomPopup(context, state.error);
                }
              },
              builder: (context, state) {
                if (isMobile) {
                  return SingleChildScrollView(
                    child: _buildMobileBody(context, state),
                  );
                }

                return _buildWebBody(context, state);
              },
            ),
          ),
          const GlobalLoader(),
        ],
      ),
      bottomNavigationBar: isMobile
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: (_isMobileButtonEnabled && !isLoading)
                        ? AppColors.k613AF5
                        : AppColors.primaryButtonBackgroundInactiveColor,
                  ),
                  onPressed: (_isMobileButtonEnabled && !isLoading)
                      ? _handleSubmit
                      : null,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: (_isMobileButtonEnabled && !isLoading)
                          ? Colors.white
                          : AppColors.primaryButtonInactiveTextColor,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
