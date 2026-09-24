import 'dart:async';

abstract class NetworkInterceptor {
  FutureOr<Map<String, String>> onRequest(
    String path,
    Map<String, String> headers,
  );

  FutureOr<void> onResponse(
    String path,
    int statusCode,
    dynamic body,
  );

  FutureOr<void> onError(
    String path,
    Object error,
  );
}

class DefaultNetworkInterceptor implements NetworkInterceptor {
  final String? Function()? getAuthToken;

  DefaultNetworkInterceptor({this.getAuthToken});

  @override
  FutureOr<Map<String, String>> onRequest(
    String path,
    Map<String, String> headers,
  ) {
    final updatedHeaders = Map<String, String>.from(headers);
    updatedHeaders['Content-Type'] = 'application/json';

    if (getAuthToken != null) {
      final token = getAuthToken!();
      if (token != null && token.isNotEmpty) {
        updatedHeaders['Authorization'] = 'Bearer $token';
      }
    }

    return updatedHeaders;
  }

  @override
  FutureOr<void> onResponse(String path, int statusCode, body) {}

  @override
  FutureOr<void> onError(String path, Object error) {}
}
