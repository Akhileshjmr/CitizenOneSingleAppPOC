import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/modules/citizen_one/theme/citizen_one_colors.dart';

class ForgotUsernameScreen extends StatefulWidget {
  const ForgotUsernameScreen({super.key});

  @override
  State<ForgotUsernameScreen> createState() => _ForgotUsernameScreenState();
}

class _ForgotUsernameScreenState extends State<ForgotUsernameScreen> {
  final _emailController = TextEditingController(text: 'user@citizenone.gov');

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().forgotUsername(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recover Username'),
        backgroundColor: CitizenOneColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthLoading) {
            return const AppLoader(message: 'Searching Account Identifier...');
          }

          if (state is ForgotUsernameSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge,
                          size: 64, color: CitizenOneColors.primary),
                      const SizedBox(height: AppSpacing.md),
                      const Text('Username Recovered', style: AppTypography.title),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Your associated username account is:',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        state.maskedUsername,
                        style: AppTypography.display.copyWith(
                          fontSize: 22,
                          color: CitizenOneColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Proceed to Login',
                        backgroundColor: CitizenOneColors.primary,
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
                      Text('Forgot Username',
                          style: AppTypography.title
                              .copyWith(color: CitizenOneColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Enter your registered email address to retrieve your account username.',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      if (state is AuthError) ...[
                        AppErrorView(message: state.errorMessage),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      AppTextField(
                        label: 'Registered Email Address',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Recover Username',
                        backgroundColor: CitizenOneColors.primary,
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
      ),
    );
  }
}
