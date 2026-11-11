import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/app_text_field.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_state.dart';
import 'package:citizenone_app/features/auth/presentation/widgets/password_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Third screen of the forgot-password flow. Asks the user to type
/// and confirm their new password, then dispatches
/// `POST /password/reset`. On success, navigates to the success screen.
class CreatePasswordScreen extends StatelessWidget {
  final String mobileNumber;

  const CreatePasswordScreen({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (_) {
        final cubit = ForgotPasswordCubit(repository: sl<AuthRepository>());
        cubit.setMobileNumber(mobileNumber);
        return cubit;
      },
      child: const _CreatePasswordView(),
    );
  }
}

class _CreatePasswordView extends StatefulWidget {
  const _CreatePasswordView();

  @override
  State<_CreatePasswordView> createState() => _CreatePasswordViewState();
}

class _CreatePasswordViewState extends State<_CreatePasswordView> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onChanged);
    _confirmPasswordController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _newPasswordController.removeListener(_onChanged);
    _newPasswordController.dispose();
    _confirmPasswordController.removeListener(_onChanged);
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
  }

  /// Returns true when the new password + confirm password satisfy
  /// all 7 rules from the reference image.
  bool _isFormValid() {
    final newPwd = _newPasswordController.text;
    final confirmPwd = _confirmPasswordController.text;
    if (newPwd.isEmpty || confirmPwd.isEmpty) return false;
    return PasswordRules.isStrong(newPwd) && newPwd == confirmPwd;
  }

  void _onSubmit() {
    if (!_isFormValid()) return;
    context.read<ForgotPasswordCubit>().resetPassword(
      newPassword: _newPasswordController.text,
    );
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(
        '/auth/forgot-password/otp',
        extra: {
          'mobileNumber': context
              .read<ForgotPasswordCubit>()
              .state
              .mobileNumber,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.resetSuccess) {
          context.go('/auth/forgot-password-success');
          return;
        }
        if (state.status == ForgotPasswordStatus.resetFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Password reset failed. Please try again.',
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.error,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.resetLoading;
        final isValid = _isFormValid() && !isLoading;
        final newPwd = _newPasswordController.text;

        return Scaffold(
          backgroundColor: tokens.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: isLoading ? null : _onBack,
                        icon: const Icon(LucideIcons.arrow_left),
                        color: tokens.textPrimary,
                      ),
                      AppText(
                        context.l10n.createPasswordTitle,
                        style: AppTextStyle.headlineSmall,
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppText(
                          context.l10n.createPasswordSubtitle,
                          style: AppTextStyle.bodyMedium,
                          color: tokens.textSecondary,
                        ),
                        const SizedBox(height: 24),

                        // White card with new + confirm fields
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: tokens.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: tokens.shadowSm,
                            border: Border.all(color: tokens.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                context.l10n.createPasswordNewLabel,
                                style: AppTextStyle.bodyMedium,
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _newPasswordController,
                                obscureText: _obscureNew,
                                enabled: !isLoading,
                                hintText: context.l10n.createPasswordNewHint,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.next,
                                inputFormatters:
                                    AppTextFieldFormatters.getFormatters(
                                      AppTextInputType.password,
                                      maxLength: 30,
                                    ),
                                prefixIcon: AppAssets.iconLock,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureNew
                                        ? LucideIcons.eye_off
                                        : LucideIcons.eye,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureNew = !_obscureNew,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              AppText(
                                context.l10n.createPasswordConfirmLabel,
                                style: AppTextStyle.bodyMedium,
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 8),
                              AppTextField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirm,
                                enabled: !isLoading,
                                hintText:
                                    context.l10n.createPasswordConfirmHint,
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                inputFormatters:
                                    AppTextFieldFormatters.getFormatters(
                                      AppTextInputType.password,
                                      maxLength: 30,
                                    ),
                                prefixIcon: AppAssets.iconLock,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? LucideIcons.eye_off
                                        : LucideIcons.eye,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Requirements card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: tokens.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: tokens.shadowSm,
                            border: Border.all(color: tokens.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                context.l10n.createPasswordRulesTitle,
                                style: AppTextStyle.bodyMedium,
                                color: tokens.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(height: 12),
                              ...PasswordRules.all.map(
                                (rule) => _RequirementRow(
                                  label: rule.label(context),
                                  satisfied: rule.check(newPwd),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Password mismatch inline error
                        if (_confirmPasswordController.text.isNotEmpty &&
                            _newPasswordController.text !=
                                _confirmPasswordController.text) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 16,
                                color: tokens.error,
                              ),
                              const SizedBox(width: 6),
                              AppText(
                                context.l10n.createPasswordMismatch,
                                style: AppTextStyle.bodySmall,
                                color: tokens.error,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom Submit button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: PrimaryButton(
                    text: context.l10n.createPasswordSubmit,
                    isLoading: isLoading,
                    onPressed: isValid ? _onSubmit : () {},
                    backgroundColor: isValid
                        ? AppColors.primary
                        : AppColors.surfaceLight,
                    foregroundColor: isValid
                        ? Colors.white
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool satisfied;

  const _RequirementRow({required this.label, required this.satisfied});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final color = satisfied ? tokens.primary : tokens.textMuted;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            satisfied ? LucideIcons.check : LucideIcons.circle,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppText(
              label,
              style: AppTextStyle.bodySmall,
              color: color,
              fontWeight: satisfied ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
