import 'package:citizenone_app/components/foundation/animated_input_wrapper.dart';
import 'package:citizenone_app/components/foundation/app_text.dart';
import 'package:citizenone_app/components/foundation/app_text_field.dart';
import 'package:citizenone_app/components/foundation/primary_button.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/forms/validators/app_text_field_validators.dart';
import 'package:citizenone_app/core/l10n/app_localizations_x.dart';
import 'package:citizenone_app/core/session/presentation/state/session_cubit.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/assets.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/theme/tokens/typography.dart';
import 'package:citizenone_app/features/auth/domain/entities/user_role.dart';
import 'package:citizenone_app/features/auth/presentation/screens/password_setup_required_sheet.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole? _selectedRole;
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  bool get _isFormReady =>
      _selectedRole != null &&
      _mobileController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthLoginStatus status) {
    if (status == AuthLoginStatus.loading) return;
    if (!_formKey.currentState!.validate() || _selectedRole == null) return;

    final authCubit = context.read<AuthCubit>();
    authCubit.setRole(_selectedRole!);
    authCubit.login(
      mobileNumber: _mobileController.text.trim(),
      password: _passwordController.text,
    );
  }

  void _navigateAfterLogin(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    final session = state.session;
    if (session == null) return;

    // Seed the global session the moment a real token is issued. A
    // no-op for the `mustChangePassword: true` case (no token yet).
    context.read<SessionCubit>().startSession(session);

    // The cubit exposes `mustChangePassword` at the state level for
    // convenience. The session also carries the same flag, so we
    // fall back to the session value if needed.
    final mustChangePassword =
        state.mustChangePassword || session.mustChangePassword;

    if (mustChangePassword) {
      // First-time agent — show the "Password Setup Required" bottom
      // sheet. The sheet, on Continue, navigates to the
      // change-password screen and forwards the credentials.
      PasswordSetupRequiredSheet.show(
        context,
        mobileNumber: _mobileController.text.trim(),
        currentPassword: _passwordController.text,
      );
      return;
    }

    if (state.selectedRole == UserRole.agent) {
      context.go('/agent/dashboard');
      return;
    }
    context.go(_roleBase(state.selectedRole));
  }

  String _roleBase(UserRole role) {
    switch (role) {
      case UserRole.agent:
        return '/agent';
      case UserRole.farmer:
        return '/farmer';
      case UserRole.citizen:
        return '/customer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: BlocConsumer<AuthCubit, AuthState>(
                listenWhen: (previous, current) =>
                    previous.loginStatus != current.loginStatus,
                listener: (context, state) {
                  if (state.loginStatus == AuthLoginStatus.success) {
                    _navigateAfterLogin(context);
                  }
                  if (state.loginStatus == AuthLoginStatus.failure) {
                    final message =
                        state.loginErrorMessage ??
                        'Login failed. Please try again.';
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(message),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: context.appTokens.error,
                        ),
                      );
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state.loginStatus == AuthLoginStatus.loading;
                  final errorMessage = state.loginErrorMessage;

                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo / Shield icon
                        SizedBox(
                          height: 86,
                          width: 212,
                          child: Image.asset(
                            AppAssets.citizenOneLogo,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppText(
                          context.l10n.loginWelcomeTitle,
                          style: AppTextStyle.headlineMedium,
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          context.l10n.loginSubtitle,
                          style: AppTextStyle.bodyMedium,
                        ),
                        const SizedBox(height: 36),

                        // ── Persona Dropdown ──
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AppText(
                            context.l10n.loginSelectPersona,
                            style: AppTextStyle.bodyMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<UserRole>(
                          initialValue: _selectedRole,
                          decoration: InputDecoration(
                            hintText: context.l10n.loginChooseRole,
                            hintStyle: AppTypography.bodyMedium(
                              context,
                            ).copyWith(color: AppColors.textMuted),
                            prefixIcon: const Icon(
                              LucideIcons.users,
                              color: AppColors.textSecondary,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                          ),
                          items: UserRole.values.map((role) {
                            return DropdownMenuItem<UserRole>(
                              value: role,
                              child: AppText(
                                role.displayName,
                                style: AppTextStyle.bodyLarge,
                              ),
                            );
                          }).toList(),
                          validator: (value) => value == null
                              ? context.l10n.loginValidationSelectPersona
                              : null,
                          onChanged: (role) {
                            setState(() => _selectedRole = role);
                          },
                        ),

                        // ── Mobile Number & Password ──
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: _selectedRole == null
                              ? const SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: AppText(
                                        context.l10n.loginMobileLabel,
                                        style: AppTextStyle.bodyMedium,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedInputWrapper(
                                      isActive: true,
                                      child: AppTextField(
                                        controller: _mobileController,
                                        hintText: context.l10n.loginMobileHint,
                                        prefixIcon: AppAssets.iconPeopleOutline,
                                        keyboardType: TextInputType.phone,
                                        enabled: !isLoading,
                                        inputFormatters:
                                            AppTextFieldFormatters.getFormatters(
                                              AppTextInputType.phone,
                                              maxLength: 10,
                                            ),
                                        validator: (v) =>
                                            AppTextFieldValidators.validate(
                                              value: v,
                                              type: AppTextInputType.phone,
                                              isRequired: true,
                                              requiredText: context
                                                  .l10n
                                                  .loginValidationMobileRequired,
                                            ),
                                        onChanged: (_) {
                                          context
                                              .read<AuthCubit>()
                                              .clearLoginError();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: AppText(
                                        context.l10n.loginPasswordLabel,
                                        style: AppTextStyle.bodyMedium,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedInputWrapper(
                                      isActive: true,
                                      child: AppTextField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        hintText:
                                            context.l10n.loginPasswordHint,
                                        prefixIcon: AppAssets.iconLock,
                                        enabled: !isLoading,
                                        textInputAction: TextInputAction.done,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: AppColors.textMuted,
                                            size: 20,
                                          ),
                                          onPressed: () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                        ),
                                        validator: (v) =>
                                            AppTextFieldValidators.validate(
                                              value: v,
                                              type: AppTextInputType.password,
                                              isRequired: true,
                                              requiredText: context
                                                  .l10n
                                                  .loginValidationPasswordRequired,
                                            ),
                                        onChanged: (_) {
                                          context
                                              .read<AuthCubit>()
                                              .clearLoginError();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                        ),

                        if (errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.appTokens.error.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: context.appTokens.error.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 18,
                                  color: context.appTokens.error,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppText(
                                    errorMessage,
                                    style: AppTextStyle.bodySmall,
                                    color: context.appTokens.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // ── Forgot Password ──
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    context.go('/auth/forgot-password');
                                  },
                            child: AppText(
                              context.l10n.loginForgotPassword,
                              style: AppTextStyle.bodySmall,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ── Login Button ──
                        PrimaryButton(
                          text: _selectedRole != null
                              ? context.l10n.loginButtonAs(
                                  _selectedRole!.displayName,
                                )
                              : context.l10n.loginButton,
                          isLoading: isLoading,
                          onPressed: !_isFormReady
                              ? () {}
                              : () => _handleLogin(state.loginStatus),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
