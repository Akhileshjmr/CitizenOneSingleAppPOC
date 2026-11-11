import 'package:citizenone_app/app/env/app_env.dart';
import 'package:citizenone_app/core/error/exception.dart';
import 'package:citizenone_app/core/network/dio_client.dart';
import 'package:citizenone_app/features/agent/insurance_partners/data/models/insurance_provider_response_model.dart';
import 'package:dio/dio.dart';

abstract class InsurancePartnerRemoteDataSource {
  Future<InsuranceProviderResponseModel> getProviders();
}

class InsurancePartnerRemoteDataSourceImpl
    implements InsurancePartnerRemoteDataSource {
  static const _providersPath = '/insurance-providers';

  final DioClient apiClient;
  final AppEnv env;

  InsurancePartnerRemoteDataSourceImpl({
    required this.apiClient,
    required this.env,
  });

  @override
  Future<InsuranceProviderResponseModel> getProviders() async {
    if (env.insuranceApiBaseUrl.isEmpty) {
      throw StateError('Insurance service is not configured.');
    }

    try {
      final response = await apiClient.dio.getUri<Map<String, dynamic>>(
        env.insuranceUri(_providersPath),
        /*options: Options(
          headers: {
            'Authorization':
                'Bearer eyJ4NXQiOiJZMkUxWXpsaU5UUm1PV0kyWkRNNVpqTTVObUV4WVdGaE4yRTNPREEwT0RFek9UTmpNV1JtWW1JMU5qZGpabUZqWm1JNU5qSmxObUU0T0dGa05qVTRPQSIsImtpZCI6IlkyRTFZemxpTlRSbU9XSTJaRE01WmpNNU5tRXhZV0ZoTjJFM09EQTBPREV6T1ROak1XUm1ZbUkxTmpkalptRmpabUk1TmpKbE5tRTRPR0ZrTmpVNE9BX1JTMjU2IiwidHlwIjoiYXQrand0IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJlM2EyMTQ3NS01MmUxLTQ3ZDEtYWFjZi1mZGRmY2E2NDM3OWEiLCJhdXQiOiJBUFBMSUNBVElPTiIsImlzcyI6Imh0dHBzOi8vMTAuMC4wLjk6OTQ0My9vYXV0aDIvdG9rZW4iLCJlbnRpdHlfaWQiOiJyNG5ZMUlOQTlNcWJEa1RSZUN5N3dwMGtzWEVhIiwiY2xpZW50X2lkIjoicjRuWTFJTkE5TXFiRGtUUmVDeTd3cDBrc1hFYSIsInVzaWQiOiJlOWQxMjg1OS03MWU4LTRmM2ItYjliMS01NWI0ODBhZTlkMzUiLCJhdWQiOiJyNG5ZMUlOQTlNcWJEa1RSZUN5N3dwMGtzWEVhIiwibmJmIjoxNzg3MTI2MTI0LCJhenAiOiJyNG5ZMUlOQTlNcWJEa1RSZUN5N3dwMGtzWEVhIiwic2NvcGUiOiJkZWZhdWx0IiwiZXhwIjoxNzk1NzY2MTI0LCJpYXQiOjE3ODcxMjYxMjQsImp0aSI6IjRjOWI3NjQ1LTQ4NWUtNGU5Ny1hNmRmLWUxMzY3MzE0NjA3NCJ9.Gw824O07lVpBzEgRBXgjzXBljIyalf9N02fZYEEzbs0FH5TCoRSGAO3gO1NZxnv-Jq6WqXzks-587PG5E8D5_iqt18nVEO7kAul4pdtgIK3rxYRHSfKdp6p_DDu1wjdUGOIYeFMYBlvWXTKzPTohlBb1EmH-pjwOpCrNBaWvMJGZEW80vaZLIshGh8ptkOoZUdOuzDJy5ke5lzG8ntcDcv1pdIOEZ4H3x_JxbQgPdrF7-FezW11lhnSocKVewEVLyxbUB0uaFnEMipu3GK9pd3sSfpPI3YwghsmABVEYykbXmRMbczT1PJOITeotJ2tQM8W1g-szv-1Z1INl6HP2lg',
          },
        ),*/
      );
      final data = response.data;
      if (data == null) {
        throw ServerException(
          dioException: DioException(
            requestOptions: RequestOptions(path: _providersPath),
            message: 'Empty response body',
          ),
          message: 'Unable to load insurance partners.',
        );
      }
      return InsuranceProviderResponseModel.fromJson(data);
    } on DioException catch (error) {
      throw ServerException(dioException: error, message: _messageFor(error));
    }
  }

  String _messageFor(DioException error) {
    final body = error.response?.data;
    if (body is Map && body['chMessage'] is Map) {
      final message = (body['chMessage'] as Map)['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => 'Request timed out. Please try again.',
      DioExceptionType.connectionError =>
        'Network error. Please check your connection.',
      _ => 'Unable to load insurance partners. Please try again.',
    };
  }
}
