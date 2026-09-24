import '../api/loans_api.dart';
import '../../domain/entities/loan_entity.dart';

abstract class LoansRepository {
  Future<LoanEntity> applyForLoan({
    required double amount,
    required int tenureMonths,
  });
}

class LoansRepositoryImpl implements LoansRepository {
  final LoansApi api;

  LoansRepositoryImpl(this.api);

  @override
  Future<LoanEntity> applyForLoan({
    required double amount,
    required int tenureMonths,
  }) async {
    return await api.applyForLoan(amount: amount, tenureMonths: tenureMonths);
  }
}
