import 'package:citizenone_app/modules/agency_banking/core/widgets/BackgroundComponent.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/app_text_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/password_masking_formatter.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Web-only (>=600px) "Create Password" view, styled to match the
/// Desktop-61 design — centered card, no banner, two-column requirements
/// checklist, Cancel + Submit side by side. Kept in its own file so
/// mobile's _buildMobileBody is never touched while editing this. All
/// state (controllers, requirement booleans, enablement, submit) is owned
/// by ResetPasswordScreen and passed in — same integration as mobile.
class ResetPasswordWebView extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscureNewPassword;
  final bool obscureConfirmPassword;
  final VoidCallback onToggleNewPasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final bool hasValidLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool noSuccessiveChars;
  final bool noExcessRepeatedChars;
  final bool isButtonEnabled;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final PasswordMaskingFormatter passwordFormatter;
  final PasswordMaskingFormatter confirmPasswordFormatter;

  const ResetPasswordWebView({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscureNewPassword,
    required this.obscureConfirmPassword,
    required this.onToggleNewPasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.hasValidLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.noSuccessiveChars,
    required this.noExcessRepeatedChars,
    required this.isButtonEnabled,
    required this.isLoading,
    required this.onSubmit,
    required this.onCancel,
    required this.passwordFormatter,
    required this.confirmPasswordFormatter,
  });

  Widget _requirementRow(String label, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isMet ? AppColors.k613AF5 : AppColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 13, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isMet ? AppColors.k613AF5 : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _requirementPairRow(
      String leftLabel, bool leftMet, String rightLabel, bool rightMet) {
    return Row(
      children: [
        Expanded(child: _requirementRow(leftLabel, leftMet)),
        Expanded(child: _requirementRow(rightLabel, rightMet)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enabled = isButtonEnabled && !isLoading;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Backgroundcomponent(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Set a strong password for your account",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    hintText: "Enter Your New Password",
                    controller: passwordController,
                    obscureText: false,
                    inputFormatters: [passwordFormatter],
                    enabled: !isLoading,
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AppTextField(
                    hintText: "Enter Your Confirm Password",
                    controller: confirmPasswordController,
                    obscureText: false,
                    inputFormatters: [confirmPasswordFormatter],
                    enabled: !isLoading,
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
                            side:
                                const BorderSide(color: AppColors.textPrimary),
                          ),
                          onPressed: onCancel,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
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
                                : AppColors
                                    .primaryButtonBackgroundInactiveColor,
                          ),
                          onPressed: enabled ? onSubmit : null,
                          child: Text(
                            "Submit",
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
                  const SizedBox(height: 24),
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: AppColors.borderLight),
                  //     borderRadius: BorderRadius.circular(14),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       const Text(
                  //         "Your password must contain:",
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w600,
                  //           color: AppColors.textPrimary,
                  //         ),
                  //       ),
                  //       const SizedBox(height: 8),
                  //       _requirementPairRow(
                  //           "8 - 30 characters", hasValidLength, "an upper case", hasUpperCase),
                  //       _requirementPairRow(
                  //           "a lower case", hasLowerCase, "a number", hasNumber),
                  //       _requirementPairRow("a special character", hasSpecialChar,
                  //           "No successive characters over 3.", noSuccessiveChars),
                  //       _requirementRow(
                  //           "Not contain characters more than 3", noExcessRepeatedChars),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
