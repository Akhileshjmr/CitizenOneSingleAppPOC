// =============================================================================
// UseCase<T, P>  —  Base contract for every domain use case
// -----------------------------------------------------------------------------
// A use case is a thin orchestrator that captures one business intent
// (GetUserAccounts, TransferFunds). It returns Either<Failure, T> to give
// the presentation layer a typed channel for both happy and error paths.
// =============================================================================

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Sentinel for use cases that take no parameters — keeps the call site
/// uniform: `useCase(NoParams())` instead of `useCase()`.
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => const [];
}
