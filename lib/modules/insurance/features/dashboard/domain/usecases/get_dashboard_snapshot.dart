// =============================================================================
// GetDashboardSnapshot  —  USE CASE
// -----------------------------------------------------------------------------
// Single-responsibility orchestration. The BLoC calls this; the use case
// delegates to the repository. This thin layer earns its keep when:
//   * Multiple data sources are combined.
//   * Cross-cutting policies (caching, retry, telemetry) live here.
//   * The same operation is reused from multiple BLoCs.
// =============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared/usecase.dart';
import '../entities/dashboard_snapshot.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSnapshot implements UseCase<DashboardSnapshot, NoParams> {
  GetDashboardSnapshot(this._repo);
  final DashboardRepository _repo;

  @override
  Future<Either<Failure, DashboardSnapshot>> call(NoParams params) =>
      _repo.getSnapshot();
}

class RefreshDashboardSnapshot implements UseCase<DashboardSnapshot, NoParams> {
  RefreshDashboardSnapshot(this._repo);
  final DashboardRepository _repo;

  @override
  Future<Either<Failure, DashboardSnapshot>> call(NoParams params) =>
      _repo.refreshSnapshot();
}
