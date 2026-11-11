import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../theme/colors/Appcolors.dart';
import '../../../utils/CommSuccessDialogues.dart';
import '../../blocs/security_bloc/security_bloc.dart';
import '../../blocs/security_bloc/security_event.dart';
import '../../blocs/security_bloc/security_state.dart';
import '../../responsive/breakpoints.dart';
import '../Dashboard/widgets/account_desktop_shell.dart';
import 'security_success_screen.dart';

class SecurityChangePasswordScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;

  const SecurityChangePasswordScreen({super.key, required this.loginResponse});

  @override
  State<SecurityChangePasswordScreen> createState() =>
      _SecurityChangePasswordScreenState();
}

class _SecurityChangePasswordScreenState
    extends State<SecurityChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool get _isButtonEnabled =>
      _currentPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _newPasswordController.text == _confirmPasswordController.text;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_updateState);
    _newPasswordController.addListener(_updateState);
    _confirmPasswordController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    context.read<SecurityBloc>().add(ChangePasswordSubmitted(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          loginResponse: widget.loginResponse,
        ));
  }

  void _onSecurityState(BuildContext context, SecurityState state) {
    if (state is SecurityLoading) {
      context.read<LoadingCubit>().show();
    } else {
      context.read<LoadingCubit>().hide();
    }

    if (state is ChangePasswordSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SecuritySuccessScreen(),
        ),
      );
    } else if (state is ChangePasswordFailure) {
      showCustomBottomPopup(context, state.error);
    }
  }

  List<Widget> _buildPasswordFields(bool isLoading) {
    return [
      AppTextField(
        label: "Current Password",
        hintText: "Enter Your Password",
        controller: _currentPasswordController,
        enabled: !isLoading,
        obscureText: !_isCurrentPasswordVisible,
        fillColor: AppColors.primaryInputBackground,
        prefixIcon: "assets/icons/lock_outline.svg",
        suffixIcon: IconButton(
          icon: Icon(
            _isCurrentPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.k613AF5,
          ),
          onPressed: isLoading
              ? null
              : () {
                  setState(() {
                    _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                  });
                },
        ),
      ),
      const SizedBox(height: 8),
      AppTextField(
        label: "New Password",
        hintText: "Enter Your New Password",
        controller: _newPasswordController,
        enabled: !isLoading,
        obscureText: !_isNewPasswordVisible,
        fillColor: AppColors.primaryInputBackground,
        prefixIcon: "assets/icons/lock_outline.svg",
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.k613AF5,
          ),
          onPressed: isLoading
              ? null
              : () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
        ),
      ),
      const SizedBox(height: 8),
      AppTextField(
        label: "Confirm Password",
        hintText: "Enter Your New Password",
        controller: _confirmPasswordController,
        enabled: !isLoading,
        obscureText: !_isConfirmPasswordVisible,
        fillColor: AppColors.primaryInputBackground,
        prefixIcon: "assets/icons/lock_outline.svg",
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.k613AF5,
          ),
          onPressed: isLoading
              ? null
              : () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
        ),
      ),
      /* if (_newPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _newPasswordController.text != _confirmPasswordController.text)
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "New Password and Confirm Password do not match.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          if (Breakpoints.isDesktop(constraints.maxWidth)) {
            return _buildDesktop(context);
          }
          return _buildMobile(context,
              isTablet: Breakpoints.isTablet(constraints.maxWidth));
        }),
        const GlobalLoader(),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return AccountDesktopScaffold(
      loginResponse: widget.loginResponse,
      activeItem: AccountNavItem.security,
      pageTitle: "Security",
      pageSubtitle: "Your Security, Our Priority.",
      maxContentWidth: 680,
      child: BlocConsumer<SecurityBloc, SecurityState>(
        listener: _onSecurityState,
        builder: (context, state) {
          final bool isLoading = state is SecurityLoading;
          final bool enabled = _isButtonEnabled && !isLoading;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.k0D1F4D,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Update your account password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: AppColors.k868686),
                ),
                const SizedBox(height: 28),
                ..._buildPasswordFields(isLoading),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                          side: const BorderSide(color: AppColors.k0D1F4D),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.k0D1F4D,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                          backgroundColor: enabled
                              ? AppColors.k613AF5
                              : AppColors.primaryButtonBackgroundInactiveColor,
                        ),
                        onPressed: enabled ? _handleSubmit : null,
                        child: Text(
                          isLoading ? "Please wait..." : "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: enabled
                                ? Colors.white
                                : AppColors.primaryButtonInactiveTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobile(BuildContext context, {bool isTablet = false}) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
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
              "Change Password",
              style: TextStyle(
                color: AppColors.k0F0F0F,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Update your account password",
              style: TextStyle(
                color: AppColors.k868686,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: isTablet ? 640 : double.infinity),
                child: BlocBuilder<SecurityBloc, SecurityState>(
                  builder: (context, state) {
                    final bool isLoading = state is SecurityLoading;
                    final bool enabled = _isButtonEnabled && !isLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                          backgroundColor: enabled
                              ? AppColors.k613AF5
                              : AppColors.primaryButtonBackgroundInactiveColor,
                        ),
                        onPressed: enabled ? _handleSubmit : null,
                        child: Text(
                          isLoading ? "Please wait..." : "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: enabled
                                ? Colors.white
                                : AppColors.primaryButtonInactiveTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<SecurityBloc, SecurityState>(
        listener: _onSecurityState,
        builder: (context, state) {
          final bool isLoading = state is SecurityLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: isTablet ? 640 : double.infinity),
                child: Backgroundcomponent(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildPasswordFields(isLoading),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
