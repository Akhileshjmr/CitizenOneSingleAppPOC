import 'package:dio/dio.dart';

import '../../../../utils/ag_constants.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/employee/employee_details.dart';
import '../../api_service/init_api_service.dart';

class ProfessionalListService {
  /// Fetch employee profession details
  static Future<EmployeeDetails?> getProfessionDetails(String path) async {
    try {
      final String mobNumber = await UserProvider.getMobileNumber();

      final Response<Map<String, dynamic>?>? response =
          await APIService.postAuth(
            path: path,
            data: {
              "reqSecureKey":
                  ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                      ? (UserProvider.currentUser?.addiParams[0] ?? '')
                      : '',
              "filterVal": mobNumber,
              "addiParams": ["EMP_DATA", mobNumber],
            },
          );

      if (response?.statusCode != 200 || response?.data == null) {
        return null;
      }

      final empDetails = response!.data!['empDetails'] as Map<String, dynamic>?;

      if (empDetails == null) {
        return null;
      }

      return EmployeeDetails.fromJson(empDetails);
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
