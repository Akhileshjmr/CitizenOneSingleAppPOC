import 'package:citizenone_app/modules/agency_banking/data/api/end_points/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';

class UrlStorage {
  static Future<void> setBaseUrl(String url) async {
    await SecureStorageHelper.setBaseUrl(url);
  }

  static Future<String> getBaseUrl() async {
    return await SecureStorageHelper.getBaseUrl() ?? ApiEndpoints.baseUrl;
  }
}
