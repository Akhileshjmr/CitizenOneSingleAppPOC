import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import '../data/api/cash_deposit_api.dart';
import '../data/datasources/cash_deposit_remote_datasource.dart';
import '../data/repository/cash_deposit_repository.dart';
import '../domain/usecases/submit_cash_deposit.dart';
import '../presentation/cubit/cash_deposit_cubit.dart';
import '../presentation/screens/cash_deposit_screen.dart';

final List<RouteBase> cashDepositRoutes = [
  GoRoute(
    path: '/agency-banking/cash-deposit',
    builder: (context, state) {
      final apiClient = ApiClient();
      final api = CashDepositApi(apiClient);
      final dataSource = CashDepositRemoteDataSourceImpl(api);
      final repository = CashDepositRepositoryImpl(dataSource);
      final useCase = SubmitCashDepositUseCase(repository);

      return BlocProvider(
        create: (_) => CashDepositCubit(useCase),
        child: const CashDepositScreen(),
      );
    },
  ),
];
