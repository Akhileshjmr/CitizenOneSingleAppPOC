import 'package:citizenone_app/core/network/session_interceptors.dart';
import 'package:dio/dio.dart';
import 'package:citizenone_app/app/env/app_env.dart';

/// Dio HTTP client factory. Configured per environment.
class DioClient {
  final AppEnv env;
  late final Dio dio;

  DioClient({
    required this.env,
    String? Function()? sessionToken,
    void Function()? onPossibleSessionExpiry,
    void Function()? onSuccessfulActivity,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: env.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      buildSessionInterceptor(
        getToken: sessionToken,
        onPossibleExpiry: onPossibleSessionExpiry,
        onSuccessfulActivity: onSuccessfulActivity,
      ),
    );

    if (env.enableLogging) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }
}
