import '../../data/repository/loans_repository.dart';
import '../entities/loan_entity.dart';

class ApplyForLoanUseCase {
  final LoansRepository repository;

  ApplyForLoanUseCase(this.repository);

  Future<LoanEntity> call({
    required double amount,
    required int tenureMonths,
  }) {
    if (amount <= 0) {
      throw ArgumentError('Loan amount must be greater than zero');
    }
    if (tenureMonths <= 0) {
      throw ArgumentError('Tenure months must be positive');
    }
    return repository.applyForLoan(amount: amount, tenureMonths: tenureMonths);
  }
}
