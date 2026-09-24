import '../entities/cash_deposit_entity.dart';
import '../../data/repository/cash_deposit_repository.dart';

class SubmitCashDepositUseCase {
  final CashDepositRepository repository;

  SubmitCashDepositUseCase(this.repository);

  Future<CashDepositEntity> call({
    required String accountNumber,
    required double amount,
    required String depositorName,
  }) {
    if (amount <= 0) {
      throw ArgumentError('Deposit amount must be greater than zero');
    }
    if (accountNumber.trim().isEmpty) {
      throw ArgumentError('Account number cannot be empty');
    }
    return repository.submitDeposit(
      accountNumber: accountNumber,
      amount: amount,
      depositorName: depositorName,
    );
  }
}
