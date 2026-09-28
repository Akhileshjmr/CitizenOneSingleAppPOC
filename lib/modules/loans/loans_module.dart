import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/core/core.dart';
import 'features/loan_application/data/api/loans_api.dart';
import 'features/loan_application/data/repository/loans_repository.dart';
import 'features/loan_application/domain/usecases/apply_for_loan.dart';
import 'features/loan_application/presentation/cubit/loan_cubit.dart';
import 'features/loan_application/presentation/screens/loan_application_screen.dart';

class LoansModule implements AppModule {
  @override
  String get id => 'loans';

  @override
  String get title => 'Loans';

  @override
  String get initialRoute => '/loans';

  @override
  List<RouteBase> get routes => [
        GoRoute(
          path: '/loans',
          builder: (context, state) {
            final apiClient = ApiClient();
            final api = LoansApi(apiClient);
            final repository = LoansRepositoryImpl(api);
            final useCase = ApplyForLoanUseCase(repository);

            return BlocProvider(
              create: (_) => LoanCubit(useCase),
              child: const LoanApplicationScreen(),
            );
          },
        ),
      ];

  @override
  List<BlocProvider> get providers => [];
}
