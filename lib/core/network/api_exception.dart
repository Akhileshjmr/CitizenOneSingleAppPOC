class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  ApiException(this.message, {this.statusCode, this.responseBody});

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, response: $responseBody)';
}

class NetworkException extends ApiException {
  final Object? originalError;
  NetworkException(super.message, {this.originalError});
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.statusCode, super.responseBody});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message, {super.statusCode, super.responseBody});
}

class ForbiddenException extends ApiException {
  ForbiddenException(super.message, {super.statusCode, super.responseBody});
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.statusCode, super.responseBody});
}

class ServerException extends ApiException {
  ServerException(super.message, {super.statusCode, super.responseBody});
}
