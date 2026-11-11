import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/agent/insurance_partners/data/datasources/insurance_partner_remote_data_source.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/entities/insurance_provider.dart';
import 'package:citizenone_app/features/agent/insurance_partners/domain/repositories/insurance_partner_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class InsurancePartnerRepositoryImpl implements InsurancePartnerRepository {
  final InsurancePartnerRemoteDataSource remoteDataSource;

  InsurancePartnerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<InsuranceProvider>>> getProviders() async {
    try {
      final response = await remoteDataSource.getProviders();
      if (!response.isSuccess || !response.hasProvidersField) {
        return Left(
          ServerFailure(
            !response.isSuccess && response.message.message.isNotEmpty
                ? response.message.message
                : 'Unable to load insurance partners.',
          ),
        );
      }
      return Right(
        response.providers
            .map(
              (provider) => InsuranceProvider(
                vendorName: provider.vendorName?.trim() ?? '',
                vendorCode: provider.vendorCode?.trim() ?? '',
                vendorDesc: provider.vendorDesc?.trim() ?? '',
                vendorLogo: provider.vendorLogo?.trim() ?? '',
                vendorKey: provider.vendorKey?.trim() ?? '',
                vendorMob: provider.vendorMob?.trim() ?? '',
              ),
            )
            .where((provider) => provider.vendorName.isNotEmpty)
            .toList(growable: false),
      );
    } on ServerException catch (error) {
      return Left(
        ServerFailure(error.message ?? 'Unable to load insurance partners.'),
      );
    } on DioException catch (_) {
      return const Left(
        NetworkFailure('Network error. Please check your connection.'),
      );
    } on StateError catch (error) {
      return Left(ServerFailure(error.message));
    } catch (_) {
      return const Left(ServerFailure('Unable to load insurance partners.'));
    }
  }
}
