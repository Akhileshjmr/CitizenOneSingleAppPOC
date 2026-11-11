import 'package:flutter/foundation.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';

import 'HeaderInfo.dart';

class HeaderStore {
  static HeaderInfo? headerInfo;

  /// `x-session-token` issued by the parent CitizenOne app's own login,
  /// handed to Agency Banking via `AgencyBankingModuleEntry.initialize()`.
  /// Null when running standalone — in that case [ApiClient] never sends
  /// the header, so the standalone login flow is unaffected.
  static String? citizenSessionToken;

  /// Notifies the host app (CitizenOne) that an authenticated Agency
  /// Banking API call just succeeded, so the host can restart its own
  /// global session-inactivity timer. Set via
  /// `AgencyBankingModuleEntry.initialize()`; null when running
  /// standalone, in which case [ApiClient] simply never calls it —
  /// Agency Banking has no session timer of its own to restart.
  static VoidCallback? onAuthenticatedActivity;

  static void update(HeaderInfo? info) {
    headerInfo = info;

    if (info == null) {
      AppLogger.info("HeaderInfo cleared globally");
    } else {
      AppLogger.debug("HeaderInfo updated globally");
    }
  }

  static void updateCitizenSessionToken(String? token) {
    citizenSessionToken = token;
    AppLogger.info(
      token == null
          ? "Citizen session token cleared"
          : "Citizen session token set",
    );
  }

  static void clearHeader() {
    headerInfo = null;
    citizenSessionToken = null;
    onAuthenticatedActivity = null;

    AppLogger.info("HeaderInfo cleared globally");

    // If you persist headerInfo, clear that persistence here too:
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('headerInfo');
  }
}
