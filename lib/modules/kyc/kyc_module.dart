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
            final apiClient = ApiClient();
            final api = KycApi(apiClient);
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
}
