abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  /// Attempts remaining after a failed OTP verification, when the API
  /// reports it. Null when the endpoint doesn't surface this data.
  final int? attemptsRemaining;

  const ServerFailure(super.message, {this.attemptsRemaining});
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}
