// =============================================================================
// LoginPage  —  PRESENTATION (PAGE)
// -----------------------------------------------------------------------------
// Wires the AuthBloc into the AuthTemplate / LoginFormOrganism. On success
// it pushes the Dashboard. The page itself contains zero design code —
// every visual decision lives in the design system.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/snack.dart';
import '../../../../design_system/atoms/atoms.dart';
import '../../../../design_system/organisms/organisms.dart';
import '../../../../design_system/templates/templates.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (p, n) => p.status != n.status,
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          // Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          //   builder: (_) => const DashboardPage(),
          // ));
        }
      },
      builder: (context, state) {
        return AuthTemplate(
          title: 'Welcome to CitizenOne',
          subtitle: 'Securely access your accounts and move money in seconds.',
          form: LoginFormOrganism(
            isLoading: state.isSubmitting,
            errorMessage: state.errorMessage,
            onForgotPassword: () => Snack.show(
              context,
              type: AppAlertType.success,
              message: 'Reset link sent',
            ),
            onSubmit: ({
              required String email,
              required String password,
              required bool rememberMe,
            }) =>
                context.read<AuthBloc>().add(AuthSignInRequested(
                      email: email,
                      password: password,
                      rememberMe: rememberMe,
                    )),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppText.caption('Need an account?'),
              const SizedBox(width: 4),
              AppButton(
                label: 'Get started',
                onPressed: () => Snack.show(
                  context,
                  message: 'Onboarding flow stub',
                ),
                variant: AppButtonVariant.text,
                size: AppButtonSize.sm,
              ),
            ],
          ),
        );
      },
    );
  }
}
