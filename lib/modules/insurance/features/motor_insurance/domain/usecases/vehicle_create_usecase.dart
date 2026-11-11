import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_create_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/vehicle_create_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class VehicleCreateParams {
  final VehicleCreateEntity vehicleCreateEntity;
  final String clientId;

  const VehicleCreateParams(this.vehicleCreateEntity, this.clientId);
}

class FetchVehicleCreateUsecase {
  final MotorInsuranceRepository respositary;
  const FetchVehicleCreateUsecase(this.respositary);

  Future<Either<Failure, VehicleCreateResponse>> call(
      VehicleCreateParams vehicleParams) async {
    return respositary.createVehicle(vehicleParams: vehicleParams);
  }
}
