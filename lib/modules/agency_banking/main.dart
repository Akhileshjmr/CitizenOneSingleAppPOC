import 'dart:io';

import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_balance_bloc/account_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_search_bloc/account_search_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_transaction_bloc/account_transaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/account_wallet_transaction/account_wallet_transaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/additional_account_bloc/additional_account_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/balance_sms_bloc/balance_sms_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_ft_bloc/bulk_ft_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/bulk_wallet_registration_bloc/bulk_wallet_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/change_pin_bloc/change_pin_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/charge_calculation_bloc/charge_calculation_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/forgot_password_bloc/forgot_password_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_loan_account_details/loan_account_details_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/get_lov_bloc/get_lov_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/image_upload_bloc/image_upload_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_upload_bloc/kyc_upload_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/language_label_bloc/language_labels_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/account_specific_repayment_bloc/account_specific_repayment_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/application_status_bloc/application_status_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/casa_account_opening_bloc/casa_account_opening_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/collatral_bloc/collateral_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/cust_specific_repayment/cust_specific_repayment_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/customer_search/customer_search_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/eligibility_score_bloc/eligibility_score_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/emi_calculation_bloc/emi_calculation_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/loan_apply_bloc/loan_apply_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/product_group_bloc/product_group_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/products-list/products_list_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/td_account_bloc/td_account_opening_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_bloc/login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/login_qr_bloc/login_qr_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/organisation_bloc/org_login_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/pin_validation_bloc/pin_validation_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/profile_drawer_bloc/profile_drawer_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/receive_request_bloc/receive_request_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/request_money_bloc/request_money_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_password_bloc/reset_password_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/reset_pin_bloc/reset_pin_bloc%20(1).dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/security_bloc/security_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/send_money_bloc/send_money_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_history/transaction_history_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_method_bloc/transaction_method_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/transaction_receipt_bloc/transaction_receipt_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/trustaccount_wallettransaction_bloc/trustaccount_wallettransaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_balance/wallet_balance_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_account_search/wallet_account_search_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_receive_payment_bloc/wallet_receive_payment_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_registration_bloc/wallet_registration_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/wallet_transaction_bloc/wallet_transaction_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/auto_login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/login/login_screen.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/Loader.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecurityGuard.dart';
import 'package:citizenone_app/modules/agrinet/app/agrinet_module.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/loans_module.dart';
import 'package:system_proxy_retriever/system_proxy_retriever.dart';

