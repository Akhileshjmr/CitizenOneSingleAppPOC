// =============================================================================
// Exceptions  —  Data-layer exception types
// -----------------------------------------------------------------------------
// Thrown by datasource implementations and translated to Failures by the
// repository. Keeping exceptions and failures separate prevents
// data-implementation details (HTTP codes, SQLite error codes) from
// leaking into the domain.
// =============================================================================

class ServerException implements Exception {
  ServerException([this.message = 'Server error']);
  final String message;
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  CacheException([this.message = 'Cache error']);
  final String message;
  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  NetworkException([this.message = 'Network error']);
  final String message;
  @override
  String toString() => 'NetworkException: $message';
}
