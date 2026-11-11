import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/handleLogin.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/password/forgot_password_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppVersionText.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../data/api/ApiClient.dart';
import '../../../../data/api/end_points/ApiEndPoints.dart';
import '../../../../data/api/end_points/UrlStorage.dart';
import '../../webView/privacy_policy_page.dart';

/// Desktop-only (>=900px) login form, styled to match the Desktop-9 design.
/// Same integration as [PasswordCard] (LoginBloc, handleLogin, forgot
/// password, change URL, privacy policy) — [PasswordCard] itself is left
/// untouched since it's still used by the 600-899px "tablet" branch of
/// LoginScreenWebLayout.
class PasswordCardWeb extends StatefulWidget {
  const PasswordCardWeb({super.key});

  @override
  State<PasswordCardWeb> createState() => _PasswordCardWebState();
}

class _PasswordCardWebState extends State<PasswordCardWeb> {
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
        handleLoginState(context, state);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(height: 8),
          AppTextField(
            key: const Key("login_password"),
            label: "Password",
            hintText: "Enter Your Password",
            controller: _passwordController,
            obscureText: false, // ALWAYS false — masking is manual now
            inputFormatters: [_passwordFormatter],
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
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen()),
                );
              },
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: AppColors.k613AF5, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key("login_secureLogin_button"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: const StadiumBorder(),
                backgroundColor: AppColors.k613AF5,
              ),
              onPressed: () {
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
          const SizedBox(height: 12),
          // Center(
          //   child: GestureDetector(
          //     onTap: _showChangeUrlDialog,
          //     child: const Text(
          //       "Change URL",
          //       style: TextStyle(
          //         color: AppColors.textSecondary,
          //         fontSize: 12,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Secure Banking  |  ",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              GestureDetector(
                onTap: () => _showPrivacyPolicy(context),
                child: const Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: AppColors.k613AF5,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Center(
            child: AppVersionText(),
          ),
        ],
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
  /*void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Privacy Policy",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: const Text(
                privacyPolicyText,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          actions: [
            AppButton(
              title: "Close",
              height: 53,
              fullWidth: true,
              enabledColor: AppColors.kDDDDDD,
              borderColor: AppColors.k613AF5,
              textColor: AppColors.k613AF5,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }*/

  void _showChangeUrlDialog() {
    String selectedOption = "dev";

    final Map<String, String> urls = {
      "public": "https://zampost.jmrinfotech.com/abapigw/agent/channel/",
      "dev": "http://192.168.3.69:8082/abapigw/agent/channel/",
      "other": ""
    };

    TextEditingController urlController =
        TextEditingController(text: urls["dev"]);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text(
                "Update Base URL",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      hintText: "Enter or edit URL",
                    ),
                  ),
                  const SizedBox(height: 10),
                  RadioListTile<String>(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Public URL",
                      style: TextStyle(fontSize: 13),
                    ),
                    value: "public",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedOption = value!;
                        urlController.text = urls[value]!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Dev URL",
                      style: TextStyle(fontSize: 13),
                    ),
                    value: "dev",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedOption = value!;
                        urlController.text = urls[value]!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    dense: true,
                    visualDensity: const VisualDensity(vertical: -2),
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Others",
                      style: TextStyle(fontSize: 13),
                    ),
                    value: "other",
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedOption = value!;
                        urlController.text = urls[value]!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.k613AF5,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String newUrl = urlController.text.trim();

                    if (newUrl.isNotEmpty) {
                      await UrlStorage.setBaseUrl(newUrl);
                      ApiClient().updateBaseUrl(newUrl);

                      setState(() {
                        ApiEndpoints.baseUrl = newUrl;
                      });

                      Navigator.pop(context);

                      showCustomBottomPopup(
                          context, "URL Updated Successfully");
                    }
                  },
                  child: const Text("Update"),
                )
              ],
            );
          },
        );
      },
    );
  }
}
