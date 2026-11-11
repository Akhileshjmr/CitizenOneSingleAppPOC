// =============================================================================
// DashboardRepository  —  DOMAIN CONTRACT
// -----------------------------------------------------------------------------
// Abstract — implementation lives in data/repositories. Domain layer never
// imports the concrete class. This is the dependency inversion that lets us
// swap a mock or alternative datasource without touching use cases.
// =============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_snapshot.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSnapshot>> getSnapshot();
  Future<Either<Failure, DashboardSnapshot>> refreshSnapshot();
}
