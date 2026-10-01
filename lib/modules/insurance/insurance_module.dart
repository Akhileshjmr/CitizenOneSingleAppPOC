import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'features/policy_purchase/data/api/insurance_api.dart';
import 'features/policy_purchase/data/repository/insurance_repository.dart';
import 'features/policy_purchase/domain/usecases/purchase_policy.dart';
import 'features/policy_purchase/presentation/cubit/insurance_cubit.dart';
import 'features/policy_purchase/presentation/screens/policy_purchase_screen.dart';
import 'theme/insurance_theme.dart';

class InsuranceModule implements AppModule {
  @override
  String get id => 'insurance';

  @override
  String get title => 'Insurance';

  @override
  String get initialRoute => '/insurance';

  @override
  ThemeData? get theme => InsuranceTheme.theme;

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/insurance',
          builder: (context, state) {
            final apiClient = ApiClient();
            final api = InsuranceApi(apiClient);
            final repository = InsuranceRepositoryImpl(api);
            final useCase = PurchasePolicyUseCase(repository);

            return BlocProvider(
              create: (_) => InsuranceCubit(useCase),
              child: const PolicyPurchaseScreen(),
            );
          },
        ),
      ];

  @override
  List<BlocProvider> get providers => [];
}
