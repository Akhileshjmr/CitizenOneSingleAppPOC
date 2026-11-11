import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/repositories/insurance_partner_repository.dart';
import 'package:dartz/dartz.dart';

class GetInsuranceProvidersUseCase {
  final InsurancePartnerRepository _repository;

  GetInsuranceProvidersUseCase(this._repository);

  Future<Either<Failure, List<InsuranceProvider>>> call() =>
      _repository.getProviders();
}
