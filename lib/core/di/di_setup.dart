import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:citizenone_app/features/kyc/data/datasources/kyc_local_data_source.dart';
import 'package:citizenone_app/features/kyc/data/datasources/kyc_remote_data_source.dart';
import 'package:citizenone_app/features/kyc/data/repositories/kyc_repository_impl.dart';
import 'package:citizenone_app/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/check_kyc_user_exists_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/download_document_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/fetch_locations_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/fetch_recent_history_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/get_agent_mobile_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/otp_usecases.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/resend_otp_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/search_kyc_user_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/submit_kyc_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/update_kyc_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/verify_otp_usecase.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:citizenone_app/app/env/app_env.dart';

// Auth
import 'package:citizenone_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:citizenone_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:citizenone_app/features/auth/data/datasources/change_password_remote_data_source.dart';
import 'package:citizenone_app/features/auth/data/datasources/forgot_password_remote_data_source.dart';
import 'package:citizenone_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:citizenone_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:citizenone_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:citizenone_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:citizenone_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:citizenone_app/features/auth/presentation/state/agent_banking_credential_holder.dart';
import 'package:citizenone_app/features/auth/presentation/state/auth_cubit.dart';
import 'package:citizenone_app/features/auth/presentation/state/forgot_password_cubit.dart';
import 'package:citizenone_app/modules/agency_banking/module/module_entry.dart';

// Session (global, cross-cutting — shared with the Insurance module)
import 'package:citizenone_app/core/session/data/datasources/session_remote_data_source.dart';
import 'package:citizenone_app/core/session/presentation/state/session_cubit.dart';
import 'package:citizenone_app/modules/insurance/core/session/session_token_provider.dart';

// Loans
import 'package:citizenone_app/features/common/loans/domain/repositories/loan_repository.dart';
import 'package:citizenone_app/features/common/loans/data/repositories/loan_repository_impl.dart';
import 'package:citizenone_app/features/common/loans/domain/usecases/get_loan_offers_usecase.dart';
import 'package:citizenone_app/features/common/loans/domain/usecases/get_loan_applications_usecase.dart';
import 'package:citizenone_app/features/common/loans/presentation/state/loan_cubit.dart';

// Customer — Services Hub
import 'package:citizenone_app/features/customer/services/domain/repositories/service_repository.dart';
import 'package:citizenone_app/features/customer/services/data/repositories/service_repository_impl.dart';
import 'package:citizenone_app/features/customer/services/data/datasources/service_data_source.dart';
import 'package:citizenone_app/features/customer/services/domain/usecases/get_services_use_case.dart'
    as hub_usecase;
import 'package:citizenone_app/features/customer/services/presentation/state/services_cubit.dart'
    as hub;

// Customer — Dashboard
import 'package:citizenone_app/features/customer/dashboard/domain/repositories/services_repository.dart';
import 'package:citizenone_app/features/customer/dashboard/data/repositories/services_repository_impl.dart';
import 'package:citizenone_app/features/customer/dashboard/domain/usecases/get_services_usecase.dart';
import 'package:citizenone_app/features/customer/dashboard/presentation/state/services_cubit.dart';

// Agent — Dashboard
import 'package:citizenone_app/features/agent/dashboard/domain/repositories/agent_dashboard_repository.dart';
import 'package:citizenone_app/features/agent/dashboard/data/repositories/agent_dashboard_repository_impl.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/usecases/get_agent_tasks_usecase.dart';
import 'package:citizenone_app/features/agent/dashboard/domain/usecases/get_agent_insights_usecase.dart';
import 'package:citizenone_app/features/agent/dashboard/presentation/state/agent_dashboard_cubit.dart';

// Agent — Tasks
import 'package:citizenone_app/features/agent/tasks/domain/repositories/agent_tasks_repository.dart';
import 'package:citizenone_app/features/agent/tasks/data/repositories/agent_tasks_repository_impl.dart';
import 'package:citizenone_app/features/agent/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:citizenone_app/features/agent/tasks/presentation/state/agent_tasks_cubit.dart';

// Agent — Customers
import 'package:citizenone_app/features/agent/customers/domain/repositories/agent_customers_repository.dart';
import 'package:citizenone_app/features/agent/customers/data/repositories/agent_customers_repository_impl.dart';
import 'package:citizenone_app/features/agent/customers/domain/usecases/get_agent_customers_usecase.dart';
import 'package:citizenone_app/features/agent/customers/presentation/state/agent_customers_cubit.dart';

