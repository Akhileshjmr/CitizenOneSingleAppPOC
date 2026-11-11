import 'package:citizenone_app/modules/agency_banking/data/models/login_models/LoginUserReqResInfo.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/login_models/TenantDetails.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/Dashboard/widgets/BankSelectionScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dashboard_mobile_layout.dart';
import 'dashboard_web_layout.dart';

/// Every screen that needs to land back on the dashboard (post-login,
/// post-transaction, post-password-change, etc.) must go through this
/// helper instead of instantiating DashBoardMobileLayout directly — that
/// used to send web sessions straight to the phone-style burger-menu /
/// bottom-tab dashboard no matter how the screen was reached. This picks
/// the desktop sidebar dashboard on web and the phone dashboard everywhere
/// else, so every entry point stays consistent.
Widget buildDashboardEntry({
  required LoginUserReqResInfo loginResponse,
  required BankOption selectedBank,
  LoginUserReqResInfo? firstLoginResponse,
  List<TenantDetails>? tenants,
  String? agentPhoneNumber,
}) {
  if (kIsWeb) {
    return DashboardWebLayout(
      loginResponse: loginResponse,
      selectedBank: selectedBank,
    );
  }
  return DashBoardMobileLayout(
    loginResponse: loginResponse,
    selectedBank: selectedBank,
    firstLoginResponse: firstLoginResponse,
    tenants: tenants,
    agentPhoneNumber: agentPhoneNumber,
  );
}
