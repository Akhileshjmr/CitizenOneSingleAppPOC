import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderStore.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/responsive_layout.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';

import '../../../core/Security/DetectSecurity.dart';
import '../../../utils/SecureStorageHelper.dart';
import '../Dashboard/widgets/BankSelectionScreen.dart';
import 'login_screen_mobilelayout.dart';
import 'login_screen_weblayout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    clearLocalData();
    DetectSecurity().initState();
    BankSelectionHelper.clearBankSelection();
  }

  void clearLocalData() async {
    await SecureStorageHelper.clearSessionData();
    HeaderStore.clearHeader();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.bgColorScreen,
      body: SafeArea(
        child: ResponsiveLayout(
          mobileLayout: LoginScreenMobilelayout(),
          tabletWebLayout: LoginScreenWebLayout(),
        ),
      ),
    );
  }
}
