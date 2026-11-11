import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:citizenone_app/modules/insurance/core/network/dio_client.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/session/session_token_provider.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/data_sources/insurance_remote_data_source.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/repositories/insurance_repository_impl.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/domain/repositories/insurance_repository.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/domain/usecases/get_insurance_categories_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/presentation/blocs/insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/data_sources/motor_insurance_remote_data_source.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/repositories/motor_insurance_repository_impl.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/compare_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_individual_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_instant_issue_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_invoice_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_key_facts_document_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_master_data_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_motor_product_details_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_risk_categories_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_vehicle_details_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/generate_motor_otp_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/insurance_transaction_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/issue_policy_by_quoteid_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/motor_maintainence_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/print_receipt_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/request_payment_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/search_kyc_user_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/sms_send_keyfacts_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/vehicle_create_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/verify_motor_otp_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';

/// Service-locator handle shared with the host app. Both CitizenOne
/// (`citizenone_app/core/di/di_setup.dart`) and this module use the same
/// [GetIt.instance] — CitizenOne intentionally does **not** register `Dio`,
/// so insurance is free to register its own. Other modules (agrinet,
/// loans_module) keep their dependencies in GetX (`Get.put` / `Get.find`)
/// rather than GetIt, so they do not collide with this registration.
final sl = GetIt.instance;

/// Idempotency guard for [setupDI]. A top-level `bool` is sufficient — the
/// host app calls [setupDI] exactly once at startup, and the module's own
/// `InsuranceModuleEntry` re-checks it before each `setupDI()` call. If the
/// host restarts (e.g. hot reload), Dart's `bool` default `false` is
/// sufficient because the GetIt container itself is also recreated.
bool _isInitialized = false;

