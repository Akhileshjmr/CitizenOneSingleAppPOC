import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class MotorMaintainenceUsecase {
  final MotorInsuranceRepository repository;

  MotorMaintainenceUsecase(this.repository);

  Future<Either<Failure, MotorMaintainenceResponseModel>> call() async {
    final result = await repository.getMotorMaintainence();
    return result;
  }
}
