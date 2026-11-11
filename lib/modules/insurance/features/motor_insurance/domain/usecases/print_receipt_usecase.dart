import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class PrintReceiptParams {
  final String policyId;

  const PrintReceiptParams ({required this.policyId});
}

class PrintReceiptUsecase {
  final MotorInsuranceRepository repository;

  PrintReceiptUsecase(this.repository);

  Future<Either<Failure, bool>> call(PrintReceiptParams  params) {
    return repository.printReceipt(params: params);
  }
}
