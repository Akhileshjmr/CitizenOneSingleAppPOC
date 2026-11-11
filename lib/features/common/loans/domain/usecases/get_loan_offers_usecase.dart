import 'package:citizenone_app/features/common/loans/domain/entities/loan_offer.dart';
import 'package:citizenone_app/features/common/loans/domain/repositories/loan_repository.dart';

class GetLoanOffersUseCase {
  final LoanRepository _repository;

  GetLoanOffersUseCase(this._repository);

  Future<List<LoanOffer>> call() {
    return _repository.getLoanOffers();
  }
}
