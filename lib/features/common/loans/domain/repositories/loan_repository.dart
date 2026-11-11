import 'package:citizenone_app/features/common/loans/domain/entities/loan_offer.dart';
import 'package:citizenone_app/features/common/loans/domain/entities/loan_application.dart';

abstract class LoanRepository {
  Future<List<LoanOffer>> getLoanOffers();
  Future<List<LoanApplication>> getLoanApplications();
}
