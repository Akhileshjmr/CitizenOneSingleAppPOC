import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:dartz/dartz.dart';

abstract class InsurancePartnerRepository {
  Future<Either<Failure, List<InsuranceProvider>>> getProviders();
}
