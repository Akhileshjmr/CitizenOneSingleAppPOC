// =============================================================================
// Failures  —  Domain-layer error types
// -----------------------------------------------------------------------------
// Use cases return `Either<Failure, T>` (from package:dartz). Sub-classing
// Failure gives the presentation layer a typed surface to switch on without
// having to inspect strings.
//
// Note: Failure is in the *domain* layer's contract. It must NOT depend on
// any Flutter or HTTP types — keep it pure Dart.
// =============================================================================

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid input']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}
