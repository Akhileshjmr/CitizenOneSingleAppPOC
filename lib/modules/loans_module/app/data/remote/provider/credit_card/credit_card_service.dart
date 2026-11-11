import 'package:dio/dio.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/limit/limit_fna_sub_resp.dart';
import '../../api_service/init_api_service.dart';

class CreditCardService {
  static Future<LimitFnaSubResp?> getApplyCC(
    String cardname,
    String bkName,
    String bkID,
    String bkurl,
    String rmark,
    String action,
  ) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'creditcard/update-credit-card-req-progress',
      data: <String, dynamic>{
        "custId":
            ((UserProvider.currentUser?.addiParams?.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams?[0] ?? '')
                : '',
        "action": action,
        "remarks": rmark,
        "cardName": cardname,
        "bankName": bkName,
        "bankId": bkID,
        "bankImgUrl": bkurl,
      },
    );
    if (res?.statusCode == 200) {
      return LimitFnaSubResp.fromJson(res?.data ?? <String, dynamic>{});
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return LimitFnaSubResp();
  }
}
