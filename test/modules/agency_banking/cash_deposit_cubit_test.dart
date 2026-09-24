import 'package:flutter_test/flutter_test.dart';
import 'package:citizenone_app/core/core.dart';
import 'package:citizenone_app/modules/agency_banking/agency_banking.dart';
import 'package:citizenone_app/modules/agency_banking/features/cash_deposit/data/api/cash_deposit_api.dart';
import 'package:citizenone_app/modules/agency_banking/features/cash_deposit/data/datasources/cash_deposit_remote_datasource.dart';
import 'package:citizenone_app/modules/agency_banking/features/cash_deposit/data/repository/cash_deposit_repository.dart';

void main() {
  group('CashDepositCubit Tests', () {
    late CashDepositCubit cubit;
    late SubmitCashDepositUseCase useCase;

    setUp(() {
      final apiClient = ApiClient();
      final api = CashDepositApi(apiClient);
      final dataSource = CashDepositRemoteDataSourceImpl(api);
      final repository = CashDepositRepositoryImpl(dataSource);
      useCase = SubmitCashDepositUseCase(repository);
      cubit = CashDepositCubit(useCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('Initial state should be CashDepositInitial', () {
      expect(cubit.state, isA<CashDepositInitial>());
    });

    test('Successful cash deposit emits Loading then Success', () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CashDepositLoading>(),
          isA<CashDepositSuccess>(),
        ]),
      );

      await cubit.submit(
        accountNumber: '100029384',
        amount: 250.0,
        depositorName: 'John Doe',
      );

      await expectation;
      expect((cubit.state as CashDepositSuccess).result.amount, equals(250.0));
    });

    test('Invalid negative amount emits Loading then Failure', () async {
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<CashDepositLoading>(),
          isA<CashDepositFailure>(),
        ]),
      );

      await cubit.submit(
        accountNumber: '100029384',
        amount: -100.0,
        depositorName: 'John Doe',
      );

      await expectation;
    });
  });
}
