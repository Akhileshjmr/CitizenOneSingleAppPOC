import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/app_text_field.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/design_system/atoms/app_loader.dart';
import 'package:citizenone_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:citizenone_app/features/auth/presentation/screens/password_success_screen.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/set_password_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/set_password_state.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/get_agent_mobile_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

/// Agent-initiated "Change Password" screen, reached via
/// Sidebar → Settings → Security → Change Password.
///
/// Reuses [SetPasswordCubit]/[SetPasswordState] — the first-time
/// password-setup flow already implements the exact field set and
/// validation rules this flow needs (current/new/confirm, required,
/// new != current, confirm == new) around the same
/// [ChangePasswordUseCase]. Only the mobile number source differs:
/// here it's resolved from the logged-in agent's session via
/// [GetAgentMobileUseCase] instead of being carried from the login
/// screen.
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final Future<String> _mobileNumberFuture = _resolveMobileNumber();

  Future<String> _resolveMobileNumber() async {
    final result = await sl<GetAgentMobileUseCase>()();
    return result.fold((_) => '', (mobile) => mobile);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return FutureBuilder<String>(
      future: _mobileNumberFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            backgroundColor: tokens.background,
            body: const Center(child: AppLoader()),
          );
        }
        return BlocProvider<SetPasswordCubit>(
          create: (_) => SetPasswordCubit(
            changePasswordUseCase: sl<ChangePasswordUseCase>(),
            mobileNumber: snapshot.data ?? '',
          ),
          child: const _ChangePasswordView(),
        );
      },
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _currentPasswordController.addListener(_onAnyFieldChanged);
    _newPasswordController.addListener(_onAnyFieldChanged);
    _confirmPasswordController.addListener(_onAnyFieldChanged);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onAnyFieldChanged() {
    final cubit = context.read<SetPasswordCubit>();
    cubit.setTemporaryPassword(_currentPasswordController.text);
    cubit.setNewPassword(_newPasswordController.text);
    cubit.setConfirmPassword(_confirmPasswordController.text);
  }

  bool _isFormValidForButton(SetPasswordState s) {
    if (s.temporaryPassword.isEmpty) return false;
    if (s.newPassword.isEmpty) return false;
    if (s.newPassword.length < 8) return false;
    if (s.newPassword == s.temporaryPassword) return false;
    if (s.confirmPassword.isEmpty) return false;
    if (s.confirmPassword != s.newPassword) return false;
    return true;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<SetPasswordCubit>();
    cubit.submit(
      validationTempRequired:
          context.l10n.changePasswordValidationCurrentRequired,
      validationNewRequired: context.l10n.setPasswordValidationNewRequired,
      validationNewTooShort: context.l10n.setPasswordValidationNewTooShort,
      validationNewSameAsTemp:
          context.l10n.changePasswordValidationNewSameAsCurrent,
      validationConfirmRequired:
          context.l10n.setPasswordValidationConfirmRequired,
      validationConfirmMismatch:
          context.l10n.setPasswordValidationConfirmMismatch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocConsumer<SetPasswordCubit, SetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) async {
        if (state.status == SetPasswordStatus.success) {
          // The old session becomes stale the moment the password
          // changes — sign the agent out so they must log in again,
          // matching the reference "login required" flow.
          await context.read<AuthCubit>().logout();
          if (!context.mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const PasswordSuccessScreen()),
          );
        }
        if (state.status == SetPasswordStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
                backgroundColor: tokens.error,
              ),
            );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SetPasswordStatus.loading;
        final isValid = _isFormValidForButton(state);

        return Scaffold(
          backgroundColor: tokens.background,
          appBar: AppBar(
            backgroundColor: tokens.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(LucideIcons.arrow_left, color: tokens.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: AppText(
              context.l10n.changePasswordTitle,
              style: AppTextStyle.headlineSmall,
              fontWeight: FontWeight.w700,
              color: tokens.textPrimary,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppText(
                            context.l10n.changePasswordSubtitle,
                            style: AppTextStyle.bodyMedium,
                            color: tokens.textSecondary,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: tokens.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: tokens.shadowSm,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel(
                                  context.l10n.changePasswordCurrentLabel,
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _currentPasswordController,
                                  obscureText: _obscureCurrent,
                                  enabled: !isLoading,
                                  hintText:
                                      context.l10n.changePasswordCurrentHint,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters:
                                      AppTextFieldFormatters.getFormatters(
                                        AppTextInputType.password,
                                        maxLength: 64,
                                      ),
                                  // Validate the live field value, not the
                                  // Cubit `state` snapshot (see
                                  // SetPasswordScreen for why the latter
                                  // can latch a stale error after paste).
                                  validator: (value) =>
                                      (value ?? '').isEmpty
                                      ? context
                                            .l10n
                                            .changePasswordValidationCurrentRequired
                                      : null,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureCurrent
                                          ? LucideIcons.eye_off
                                          : LucideIcons.eye,
                                      color: AppColors.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureCurrent = !_obscureCurrent,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _fieldLabel(context.l10n.setPasswordNewLabel),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _newPasswordController,
                                  obscureText: _obscureNew,
                                  enabled: !isLoading,
                                  hintText: context.l10n.setPasswordNewHint,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters:
                                      AppTextFieldFormatters.getFormatters(
                                        AppTextInputType.password,
                                        maxLength: 64,
                                      ),
                                  validator: (value) {
                                    final newPassword = value ?? '';
                                    if (newPassword.isEmpty) {
                                      return null;
                                    }
                                    if (newPassword.length < 8) {
                                      return context
                                          .l10n
                                          .setPasswordValidationNewTooShort;
                                    }
                                    if (newPassword ==
                                        _currentPasswordController.text) {
                                      return context
                                          .l10n
                                          .changePasswordValidationNewSameAsCurrent;
                                    }
                                    return null;
                                  },
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
                                _fieldLabel(
                                  context.l10n.setPasswordConfirmLabel,
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirm,
                                  enabled: !isLoading,
                                  hintText: context.l10n.setPasswordConfirmHint,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters:
                                      AppTextFieldFormatters.getFormatters(
                                        AppTextInputType.password,
                                        maxLength: 64,
                                      ),
                                  validator: (value) {
                                    final confirmPassword = value ?? '';
                                    if (confirmPassword.isNotEmpty &&
                                        confirmPassword !=
                                            _newPasswordController.text) {
                                      return context
                                          .l10n
                                          .setPasswordValidationConfirmMismatch;
                                    }
                                    return null;
                                  },
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
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: _SubmitButton(
                    text: context.l10n.setPasswordSubmit,
                    isLoading: isLoading,
                    isEnabled: isValid,
                    onPressed: isValid && !isLoading ? _onSubmit : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fieldLabel(String label) => AppText(
    label,
    style: AppTextStyle.bodyMedium,
    color: context.appTokens.textPrimary,
    fontWeight: FontWeight.w600,
  );
}

/// Gray "disabled" look when the form is invalid, primary purple when
/// valid — mirrors `SetPasswordScreen`'s `_SubmitButton`.
class _SubmitButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const _SubmitButton({
    required this.text,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final canSubmit = isEnabled && onPressed != null;

    if (canSubmit) {
      return PrimaryButton(
        text: text,
        isLoading: isLoading,
        onPressed: onPressed!,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: tokens.textPrimary,
                  strokeWidth: 2,
                ),
              )
            : AppText(
                text,
                style: AppTextStyle.bodyLarge,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }
}
