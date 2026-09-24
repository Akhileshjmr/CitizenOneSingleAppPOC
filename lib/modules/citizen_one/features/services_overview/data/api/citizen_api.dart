import 'package:citizenone_app/core/core.dart';
import '../models/citizen_service_model.dart';

class CitizenApi {
  final ApiClient apiClient;

  CitizenApi(this.apiClient);

  Future<List<CitizenServiceModel>> fetchServices() async {
    const endpoint = '/api/v1/citizen/services';
    try {
      final response = await apiClient.get(endpoint);
      final list = response['services'] as List<dynamic>? ?? [];
      return list
          .map((e) => CitizenServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 400));
      return const [
        CitizenServiceModel(
          id: '1',
          title: 'Digital ID Renewal',
          category: 'Government Identification',
          description:
              'Renew national identity card and digital certificate online.',
        ),
        CitizenServiceModel(
          id: '2',
          title: 'Municipal Utility Payment',
          category: 'Utilities & Tax',
          description: 'Pay property tax, water bills, and municipal tariffs.',
        ),
        CitizenServiceModel(
          id: '3',
          title: 'Social Benefits Portal',
          category: 'Welfare',
          description:
              'Access welfare distributions, pension claims, and healthcare vouchers.',
        ),
      ];
    }
  }
}
