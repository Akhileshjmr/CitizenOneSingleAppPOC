import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'citizen_user');
  final _passwordController = TextEditingController(text: 'pass1234');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            username: _usernameController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back, ${state.user.username}!'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const AppLoader(message: 'Authenticating Account...');
        }

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.account_balance,
                        size: 56,
                        color: primaryColor,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'CitizenOne Portal Login',
                        style: AppTypography.display.copyWith(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to access unified civic & banking services',
                        style: AppTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      if (state is AuthError) ...[
                        AppErrorView(message: state.errorMessage),
                        const SizedBox(height: AppSpacing.md),
                      ],
                      AppTextField(
                        label: 'Username / Account ID',
                        controller: _usernameController,
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Enter username'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Enter password'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 4,
                        children: [
                          TextButton(
                            onPressed: () => context.push('/forgot-username'),
                            child: const Text('Forgot Username?'),
                          ),
                          TextButton(
                            onPressed: () => context.push('/forgot-password'),
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Sign In',
                        backgroundColor: primaryColor,
                        onPressed: _submitLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
