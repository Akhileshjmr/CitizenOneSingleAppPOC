import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_individual_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class CreateIndividualParams {
  final CustomerDetails customerDetails;

  const CreateIndividualParams({required this.customerDetails});
}

class CreateIndividualUseCase {
  final MotorInsuranceRepository repository;

  const CreateIndividualUseCase(this.repository);

  Future<Either<Failure, CreateIndividualResponseModel>> call({
    required CreateIndividualParams params,
  }) {
    return repository.createIndividualUser(
      customerDetails: params.customerDetails,
    );
  }
}
