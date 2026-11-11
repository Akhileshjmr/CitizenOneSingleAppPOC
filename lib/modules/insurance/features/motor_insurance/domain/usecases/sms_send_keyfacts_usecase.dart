import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class SmsSendForKeyFactsUseCase {
  final MotorInsuranceRepository repository;

  SmsSendForKeyFactsUseCase(this.repository);

  Future<Either<Failure, bool>> call(
      String productId, String customerPhoneNumber) async {
    return await repository.sendSMSForPolicyKeyFacts(
        productId: productId, customerPhoneNumber: customerPhoneNumber);
  }
}
