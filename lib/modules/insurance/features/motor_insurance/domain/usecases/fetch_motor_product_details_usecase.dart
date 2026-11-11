import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_product_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/repositories/motor_insurance_repository.dart';

class FetchMotorProductDetailsUseCase {
  final MotorInsuranceRepository repository;

  FetchMotorProductDetailsUseCase(this.repository);

  Future<Either<Failure, MotorProductDetailsResponseModel>> call(
      String productId) async {
    return await repository.fetchMotorProductDetails(productId);
  }
}
