import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/app_text_field.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/forms/validators/app_text_field_validators.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// First screen of the agent forgot-password flow.
///
/// Asks the user for their registered mobile number and dispatches
/// `POST /password/forgot`. On success, the cubit emits
/// `forgotSuccess` and the screen navigates to the OTP screen.
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (_) => ForgotPasswordCubit(repository: sl<AuthRepository>()),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _mobileController.removeListener(_onChanged);
    _mobileController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final cubit = context.read<ForgotPasswordCubit>();
    cubit.setMobileNumber(_mobileController.text);
    cubit.clearError();

    final newValid = _mobileController.text.trim().length == 9;
    if (newValid != _isFormValid) {
      setState(() => _isFormValid = newValid);
    }
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().submitForgot();
  }

  void _onSignIn() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.forgotSuccess) {
          // Forward the mobile number and the OTP timer/attempts data
          // to the OTP screen so it doesn't start from zero. The cubit
          // instance is replaced by the new BlocProvider on the OTP
          // route, so this all travels via `extra:`.
          context.go(
            '/auth/forgot-password/otp',
            extra: {
              'mobileNumber': state.mobileNumber,
              'otpExpiresInSeconds': state.otpExpiresInSeconds,
              'resendCooldownSeconds': state.resendCooldown,
              'maxAttempts': state.maxAttempts,
              'attemptsRemaining': state.attemptsRemaining,
            },
          );
        } else if (state.status == ForgotPasswordStatus.forgotFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Unable to send OTP. Please try again.',
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.error,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ForgotPasswordStatus.forgotLoading;
        return Scaffold(
          backgroundColor: tokens.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    _Branding(),
                    const SizedBox(height: 36),

                    // White rounded card
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      decoration: BoxDecoration(
                        color: tokens.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: tokens.shadowMd,
                        border: Border.all(color: tokens.outline),
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppText(
                              context.l10n.forgotPasswordTitle,
                              style: AppTextStyle.headlineMedium,
                              fontWeight: FontWeight.w700,
                              color: tokens.textPrimary,
                            ),
                            const SizedBox(height: 10),
                            AppText(
                              context.l10n.forgotPasswordBody,
                              style: AppTextStyle.bodyMedium,
                              color: tokens.textSecondary,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 24),

                            // Mobile Number label
                            AppText(
                              context.l10n.forgotPasswordMobileLabel,
                              style: AppTextStyle.bodyMedium,
                              color: tokens.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 8),

                            // Country code + mobile number row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 88,
                                  child: _CountryCodeField(disabled: isLoading),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    controller: _mobileController,
                                    keyboardType: TextInputType.phone,
                                    hintText:
                                        context.l10n.forgotPasswordMobileHint,
                                    enabled: !isLoading,
                                    inputFormatters:
                                        AppTextFieldFormatters.getFormatters(
                                          AppTextInputType.phone,
                                          maxLength: 9,
                                        ),
                                    validator: (v) =>
                                        AppTextFieldValidators.validate(
                                          value: v,
                                          type: AppTextInputType.phone,
                                          isRequired: true,
                                          requiredText: context
                                              .l10n
                                              .forgotPasswordMobileRequired,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Identity verification banner
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: tokens.primary.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: tokens.primary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    LucideIcons.info,
                                    size: 18,
                                    color: tokens.primary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: AppText(
                                      context.l10n.forgotPasswordInfoBanner,
                                      style: AppTextStyle.bodySmall,
                                      color: tokens.textSecondary,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            PrimaryButton(
                              text: context.l10n.forgotPasswordContinue,
                              isLoading: isLoading,
                              onPressed: !_isFormValid || isLoading
                                  ? () {}
                                  : _onContinue,
                              backgroundColor: _isFormValid && !isLoading
                                  ? AppColors.primary
                                  : AppColors.surfaceLight,
                              foregroundColor: _isFormValid && !isLoading
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Sign In link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            context.l10n.forgotPasswordRememberPrefix,
                            style: AppTextStyle.bodyMedium,
                            color: tokens.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: isLoading ? null : _onSignIn,
                            behavior: HitTestBehavior.opaque,
                            child: AppText(
                              context.l10n.forgotPasswordSignIn,
                              style: AppTextStyle.bodyMedium,
                              color: tokens.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CountryCodeField extends StatelessWidget {
  final bool disabled;
  const _CountryCodeField({required this.disabled});

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: disabled ? tokens.surfaceSoft : tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusSm),
        border: Border.all(color: tokens.outline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            '+260',
            style: AppTextStyle.bodyLarge,
            color: tokens.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      width: 212,
      child: Image.asset(AppAssets.citizenOneLogo, fit: BoxFit.contain),
    );
  }
}