/// Wires the insurance module's [GetIt] registrations. Safe to call
/// multiple times — every registration is guarded with
/// `sl.isRegistered<T>()` (or a named-instance check for `Dio`), and the
/// top-level [_isInitialized] flag short-circuits before any registration
/// runs.
///
/// Why not `sl.allowReassignment = true`? Setting that flag on a shared
/// GetIt instance lets unrelated modules overwrite each other's
/// registrations, which is a worse failure mode than the one this guard
/// is replacing.
Future<void> setupDI() async {
  if (_isInitialized) return;

  // Register a typed `Dio` for the *first* call only when it has not been
  // bound by anything else (CitizenOne, an embedded test, a previous
  // `setupDI` run). If `Dio` is already registered — e.g. by the host
  // app or by another module — we keep that binding instead of throwing
  // "Type Dio is already registered inside GetIt".
  //
  // On a fresh boot the `if (!sl.isRegistered<Dio>())` branch runs and the
  // unnamed registration succeeds (CitizenOne explicitly does not register
  // `Dio` — see `citizenone_app/core/di/di_setup.dart`).
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  }

  //Secure Storage
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(
        () => const FlutterSecureStorage());
  }
  if (!sl.isRegistered<SecureStorageService>()) {
    sl.registerLazySingleton<SecureStorageService>(
        () => SecureStorageService(sl()));
  }

  // DIO CLIENT — use the existing one if already bound (e.g. by CitizenOne's
  // own DI). Otherwise build one with the secure-storage-backed
  // [SecureStorageService]. `SessionTokenProvider` is resolved
  // defensively: the host (CitizenOne) registers it, but this module
  // must stay runnable/testable without a host present.
  if (!sl.isRegistered<DioClient>()) {
    sl.registerLazySingleton<DioClient>(
      () => DioClient(
        secureStorageService: sl(),
        sessionTokenProvider: sl.isRegistered<SessionTokenProvider>()
            ? sl<SessionTokenProvider>()
            : null,
      ),
    );
  }

  // kyc (Motor insurance)
  if (!sl.isRegistered<MotorInsuraceRemoteDataSource>()) {
    sl.registerLazySingleton<MotorInsuraceRemoteDataSource>(
      () => MotorInsuraceRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<MotorInsuranceRepository>()) {
    sl.registerLazySingleton<MotorInsuranceRepository>(
      () => MotorInsuranceRepositoryImpl(remoteDataSource: sl()),
    );
  }
  sl.registerFactory(() => SearchKycUserUseCase(sl()));
  sl.registerFactory(() => MotorMaintainenceUsecase(sl()));
  sl.registerFactory(() => FetchVehicleDetailsUsecase(sl()));
  sl.registerFactory(() => FetchMasterDataUsecase(sl()));
  sl.registerFactory(() => FetchRiskCategoriesUsecase(sl()));
  sl.registerFactory(() => FetchVehicleCreateUsecase(sl()));
  sl.registerFactory(() => GenerateMotorOtpUsecase(sl()));
  sl.registerFactory(() => VerifyMotorOtpUsecase(sl()));
  sl.registerFactory(() => CompareQuotationUsecase(sl()));
  sl.registerFactory(() => CreateIndividualUseCase(sl()));
  sl.registerFactory(() => CreateQuotationUseCase(sl()));
  sl.registerFactory(() => CreateInstantIssueUseCase(sl()));
  sl.registerFactory(() => DownloadInvoiceUseCase(sl()));
  sl.registerFactory(() => FetchInsuranceTransactionsUsecase(sl()));
  sl.registerFactory(() => RequestMotorInsurancePaymentUseCase(sl()));
  sl.registerFactory(() => PrintReceiptUsecase(sl()));
  sl.registerFactory(() => IssuePolicyByQuoteIDUseCase(sl()));
  sl.registerFactory(() => FetchMotorProductDetailsUseCase(sl()));
  sl.registerFactory(() => SmsSendForKeyFactsUseCase(sl()));
  sl.registerFactory(() => DownloadKeyFactsDocumentUseCase(sl()));
  sl.registerFactory(
    () => MotorInsuranceBloc(
        searchKycUserUseCase: sl(),
        motorMaintainenceUsecase: sl(),
        fetchVehicleDetailsUsecase: sl(),
        fetchRiskCategoriesUsecase: sl(),
        masterDataUsecase: sl(),
        vehicleCreateUseCase: sl(),
        generateMotorOtpUsecase: sl(),
        verifyMotorOtpUsecase: sl(),
        compareQuotationUsecase: sl(),
        createQuotationUseCase: sl(),
        createIndividualUseCase: sl(),
        createInstantIssueUseCase: sl(),
        downloadReceiptUseCase: sl(),
        fetchInsuranceTransactionsUsecase: sl(),
        requestMotorInsurancePaymentUseCase: sl(),
        secureStorageService: sl(),
        printReceiptUseCase: sl(),
        issuePolicyByQuoteIDUseCase: sl(),
        fetchMotorProductDetailsUseCase: sl(),
        smsSendForKeyFactsUseCase: sl(),
        downloadKeyFactsDocumentUseCase: sl()),
  );
  if (!sl.isRegistered<MotorInsuranceBloc>()) {
    sl.registerFactory(
      () => MotorInsuranceBloc(
          searchKycUserUseCase: sl(),
          motorMaintainenceUsecase: sl(),
          fetchVehicleDetailsUsecase: sl(),
          fetchRiskCategoriesUsecase: sl(),
          masterDataUsecase: sl(),
          vehicleCreateUseCase: sl(),
          generateMotorOtpUsecase: sl(),
          verifyMotorOtpUsecase: sl(),
          compareQuotationUsecase: sl(),
          createQuotationUseCase: sl(),
          createIndividualUseCase: sl(),
          createInstantIssueUseCase: sl(),
          downloadReceiptUseCase: sl(),
          fetchInsuranceTransactionsUsecase: sl(),
          requestMotorInsurancePaymentUseCase: sl(),
          secureStorageService: sl(),
          printReceiptUseCase: sl(),
          issuePolicyByQuoteIDUseCase: sl(),
          fetchMotorProductDetailsUseCase: sl(),
          smsSendForKeyFactsUseCase: sl(),
          downloadKeyFactsDocumentUseCase: sl()),
    );
  }

  // Insurance
  if (!sl.isRegistered<InsuranceRemoteDataSource>()) {
    sl.registerLazySingleton<InsuranceRemoteDataSource>(
      () => InsuranceRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<InsuranceRepository>()) {
    sl.registerLazySingleton<InsuranceRepository>(
      () => InsuranceRepositoryImpl(remoteDataSource: sl()),
    );
  }
  sl.registerFactory(() => GetInsuranceCategoriesUseCase(sl()));
  if (!sl.isRegistered<InsuranceBloc>()) {
    sl.registerFactory(
      () => InsuranceBloc(
        getInsuranceCategoriesUseCase: sl(),
      ),
    );
  }

  _isInitialized = true;
}
