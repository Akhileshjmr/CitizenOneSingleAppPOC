import 'package:dio/dio.dart'; 
import 'package:citizenone_app/modules/insurance/core/network/dio_client.dart';
import 'package:citizenone_app/modules/insurance/features/insurance/data/models/insurance_category_model.dart';

abstract class InsuranceRemoteDataSource {
  Future<List<InsuranceCategoryModel>> fetchInsuranceCategories({
    required String vendorCode,
  });
}

class InsuranceRemoteDataSourceImpl implements InsuranceRemoteDataSource {
  final DioClient apiClient;

  InsuranceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<InsuranceCategoryModel>> fetchInsuranceCategories({
    required String vendorCode,
  }) async {
    try {
      final response = {
        'reqSecureKey': null,
        'addiParams': null,
        'chMessage': {
          'code': 'SUCCESS',
          'message': 'Request processed successfully.',
          'type': 'SUCCESS',
          'dispType': 'ALERT',
          'isError': false,
          'subject': 'Alert',
          'dataArr': null
        },
        'urlDecision': null,
        'categories': [
          {
            'code': '528527',
            'name': 'General Insurance',
            'subCategories': [
              {'code': 'CAT2505260403', 'name': 'Home Insurance'}
            ]
          },
          {
            'code': '530385',
            'name': 'Motor Insurance',
            'subCategories': [
              {
                'code': 'CAT0806260404',
                'name': 'Third-Party Liability Insurance'
              }
            ]
          }
        ],
        'policies': null,
        'policy': null,
        'paging': null
      };
      // await apiClient.dio.get(
      //   ApiConstants.getInsuranceCategories,
      //   queryParameters: {'vendorCode': vendorCode.trim()},
      // );

      // if (response.statusCode == 200) {
      //   if (response.data != null) {
      final categoriesResponse = InsuranceCategoriesResponse.fromJson(
        response as Map<String, dynamic>,
      );
      return categoriesResponse.categories;
      // }
      //   return [];
      // }

      // throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }
}
