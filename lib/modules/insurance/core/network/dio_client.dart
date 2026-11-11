import 'package:dio/dio.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/session/session_token_provider.dart';

/// Dio HTTP client factory. Configured per environment.
///
/// Session is owned by the host app (CitizenOne), not this module.
/// [sessionTokenProvider] is the only seam: it supplies the live
/// `X-Session-Token` and is told about responses that look like the
/// session has expired, so the host can react (its own "session
/// expired" UI) — this module never creates or manages a session
/// itself. Nullable so the module stays runnable/testable standalone.
class DioClient {
  late final Dio dio;
  final SecureStorageService secureStorageService;
  final SessionTokenProvider? sessionTokenProvider;

  DioClient({required this.secureStorageService, this.sessionTokenProvider}) {
    dio = Dio(
      BaseOptions(
        validateStatus: (status) {
          return status != null && status < 503;
        },
        baseUrl: '',
        connectTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final vendorKey = await secureStorageService.getVendorKey();
          options.headers['X-Vendor-Code'] =
              (vendorKey != null && vendorKey.isNotEmpty)
                  ? vendorKey
                  : 'INNOVATE';

          final token = sessionTokenProvider?.currentToken;
          if (token != null && token.isNotEmpty) {
            options.headers['X-Session-Token'] = token;
          }
          options.headers['Authorization'] =
              'Bearer ${AppConfig.staticInsuranceAccessToken}';

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (_looksLikeExpiredSession(response.statusCode)) {
            sessionTokenProvider?.reportPossibleExpiry();
          } else if (_looksLikeSuccess(response)) {
            sessionTokenProvider?.reportActivity();
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (_looksLikeExpiredSession(error.response?.statusCode)) {
            sessionTokenProvider?.reportPossibleExpiry();
          }
          handler.next(error);
        },
      ),
    );
  }

  // Deliberately just a status-code check — this module can't see the
  // host's richer business-error contract (e.g. CitizenOne's
  // `chMessage` codes), and shouldn't guess at it. Tighten here if
  // this module's own backend defines a more specific signal.
  bool _looksLikeExpiredSession(int? statusCode) =>
      statusCode == 401 || statusCode == 403;

  // A response only reaches `onResponse` (never `onError`) once it has
  // actually come back from the server, so this never fires for
  // network failures/timeouts. This module's backend uses the same
  // `chMessage.isError` envelope as CitizenOne's (see
  // `insurance_remote_data_source.dart`), so that is the success
  // signal when present; a bare 2xx with no envelope (e.g. a
  // vendor/gateway endpoint) is treated as success too.
  bool _looksLikeSuccess(Response<dynamic> response) {
    final status = response.statusCode;
    if (status == null || status < 200 || status >= 300) return false;

    final data = response.data;
    if (data is Map && data['chMessage'] is Map) {
      final isError = (data['chMessage'] as Map)['isError'] as bool? ?? false;
      return !isError;
    }
    return true;
  }
}
