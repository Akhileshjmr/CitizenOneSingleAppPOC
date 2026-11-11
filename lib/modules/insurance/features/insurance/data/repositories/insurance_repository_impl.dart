import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/data_sources/insurance_remote_data_source.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/domain/entities/insurance_category_entity.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/domain/repositories/insurance_repository.dart';

class InsuranceRepositoryImpl implements InsuranceRepository {
  final InsuranceRemoteDataSource remoteDataSource;

  InsuranceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InsuranceCategoryEntity>>> getInsuranceCategories({
    required String vendorCode,
  }) async {
    try {
      final models = await remoteDataSource.fetchInsuranceCategories(
        vendorCode: vendorCode,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
