import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/responsive_layout.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard/dashboard_mobile_layout.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dashboard_web_layout.dart';

class DashboardScreen extends StatefulWidget {
  final LoginUserReqResInfo loginResponse;
  final BankOption selectedBank; // <-- add this
  const DashboardScreen(
      {super.key, required this.loginResponse, required this.selectedBank});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // On a web build the dashboard must always show the desktop sidebar
    // design (per the web mockup) — never the phone burger-menu/bottom-tab
    // experience, regardless of how narrow the browser window is resized.
    // Native (non-web) builds keep the original width-based switch so a
    // native tablet still gets the wider layout while a phone gets the
    // dedicated mobile one.
    final Widget dashboardBody = kIsWeb
        ? DashboardWebLayout(
            loginResponse: widget.loginResponse,
            selectedBank: widget.selectedBank,
          )
        : ResponsiveLayout(
            mobileLayout: DashBoardMobileLayout(
              loginResponse: widget.loginResponse,
              selectedBank: widget.selectedBank,
            ),
            tabletWebLayout: DashboardWebLayout(
              loginResponse: widget.loginResponse,
              selectedBank: widget.selectedBank,
            ),
          );

    return Scaffold(
      backgroundColor: AppColors.loginBackground, //.bgColorScreen,
      body: SafeArea(
        child: dashboardBody,
      ),
    );
  }
}
