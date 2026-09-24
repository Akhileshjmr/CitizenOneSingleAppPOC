import '../api/cash_deposit_api.dart';
import '../models/cash_deposit_model.dart';

abstract class CashDepositRemoteDataSource {
  Future<CashDepositModel> submitDeposit({
    required String accountNumber,
    required double amount,
    required String depositorName,
  });
}

class CashDepositRemoteDataSourceImpl implements CashDepositRemoteDataSource {
  final CashDepositApi api;

  CashDepositRemoteDataSourceImpl(this.api);

  @override
  Future<CashDepositModel> submitDeposit({
    required String accountNumber,
    required double amount,
    required String depositorName,
  }) {
    return api.submitDeposit(
      accountNumber: accountNumber,
      amount: amount,
      depositorName: depositorName,
    );
  }
}
