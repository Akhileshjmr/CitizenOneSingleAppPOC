import 'package:citizenone_app/modules/agency_banking/data/api/ApiClient.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/common_models/HeaderStore.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';
import 'package:citizenone_app/modules/agrinet/app/agrinet_module.dart';
import 'package:flutter/widgets.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';

import '../core/Security/SecurityMonitor.dart';
import '../core/widgets/agency_banking_host_callbacks.dart';
import '../main.dart';
import '../presentation/screens/Dashboard/widgets/BankSelectionScreen.dart'
    show BankSelectionHelper;

/// Public façade Citizen One (or any other host app) uses to embed Agency
/// Banking as a module, mirroring the existing Insurance module's
/// `InsuranceModuleEntry.initialize()`/`.start()` shape.
class AgencyBankingModuleEntry {
  /// Points the singleton [ApiClient] at the host-provided gateway and
  /// resets any locally-cached session state, so every embedded session
  /// starts clean (no stale tenant/bank selection leaking across launches).
  /// Also runs the same pre-`runApp` module initialization Agency
  /// Banking's own `main()` performs for its Agrinet/Loans sub-modules,
  /// since `main()` never runs when embedded.
  /// [sessionToken]: the parent CitizenOne app's own `x-session-token`,
  /// forwarded as an `x-session-token` HTTP header on every Agency Banking
  /// request (including the citizen login call `start()` triggers). Leave
  /// null for a standalone-equivalent session (no header sent).
  /// [onSessionActivity]: invoked whenever an authenticated Agency Banking
  /// API call succeeds, so the host can restart its own global session
  /// timer. Agency Banking has no session timer of its own — this is the
  /// only signal it gives the host that the user is still active. Leave
  /// null for a standalone-equivalent session (never called).
  static Future<void> initialize({
    String gatewayBaseUrl = 'http://192.168.3.69:8082',
    String? sessionToken,
    VoidCallback? onSessionActivity,
  }) async {
    ApiClient().updateBaseUrl('$gatewayBaseUrl/abapigw/agent/channel/');
    await SecureStorageHelper.clearSessionData();
    HeaderStore.clearHeader();
    HeaderStore.updateCitizenSessionToken(sessionToken);
    HeaderStore.onAuthenticatedActivity = onSessionActivity;
    await BankSelectionHelper.clearBankSelection();
    await AgrinetModule.initialize();
    await LoansModule.initialize();
  }

  /// Returns Agency Banking's root widget, silently authenticated with
  /// [agentMobileNumber]/[agentPassword] instead of showing its own login
  /// screen. Call [initialize] first.
  ///
  /// [onExit]: invoked when the user backs out at the module's root —
  /// e.g. `onExit: () => Navigator.of(routeContext).pop()`.
  /// [onSignOut]: invoked when the user signs out from inside the embedded
  /// module — supply the host's own sign-out flow.
  static Widget start({
    required String agentMobileNumber,
    required String agentPassword,
    VoidCallback? onExit,
    VoidCallback? onSignOut,
  }) {
    return SecurityMonitor(
      child: AgencyBankingHostCallbacks(
        onExit: onExit,
        onSignOut: onSignOut,
        child: MyApp(
          autoLoginPhone: agentMobileNumber,
          autoLoginPassword: agentPassword,
        ),
      ),
    );
  }

  /// Clears Agency Banking's local session state. Call from the host's own
  /// logout flow so a stale Agency Banking session never survives a host
  /// sign-out, even if Banking was never opened this session (harmless
  /// no-op in that case).
  static Future<void> clearSession() async {
    await SecureStorageHelper.clearSessionData();
    HeaderStore.clearHeader();
    await BankSelectionHelper.clearBankSelection();
  }
}
