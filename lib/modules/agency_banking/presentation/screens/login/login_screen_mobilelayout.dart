import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/form/app_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/handleLogin.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/privacy_policy_content.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/password/forgot_password_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppVersionText.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/widgets/BackgroundComponent.dart';
import '../../../data/api/ApiClient.dart';
import '../../../data/api/end_points/ApiEndPoints.dart';
import '../../../data/api/end_points/UrlStorage.dart';
import '../../../utils/Loader.dart';
import '../../blocs/login_bloc/login_bloc.dart';
import '../../blocs/login_bloc/login_state.dart';
import '../webView/privacy_policy_page.dart';

/// Mobile login screen — logo, heading, Mobile Number/Password fields and
/// Secure Login button, matching the CitizenOne mobile design. Rendered by
/// ResponsiveLayout only when screen width < 600, so it owns no web-layout
/// branching of its own; LoginScreenWebLayout continues to serve web/tablet.
class LoginScreenMobilelayout extends StatefulWidget {
  const LoginScreenMobilelayout({super.key});

  @override
  State<LoginScreenMobilelayout> createState() =>
      _LoginScreenMobilelayoutState();
}

class _LoginScreenMobilelayoutState extends State<LoginScreenMobilelayout> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  // NEW: formatter that fully replaces obscureText-based masking.
  late final PasswordMaskingFormatter _passwordFormatter =
      PasswordMaskingFormatter(getObscure: () => _obscurePassword);

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // NEW: single place that toggles obscure + refreshes the displayed text.
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;

      final display = _obscurePassword
          ? '•' * _passwordFormatter.realValue.length
          : _passwordFormatter.realValue;

      _passwordController.value = TextEditingValue(
        text: display,
        selection: TextSelection.collapsed(offset: display.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          FocusScope.of(context).unfocus();
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }
        handleLoginState(context, state);
      },
      child: Scaffold(
        backgroundColor: AppMobileColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Backgroundcomponent(
                          //     child:
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // const SizedBox(height: 24),
                              SizedBox(
                                height: 86,
                                width: 212,
                                child: Image.asset(
                                  'assets/icons/citizenLogo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 36),
                              Backgroundcomponent(
                                child: _buildLoginCard(context),
                              ),
                            ],
                            // ),
                          ).paddingSymmetric(horizontal: 24),
                          const SizedBox(height: 10),

                          // Change URL
                          /*Center(
                            child: GestureDetector(
                              onTap: _showChangeUrlDialog,
                              child: const Text(
                                "Change URL",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),*/

                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Secure Banking  |  ",
                                style: TextStyle(
                                    color: AppColors.black, fontSize: 12),
                              ),
                              GestureDetector(
                                onTap: () => _showPrivacyPolicy(context),
                                child: const Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                    color: AppColors.k613AF5,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Center(
                            child: AppVersionText(),
                          ),
                        ]),
                  ),
                ),
              ),
              const GlobalLoader(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    return Material(
      elevation: 0,
      color: AppMobileColors.cBackground,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.loginBackground,
              blurRadius: 18,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mobile Number
            // const SizedBox(height: 8),
            const Text(
              "Welcome to CitizenOne",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Sign in to continue to your account",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              key: const Key("login_mobile_number"),
              label: "Mobile Number",
              hintText: "Enter Mobile Number",
              controller: _usernameController,
              keyboardType: TextInputType.number,
              maxLength: 9,
              fillColor: AppColors.primaryInputBackground,
              prefixIcon: "assets/icons/person_outline.svg",
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),

            const SizedBox(height: 10),

            // Password
            AppTextField(
              key: const Key("login_password"),
              label: "Password",
              hintText: "Enter Password",
              controller: _passwordController,
              obscureText: false, // ALWAYS false — masking is manual now
              inputFormatters: [_passwordFormatter], // does the masking
              maxLength: 15,
              fillColor: AppColors.primaryInputBackground,
              prefixIcon: "assets/icons/lock_outline.svg",
              suffixIcon: IconButton(
                icon: _obscurePassword
                    ? SvgPicture.asset(
                        "assets/icons/remove_red_eye.svg",
                        width: 18,
                        height: 18,
                      )
                    : const Icon(Icons.visibility_off_outlined,
                        size: 20, color: AppColors.k613AF5),
                onPressed: () {
                  _toggleObscurePassword();
                },
              ),
            ),

            const SizedBox(height: 2),
            // Forgot
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: AppColors.k613AF5, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key("login_secureLogin_button"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                  backgroundColor: AppColors.k613AF5,
                ),
                onPressed: () {
                  AppLogger.debug("Controller : ${_passwordController.text}");
                  AppLogger.debug(
                      "Real Value : ${_passwordFormatter.realValue}");
                  handleLogin(
                    context,
                    _usernameController.text,
                    _passwordFormatter.realValue,
                  );
                },
                child: const Text(
                  "Secure Login",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyPage(),
      ),
    );
  }
}
