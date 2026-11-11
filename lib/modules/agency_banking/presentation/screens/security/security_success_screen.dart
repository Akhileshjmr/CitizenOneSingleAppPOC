import 'package:citizenone_app/modules/agency_banking/core/widgets/app_success_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';

class SecuritySuccessScreen extends StatelessWidget {
  const SecuritySuccessScreen({super.key});

  Future<void> _navigateToLogin(BuildContext context) async {
    await clearStoredLoginData();
    await BankSelectionHelper.clearBankSelection();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(AuthService()),
            child: const LoginScreen(),
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _navigateToLogin(context);
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;
          return AppSuccessScreen(
            message: isMobile
                ? "Your Password has been\nSuccessfully Updated."
                : "Your Password has been Successfully Updated.",
            buttonText: "Login Now",
            onButtonPressed: () => _navigateToLogin(context),
            useWebLayout: !isMobile,
          );
        },
      ),
    );
  }
}