// Agent — Collections
import 'package:citizenone_app/features/agent/collections/domain/repositories/agent_collections_repository.dart';
import 'package:citizenone_app/features/agent/collections/data/repositories/agent_collections_repository_impl.dart';
import 'package:citizenone_app/features/agent/collections/domain/usecases/get_agent_collections_usecase.dart';
import 'package:citizenone_app/features/agent/collections/presentation/state/agent_collections_cubit.dart';
import 'package:citizenone_app/features/agent/insurance_partners/data/datasources/insurance_partner_remote_data_source.dart';
import 'package:citizenone_app/features/agent/insurance_partners/data/repositories/insurance_partner_repository_impl.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/repositories/insurance_partner_repository.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/usecases/get_insurance_providers_use_case.dart';
import 'package:citizenone_app/features/agent/insurance_partners/presentation/state/insurance_partner_cubit.dart';

// Theme
import 'package:citizenone_app/core/theme/theme_cubit.dart';

// Localisation
import 'package:citizenone_app/core/l10n/domain/repositories/locale_repository.dart';
import 'package:citizenone_app/core/l10n/data/repositories/locale_repository_impl.dart';
import 'package:citizenone_app/core/l10n/domain/usecases/get_saved_locale_usecase.dart';
import 'package:citizenone_app/core/l10n/domain/usecases/save_locale_usecase.dart';
import 'package:citizenone_app/core/l10n/presentation/state/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDI({AppEnv env = AppEnv.dev}) async {
  // ── Infrastructure (external singletons) ──────────────────────────────────
  // SharedPreferences is awaited once and registered as a lazy singleton so
  // it is available to any repository that needs it without duplicating await.
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // ENV
  sl.registerLazySingleton<AppEnv>(() => env);

  // SECURE STORAGE — session token/metadata (sensitive) lives here.
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // DIO CLIENT — attaches X-Session-Token from the global SessionCubit,
  // reports possible session expiry, and reports successful activity
  // (resetting the global inactivity timer), so KYC/InsurancePartner
  // (and any future consumer of this shared client) never handle any
  // of that manually.
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      env: sl<AppEnv>(),
      sessionToken: () => sl<SessionCubit>().currentToken,
      onPossibleSessionExpiry: () => sl<SessionCubit>().reportPossibleExpiry(),
      onSuccessfulActivity: () => sl<SessionCubit>().reportActivity(),
    ),
  );

  // Note: no unnamed `Dio` registration here — the insurance module
  // (packages/insurance_module) registers its own `Dio` (with its own
  // base URL/interceptors) the first time its `setupDI()` runs, guarded
  // by `sl.isRegistered<Dio>()`. See its `core/di/di_setup.dart`.

  // ── Repositories (registerLazySingleton) ──────────────────────────────────
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl<FlutterSecureStorage>(),
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () =>
        AuthRemoteDataSourceImpl(apiClient: sl<DioClient>(), env: sl<AppEnv>()),
  );
  sl.registerLazySingleton<ChangePasswordRemoteDataSource>(
    () => ChangePasswordRemoteDataSourceImpl(
      apiClient: sl<DioClient>(),
      env: sl<AppEnv>(),
      sessionToken: () => sl<SessionCubit>().currentToken,
    ),
  );
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(
      apiClient: sl<DioClient>(),
      env: sl<AppEnv>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      changePasswordDataSource: sl<ChangePasswordRemoteDataSource>(),
      forgotPasswordDataSource: sl<ForgotPasswordRemoteDataSource>(),
    ),
  );
  // Session — global session owned by CitizenOne, consumed by CitizenOne's
  // own networking layer AND by the Insurance module via the
  // `SessionTokenProvider` interface (defined in the insurance package
  // itself, since it cannot import CitizenOne types).
  sl.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(env: sl<AppEnv>()),
  );
  sl.registerLazySingleton<SessionCubit>(
    () => SessionCubit(
      remoteDataSource: sl<SessionRemoteDataSource>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerLazySingleton<SessionTokenProvider>(() => sl<SessionCubit>());

  sl.registerLazySingleton<LoanRepository>(() => LoanRepositoryImpl());
  sl.registerLazySingleton<ServicesRepository>(() => ServicesRepositoryImpl());

  // Services Hub
  sl.registerLazySingleton<ServiceDataSource>(() => ServiceDataSourceImpl());
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AgentDashboardRepository>(
    () => AgentDashboardRepositoryImpl(),
  );
  sl.registerLazySingleton<AgentTasksRepository>(
    () => AgentTasksRepositoryImpl(),
  );
  sl.registerLazySingleton<AgentCustomersRepository>(
    () => AgentCustomersRepositoryImpl(),
  );
  sl.registerLazySingleton<AgentCollectionsRepository>(
    () => AgentCollectionsRepositoryImpl(),
  );
  sl.registerLazySingleton<InsurancePartnerRemoteDataSource>(
    () => InsurancePartnerRemoteDataSourceImpl(
      apiClient: sl<DioClient>(),
      env: sl<AppEnv>(),
    ),
  );
  sl.registerLazySingleton<InsurancePartnerRepository>(
    () => InsurancePartnerRepositoryImpl(remoteDataSource: sl()),
  );

  // Locale — maps concrete impl to abstract interface (DIP)
  sl.registerLazySingleton<LocaleRepository>(
    () => LocaleRepositoryImpl(sl<SharedPreferences>()),
  );

  // ── UseCases (registerLazySingleton) ──────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetLoanOffersUseCase(sl()));
  sl.registerLazySingleton(() => GetLoanApplicationsUseCase(sl()));
  sl.registerLazySingleton(() => GetServicesUseCase(sl()));

  // Services Hub
  sl.registerLazySingleton(
    () => hub_usecase.GetServicesUseCase(sl<ServiceRepository>()),
  );

  sl.registerLazySingleton(() => GetAgentTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetAgentInsightsUseCase(sl()));
  sl.registerLazySingleton(() => GetAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => GetAgentCustomersUseCase(sl()));
  sl.registerLazySingleton(() => GetAgentCollectionsUseCase(sl()));
  sl.registerLazySingleton(() => GetInsuranceProvidersUseCase(sl()));

  // Locale use cases
  sl.registerLazySingleton(() => GetSavedLocaleUseCase(sl<LocaleRepository>()));
  sl.registerLazySingleton(() => SaveLocaleUseCase(sl<LocaleRepository>()));

  // ── Cubits (registerFactory — prevents stale state) ───────────────────────
  // AuthCubit is a lazySingleton (not a factory): `main.dart` resolves it
  // twice — once to call `bootstrapSession()` before `runApp`, and once
  // again inside the root `MultiBlocProvider` — and both call sites must
  // see the same instance, or the bootstrapped session is silently
  // discarded. Mirrors the existing `LocaleCubit` precedent below.
  sl.registerLazySingleton<AgentBankingCredentialHolder>(
    () => AgentBankingCredentialHolder(),
  );
  sl.registerLazySingleton(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      repository: sl<AuthRepository>(),
      onSessionCleared: () {
        sl<SessionCubit>().endSession();
        sl<AgentBankingCredentialHolder>().clear();
        AgencyBankingModuleEntry.clearSession();
      },
    ),
  );
  sl.registerFactory(
    () => ForgotPasswordCubit(repository: sl<AuthRepository>()),
  );
  sl.registerFactory(
    () => LoanCubit(offersUseCase: sl(), applicationsUseCase: sl()),
  );
  sl.registerFactory(() => ServicesCubit(getServicesUseCase: sl()));

  // Services Hub
  sl.registerFactory(
    () => hub.ServicesCubit(sl<hub_usecase.GetServicesUseCase>()),
  );

  sl.registerFactory(
    () => AgentDashboardCubit(getTasksUseCase: sl(), getInsightsUseCase: sl()),
  );
  sl.registerFactory(() => AgentTasksCubit(getAllTasksUseCase: sl()));
  sl.registerFactory(() => AgentCustomersCubit(getCustomersUseCase: sl()));
  sl.registerFactory(() => AgentCollectionsCubit(getCollectionsUseCase: sl()));
  sl.registerFactory(() => InsurancePartnerCubit(getInsuranceProviders: sl()));
  sl.registerFactory(() => ThemeCubit());

  // LocaleCubit — registerLazySingleton so the same cubit instance drives
  // MaterialApp.locale from root to the entire widget tree without recreation.
  sl.registerLazySingleton(
    () => LocaleCubit(getSavedLocaleUseCase: sl(), saveLocaleUseCase: sl()),
  );

  //kyc
  sl.registerLazySingleton<KycRemoteDataSource>(
    () => KycRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<KycLocalDataSource>(
    () => KycLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<KycRepository>(
    () => KycRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );
  sl.registerFactory(() => SearchKycUserUseCase(sl()));
  sl.registerFactory(() => CheckKycUserExistsUseCase(sl()));
  sl.registerFactory(() => FetchRecentHistoryUseCase(sl()));
  sl.registerFactory(() => SubmitKycUseCase(sl()));
  sl.registerFactory(() => UpdateKycUseCase(sl()));
  sl.registerFactory(() => DownloadDocumentUseCase(sl()));
  sl.registerFactory(() => FetchLocationsUseCase(sl()));
  sl.registerFactory(() => SendOtpUseCase(sl()));
  sl.registerFactory(() => VerifyOtpUseCase(sl()));
  sl.registerFactory(() => ResendOtpUseCase(sl()));
  sl.registerFactory(() => GetAgentMobileUseCase(sl()));
  sl.registerFactory(
    () => KycBloc(
      searchKycUserUseCase: sl(),
      checkKycUserExistsUseCase: sl(),
      fetchLocationsUseCase: sl(),
      fetchRecentHistoryUseCase: sl(),
      submitKycUseCase: sl(),
      updateKycUseCase: sl(),
      downloadDocumentUseCase: sl(),
      sendOtpUseCase: sl(),
      resendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      getAgentMobileUseCase: sl(),
    ),
  );
}
