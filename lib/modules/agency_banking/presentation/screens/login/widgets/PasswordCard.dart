import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/handleLogin.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/privacy_policy_content.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/password/forgot_password_screen.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppVersionText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../widgets/dialogs/update_base_url_dialog.dart';
import '../../Loans/application_form/widgets/labeled_textField.dart';
import '../../webView/privacy_policy_page.dart';
import 'password_masking_formatter.dart'; // NEW

class PasswordCard extends StatefulWidget {
  const PasswordCard({super.key});

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
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
      child: Material(
        elevation: 0,
        color: AppColors.loginBackground,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
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
            children: [
              // Username
              LabeledTextField(
                key: const Key("login_mobile_number"),
                label: "Mobile Number",
                hint: "Enter Mobile Number",
                controller: _usernameController,
                keyboardType: TextInputType.number,
                maxLength: 9,
                backgroundColor: AppColors.white,
                prefixIcon:
                    const Icon(Icons.person_outline, color: Colors.grey),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // unchanged
                ],
              ),

              const SizedBox(height: 10),

              // Password — FIXED: no more obscureText flash on any device
              LabeledTextField(
                key: const Key("login_password"),
                label: "Password",
                hint: "Enter Password",
                controller: _passwordController,
                obscureText: false, // ALWAYS false — masking is manual now
                inputFormatters: [_passwordFormatter], // does the masking
                maxLength: 15,
                backgroundColor: AppColors.white,
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleObscurePassword,
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
                      style: TextStyle(color: AppColors.black, fontSize: 12),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.fbLiteDark,
                  ),
                  onPressed: () {
                    handleLogin(
                      context,
                      _usernameController.text,
                      _passwordFormatter.realValue, // FIXED: real password
                    );
                  },
                  child: const Text(
                    "Secure Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Change URL Button (Centered)
              // Center(
              //   child: GestureDetector(
              //     onTap: _showChangeUrlDialog,
              //     child: const Text(
              //       "Change URL",
              //       style: TextStyle(
              //         color: AppColors.black,
              //         fontSize: 12,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),

              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Secure Banking  |  ",
                        style: TextStyle(color: AppColors.black, fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () => _showPrivacyPolicy(context),
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.blue_grey_light,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Center(
                child: AppVersionText(),
              ),
            ],
          ),
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

  Future<void> _showChangeUrlDialog() async {
    final newUrl = await UpdateBaseUrlDialog.show(context);
    if (newUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Base URL updated to $newUrl')),
      );
    }
    /*final deviceId = await DeviceIdHelper().getDeviceId();
    print('Device ID: $deviceId');*/
  }
}
