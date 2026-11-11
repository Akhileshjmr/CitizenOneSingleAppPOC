import 'package:citizenone_app/features/common/loans/domain/entities/loan_application.dart';
import 'package:citizenone_app/features/common/loans/domain/repositories/loan_repository.dart';

class GetLoanApplicationsUseCase {
  final LoanRepository _repository;

  GetLoanApplicationsUseCase(this._repository);

  Future<List<LoanApplication>> call() {
    return _repository.getLoanApplications();
  }
}
