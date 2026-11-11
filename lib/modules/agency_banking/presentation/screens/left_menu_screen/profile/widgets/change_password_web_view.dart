import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Web-only (>=600px) view for Change Password / Set Your Password, styled
/// to match the Desktop-17 (first-time login) / Desktop-28 (password
/// expired) designs — centered card, no banner, Back + Submit side by side.
/// Kept in its own file so mobile's _buildMobileBody is never touched while
/// editing this. All state/dispatch is owned by ChangePasswordScreen and
/// passed in — same integration as mobile.
class ChangePasswordWebView extends StatelessWidget {
  final bool isFirstTimeLogin;
  final bool isPasswordExpired;
  final TextEditingController passwordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final bool isButtonEnabled;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final PasswordMaskingFormatter currentPasswordFormatter;
  final PasswordMaskingFormatter newPasswordFormatter;
  final PasswordMaskingFormatter confirmPasswordFormatter;

  const ChangePasswordWebView({
    super.key,
    required this.isFirstTimeLogin,
    required this.isPasswordExpired,
    required this.passwordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.isButtonEnabled,
    required this.onSubmit,
    required this.onCancel,
    required this.currentPasswordFormatter,
    required this.newPasswordFormatter,
    required this.confirmPasswordFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final String title = isFirstTimeLogin
        ? "Set Your Password"
        : (isPasswordExpired ? "Old Password" : "Change Password");
    final String subtitle = isFirstTimeLogin
        ? "Set your password to continue"
        : "Update your account password";
    final String firstFieldLabel = isFirstTimeLogin
        ? "Temporary Password"
        : isPasswordExpired
            ? "Old Password"
            : "Current Password";
    final String firstFieldHint =
        isPasswordExpired ? "Enter Old Password" : "Enter Temporary Password";

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Backgroundcomponent(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      firstFieldLabel,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    hintText: firstFieldHint,
                    controller: passwordController,
                    obscureText: false,
                    inputFormatters: [currentPasswordFormatter],
                    maxLength: 30,
                    prefixIcon: 'assets/icons/lock_outline.svg',
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: obscurePassword
                          ? SvgPicture.asset(
                              "assets/icons/remove_red_eye.svg",
                              width: 18,
                              height: 18,
                            )
                          : const Icon(Icons.visibility_off_outlined,
                              size: 20, color: AppColors.k613AF5),
                      onPressed: onTogglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: AppColors.borderLight),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    hintText: "Enter Your New Password",
                    prefixIcon: 'assets/icons/lock_outline.svg',
                    controller: newPasswordController,
                    obscureText: false,
                    inputFormatters: [newPasswordFormatter],
                    maxLength: 30,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: obscureNewPassword
                          ? SvgPicture.asset(
                              "assets/icons/remove_red_eye.svg",
                              width: 18,
                              height: 18,
                            )
                          : const Icon(Icons.visibility_off_outlined,
                              size: 20, color: AppColors.k613AF5),
                      onPressed: onToggleNewPasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Confirm Password",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    hintText: "Enter Your Confirm Password",
                    prefixIcon: 'assets/icons/lock_outline.svg',
                    controller: confirmPasswordController,
                    obscureText: false,
                    inputFormatters: [confirmPasswordFormatter],
                    maxLength: 30,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: obscureConfirmPassword
                          ? SvgPicture.asset(
                              "assets/icons/remove_red_eye.svg",
                              width: 18,
                              height: 18,
                            )
                          : const Icon(Icons.visibility_off_outlined,
                              size: 20, color: AppColors.k613AF5),
                      onPressed: onToggleConfirmPasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: AppColors.k613AF5),
                          ),
                          onPressed: onCancel,
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.k613AF5,
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
                            backgroundColor: isButtonEnabled
                                ? AppColors.k613AF5
                                : AppColors
                                    .primaryButtonBackgroundInactiveColor,
                          ),
                          onPressed: isButtonEnabled ? onSubmit : null,
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isButtonEnabled
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
            ),
          ),
        ),
      ),
    );
  }
}
