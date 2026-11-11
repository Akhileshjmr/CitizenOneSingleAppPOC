import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'features/services_overview/data/api/citizen_api.dart';
import 'features/services_overview/data/repository/citizen_repository.dart';
import 'features/services_overview/domain/usecases/get_citizen_services.dart';
import 'features/services_overview/presentation/cubit/citizen_cubit.dart';
import 'features/services_overview/presentation/screens/citizen_services_screen.dart';
import 'features/auth/login/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/forgot_password_otp_screen.dart';
import 'features/auth/presentation/screens/create_password_screen.dart';
import 'features/auth/presentation/screens/forgot_password_success_screen.dart';
import 'features/auth/presentation/screens/forgot_username_screen.dart';
import 'features/agent/domain/usecases/get_agent_dashboard_usecase.dart';
import 'features/agent/domain/usecases/get_agent_tasks_usecase.dart';
import 'features/agent/domain/usecases/get_agent_customers_usecase.dart';
import 'features/agent/domain/usecases/get_agent_collections_usecase.dart';
import 'features/agent/data/datasources/agent_remote_datasource.dart';
import 'features/agent/data/repositories/agent_repository_impl.dart';
import 'features/agent/presentation/cubits/agent_dashboard_cubit.dart';
import 'features/agent/presentation/cubits/agent_tasks_cubit.dart';
import 'features/agent/presentation/cubits/agent_customers_cubit.dart';
import 'features/agent/presentation/cubits/agent_collections_cubit.dart';
import 'features/agent/presentation/screens/agent_services_dashboard_screen.dart';
import 'features/agent/presentation/screens/insurance_partner_selection_screen.dart';
import 'features/agent/presentation/screens/agent_tasks_screen.dart';
import 'features/agent/presentation/screens/agent_customers_screen.dart';
import 'features/agent/presentation/screens/agent_collections_screen.dart';
import 'theme/common_theme.dart';

class CommonModule implements AppModule {
  @override
  ApiClient? apiClient;

  late AgentRemoteDataSource _agentRemoteDataSource;
  late AgentRepositoryImpl _agentRepository;

  CitizenCubit? _citizenCubit;
  AgentDashboardCubit? _agentDashboardCubit;
  AgentTasksCubit? _agentTasksCubit;
  AgentCustomersCubit? _agentCustomersCubit;
  AgentCollectionsCubit? _agentCollectionsCubit;

  @override
  String get id => 'common';

  @override
  String get title => 'Common Services';

  @override
  String get initialRoute => '/common';

  @override
  ThemeData? get theme => CommonTheme.theme;

  void _ensureInitialized() {
    final client = apiClient ?? ApiClient();
    _agentRemoteDataSource = AgentRemoteDataSourceImpl(client);
    _agentRepository = AgentRepositoryImpl(_agentRemoteDataSource);

    _agentDashboardCubit ??= AgentDashboardCubit(
      GetAgentDashboardUseCase(_agentRepository),
    );
    _agentTasksCubit ??= AgentTasksCubit(
      getTasksUseCase: GetAgentTasksUseCase(_agentRepository),
      updateTaskStatusUseCase: UpdateTaskStatusUseCase(_agentRepository),
    );
    _agentCustomersCubit ??= AgentCustomersCubit(
      GetAgentCustomersUseCase(_agentRepository),
    );
    _agentCollectionsCubit ??= AgentCollectionsCubit(
      getCollectionsUseCase: GetAgentCollectionsUseCase(_agentRepository),
      recordCollectionUseCase: RecordCollectionUseCase(_agentRepository),
    );
  }

  Widget _wrapAgent(Widget child) {
    _ensureInitialized();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _agentDashboardCubit!),
        BlocProvider.value(value: _agentTasksCubit!),
        BlocProvider.value(value: _agentCustomersCubit!),
        BlocProvider.value(value: _agentCollectionsCubit!),
      ],
      child: child,
    );
  }

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/forgot-password/otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final mobile = extra?['mobileNumber'] as String? ?? '0971234567';
            return ForgotPasswordOtpScreen(mobileNumber: mobile);
          },
        ),
        GoRoute(
          path: '/auth/forgot-password/otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final mobile = extra?['mobileNumber'] as String? ?? '0971234567';
            return ForgotPasswordOtpScreen(mobileNumber: mobile);
          },
        ),
        GoRoute(
          path: '/forgot-password/create-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final mobile = extra?['mobileNumber'] as String? ?? '0971234567';
            return CreatePasswordScreen(mobileNumber: mobile);
          },
        ),
        GoRoute(
          path: '/auth/forgot-password/create-password',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final mobile = extra?['mobileNumber'] as String? ?? '0971234567';
            return CreatePasswordScreen(mobileNumber: mobile);
          },
        ),
        GoRoute(
          path: '/forgot-password/success',
          builder: (context, state) => const ForgotPasswordSuccessScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-password/success',
          builder: (context, state) => const ForgotPasswordSuccessScreen(),
        ),
        GoRoute(
          path: '/forgot-username',
          builder: (context, state) => const ForgotUsernameScreen(),
        ),
        GoRoute(
          path: '/auth/forgot-username',
          builder: (context, state) => const ForgotUsernameScreen(),
        ),
        GoRoute(
          path: '/common',
          builder: (context, state) {
            final client = apiClient ?? ApiClient();
            final api = CitizenApi(client);
            final repository = CitizenRepositoryImpl(api);
            final useCase = GetCitizenServicesUseCase(repository);

            _citizenCubit ??= CitizenCubit(useCase);
            return BlocProvider.value(
              value: _citizenCubit!,
              child: const CitizenServicesScreen(),
            );
          },
        ),
        GoRoute(
          path: '/citizen-one',
          builder: (context, state) {
            final client = apiClient ?? ApiClient();
            final api = CitizenApi(client);
            final repository = CitizenRepositoryImpl(api);
            final useCase = GetCitizenServicesUseCase(repository);

            _citizenCubit ??= CitizenCubit(useCase);
            return BlocProvider.value(
              value: _citizenCubit!,
              child: const CitizenServicesScreen(),
            );
          },
        ),
        GoRoute(
          path: '/agent/dashboard',
          builder: (context, state) =>
              _wrapAgent(const AgentServicesDashboardScreen()),
        ),
        GoRoute(
          path: '/agent/partners/insurance',
          builder: (context, state) =>
              _wrapAgent(const InsurancePartnerSelectionScreen()),
        ),
        GoRoute(
          path: '/agent/tasks',
          builder: (context, state) =>
              _wrapAgent(const AgentTasksScreen()),
        ),
        GoRoute(
          path: '/agent/customers',
          builder: (context, state) =>
              _wrapAgent(const AgentCustomersScreen()),
        ),
        GoRoute(
          path: '/agent/collections',
          builder: (context, state) =>
              _wrapAgent(const AgentCollectionsScreen()),
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
    AppLogger.info('Initializing Common & Agent Services module with host client', id);
  }

  @override
  FutureOr<void> dispose() {
    AppLogger.info('Disposing in-memory services cache and resetting agent cubits for Common Services', id);
    _citizenCubit?.reset();
    _agentDashboardCubit?.reset();
    _agentTasksCubit?.reset();
    _agentCustomersCubit?.reset();
    _agentCollectionsCubit?.reset();
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    if (!isAuthenticated) {
      AppLogger.info('Session reset for Common & Agent Services. Wiping state.', id);
      dispose();
    }
  }
}

@Deprecated('Use CommonModule instead')
typedef CitizenOneModule = CommonModule;
