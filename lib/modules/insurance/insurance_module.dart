import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'domain/repositories/insurance_repository.dart';
import 'domain/usecases/get_insurance_categories_usecase.dart';
import 'domain/usecases/get_insurance_plans_usecase.dart';
import 'domain/usecases/get_insurance_partners_usecase.dart';
import 'domain/usecases/get_active_policies_usecase.dart';
import 'domain/usecases/purchase_policy_usecase.dart';
import 'domain/usecases/submit_claim_usecase.dart';
import 'data/datasources/insurance_remote_datasource.dart';
import 'data/repositories/insurance_repository_impl.dart';
import 'presentation/cubits/insurance_categories_cubit.dart';
import 'presentation/cubits/insurance_plans_cubit.dart';
import 'presentation/cubits/active_policies_cubit.dart';
import 'presentation/cubits/insurance_claim_cubit.dart';
import 'presentation/cubits/insurance_partner_cubit.dart';
import 'presentation/cubits/policy_purchase_cubit.dart';
import 'presentation/screens/insurance_dashboard_screen.dart';
import 'presentation/screens/insurance_partners_screen.dart';
import 'presentation/screens/insurance_plans_screen.dart';
import 'presentation/screens/policy_purchase_screen.dart';
import 'presentation/screens/active_policies_screen.dart';
import 'presentation/screens/insurance_claims_screen.dart';
import 'module/module_entry.dart';
import 'theme/insurance_theme.dart';

class InsuranceModule implements AppModule {
  @override
  ApiClient? apiClient;

  late InsuranceRemoteDataSource _remoteDataSource;
  late InsuranceRepository _repository;

  InsuranceCategoriesCubit? _categoriesCubit;
  InsurancePlansCubit? _plansCubit;
  ActivePoliciesCubit? _policiesCubit;
  InsuranceClaimCubit? _claimsCubit;
  InsurancePartnerCubit? _partnerCubit;
  PolicyPurchaseCubit? _purchaseCubit;

  @override
  String get id => 'insurance';

  @override
  String get title => 'Insurance';

  @override
  String get initialRoute => '/insurance';

  @override
  ThemeData? get theme => InsuranceTheme.theme;

  void _ensureInitialized() {
    final client = apiClient ?? ApiClient();
    _remoteDataSource = InsuranceRemoteDataSourceImpl(client);
    _repository = InsuranceRepositoryImpl(_remoteDataSource);

    _categoriesCubit ??= InsuranceCategoriesCubit(
      GetInsuranceCategoriesUseCase(_repository),
    );
    _plansCubit ??= InsurancePlansCubit(
      GetInsurancePlansUseCase(_repository),
    );
    _policiesCubit ??= ActivePoliciesCubit(
      GetActivePoliciesUseCase(_repository),
    );
    _claimsCubit ??= InsuranceClaimCubit(
      submitClaimUseCase: SubmitClaimUseCase(_repository),
      repository: _repository,
    );
    _partnerCubit ??= InsurancePartnerCubit(
      GetInsurancePartnersUseCase(_repository),
    );
    _purchaseCubit ??= PolicyPurchaseCubit(
      PurchasePolicyUseCase(_repository),
    );
  }

  Widget _wrapWithProviders(Widget child) {
    _ensureInitialized();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _categoriesCubit!),
        BlocProvider.value(value: _plansCubit!),
        BlocProvider.value(value: _policiesCubit!),
        BlocProvider.value(value: _claimsCubit!),
        BlocProvider.value(value: _partnerCubit!),
        BlocProvider.value(value: _purchaseCubit!),
      ],
      child: child,
    );
  }

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/insurance',
          builder: (context, state) =>
              _wrapWithProviders(const InsuranceDashboardScreen()),
        ),
        GoRoute(
          path: '/insurance/partners',
          builder: (context, state) =>
              _wrapWithProviders(const InsurancePartnersScreen()),
        ),
        GoRoute(
          path: '/insurance/plans',
          builder: (context, state) {
            final categoryCode = state.uri.queryParameters['categoryCode'];
            final vendorCode = state.uri.queryParameters['vendorCode'];
            return _wrapWithProviders(
              InsurancePlansScreen(
                categoryCode: categoryCode,
                vendorCode: vendorCode,
              ),
            );
          },
        ),
        GoRoute(
          path: '/insurance/buy',
          builder: (context, state) {
            final planId = state.uri.queryParameters['planId'] ?? 'PLN-002';
            final title = state.uri.queryParameters['title'] ?? 'Health Shield Supreme';
            final premium = state.uri.queryParameters['premium'] ?? 'ZMW 3,500/yr';
            final cover = state.uri.queryParameters['cover'] ?? 'ZMW 200,000';
            return _wrapWithProviders(
              PolicyPurchaseScreen(
                planId: planId,
                title: title,
                premium: premium,
                cover: cover,
              ),
            );
          },
        ),
        GoRoute(
          path: '/insurance/active-policies',
          builder: (context, state) =>
              _wrapWithProviders(const ActivePoliciesScreen()),
        ),
        GoRoute(
          path: '/insurance/claims',
          builder: (context, state) {
            final policyId = state.uri.queryParameters['policyId'];
            return _wrapWithProviders(
              InsuranceClaimsScreen(initialPolicyId: policyId),
            );
          },
        ),
        GoRoute(
          path: '/insurance/motor',
          builder: (context, state) {
            final vendorCode =
                state.uri.queryParameters['vendorCode'] ?? 'SANLAM_ZM';
            final authState = context.read<AuthCubit>().state;
            final user = authState is AuthAuthenticated ? authState.user : null;
            final agentMobNo = user?.username ?? '0971234567';
            try {
              InsuranceModuleEntry.initialize(
                insuranceProviderData: {
                  'vendorCode': vendorCode,
                  'vendorKey': 'partner-key-$vendorCode',
                  'vendorMob': '0970000000',
                  'agentMobNo': agentMobNo,
                  'vendorLogo': '',
                  'agentCode': agentMobNo,
                },
              );
            } catch (_) {}
            return InsuranceModuleEntry.start(
              onExit: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/agent/partners/insurance');
                }
              },
              onSignOut: () {
                context.go('/login');
              },
            );
          },
        ),
      ];

  @override
  List<BlocProvider> get providers => [];

  @override
  FutureOr<void> initialize({ApiClient? apiClient}) {
    if (apiClient != null) {
      this.apiClient = apiClient;
    }
    _ensureInitialized();
    AppLogger.info('Initializing Insurance module with host client and scoped authorization', id);
  }

  @override
  FutureOr<void> dispose() {
    AppLogger.info('Disposing in-memory policy caches, resetting cubits and wiping session tokens for Insurance', id);
    _categoriesCubit?.reset();
    _plansCubit?.reset();
    _policiesCubit?.reset();
    _claimsCubit?.reset();
    _partnerCubit?.reset();
    _purchaseCubit?.reset();
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    if (!isAuthenticated) {
      AppLogger.info('Session invalidated for Insurance. Triggering clean teardown.', id);
      dispose();
    }
  }
}
