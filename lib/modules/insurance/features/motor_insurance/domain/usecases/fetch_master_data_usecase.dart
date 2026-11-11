import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class FetchMasterDataUsecase {
  final MotorInsuranceRepository repository;

  FetchMasterDataUsecase(this.repository);

  Future<Either<Failure, MotorInsuranceMasterData>> call() async {
    final result = await repository.masterData();
    return result;
  }
}
