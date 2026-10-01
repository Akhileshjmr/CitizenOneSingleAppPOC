import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _identifierController =
      TextEditingController(text: 'user@citizenone.gov');

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().forgotPassword(_identifierController.text);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Password reset link sent to ${state.email}')),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const AppLoader(message: 'Sending Password Reset Link...');
        }

        if (state is ForgotPasswordSuccess) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mark_email_read,
                        size: 64, color: Colors.green),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Instructions Sent!', style: AppTypography.title),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Password reset instructions have been dispatched to ${state.email}.',
                      style: AppTypography.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Return to Login',
                      backgroundColor: primaryColor,
                      onPressed: () {
                        context.read<AuthCubit>().resetState();
                        context.go('/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Forgot Password',
                      style: AppTypography.title.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Enter your registered Username or Email address to receive password reset instructions.',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (state is AuthError) ...[
                      AppErrorView(message: state.errorMessage),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    AppTextField(
                      label: 'Username / Email Address',
                      controller: _identifierController,
                      prefixIcon: Icon(Icons.email, color: primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Send Reset Link',
                      backgroundColor: primaryColor,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Login'),
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
