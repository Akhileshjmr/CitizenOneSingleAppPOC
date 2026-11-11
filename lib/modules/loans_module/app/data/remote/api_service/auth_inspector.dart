import 'dart:async';

import 'package:dio/dio.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  // -----------------------------------
  // ADD TOKEN TO REQUEST
  // -----------------------------------
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    handler.next(options);
  }

  // -----------------------------------
  // HANDLE 401 / 403
  // -----------------------------------
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError) {
      appSnackbar(
        message: 'Please check your internet connection and try again.',
        snackbarState: SnackbarState.warning,
      );

      return handler.reject(err);
    }

    if (_shouldRefresh(err)) {
      try {
        // await _handleRefresh();

        // Retry original request
        final response = await _retry(err.requestOptions);

        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  // -----------------------------------
  // CHECK IF TOKEN EXPIRED
  // -----------------------------------
  bool _shouldRefresh(DioException err) {
    return err.response?.statusCode == 401 || err.response?.statusCode == 403;
  }

  // -----------------------------------
  // REFRESH HANDLER (QUEUE)
  // -----------------------------------
  /*Future<void> _handleRefresh() async {
    if (_isRefreshing) {
      // Wait for existing refresh
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      debugPrint("🔄 Refreshing token...");

      final result = await AuthProvider.refreshSessionToken();

      if (result?.token == null) {
        throw Exception("Refresh failed");
      }

      await UserPrefs.updateToken(result!.token!);

      debugPrint("✅ Token refreshed");

      _refreshCompleter?.complete();
    } catch (e) {
      debugPrint("❌ Refresh failed: $e");

      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }*/

  // -----------------------------------
  // RETRY FAILED REQUEST
  // -----------------------------------
  Future<Response> _retry(RequestOptions request) {
    final options = Options(
      method: request.method,
      headers: request.headers,
      extra: request.extra,
      responseType: request.responseType,
      contentType: request.contentType,
      followRedirects: request.followRedirects,
      validateStatus: request.validateStatus,
    );

    return dio.request(
      request.path,
      data: request.data,
      queryParameters: request.queryParameters,
      options: options,
    );
  }
}
