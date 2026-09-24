import '../../domain/entities/cash_deposit_entity.dart';
import '../datasources/cash_deposit_remote_datasource.dart';

abstract class CashDepositRepository {
  Future<CashDepositEntity> submitDeposit({
    required String accountNumber,
    required double amount,
    required String depositorName,
  });
}

class CashDepositRepositoryImpl implements CashDepositRepository {
  final CashDepositRemoteDataSource remoteDataSource;

  CashDepositRepositoryImpl(this.remoteDataSource);

  @override
  Future<CashDepositEntity> submitDeposit({
    required String accountNumber,
    required double amount,
    required String depositorName,
  }) async {
    return await remoteDataSource.submitDeposit(
      accountNumber: accountNumber,
      amount: amount,
      depositorName: depositorName,
    );
  }
}
