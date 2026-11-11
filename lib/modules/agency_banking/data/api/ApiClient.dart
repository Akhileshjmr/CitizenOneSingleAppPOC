import 'dart:convert';

import 'package:dio/dio.dart';

import '../../constants/ABErrorCodes.dart';
import '../../core/Security/CertificatePinningService.dart';
import '../../core/Security/ReplayProtectionService.dart';
import '../../core/Security/secure_storage.dart';
import '../../utils/AppLogger.dart';
import '../models/common_models/HeaderInfo.dart';
import '../models/common_models/HeaderStore.dart';
import 'end_points/ApiEndPoints.dart';

class ApiClient {
  static final ApiClient _singleton = ApiClient._internal();

  late Dio _dio;

  // ─────────────────────────────────────────────
  // NOTE: Static token variable is REMOVED to pass
  // static code security analysis (SAST). Tokens are
  // dynamically read from FlutterSecureStorage at runtime.
  // ─────────────────────────────────────────────

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 3),
      ),
    );

    // ─────────────────────────────────────────────
    // SSL Certificate Pinning
    // ─────────────────────────────────────────────
    CertificatePinningService.apply(_dio);

    _dio.interceptors.add(
      InterceptorsWrapper(
        // ═══════════════════════════════════════════
        // REQUEST INTERCEPTOR
        // ═══════════════════════════════════════════
        onRequest: (options, handler) async {
          AppLogger.network("========================================");
          AppLogger.network("REQUEST");
          AppLogger.network("URL    : ${options.uri}");
          AppLogger.network("METHOD : ${options.method}");

          // ─────────────────────────────────────────
          // Authorization Header (Dynamic Fetch)
          // ─────────────────────────────────────────
          final storedToken = await SecureStorage().getAccessToken();

          if (storedToken.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $storedToken";
          } else {
            AppLogger.warning(
              "No access token found in SecureStorage for Authorization header",
            );
          }

          // ── Replay Protection: Nonce + HMAC Signature ──
          final nonce = ReplayProtectionService.generateNonce();
          final sessionId =
              (HeaderStore.headerInfo?.userSessionId ?? '').replaceAll('"', '');
          final signature =
              ReplayProtectionService.computeSignature(nonce, sessionId);
          options.headers['X-Nonce'] = nonce;
          options.headers['X-Signature'] = signature;
          options.headers['X-Session-Id'] = sessionId;

          // ── CitizenOne Session Token (x-session-token) ──
          // Forwarded by the host CitizenOne app via
          // AgencyBankingModuleEntry.initialize(). When null
          // (standalone mode), no header is sent — preserving
          // the existing standalone login flow.
          final citizenToken = HeaderStore.citizenSessionToken;
          if (citizenToken != null && citizenToken.isNotEmpty) {
            options.headers['x-session-token'] = citizenToken;
          }

          // ─────────────────────────────────────────
          // PRINT REQUEST HEADERS
          // Authorization token is masked
          // ─────────────────────────────────────────
          final headersToLog = Map<String, dynamic>.from(options.headers);

          if (headersToLog.containsKey("Authorization")) {
            headersToLog["Authorization"] = "Bearer ****MASKED****";
          }

          AppLogger.network("========== REQUEST HEADERS ==========");
          AppLogger.network(
            const JsonEncoder.withIndent('  ').convert(headersToLog),
          );
          AppLogger.network("=====================================");

          // ─────────────────────────────────────────
          // Authentication APIs
          // ─────────────────────────────────────────
          if (options.path.contains(ApiEndpoints.login) ||
              options.path.contains(ApiEndpoints.citizenUserLogin) ||
              options.path.contains(ApiEndpoints.otpValidation) ||
              options.path.contains(ApiEndpoints.requestOtp) ||
              options.path.contains(ApiEndpoints.resetPassword) ||
              options.path.contains(ApiEndpoints.transMethod)) {
            AppLogger.info(
              "Skipping headerInfo injection",
            );

            AppLogger.network("Request Body:");

            if (options.data != null) {
              AppLogger.network(
                const JsonEncoder.withIndent('  ').convert(options.data),
              );
            }

            return handler.next(options);
          }

          // ─────────────────────────────────────────
          // Second Login API
          // ─────────────────────────────────────────
          if (options.path.contains(ApiEndpoints.secondLogin)) {
            AppLogger.info(
              "Skipping headerInfo injection for second login API",
            );

            if (HeaderStore.headerInfo?.authorizationToken != null) {
              AppLogger.debug(
                "Authorization Token received from HeaderStore",
              );

              options.headers["Authorization"] =
                  HeaderStore.headerInfo!.authorizationToken!;

              if (options.data is Map && options.data["headerInfo"] != null) {
                options.data["headerInfo"]["authorizationToken"] =
                    HeaderStore.headerInfo!.authorizationToken!;
              }

              AppLogger.info(
                "Injected authorization token only",
              );
            }

            // Print headers again because Authorization
            // may have changed for second login.
            final headersToLog = Map<String, dynamic>.from(options.headers);

            if (headersToLog.containsKey("Authorization")) {
              headersToLog["Authorization"] = "Bearer ****MASKED****";
            }

            AppLogger.network(
              "========== SECOND LOGIN HEADERS ==========",
            );

            AppLogger.network(
              const JsonEncoder.withIndent('  ').convert(headersToLog),
            );

            AppLogger.network(
              "==========================================",
            );

            AppLogger.network("Request Body:");

            if (options.data != null) {
              AppLogger.network(
                const JsonEncoder.withIndent('  ').convert(options.data),
              );
            }

            return handler.next(options);
          }

          // ─────────────────────────────────────────
          // Inject HeaderInfo for Other APIs
          // ─────────────────────────────────────────
          if (options.data is Map<String, dynamic>) {
            final Map<String, dynamic> body = options.data;

            if (body.containsKey("headerInfo")) {
              if (HeaderStore.headerInfo != null) {
                final headerJson = HeaderStore.headerInfo!.toJson();

                // ─────────────────────────────────────
                // Dynamic Logout Flag
                // ─────────────────────────────────────
                if (options.path.contains(ApiEndpoints.logout)) {
                  headerJson["logout"] = "Y";
                  AppLogger.debug(
                    "Logout API -> logout = Y",
                  );
                } else {
                  headerJson["logout"] = "N";

                  AppLogger.debug(
                    "Normal API -> logout = N",
                  );
                }

                body["headerInfo"] = headerJson;

                AppLogger.debug(
                  "HeaderInfo injected successfully",
                );
              }
            } else {
              AppLogger.info(
                "Request model does not contain headerInfo. "
                "Injection skipped.",
              );
            }

            AppLogger.network("Request Body:");

            AppLogger.network(
              const JsonEncoder.withIndent('  ').convert(body),
            );
          }

          // ─────────────────────────────────────────
          // Final Request Headers
          // Print after ALL header modifications
          // ─────────────────────────────────────────
          final finalHeadersToLog = Map<String, dynamic>.from(options.headers);

          if (finalHeadersToLog.containsKey("Authorization")) {
            finalHeadersToLog["Authorization"] = "Bearer ****MASKED****";
          }

          AppLogger.network(
            "========== FINAL REQUEST HEADERS ==========",
          );

          AppLogger.network(
            const JsonEncoder.withIndent('  ').convert(finalHeadersToLog),
          );

          AppLogger.network(
            "===========================================",
          );

          return handler.next(options);
        },

        // ═══════════════════════════════════════════
        // RESPONSE INTERCEPTOR
        // ═══════════════════════════════════════════
        onResponse: (response, handler) {
          final path = response.requestOptions.path;

          AppLogger.network(
            "Response received from: $path",
          );

          AppLogger.network(
            const JsonEncoder.withIndent('  ').convert(response.data),
          );

          // ─────────────────────────────────────────
          // Skip Authentication APIs
          // ─────────────────────────────────────────
          if (path.contains(ApiEndpoints.login) ||
              path.contains(ApiEndpoints.pinValidation) ||
              path.contains(ApiEndpoints.otpValidation) ||
              path.contains(ApiEndpoints.requestOtp) ||
              path.contains(ApiEndpoints.resetPassword)) {
            AppLogger.info(
              "Skipping HeaderInfo update for authentication APIs",
            );

            return handler.next(response);
          }

          // ─────────────────────────────────────────
          // Update HeaderInfo on Successful Response
          // ─────────────────────────────────────────
          if (response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;

            final errorCode = data["resMessage"]?["errorCode"];
            final isSuccess = errorCode == AbErrorCodes.success;

            final headerInfoJson = data["headerInfo"];

            if (isSuccess &&
                errorCode == AbErrorCodes.success &&
                headerInfoJson != null) {
              try {
                final header = HeaderInfo.fromJson(headerInfoJson);

                HeaderStore.update(header);

                AppLogger.debug(
                  "HeaderInfo updated successfully from response",
                );
              } catch (e, stackTrace) {
                AppLogger.error(
                  "Failed to parse HeaderInfo",
                  e,
                  stackTrace,
                );
              }
            } else if (!isSuccess) {
              AppLogger.warning(
                "HeaderInfo not updated. ErrorCode: $errorCode",
              );
            }

            // Tell the host (CitizenOne) this was valid, successful user
            // activity, independent of whether this particular response
            // happened to carry a `headerInfo` block — that field is
            // Agency Banking's own concern, not a signal of whether the
            // parent session is still in use.
            if (isSuccess) {
              HeaderStore.onAuthenticatedActivity?.call();
            }
          }

          return handler.next(response);
        },

        // ═══════════════════════════════════════════
        // ERROR INTERCEPTOR
        // ═══════════════════════════════════════════
        onError: (DioException e, handler) {
          AppLogger.error(
            "API request failed",
            e,
            e.stackTrace,
          );

          AppLogger.network("========== ERROR RESPONSE BODY ==========");

          if (e.response?.data != null) {
            try {
              AppLogger.network(
                const JsonEncoder.withIndent('  ').convert(e.response!.data),
              );
            } catch (_) {
              AppLogger.network(e.response!.data.toString());
            }
          } else {
            AppLogger.network("No response body received.");
          }

          AppLogger.network("Status Code : ${e.response?.statusCode}");
          AppLogger.network("==========================================");

          return handler.next(e);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Dio Client
  // ═══════════════════════════════════════════════

  Dio get client => _dio;

  // ═══════════════════════════════════════════════
  // Update Base URL
  // ═══════════════════════════════════════════════

  void updateBaseUrl(String newUrl) {
    _dio.options.baseUrl = newUrl;
    ApiEndpoints.baseUrl = newUrl;
    AppLogger.info(
      "Base URL updated to: $newUrl",
    );
  }
}
