import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getX;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../session/session_interceptor.dart';
import '../../../session/session_manager.dart';
import '../../../utils/aes_encoder.dart';
import '../../local/store/user_provider.dart';

/// DIO interceptor to add the authentication token
InterceptorsWrapper addAuthToken({String authTokenHeader = 'authToken'}) =>
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (UserProvider.authToken != null &&
            UserProvider.authToken!.isNotEmpty) {
          options.headers.addAll(<String, dynamic>{
            authTokenHeader: 'Bearer ${UserProvider.authToken}',
          });
        }
        handler.next(options); //continue
      },
    );

/// API service of the application. To use Get, POST, PUT and PATCH rest methods
class APIService {
  static final Dio _dio = Dio();
  static bool _isInitialized = false;

  static late String _prodBaseApiUrl;
  static late String _devBaseApiUrl;
  static late String _WebUrl;

  static late String _prodImageBaseUrl;
  static late String _devImageBaseUrl;
  static bool _isEncryptRequired = false; // Added encryption flag

  static String get baseUrl => kReleaseMode ? _prodBaseApiUrl : _devBaseApiUrl;
  static String get webUrl => _WebUrl;
  static String get imageBaseUrl =>
      kReleaseMode ? _prodImageBaseUrl : _devImageBaseUrl;

  static const bool encryptData = false;

  /// Initialize the API service
  static void initializeAPIService({
    required String devBaseUrl,
    required String prodBaseUrl,
    required String devImageBaseUrl,
    required String prodImageBaseUrl,
    required String livezyWebUrl,
    bool encryptData = false, // Added encryption parameter
    String authHeader = 'authToken',
    String xAPIKeyHeader = 'x-api-key',
    String xAPIKeyValue = 'x-api-key',
  }) {
    if (_isInitialized) {
      return;
    }

    _devBaseApiUrl = devBaseUrl;
    _prodBaseApiUrl = prodBaseUrl;
    _WebUrl = livezyWebUrl;
    _isEncryptRequired = encryptData; // Set encryption flag
    _devImageBaseUrl = devImageBaseUrl.replaceAll('//cms', '/cms');
    _prodImageBaseUrl = prodImageBaseUrl.replaceAll('//cms', '/cms');

    _dio.options.baseUrl = baseUrl;
    _dio.options.headers.addAll(<String, dynamic>{xAPIKeyHeader: xAPIKeyValue});

    _dio.interceptors.add(addAuthToken(authTokenHeader: authHeader));
    _dio.interceptors.add(SessionInterceptor());

    // Add response interceptor for AED/AUD conversion and session updates
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          // AED/AUD conversion as before
          if (response.data != null) {
            final modified = _replaceAEDWithAUDForResponse(response.data);
            if (modified is Map) {
              response.data = _convertKeysToString(modified);
            } else {
              response.data = modified;
            }
          }
          try {
            if (response.data != null) {
              if (getX.Get.isRegistered<SessionManager>()) {
                getX.Get.find<SessionManager>().updateSessionFromPayload();
              }
            }
          } catch (e) {
            debugPrint('Session auto‑update failed: $e');
          }
          handler.next(response);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    _isInitialized = true;
  }

