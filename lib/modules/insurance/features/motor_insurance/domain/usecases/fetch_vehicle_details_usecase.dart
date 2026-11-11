import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class FetchVehicleDetailsUsecase {
  final MotorInsuranceRepository repository;

  FetchVehicleDetailsUsecase(this.repository);

  Future<Either<Failure, VehicleDetailsResponse>> call({
    required String registrationNo,
  }) async {
    final result = await repository.fetchVehicleDetails(
      registrationNo: registrationNo,
    );
    return result;
  }
}
