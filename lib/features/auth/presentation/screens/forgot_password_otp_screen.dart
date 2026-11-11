import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

/// Second screen of the forgot-password flow. Asks the user for the
/// 6-digit OTP and dispatches `POST /password/verify-otp`. On success,
/// navigates to the create-password screen with the mobile number
/// carried forward via `extra:`.
class ForgotPasswordOtpScreen extends StatelessWidget {
  final String mobileNumber;

  /// OTP/session expiration countdown seconds, forwarded from the
  /// Forgot-Password API response via navigation `extra:`. Null when
  /// unavailable — the cubit applies a sane default in that case.
  final int? otpExpiresInSeconds;

  /// Resend cooldown seconds, forwarded the same way.
  final int? resendCooldownSeconds;

  /// Max OTP attempts allowed, forwarded the same way.
  final int? maxAttempts;

  /// Attempts remaining, forwarded the same way.
  final int? attemptsRemaining;

  const ForgotPasswordOtpScreen({
    super.key,
    required this.mobileNumber,
    this.otpExpiresInSeconds,
    this.resendCooldownSeconds,
    this.maxAttempts,
    this.attemptsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (_) {
        final cubit = ForgotPasswordCubit(repository: sl<AuthRepository>());
        cubit.setMobileNumber(mobileNumber);
        cubit.seedOtpSession(
          otpExpiresInSeconds: otpExpiresInSeconds,
          resendCooldownSeconds: resendCooldownSeconds,
          maxAttempts: maxAttempts,
          attemptsRemaining: attemptsRemaining,
        );
        return cubit;
      },
      child: const _ForgotPasswordOtpView(),
    );
  }
}

class _ForgotPasswordOtpView extends StatefulWidget {
  const _ForgotPasswordOtpView();

  @override
  State<_ForgotPasswordOtpView> createState() => _ForgotPasswordOtpViewState();
}

class _ForgotPasswordOtpViewState extends State<_ForgotPasswordOtpView> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged() {
    final value = _otpController.text;
    final newComplete = value.length == 6;
    if (newComplete != _isOtpComplete) {
      setState(() => _isOtpComplete = newComplete);
    }
    context.read<ForgotPasswordCubit>().setOtp(value);
  }

  void _onVerify() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().verifyOtp();
  }

  void _onResend() {
    context.read<ForgotPasswordCubit>().resendOtp();
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/auth/forgot-password');
    }
  }

  String _formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.verifySuccess) {
          context.go(
            '/auth/create-password',
            extra: {'mobileNumber': state.mobileNumber},
          );
          return;
        }
        if (state.status == ForgotPasswordStatus.verifyFailure) {
          // Clear the OTP so the user can re-enter it cleanly.
          _otpController.clear();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Invalid OTP. Please try again.',
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.error,
              ),
            );
          return;
        }
        if (state.status == ForgotPasswordStatus.resendSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(context.l10n.forgotPasswordOtpResent),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.success,
              ),
            );
          return;
        }
        if (state.status == ForgotPasswordStatus.resendFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Unable to resend OTP. Please try again.',
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.error,
              ),
            );
        }
      },
      builder: (context, state) {
        final isVerifying = state.status == ForgotPasswordStatus.verifyLoading;
        final isResending = state.status == ForgotPasswordStatus.resendLoading;
        final isBusy = isVerifying || isResending;
        final cooldown = state.resendCooldown;
        final canResend = cooldown <= 0 && !isResending;

        return Scaffold(
          backgroundColor: tokens.background,
          appBar: AppBar(
            backgroundColor: tokens.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrow_left),
              onPressed: isBusy ? null : _onBack,
              color: tokens.textPrimary,
            ),
            title: AppText(
              context.l10n.forgotPasswordOtpTitle,
              style: AppTextStyle.headlineSmall,
              color: tokens.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            centerTitle: false,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // White card with shield icon + description
                          Container(
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                            decoration: BoxDecoration(
                              color: tokens.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: tokens.shadowMd,
                              border: Border.all(color: tokens.outline),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: tokens.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    LucideIcons.shield_check,
                                    size: 36,
                                    color: tokens.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AppText(
                                  context.l10n.forgotPasswordOtpCardTitle,
                                  style: AppTextStyle.headlineSmall,
                                  color: tokens.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(height: 8),
                                AppText(
                                  context.l10n.forgotPasswordOtpBody,
                                  style: AppTextStyle.bodyMedium,
                                  color: tokens.textSecondary,
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                ),
                                const SizedBox(height: 24),

                                // OTP Pinput field
                                Form(
                                  key: _formKey,
                                  child: Pinput(
                                    controller: _otpController,
                                    length: 6,
                                    autofocus: !isBusy,
                                    enabled: !isBusy,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                        RegExp(r'[^0-9]'),
                                      ),
                                    ],
                                    defaultPinTheme: PinTheme(
                                      height: 52,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        color: tokens.surface,
                                        border: Border.all(
                                          color: tokens.outline,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: AppTypography.headlineSmall(
                                        context,
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      height: 52,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        color: tokens.surface,
                                        border: Border.all(
                                          color: tokens.primary,
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: AppTypography.headlineSmall(
                                        context,
                                      ),
                                    ),
                                    submittedPinTheme: PinTheme(
                                      height: 52,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        color: tokens.primary.withValues(
                                          alpha: 0.06,
                                        ),
                                        border: Border.all(
                                          color: tokens.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      textStyle: AppTypography.headlineSmall(
                                        context,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return context
                                            .l10n
                                            .forgotPasswordOtpRequired;
                                      }
                                      if (value.length != 6) {
                                        return context
                                            .l10n
                                            .forgotPasswordOtpInvalid;
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Timer + Attempts row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Timer
                                    Row(
                                      children: [
                                        Icon(
                                          LucideIcons.timer,
                                          size: 16,
                                          color: tokens.textSecondary,
                                        ),
                                        const SizedBox(width: 6),
                                        AppText(
                                          '${_formatTimer(state.otpExpiresInSeconds)} ${context.l10n.forgotPasswordOtpSec}',
                                          style: AppTextStyle.bodySmall,
                                          color: tokens.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    // Attempts left
                                    AppText(
                                      context.l10n
                                          .forgotPasswordOtpAttemptsLeft(
                                            state.attemptsRemaining,
                                          ),
                                      style: AppTextStyle.bodySmall,
                                      color: tokens.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Resend OTP button — disabled while cooldown > 0
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: canResend ? _onResend : null,
                                    icon: isResending
                                        ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: tokens.primary,
                                            ),
                                          )
                                        : Icon(
                                            LucideIcons.refresh_cw,
                                            size: 18,
                                            color: canResend
                                                ? tokens.primary
                                                : tokens.textMuted,
                                          ),
                                    label: AppText(
                                      context.l10n.forgotPasswordOtpResend,
                                      style: AppTextStyle.bodyMedium,
                                      color: canResend
                                          ? tokens.primary
                                          : tokens.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      side: BorderSide(
                                        color: canResend
                                            ? tokens.primary
                                            : tokens.outline,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Verify OTP bottom button
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: context.l10n.forgotPasswordOtpVerify,
                    isLoading: isVerifying,
                    onPressed: !_isOtpComplete || isVerifying
                        ? () {}
                        : _onVerify,
                    backgroundColor: _isOtpComplete && !isVerifying
                        ? AppColors.primary
                        : AppColors.surfaceLight,
                    foregroundColor: _isOtpComplete && !isVerifying
                        ? Colors.white
                        : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