  static String _formatUrl(String? forcedBaseUrl, String path) {
    String base = forcedBaseUrl ?? baseUrl;
    if (!base.endsWith('/')) {
      base += '/';
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    return base + path;
  }

  /// Enhanced GET method with encryption support
  static Future<Response<Map<String, dynamic>?>?> get({
    required String path,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);
    print('GET url: $url, encryption: $useEncryption');

    try {
      final Response<String> response = await _dio.get<String>(
        url,
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'encrypt': useEncryption,
            'Content-Type':
                useEncryption
                    ? 'text/plain'
                    : 'application/json; charset=UTF-8',
            'Accept': '*/*',
          },
          responseType: ResponseType.plain,
        ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: true,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      if (_shouldRefreshAuthToken(dioError)) {
        await _handleTokenRefresh();
        return await get(
          path: path,
          params: params,
          encrypt: useEncryption,
          forcedBaseUrl: forcedBaseUrl,
        );
      }
      rethrow;
    }
  }

  /// Enhanced POST method with encryption support
  static Future<Response<Map<String, dynamic>?>?> post({
    required String path,
    dynamic? data,
    Map<String, dynamic>? params,
    Options? options,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);
    print('POST url: $url, encryption: $useEncryption');

    try {
      // Prepare data (with AED/AUD conversion)
      dynamic finalData = data;
      if (data is Map<String, dynamic>) {
        finalData = _replaceAedWithAud(data);
      }

      String? encryptedData;
      if (finalData != null && useEncryption) {
        final String jsonString = jsonEncode(finalData);
        encryptedData = AesEncryption.encrypt(jsonString);
      }

      final Response<String> response = await _dio.post<String>(
        url,
        data: useEncryption ? encryptedData : finalData,
        queryParameters: params,
        options:
            options ??
            Options(
              headers: <String, dynamic>{
                'encrypt': useEncryption,
                'Content-Type':
                    useEncryption
                        ? 'text/plain'
                        : 'application/json; charset=UTF-8',
                'Accept': '*/*',
              },
              responseType: ResponseType.plain,
            ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: false,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      if (_shouldRefreshAuthToken(dioError)) {
        await _handleTokenRefresh();
        return await post(
          path: path,
          data: data,
          params: params,
          encrypt: useEncryption,
          forcedBaseUrl: forcedBaseUrl,
        );
      }
      rethrow;
    }
  }

  /// POST with authentication and encryption
  static Future<Response<Map<String, dynamic>?>?> postAuth({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);

    try {
      // Get user credentials
      final String mobNumber = await UserProvider.getMobileNumber();
      final String email = await UserProvider.getEmail();

      String? userID;
      if (mobNumber.isEmpty && email.isNotEmpty) {
        userID = AesEncryption.encrypt(email);
      } else {
        userID = mobNumber.isNotEmpty ? AesEncryption.encrypt(mobNumber) : '';
      }

      String? auth =
          (UserProvider.authToken ?? '').isNotEmpty
              ? AesEncryption.encrypt(UserProvider.authToken!)
              : null;

      // Prepare data
      Map<String, dynamic>? modifiedData =
          data != null ? _replaceAedWithAud(data) : null;

      String? encryptedData;
      if (modifiedData != null && useEncryption) {
        final String jsonString = jsonEncode(modifiedData);
        encryptedData = AesEncryption.encrypt(jsonString);
      }

      final Response<String> response = await _dio.post<String>(
        url,
        data: useEncryption ? encryptedData : modifiedData,
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'encrypt': useEncryption,
            'Content-Type':
                useEncryption
                    ? 'text/plain'
                    : 'application/json; charset=UTF-8',
            'Accept': '*/*',
            'userId': userID,
            'authorization': auth,
          },
          responseType: ResponseType.plain,
        ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: false,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      if (_shouldRefreshAuthToken(dioError)) {
        await _handleTokenRefresh();
        return await postAuth(
          path: path,
          data: data,
          params: params,
          encrypt: useEncryption,
          forcedBaseUrl: forcedBaseUrl,
        );
      }
      rethrow;
    }
  }

  /// GET with authentication and encryption
  static Future<Response<Map<String, dynamic>?>?> getAuth({
    required String path,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);

    try {
      // Get user credentials
      final String mobNumber = await UserProvider.getMobileNumber();
      final String email = await UserProvider.getEmail();

      String? userID;
      if (mobNumber.isEmpty && email.isNotEmpty) {
        userID = AesEncryption.encrypt(email);
      } else {
        userID = mobNumber.isNotEmpty ? AesEncryption.encrypt(mobNumber) : '';
      }

      String? auth =
          (UserProvider.authToken ?? '').isNotEmpty
              ? AesEncryption.encrypt(UserProvider.authToken!)
              : null;

      final Response<String> response = await _dio.get<String>(
        url,
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'encrypt': useEncryption,
            'Content-Type':
                useEncryption
                    ? 'text/plain'
                    : 'application/json; charset=UTF-8',
            'Accept': '*/*',
            'userId': userID,
            'authorization': auth,
          },
          responseType: ResponseType.plain,
        ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: true,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      if (_shouldRefreshAuthToken(dioError)) {
        await _handleTokenRefresh();
        return await getAuth(
          path: path,
          params: params,
          encrypt: useEncryption,
          forcedBaseUrl: forcedBaseUrl,
        );
      }
      rethrow;
    }
  }

  /// DELETE with authentication and encryption
  static Future<Response<Map<String, dynamic>?>?> delete({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);

    try {
      // Get user credentials
      final String mobNumber = await UserProvider.getMobileNumber();
      final String email = await UserProvider.getEmail();

      String? userID;
      if (mobNumber.isEmpty && email.isNotEmpty) {
        userID = AesEncryption.encrypt(email);
      } else {
        userID = mobNumber.isNotEmpty ? AesEncryption.encrypt(mobNumber) : '';
      }

      String? auth =
          (UserProvider.authToken ?? '').isNotEmpty
              ? AesEncryption.encrypt(UserProvider.authToken!)
              : null;

      // Prepare data
      Map<String, dynamic>? modifiedData =
          data != null ? _replaceAedWithAud(data) : null;

      String? encryptedData;
      if (modifiedData != null && useEncryption) {
        final String jsonString = jsonEncode(modifiedData);
        encryptedData = AesEncryption.encrypt(jsonString);
      }

      final Response<String> response = await _dio.post<String>(
        url,
        data: useEncryption ? encryptedData : modifiedData,
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'encrypt': useEncryption,
            'Content-Type':
                useEncryption
                    ? 'text/plain'
                    : 'application/json; charset=UTF-8',
            'Accept': '*/*',
            'userId': userID,
            'authorization': auth,
          },
          responseType: ResponseType.plain,
        ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: false,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      if (_shouldRefreshAuthToken(dioError)) {
        await _handleTokenRefresh();
        return await delete(
          path: path,
          data: data,
          params: params,
          encrypt: useEncryption,
          forcedBaseUrl: forcedBaseUrl,
        );
      }
      rethrow;
    }
  }

  /// Common response processing method
  static Future<Response<Map<String, dynamic>?>?> _processResponse({
    required Response<String> response,
    required String path,
    Map<String, dynamic>? params,
    required bool encrypt,
    String? forcedBaseUrl,
    required bool isGetRequest,
  }) async {
    final isResponseEncrypted =
        response.headers.value('encrypted')?.toLowerCase() == 'true';
    print('Server indicates encrypted: $isResponseEncrypted');

    if (isResponseEncrypted && response.data != null) {
      try {
        String dataToParse = AesEncryption.decrypt(response.data!);
        final Map<String, dynamic> parsedData = jsonDecode(dataToParse);

        if (response.statusCode == 401) {
          await _handleTokenRefresh();
          // Retry logic would go here
        }

        return Response<Map<String, dynamic>>(
          data: parsedData,
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );
      } catch (e) {
        print('Error processing encrypted response: $e');
        rethrow;
      }
    } else {
      // Non-encrypted response handling
      if (response.data is String && (response.data as String).isNotEmpty) {
        try {
          final Map<String, dynamic> parsedData = jsonDecode(response.data!);
          return Response<Map<String, dynamic>>(
            data: parsedData,
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            extra: response.extra,
          );
        } catch (e) {
          print('JSON parsing failed: $e');
          rethrow;
        }
      } else if (response.data is Map<String, dynamic>) {
        return Response<Map<String, dynamic>>(
          data: response.data as Map<String, dynamic>?,
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );
      } else {
        return Response<Map<String, dynamic>>(
          data: null,
          requestOptions: response.requestOptions,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
          extra: response.extra,
        );
      }
    }
  }

  /// Handle token refresh
  static Future<void> _handleTokenRefresh() async {
    try {
      final refreshResponse = await getTokenAuth(path: 'auth/refresh/token');
      if (refreshResponse != null && refreshResponse.statusCode == 200) {
        print('Token refreshed successfully');
      } else {
        throw Exception('Token refresh failed');
      }
    } catch (e) {
      print('Error refreshing token: $e');
      rethrow;
    }
  }

  /// Token refresh method
  static Future<Response<Map<String, dynamic>?>?> getTokenAuth({
    required String path,
  }) async {
    try {
      final String mobNumber = await UserProvider.getMobileNumber();
      final String email = await UserProvider.getEmail();

      final String? userID =
          (mobNumber.isEmpty && email.isEmpty)
              ? ''
              : AesEncryption.encrypt(
                (mobNumber.isEmpty && email.isNotEmpty) ? email : mobNumber,
              );

      final String url = _formatUrl(null, path);

      final response = await _dio.get<String>(
        url,
        options: Options(
          headers: {
            'Content-Type': 'text/plain',
            'Accept': '*/*',
            'userId': userID,
          },
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        try {
          final String decrypted = AesEncryption.decrypt(response.data!);
          final Map<String, dynamic> parsedData = jsonDecode(decrypted);
          final String? token = parsedData['accessToken'];

          if (token != null && token.isNotEmpty) {
            UserProvider.setAuthToken(token);
            print('Token refreshed and saved');
          }

          return Response<Map<String, dynamic>>(
            data: parsedData,
            requestOptions: response.requestOptions,
            statusCode: response.statusCode,
            statusMessage: response.statusMessage,
            headers: response.headers,
            isRedirect: response.isRedirect,
            redirects: response.redirects,
            extra: response.extra,
          );
        } catch (e) {
          print('Failed to decrypt token response: $e');
          return null;
        }
      }
      return null;
    } catch (e) {
      print('Token refresh error: $e');
      return null;
    }
  }

  /// AED to AUD conversion for request data
  static Map<String, dynamic> _replaceAedWithAud(Map<String, dynamic> data) {
    Map<String, dynamic> updated = {};

    data.forEach((key, value) {
      if (key == 'downPayment') {
        updated[key] = value.toString().trim().substring(3);
      } else if (value is String && value.contains('AUD')) {
        updated[key] = value.replaceAll('AUD', 'AED');
      } else if (value is Map) {
        updated[key] = _replaceAedWithAud(Map<String, dynamic>.from(value));
      } else if (value is List) {
        updated[key] = _processList(value);
      } else {
        updated[key] = value;
      }
    });

    return updated;
  }

  static List _processList(List list) {
    return list.map((item) {
      if (item is String && item.contains('AUD')) {
        return item.replaceAll('AUD', 'AED');
      } else if (item is Map) {
        return _replaceAedWithAud(Map<String, dynamic>.from(item));
      } else if (item is List) {
        return _processList(item);
      }
      return item;
    }).toList();
  }

  /// AUD to AED conversion for response data
  static dynamic _replaceAEDWithAUDForResponse(dynamic input) {
    if (input is Map) {
      return input.map((key, value) {
        final newValue = _replaceAEDWithAUDForResponse(value);
        return MapEntry(key, newValue);
      });
    } else if (input is List) {
      return input.map(_replaceAEDWithAUDForResponse).toList();
    } else if (input is String && input.contains('AUD')) {
      return input.replaceAll('AUD', 'AED');
    } else if (input is String && input.contains('FJD')) {
      return input.replaceAll('FJD', 'AED');
    }
    return input;
  }

  /// Convert dynamic keys to String for Map
  static Map<String, dynamic> _convertKeysToString(Map input) {
    final Map<String, dynamic> result = {};
    input.forEach((key, value) {
      String newKey = key.toString();
      dynamic newValue;

      if (value is Map) {
        newValue = _convertKeysToString(value);
      } else if (value is List) {
        newValue =
            value.map((item) {
              if (item is Map) {
                return _convertKeysToString(item);
              }
              return _replaceAEDWithAUDForResponse(item);
            }).toList();
      } else {
        newValue = _replaceAEDWithAUDForResponse(value);
      }

      result[newKey] = newValue;
    });
    return result;
  }

  /// POST with JSON content type
  static Future<Response<Map<String, dynamic>?>?> postwithjson({
    required String path,
    dynamic data,
    Map<String, dynamic>? params,
    String? forcedBaseUrl,
    bool? encrypt,
  }) async {
    final bool useEncryption = encrypt ?? _isEncryptRequired;
    final String url = _formatUrl(forcedBaseUrl, path);
    print('POST with JSON url: $url, encryption: $useEncryption');

    try {
      String? encryptedData;
      if (data != null && useEncryption) {
        final String jsonString = jsonEncode(data);
        encryptedData = AesEncryption.encrypt(jsonString);
      }

      final Response<String> response = await _dio.post<String>(
        url,
        data: useEncryption ? encryptedData : data,
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'encrypt': useEncryption,
            'Content-Type':
                useEncryption
                    ? 'text/plain'
                    : 'application/json; charset=UTF-8',
            'Accept': '*/*',
          },
          responseType: ResponseType.plain,
        ),
      );

      return await _processResponse(
        response: response,
        path: path,
        params: params,
        encrypt: useEncryption,
        forcedBaseUrl: forcedBaseUrl,
        isGetRequest: false,
      );
    } on DioException catch (dioError) {
      print('DioException: ${dioError.message}');
      rethrow;
    }
  }

  static bool _shouldRefreshAuthToken(DioException dioError) {
    if (dioError.response?.statusCode != 401) {
      return false;
    }

    if (getX.Get.isRegistered<SessionManager>() &&
        getX.Get.find<SessionManager>().hasActiveSession) {
      return false;
    }

    return true;
  }

  static Future<Response<dynamic>> download({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) {
    return _dio.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      options: options,
    );
  }

  static Future<Response<Map<String, dynamic>?>?> put({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final String url = _formatUrl(forcedBaseUrl, path);
    return await _dio.put<Map<String, dynamic>?>(
      url,
      data: data,
      queryParameters: params,
      options: Options(headers: <String, dynamic>{'encrypt': encrypt}),
    );
  }

  static Future<Response<Map<String, dynamic>?>?> patch({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    bool? encrypt,
    String? forcedBaseUrl,
  }) async {
    final String url = _formatUrl(forcedBaseUrl, path);
    return await _dio.patch<Map<String, dynamic>?>(
      url,
      data: data,
      queryParameters: params,
      options: Options(headers: <String, dynamic>{'encrypt': encrypt}),
    );
  }
}