import 'core/Security/DetectSecurity.dart';
import 'core/Security/SecurityMonitor.dart';
import 'core/Security/secure_storage.dart';
import 'core/widgets/agency_banking_host_callbacks.dart';
import 'data/api/end_points/ApiEndPoints.dart';
import 'data/api/end_points/UrlStorage.dart';
import 'data/services/AuthService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Secure Storage Initialization ──
  await SecureStorage().checkFirstInstall();
  await SecureStorage().initializeTokenFromEnvironment();

  await AgrinetModule.initialize();
  await LoansModule.initialize();

  //await Firebase.initializeApp();
  DetectSecurity.startRuntimeMonitoring();

  //await Firebase.initializeApp();

  ApiEndpoints.baseUrl = await UrlStorage.getBaseUrl();

  Map<String, String>? proxy;
  try {
    proxy = await SystemProxy.getProxySettings();
    if (proxy != null && proxy['host'] != null && proxy['port'] != null) {
      HttpOverrides.global = MyHttpOverrides(proxy);
      AppLogger.info('System proxy configured');
    }
  } catch (e) {
    AppLogger.error('Failed to get proxy settings', e);
  }

  // ── Security checks (#12, #15) — run before app launch ──
  final securityResult = await SecurityGuard.performChecks();
  if (securityResult.hasThreat) {
    AppLogger.warning('Security threats detected: ${securityResult.threats}');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.security, size: 64, color: Colors.red),
                  const SizedBox(height: 24),
                  const Text(
                    'Security Alert',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This app cannot run on this device due to security concerns:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  ...securityResult.threats.map((threat) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber,
                                size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text(
                              threat,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    'Please resolve the issue and restart the app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }

  runApp(
    SecurityMonitor(
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  final Map<String, String>? proxy;

  MyHttpOverrides(this.proxy);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.findProxy = (uri) {
      if (proxy != null &&
          proxy!['host'] != null &&
          proxy!['port'] != null &&
          proxy!['host']!.isNotEmpty) {
        final host = proxy!['host'];
        final port = proxy!['port'];
        AppLogger.network('Using system proxy');
        return "PROXY $host:$port;";
      }
      return "DIRECT";
    };

    // Only bypass certificate validation when pinning is disabled
    if (!SecurityConfig.enableCertificatePinning) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    }

    return client;
  }
}

class MyApp extends StatefulWidget {
  /// Set (both non-null) when embedded in a host app that has already
  /// authenticated the agent — skips [LoginScreen] entirely and silently
  /// signs in via [AutoLoginScreen] instead. Both null in the standalone
  /// app, which is unaffected.
  final String? autoLoginPhone;
  final String? autoLoginPassword;

  const MyApp({super.key, this.autoLoginPhone, this.autoLoginPassword});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  AuthService authService = AuthService();
  final bool isDesktop = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginBloc(authService)),
          BlocProvider(create: (_) => CustomerRegistrationBloc(authService)),
          BlocProvider(create: (_) => CustomerSearchBloc(authService)),
          BlocProvider(create: (_) => TdAccountOpeningBloc(authService)),
          BlocProvider(create: (_) => CasaAccountOpeningBloc(authService)),
          BlocProvider(create: (_) => EmiCalculationBloc(authService)),
          BlocProvider(create: (_) => CustSpecificRepaymentBloc(authService)),
          BlocProvider(
              create: (_) => AccountSpecificRepaymentBloc(authService)),
          BlocProvider(create: (_) => ApplicationStatusBloc(authService)),
          BlocProvider(create: (_) => EligibilityScoreBloc(authService)),
          BlocProvider(create: (_) => ProductGroupBloc(authService)),
          BlocProvider(create: (_) => ProductsListBloc(authService)),
          BlocProvider(create: (_) => LoanApplyBloc(authService)),
          BlocProvider(create: (_) => ChargeCalculationBloc(authService)),
          BlocProvider(create: (_) => LoadingCubit()),
          BlocProvider(create: (_) => ForgotPasswordBloc(authService)),
          BlocProvider(create: (_) => AccountTransactionBloc(authService)),
          BlocProvider(create: (_) => WalletTransactionBloc(authService)),
          BlocProvider(create: (_) => GetLovBloc(authService)),
          BlocProvider(create: (_) => SendMoneyBloc(authService)),
          BlocProvider(create: (_) => PinValidationBloc(authService)),
          BlocProvider(create: (_) => WalletBalanceBloc(authService)),
          BlocProvider(create: (_) => AccountBalanceBloc(authService)),
          BlocProvider(create: (_) => BalanceSmsBloc(authService)),
          BlocProvider(create: (context) => RequestMoneyBloc(authService)),
          BlocProvider(
              create: (_) => DashboardTransactionHistoryBloc(authService)),
          BlocProvider(
              create: (_) => HistoryTransactionHistoryBloc(authService)),
          BlocProvider(create: (_) => AccountSearchBloc(authService)),
          BlocProvider(create: (_) => WalletSearchBloc(authService)),
          BlocProvider(create: (_) => ReceiveRequestBloc(authService)),
          BlocProvider(create: (_) => TransactionReceiptBloc(authService)),
          BlocProvider(create: (_) => ProfileDrawerBloc(authService)),
          BlocProvider(create: (_) => UserProfileBloc(authService)),
          BlocProvider(create: (_) => LoanAccountDetailsBloc(authService)),
          BlocProvider(create: (_) => LoginQrBloc(authService)),
          BlocProvider(create: (_) => ResetPinBloc(authService)),
          BlocProvider(create: (_) => ChangePinBloc(authService)),
          BlocProvider(
              create: (_) => AccountWalletTransactionBloc(authService)),
          BlocProvider(create: (_) => ResetPasswordBloc(authService)),
          BlocProvider(
              create: (_) => TrustaccountWallettransactionBloc(authService)),
          BlocProvider(create: (_) => WalletRegistrationBloc(authService)),
          BlocProvider(create: (_) => KycUploadBloc(authService)),
          BlocProvider(create: (_) => AdditionalAccountBloc(authService)),
          BlocProvider(create: (_) => CustImageUploadBloc(authService)),
          BlocProvider(create: (_) => WalletReceivePaymentBloc(authService)),
          BlocProvider(create: (_) => LanguageLabelsBloc(authService)),
          BlocProvider(create: (_) => BulkWalletRegistrationBloc(authService)),
          BlocProvider(create: (_) => BulkFtBloc(authService)),
          BlocProvider(create: (_) => CollateralBloc(authService)),
          BlocProvider(create: (_) => OrgLoginBloc(authService)),
          BlocProvider(create: (_) => KycBloc(authService)),
          BlocProvider(create: (_) => TransactionMethodBloc(authService)),
          BlocProvider(create: (_) => SecurityBloc(authService)),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              title: 'CitizenOne',
              debugShowCheckedModeBanner: false,
              builder: (context, child) => GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                behavior: HitTestBehavior.translucent,
                child: child ?? const SizedBox(),
              ),
              home: widget.autoLoginPhone != null
                  ? AutoLoginScreen(
                      phone: widget.autoLoginPhone!,
                      password: widget.autoLoginPassword!,
                      onExit:
                          AgencyBankingHostCallbacks.maybeOf(context)?.onExit,
                    )
                  : const LoginScreen(),
              getPages: [
                ...AgrinetModule.pages,
                ...LoansModule.pages,
              ],
              theme: ThemeData(
                fontFamily: 'Sora',
                colorSchemeSeed: Colors.green,
                useMaterial3: true,
                drawerTheme: const DrawerThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            );
          },
        ));
  }
}
