// =============================================================================
// injection_container.dart  —  Dependency Injection composition root
// -----------------------------------------------------------------------------
// All wiring of the dependency graph happens here. Features know nothing
// about how their collaborators are constructed — they just ask the
// service locator for them via constructors injected by the BlocProvider.
//
// Why GetIt over a global Provider tree?
//   * Domain/data layers stay Flutter-free.
//   * One place to read the entire app's dependency graph.
//   * Trivially overridden in tests via `sl.allowReassignment = true`.
//
// White-label note:
//   Switching brand is a one-line change here:
//
//     sl.registerLazySingleton<BrandPalette>(() => const BankBetaBrand());
//
//   At runtime we use AppShell.useAlternateBrand to demonstrate the swap;
//   in production, the brand is typically chosen at build time via
//   --dart-define=BRAND=alpha.
// =============================================================================

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:citizenone_app/modules/insurance/core/network/dio_client.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';

// core
import 'core/network/network_info.dart';

// features ▸ dashboard
import 'features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_snapshot.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

// features ▸ auth
import 'features/auth/data/datasource/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// features ▸ insurance
import 'features/insurance/data/data_sources/insurance_remote_data_source.dart';
import 'features/insurance/data/repositories/insurance_repository_impl.dart';
import 'features/insurance/domain/repositories/insurance_repository.dart';
import 'features/insurance/domain/usecases/get_insurance_categories_usecase.dart';

/// Service locator handle exposed to the rest of the app.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---------- Core --------------------------------------------------------
  sl.registerLazySingleton<DioClient>(
      () => DioClient(secureStorageService: sl()));
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  sl.registerLazySingleton<NetworkInfo>(() => const NetworkInfoImpl());

  // ---------- Dashboard feature ------------------------------------------
  sl
    ..registerLazySingleton<DashboardLocalDatasource>(
        () => const DashboardLocalDatasourceImpl())
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        localDatasource: sl(),
        networkInfo: sl(),
      ),
    )
    ..registerLazySingleton(() => GetDashboardSnapshot(sl()))
    ..registerLazySingleton(() => RefreshDashboardSnapshot(sl()))
    ..registerFactory(() => DashboardBloc(
          getDashboardSnapshot: sl(),
          refreshDashboardSnapshot: sl(),
        ));

  // ---------- Auth feature -----------------------------------------------
  sl
    ..registerLazySingleton<AuthRemoteDatasource>(
        () => const AuthRemoteDatasourceImpl())
    ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remote: sl()))
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerFactory(() => AuthBloc(signIn: sl()));

  // ---------- Insurance feature --------------------------------------------
  sl
    ..registerLazySingleton<InsuranceRemoteDataSource>(
        () => InsuranceRemoteDataSourceImpl(apiClient: sl()))
    ..registerLazySingleton<InsuranceRepository>(
        () => InsuranceRepositoryImpl(remoteDataSource: sl()))
    ..registerLazySingleton(() => GetInsuranceCategoriesUseCase(sl()))
    ..registerFactory(() => InsuranceBloc(getInsuranceCategoriesUseCase: sl()));
}
