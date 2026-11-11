import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_success_screen.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_password_bloc/reset_password_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_password_bloc/reset_password_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/AbAgentForgotChangePwd.dart';
import '../../../../data/services/AuthService.dart';
import '../../../../utils/AESEncryption.dart';
import '../../Dashboard/widgets/BankSelectionScreen.dart';
import 'widgets/change_password_web_view.dart';

class ChangePasswordScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final bool isFirstTimeLogin;
  final bool isPasswordExpired;

  const ChangePasswordScreen(
      {Key? key,
      required this.loginResponse,
      this.isFirstTimeLogin = false,
      this.isPasswordExpired = false})
      : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String oldpassword = '';
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get _isButtonEnabled =>
      _passwordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _newPasswordController.text == _confirmPasswordController.text;

  late final PasswordMaskingFormatter _currentPasswordFormatter =
      PasswordMaskingFormatter(
    getObscure: () => !_isPasswordVisible,
  );

  late final PasswordMaskingFormatter _newPasswordFormatter =
      PasswordMaskingFormatter(
    getObscure: () => !_isNewPasswordVisible,
  );

  late final PasswordMaskingFormatter _confirmPasswordFormatter =
      PasswordMaskingFormatter(
    getObscure: () => !_isConfirmPasswordVisible,
  );

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
    _newPasswordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
    oldpassword = AESEncryptionService.decrypt(
        widget.loginResponse.loginUserInfo.password ?? "");
  }

  void _updateButtonState() => setState(() {});

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility({
    required TextEditingController controller,
    required PasswordMaskingFormatter formatter,
    required bool isVisible,
    required ValueSetter<bool> setVisible,
  }) {
    setState(() {
      final visible = !isVisible;
      setVisible(visible);

      final display =
          visible ? formatter.realValue : '•' * formatter.realValue.length;

      controller.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
    });
  }

  void _handleSubmit() {
    final resetRequest = AbAgentForgetChangePwd(
      headerInfo: HeaderInfo(message: "SKIP_SESSION", initialAccess: true),
      userName: widget.loginResponse.loginUserInfo.userName ?? "",
      newPwd: AESEncryptionService.encrypt(_newPasswordFormatter.realValue),
      deviceId: AESEncryptionService.encrypt("3704e319b72f9d3e"),
      status: '',
      pwd: AESEncryptionService.encrypt(_currentPasswordFormatter.realValue),
      confPword: '',
      agentCode: '',
      otp: '',
      email: '',
      ph_no: '',
    );

    context.read<ResetPasswordBloc>().add(ResetPasswordSubmitted(resetRequest));
  }

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

  PreferredSizeWidget? _buildAppBar(bool isMobile) {
    if (!isMobile) {
      return null;
    }
    final String title =
        widget.isFirstTimeLogin ? "Set Your Password" : "Change Password";
    final String subtitle = widget.isFirstTimeLogin
        ? "Set your password to continue"
        : "Update your account password";

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 130),
      child: Backgroundcomponent(
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
              label: widget.isFirstTimeLogin
                  ? "Temporary Password"
                  : widget.isPasswordExpired
                      ? "Old Password"
                      : "Current Password",
              // !widget.isFirstTimeLogin //widget.isPasswordExpired
              //     ? "Current Password"
              //     : "Temporary Password",
              hintText: widget.isFirstTimeLogin
                  ? "Enter Temporary Password"
                  : widget.isPasswordExpired
                      ? "Enter Old Password"
                      : "Enter Current Password",
              controller: _passwordController,
              obscureText: false, // ALWAYS false — masking is manual now
              inputFormatters: [_currentPasswordFormatter], // does the masking
              maxLength: 30,
              fillColor: AppColors.primaryInputBackground,
              prefixIcon: "assets/icons/lock_outline.svg",
              suffixIcon: IconButton(
                icon: !_isPasswordVisible
                    ? SvgPicture.asset(
                        "assets/icons/remove_red_eye.svg",
                        width: 18,
                        height: 18,
                      )
                    : const Icon(Icons.visibility_off_outlined,
                        size: 20, color: AppColors.k613AF5),
                onPressed: () {
                  _togglePasswordVisibility(
                    controller: _passwordController,
                    formatter: _currentPasswordFormatter,
                    isVisible: _isPasswordVisible,
                    setVisible: (value) => _isPasswordVisible = value,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.borderLight),
            const SizedBox(height: 12),
            AppTextField(
              label: "New Password",
              hintText: "Enter Your New Password",
              controller: _newPasswordController,
              obscureText: false, // ALWAYS false — masking is manual now
              inputFormatters: [_newPasswordFormatter], // does the masking
              maxLength: 30,
              fillColor: AppColors.primaryInputBackground,
              prefixIcon: "assets/icons/lock_outline.svg",
              suffixIcon: IconButton(
                icon: !_isNewPasswordVisible
                    ? SvgPicture.asset(
                        "assets/icons/remove_red_eye.svg",
                        width: 18,
                        height: 18,
                      )
                    : const Icon(Icons.visibility_off_outlined,
                        size: 20, color: AppColors.k613AF5),
                onPressed: () {
                  _togglePasswordVisibility(
                    controller: _newPasswordController,
                    formatter: _newPasswordFormatter,
                    isVisible: _isNewPasswordVisible,
                    setVisible: (value) => _isNewPasswordVisible = value,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: "Confirm Password",
              hintText: "Enter Your Confirm Password",
              controller: _confirmPasswordController,
              obscureText: false, // ALWAYS false — masking is manual now
              inputFormatters: [_confirmPasswordFormatter], // does the masking
              maxLength: 30,
              fillColor: AppColors.primaryInputBackground,
              prefixIcon: "assets/icons/lock_outline.svg",
              suffixIcon: IconButton(
                icon: !_isConfirmPasswordVisible
                    ? SvgPicture.asset(
                        "assets/icons/remove_red_eye.svg",
                        width: 18,
                        height: 18,
                      )
                    : const Icon(Icons.visibility_off_outlined,
                        size: 20, color: AppColors.k613AF5),
                onPressed: () {
                  _togglePasswordVisibility(
                    controller: _confirmPasswordController,
                    formatter: _confirmPasswordFormatter,
                    isVisible: _isConfirmPasswordVisible,
                    setVisible: (value) => _isConfirmPasswordVisible = value,
                  );
                },
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 16, vertical: 24),
      ),
    );
  }

  Widget _buildWebBody() {
    return ChangePasswordWebView(
      isFirstTimeLogin: widget.isFirstTimeLogin,
      isPasswordExpired: widget.isPasswordExpired,
      passwordController: _passwordController,
      newPasswordController: _newPasswordController,
      confirmPasswordController: _confirmPasswordController,
      obscurePassword: false,
      obscureNewPassword: false,
      obscureConfirmPassword: false,
      currentPasswordFormatter: _currentPasswordFormatter,
      newPasswordFormatter: _newPasswordFormatter,
      confirmPasswordFormatter: _confirmPasswordFormatter,
      onTogglePasswordVisibility: () {
        _togglePasswordVisibility(
          controller: _passwordController,
          formatter: _currentPasswordFormatter,
          isVisible: _isPasswordVisible,
          setVisible: (value) => _isPasswordVisible = value,
        );
      },
      onToggleNewPasswordVisibility: () {
        _togglePasswordVisibility(
          controller: _newPasswordController,
          formatter: _newPasswordFormatter,
          isVisible: _isNewPasswordVisible,
          setVisible: (value) => _isNewPasswordVisible = value,
        );
      },
      onToggleConfirmPasswordVisibility: () {
        _togglePasswordVisibility(
          controller: _confirmPasswordController,
          formatter: _confirmPasswordFormatter,
          isVisible: _isConfirmPasswordVisible,
          setVisible: (value) => _isConfirmPasswordVisible = value,
        );
      },
      isButtonEnabled: _isButtonEnabled,
      onSubmit: _handleSubmit,
      onCancel: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isLoading =
        context.watch<ResetPasswordBloc>().state is ResetPasswordLoading;

    return Scaffold(
      backgroundColor:
          isMobile ? AppMobileColors.background : AppColors.loginBackground,
      appBar: _buildAppBar(isMobile),

      // ✅ FIXED PERFECT BOTTOM BUTTON
      bottomNavigationBar: isMobile
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                    backgroundColor: (_isButtonEnabled && !isLoading)
                        ? AppColors.k613AF5
                        : AppColors.primaryButtonBackgroundInactiveColor,
                  ),
                  onPressed:
                      (_isButtonEnabled && !isLoading) ? _handleSubmit : null,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: (_isButtonEnabled && !isLoading)
                          ? Colors.white
                          : AppColors.primaryButtonInactiveTextColor,
                    ),
                  ),
                ),
              ),
            )
          : null,

      body: Stack(
        children: [
          BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
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
              return isMobile
                  ? SingleChildScrollView(child: _buildMobileBody())
                  : _buildWebBody();
            },
          ),
          const GlobalLoader(),
        ],
      ),
    );
  }
}
