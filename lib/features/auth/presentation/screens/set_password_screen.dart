import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/app_text_field.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/di/di_setup.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:citizenone_app/features/auth/presentation/state/set_password_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/set_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

/// Screen for setting a new password on first-time agent login.
///
/// The user must manually enter all three password fields. The
/// `currentPassword` value passed in via the router is no longer used
/// to prefill the Temporary Password field — the field is always
/// empty on first render. It is preserved on the constructor for
/// callers that still provide it (e.g. for comparison elsewhere),
/// but it is intentionally ignored here.
class SetPasswordScreen extends StatelessWidget {
  final String mobileNumber;

  /// Ignored. Kept on the constructor so existing callers that pass
  /// it (e.g. the router's `extra:` payload) do not break.
  final String? currentPassword;

  const SetPasswordScreen({
    super.key,
    required this.mobileNumber,
    this.currentPassword,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SetPasswordCubit>(
      create: (_) => SetPasswordCubit(
        changePasswordUseCase: sl<ChangePasswordUseCase>(),
        mobileNumber: mobileNumber,
      ),
      child: const _SetPasswordView(),
    );
  }
}

class _SetPasswordView extends StatefulWidget {
  const _SetPasswordView();

  @override
  State<_SetPasswordView> createState() => _SetPasswordViewState();
}

class _SetPasswordViewState extends State<_SetPasswordView> {
  // Each password field has its own controller. None of them are
  // prefilled — the user must type into each one.
  final _temporaryPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureTemporary = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _temporaryPasswordController.addListener(_onAnyFieldChanged);
    _newPasswordController.addListener(_onAnyFieldChanged);
    _confirmPasswordController.addListener(_onAnyFieldChanged);
  }

  @override
  void dispose() {
    _temporaryPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onAnyFieldChanged() {
    final cubit = context.read<SetPasswordCubit>();
    cubit.setTemporaryPassword(_temporaryPasswordController.text);
    cubit.setNewPassword(_newPasswordController.text);
    cubit.setConfirmPassword(_confirmPasswordController.text);
  }

  /// Drives the submit button's enabled/disabled look. All three
  /// fields must be valid before the user can submit.
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
      validationTempRequired: context.l10n.setPasswordValidationTempRequired,
      validationNewRequired: context.l10n.setPasswordValidationNewRequired,
      validationNewTooShort: context.l10n.setPasswordValidationNewTooShort,
      validationNewSameAsTemp: context.l10n.setPasswordValidationNewSameAsTemp,
      validationConfirmRequired:
          context.l10n.setPasswordValidationConfirmRequired,
      validationConfirmMismatch:
          context.l10n.setPasswordValidationConfirmMismatch,
    );
  }

  void _onBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    return BlocConsumer<SetPasswordCubit, SetPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SetPasswordStatus.success) {
          context.go('/auth/password-success');
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
          body: SafeArea(
            child: Column(
              children: [
                // Header bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => _onBack(context),
                        icon: const Icon(LucideIcons.arrow_left),
                        color: tokens.textPrimary,
                      ),
                      AppText(
                        context.l10n.setPasswordTitle,
                        style: AppTextStyle.headlineSmall,
                        color: tokens.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                // Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppText(
                            context.l10n.setPasswordSubtitle,
                            style: AppTextStyle.bodyMedium,
                            color: tokens.textSecondary,
                          ),
                          const SizedBox(height: 24),

                          // White card with the three fields
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
                                _buildFieldLabel(
                                  context,
                                  context.l10n.setPasswordTempLabel,
                                ),
                                const SizedBox(height: 8),
                                AppTextField(
                                  controller: _temporaryPasswordController,
                                  obscureText: _obscureTemporary,
                                  enabled: !isLoading,
                                  hintText: context.l10n.setPasswordTempHint,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters:
                                      AppTextFieldFormatters.getFormatters(
                                        AppTextInputType.password,
                                        maxLength: 64,
                                      ),
                                  validator: (value) =>
                                      _validateTemporaryPassword(
                                        value,
                                        context
                                            .l10n
                                            .setPasswordValidationTempRequired,
                                      ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureTemporary
                                          ? LucideIcons.eye_off
                                          : LucideIcons.eye,
                                      color: AppColors.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureTemporary =
                                          !_obscureTemporary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                _buildFieldLabel(
                                  context,
                                  context.l10n.setPasswordNewLabel,
                                ),
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
                                  validator: (value) => _validateNewPassword(
                                    value,
                                    context
                                        .l10n
                                        .setPasswordValidationNewTooShort,
                                    context
                                        .l10n
                                        .setPasswordValidationNewSameAsTemp,
                                  ),
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

                                _buildFieldLabel(
                                  context,
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
                                  validator: (value) =>
                                      _validateConfirmPassword(
                                        value,
                                        context
                                            .l10n
                                            .setPasswordValidationConfirmMismatch,
                                      ),
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

                // Bottom submit area
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

  Widget _buildFieldLabel(BuildContext context, String label) {
    return AppText(
      label,
      style: AppTextStyle.bodyMedium,
      color: context.appTokens.textPrimary,
      fontWeight: FontWeight.w600,
    );
  }

  // These validators read the live value the FormField hands them (and,
  // for cross-field checks, the sibling controllers' current `.text`)
  // rather than the Cubit's `state` snapshot. `state` is only updated on
  // the next rebuild after a controller change, so a validator bound to
  // it can run — via the controller's own change-notification, which
  // fires synchronously and before that rebuild — against a stale,
  // pre-update snapshot. That stale run latches an error (e.g.
  // "required" right after pasting a non-empty value) that nothing
  // re-triggers once the rebuild does land, since Flutter doesn't
  // automatically re-validate a FormField when its validator closure
  // changes. Controllers are always current at the moment validate()
  // runs, so reading them directly avoids the race entirely.
  String? _validateTemporaryPassword(String? value, String tempRequired) {
    if ((value ?? '').isEmpty) return tempRequired;
    return null;
  }

  String? _validateNewPassword(
    String? value,
    String tooShort,
    String sameAsTemp,
  ) {
    final newPassword = value ?? '';
    if (newPassword.isEmpty) return null;
    if (newPassword.length < 8) return tooShort;
    if (newPassword == _temporaryPasswordController.text) return sameAsTemp;
    return null;
  }

  String? _validateConfirmPassword(String? value, String mismatch) {
    final confirmPassword = value ?? '';
    if (confirmPassword.isEmpty) return null;
    if (confirmPassword != _newPasswordController.text) return mismatch;
    return null;
  }
}

/// Renders the submit button with a disabled gray look when the form
/// is invalid (matching the reference image's "empty" state) and the
/// primary purple look when valid (matching the "filled" state).
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
