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
import 'features/auth/forgot_password/presentation/screens/forgot_password_screen.dart';
import 'features/auth/forgot_username/presentation/screens/forgot_username_screen.dart';
import 'theme/common_theme.dart';

class CommonModule implements AppModule {
  @override
  String get id => 'common';

  @override
  String get title => 'Common Services';

  @override
  String get initialRoute => '/common';

  @override
  ThemeData? get theme => CommonTheme.theme;

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
          path: '/forgot-username',
          builder: (context, state) => const ForgotUsernameScreen(),
        ),
        GoRoute(
          path: '/common',
          builder: (context, state) {
            final apiClient = ApiClient();
            final api = CitizenApi(apiClient);
            final repository = CitizenRepositoryImpl(api);
            final useCase = GetCitizenServicesUseCase(repository);

            return BlocProvider(
              create: (_) => CitizenCubit(useCase),
              child: const CitizenServicesScreen(),
            );
          },
        ),
        GoRoute(
          path: '/citizen-one',
          builder: (context, state) {
            final apiClient = ApiClient();
            final api = CitizenApi(apiClient);
            final repository = CitizenRepositoryImpl(api);
            final useCase = GetCitizenServicesUseCase(repository);

            return BlocProvider(
              create: (_) => CitizenCubit(useCase),
              child: const CitizenServicesScreen(),
            );
          },
        ),
      ];

  @override
  List<BlocProvider> get providers => [];
}

@Deprecated('Use CommonModule instead')
typedef CitizenOneModule = CommonModule;
