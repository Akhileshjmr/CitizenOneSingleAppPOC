import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/insurance_transaction_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class FetchInsuranceTransactionsParams {
  final int page;
  final int size;
  final String? search;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String agentCode;
  final String vendorCode;

  FetchInsuranceTransactionsParams({
    required this.page,
    this.size = 20,
    this.search,
    this.fromDate,
    this.toDate,
    required this.agentCode,
    required this.vendorCode,
  });
}

class FetchInsuranceTransactionsUsecase {
  final MotorInsuranceRepository repository;

  FetchInsuranceTransactionsUsecase(this.repository);

  Future<Either<Failure, InsuranceTransactionListResponseModel>> call(
      FetchInsuranceTransactionsParams params) {
    return repository.fetchInsuranceTransactions(
        page: params.page,
        size: params.size,
        search: params.search,
        fromDate: params.fromDate,
        toDate: params.toDate,
        agentCode: params.agentCode,
        vendorCode: params.vendorCode);
  }
}
