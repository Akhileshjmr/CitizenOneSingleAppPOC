import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/PasswordCard.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/widgets/PasswordCardWeb.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/Loader.dart';
import '../../blocs/login_bloc/login_bloc.dart';
import '../../blocs/login_bloc/login_state.dart';

class LoginScreenWebLayout extends StatefulWidget {
  const LoginScreenWebLayout({super.key});

  @override
  State<LoginScreenWebLayout> createState() => _LoginScreenWebLayoutState();
}

class _LoginScreenWebLayoutState extends State<LoginScreenWebLayout> {
  final PageController _page = PageController();
  int _current = 0;
  bool _showPasswordCard = false;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  final List<String> _banners = [
    "assets/icons/useful_icons/bank_logo_zanaco.png",
    "assets/icons/useful_icons/bank_logo_zanaco.png",
    "assets/icons/useful_icons/bank_logo_zanaco.png",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          FocusScope.of(context).unfocus();
          context.read<LoadingCubit>().show();
        } else {
          context.read<LoadingCubit>().hide();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          return Scaffold(
            backgroundColor: AppColors.loginBackground,
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      isMobile ? _buildMobile(context) : _buildWeb(context),
                      const GlobalLoader(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// -------------------- Web Layout --------------------
  Widget _buildWeb(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Image.asset(
            "assets/web/image 88411.png",
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/icons/citizenLogo.png",
                        height: 90,
                      ),
                      const SizedBox(height: 32),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome to CitizenOne",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Sign in to continue to your account",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const PasswordCardWeb(),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// -------------------- Mobile Layout --------------------
  Widget _buildMobile(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min, // shrink column height
            crossAxisAlignment:
                CrossAxisAlignment.center, // center horizontally
            children: [
              // Logo
              Image.asset(
                "assets/icons/useful_icons/CitizenOneLogo.png",
                height: 55,
              ),
              SizedBox(height: 10),
              const Text(
                "Welcome to CitizenOne",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
              ),

              // Add the subtitle here
              const SizedBox(height: 3),
              const Text(
                "Sign-in to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  letterSpacing: 0.3,
                ),
              ),

              const SizedBox(height: 20), // spacing before card
              // Login / Password Card
              const PasswordCard(),
            ],
          ),
        ),
      ),
    );
  }
}
