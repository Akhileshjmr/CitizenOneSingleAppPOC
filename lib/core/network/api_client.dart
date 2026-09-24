import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';
import 'network_interceptor.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final NetworkInterceptor interceptor;

  ApiClient({
    this.baseUrl = 'https://api.citizenone.example.com',
    http.Client? client,
    NetworkInterceptor? interceptor,
  })  : _client = client ?? http.Client(),
        interceptor = interceptor ?? DefaultNetworkInterceptor();

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});

    try {
      final response = await _client.get(uri, headers: reqHeaders);
      return _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException('Network GET request failed: $e',
          originalError: e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _client.post(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException('Network POST request failed: $e',
          originalError: e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});
    final encodedBody = body != null ? jsonEncode(body) : null;

    try {
      final response = await _client.put(
        uri,
        headers: reqHeaders,
        body: encodedBody,
      );
      return _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException('Network PUT request failed: $e',
          originalError: e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final reqHeaders = await interceptor.onRequest(path, headers ?? {});

    try {
      final response = await _client.delete(uri, headers: reqHeaders);
      return _processResponse(path, response);
    } catch (e) {
      await interceptor.onError(path, e);
      if (e is ApiException) rethrow;
      throw NetworkException('Network DELETE request failed: $e',
          originalError: e);
    }
  }

  Map<String, dynamic> _processResponse(String path, http.Response response) {
    interceptor.onResponse(path, response.statusCode, response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException('Unauthorized access');
    } else if (response.statusCode == 404) {
      throw const NotFoundException('Resource not found');
    } else if (response.statusCode >= 500) {
      throw ServerException('Server error (${response.statusCode})');
    } else {
      throw ApiException(
        'Request failed with status code ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}
