import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'features/document_upload/data/api/kyc_api.dart';
import 'features/document_upload/data/repository/kyc_repository.dart';
import 'features/document_upload/domain/usecases/upload_kyc_document.dart';
import 'features/document_upload/presentation/cubit/kyc_cubit.dart';
import 'features/document_upload/presentation/screens/kyc_upload_screen.dart';
import 'theme/kyc_theme.dart';

class KycModule implements AppModule {
  @override
  ApiClient? apiClient;

  @override
  String get id => 'kyc';

  @override
  String get title => 'KYC Verification';

  @override
  String get initialRoute => '/kyc';

  @override
  ThemeData? get theme => KycTheme.theme;

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/kyc',
          builder: (context, state) {
            final client = apiClient ?? ApiClient();
            final api = KycApi(client);
            final repository = KycRepositoryImpl(api);
            final useCase = UploadKycDocumentUseCase(repository);

            return BlocProvider(
              create: (_) => KycCubit(useCase),
              child: const KycUploadScreen(),
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
    AppLogger.info('Initializing KYC Verification module with host client', id);
  }

  @override
  FutureOr<void> dispose() {
    AppLogger.info('Disposing KYC document caches and temporary file references', id);
  }

  @override
  void onSessionStateChanged(bool isAuthenticated, UserModel? user) {
    if (!isAuthenticated) {
      AppLogger.info('Session invalidated for KYC Verification', id);
    }
  }
}
