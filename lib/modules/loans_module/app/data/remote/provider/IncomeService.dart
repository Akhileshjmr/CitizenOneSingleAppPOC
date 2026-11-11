import 'package:dio/dio.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PersonalLoan/FormData/LoanDetails.dart';

import '../../../utils/ag_constants.dart';
import '../api_service/init_api_service.dart';

class IncomeService {
  /// To get list of my sessions
  static Future<LoanDetails?> getPersonalDetails(String url) async {
    final String mobNumber = await UserProvider.getMobileNumber();

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
        "filterVal": mobNumber,
        "addiParams": ["INCOME_DETAILS", AgConstants.moduleName, mobNumber],
      },
    );

    if (res?.statusCode == 200) {
      LoanDetails loanDetails = LoanDetails.fromJson(
        res?.data!['loanDetails'] ?? <String, dynamic>{},
      );
      if (res?.data!['loanDetails'] != null) {
        return LoanDetails.fromJson(
          res?.data!['loanDetails'] ?? <String, dynamic>{},
        );
      }
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return LoanDetails();
  }
}
