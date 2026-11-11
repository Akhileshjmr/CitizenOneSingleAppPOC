import 'package:citizenone_app/modules/agrinet/app/data/config/api_res_ext.dart';
import 'package:dio/dio.dart';
import '../../models/HomeResp/HomeImageResp.dart';
import '../remote/api_service/ApiEndPoints.dart';
import '../remote/api_service/init_api_service.dart';

class HomeService {
  static Future<homeViewResp?> fetchDashboardProduct(
      {required String filterVal}) async {
    try {
      final Response<Map<String, dynamic>?>? response = await APIService.post(
          path: ApiEndPoints.homeImage,
          data: <String, dynamic>{'filterVal': filterVal});
      if (response != null && response.isOk) {
        return homeViewResp.fromJson(response.data!);
      }
    } on Exception catch (e) {
      // logE(e);
    }
    return null;
  }
}