// =============================================================================
// LoginFormOrganism  —  ORGANISM
// -----------------------------------------------------------------------------
// Composes LoginFormField molecules + a remember-me checkbox + the primary
// "Sign in" AppButton. State that is purely UI (the checkbox, password
// visibility) lives here; authentication state belongs to the feature
// BLoC, which is injected through callbacks.
// =============================================================================

import 'package:flutter/material.dart';
import '../../core/extensions/build_context_x.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../atoms/atoms.dart';
import '../molecules/molecules.dart';

class LoginFormOrganism extends StatefulWidget {
  const LoginFormOrganism({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
    this.onForgotPassword,
  });

  final void Function({
    required String email,
    required String password,
    required bool rememberMe,
  }) onSubmit;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onForgotPassword;

  @override
  State<LoginFormOrganism> createState() => _LoginFormOrganismState();
}

class _LoginFormOrganismState extends State<LoginFormOrganism> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      email: _email.text.trim(),
      password: _password.text,
      rememberMe: _rememberMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginFormField(
            label: 'Email',
            controller: _email,
            hint: 'you@bank.com',
            prefixIcon: Icons.alternate_email_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
          ),
          const AppSpacer.lg(),
          LoginFormField(
            label: 'Password',
            controller: _password,
            hint: '••••••••',
            isPassword: true,
            prefixIcon: Icons.lock_outline_rounded,
            textInputAction: TextInputAction.done,
            validator: Validators.password,
            onSubmitted: (_) => _submit(),
          ),
          const AppSpacer.sm(),
          if (widget.errorMessage != null) ...[
            const AppSpacer.xs(),
            AppText.error(widget.errorMessage!),
          ],
          const AppSpacer.sm(),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                activeColor: context.colors.primary,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
              ),
              const AppText('Remember me'),
              const Spacer(),
              if (widget.onForgotPassword != null)
                AppButton(
                  label: 'Forgot?',
                  onPressed: widget.onForgotPassword,
                  variant: AppButtonVariant.text,
                  size: AppButtonSize.sm,
                ),
            ],
          ),
          const AppSpacer.lg(),
          AppButton(
            label: 'Sign in',
            onPressed: widget.isLoading ? null : _submit,
            isLoading: widget.isLoading,
            isFullWidth: true,
          ),
          const AppSpacer.md(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppText.caption(
              'By continuing you accept our Terms & Privacy Policy.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
