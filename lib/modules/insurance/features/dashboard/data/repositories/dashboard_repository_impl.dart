// =============================================================================
// DashboardRepositoryImpl  —  DATA LAYER
// -----------------------------------------------------------------------------
// Implements the domain contract by orchestrating datasources. Translates
// data-layer exceptions into domain Failures so the use case stays clean.
// =============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/dashboard_snapshot.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({
    required this.localDatasource,
    required this.networkInfo,
  });

  final DashboardLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, DashboardSnapshot>> getSnapshot() async {
    try {
      final snapshot = await localDatasource.getSnapshot();
      return Right(snapshot);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DashboardSnapshot>> refreshSnapshot() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    return getSnapshot();
  }
}
