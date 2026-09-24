class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message)';
}

class NetworkException extends ApiException {
  const NetworkException(super.message,
      {super.statusCode, super.originalError});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message,
      {super.statusCode = 401, super.originalError});
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message,
      {super.statusCode = 404, super.originalError});
}

class ServerException extends ApiException {
  const ServerException(super.message,
      {super.statusCode = 500, super.originalError});
}
