import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:citizenone_app/modules/insurance/app.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/app_constants.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/insurance_transaction_screen.dart';
import 'package:citizenone_app/modules/insurance/module/models/insurance_provider_model.dart';

class InsuranceModuleEntry {
  static Future<void> initialize(
      {required Map<String, dynamic> insuranceProviderData}) async {
    AppConfig.init(pName: AppConstants.packageName);
    await storageInsuranceProviderDetail(InsuranceModuleEntryDetails(
      vendorLogo: insuranceProviderData['vendorLogo'] as String? ?? '',
      vendorCode: insuranceProviderData['vendorCode'] as String? ?? '',
      agentCode: insuranceProviderData['agentCode'] as String? ?? '',
      agentMobNo: insuranceProviderData['agentMobNo'] as String? ?? '',
      vendorKey: insuranceProviderData['vendorKey'] as String? ?? '',
      vendorMob: insuranceProviderData['vendorMob'] as String? ?? '',
    ));
    await setupDI();
  }

  static Future<void> storageInsuranceProviderDetail(
      InsuranceModuleEntryDetails insuranceProviderData) async {
    const secureStorage = FlutterSecureStorage();
    await Future.wait([
      secureStorage.write(
          key: AppConstants.vendorCode,
          value: insuranceProviderData.vendorCode),
      secureStorage.write(
          key: AppConstants.agentCode, value: insuranceProviderData.agentCode),
      secureStorage.write(
          key: AppConstants.agentMobNo,
          value: insuranceProviderData.agentMobNo),
      secureStorage.write(
          key: AppConstants.vendorKey, value: insuranceProviderData.vendorKey),
      secureStorage.write(
          key: AppConstants.vendorMob, value: insuranceProviderData.vendorMob),
      secureStorage.write(
          key: AppConstants.vendorLogo,
          value: insuranceProviderData.vendorLogo),
    ]);
  }

  /// [onExit] is invoked when the module is at its own root and the user
  /// backs out (system back, iOS gesture, header/AppBar exit actions).
  /// Supply it as `onExit: () => Navigator.of(routeContext).pop()` from the
  /// same route that pushes this widget, so exiting always targets the
  /// exact Navigator the host used to show the module — see [App.onExit].
  ///
  /// [onSignOut] is invoked when the user taps "Sign Out" in the module's
  /// sidebar. Supply it as the host app's existing sign-out flow (session
  /// clearing + logout call + navigation to the host's login screen) from
  /// the same route that pushes this widget — see [App.onSignOut].
  static Widget start({VoidCallback? onExit, VoidCallback? onSignOut}) {
    return App(onExit: onExit, onSignOut: onSignOut);
  }

  static Future<T?> openInsuranceTransactionScreen<T extends Object?>(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) async {
    await setupDI();

    if (!context.mounted) return null;

    return Navigator.of(context).push<T>(
      MaterialPageRoute<T>(
        settings: RouteSettings(
          name: AppRoutes.insuranceTransactionScreen,
          arguments: arguments,
        ),
        builder: (routeContext) => _withInsuranceTheme(
          routeContext,
          BlocProvider(
            create: (context) => sl<MotorInsuranceBloc>(),
            child: InsuranceTransactionScreen(
              arguments: arguments,
              launchedFromCitizenOne: true,
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the Insurance Transactions screen as a plain widget — no
  /// [Navigator] push — for hosts that provide their own persistent chrome
  /// (e.g. a sidebar) and want this module rendered inside their own content
  /// area instead of as a separate full-screen route. Reuses the exact same
  /// DI/theme/bloc wiring as [openInsuranceTransactionScreen]; only the
  /// "push a new route" step is skipped.
  ///
  /// The returned widget still reads `agentCode` via
  /// `ModalRoute.of(context)!.settings.arguments`, so the host's own route
  /// (whatever it pushes to reach this content) must carry
  /// `arguments: {'agentCode': ...}` in its [RouteSettings].
  static Widget buildInsuranceTransactionScreen() {
    return const _InsuranceTransactionEmbeddedScreen();
  }

  static Widget _withInsuranceTheme(BuildContext context, Widget child) {
    final parentTheme = Theme.of(context);
    final hasAppThemeTokens = parentTheme.extension<AppThemeTokens>() != null;

    if (hasAppThemeTokens) {
      return child;
    }

    return Theme(
      data: AppTheme.light(const DefaultBrandPalette()),
      child: child,
    );
  }
}

/// Backs [InsuranceModuleEntry.buildInsuranceTransactionScreen]. A
/// [StatefulWidget] so the `setupDI()` future is created exactly once (in
/// [initState]) and survives host rebuilds (e.g. a desktop/web window
/// resize) — an inline `FutureBuilder(future: setupDI(), ...)` in a stateless
/// `build()` would instead recreate the future, and therefore the loader and
/// the module's [MotorInsuranceBloc], on every rebuild.
class _InsuranceTransactionEmbeddedScreen extends StatefulWidget {
  const _InsuranceTransactionEmbeddedScreen();

  @override
  State<_InsuranceTransactionEmbeddedScreen> createState() =>
      _InsuranceTransactionEmbeddedScreenState();
}

class _InsuranceTransactionEmbeddedScreenState
    extends State<_InsuranceTransactionEmbeddedScreen> {
  late final Future<void> _setupDIFuture = setupDI();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _setupDIFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return InsuranceModuleEntry._withInsuranceTheme(
          context,
          BlocProvider(
            create: (context) => sl<MotorInsuranceBloc>(),
            child: const InsuranceTransactionScreen(
              launchedFromCitizenOne: true,
            ),
          ),
        );
      },
    );
  }
}
