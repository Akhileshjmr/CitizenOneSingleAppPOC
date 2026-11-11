import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/CreditCard/FinalCCFormSumbitResp.dart';
import '../../../data/remote/provider/CreditCardService.dart';

class CreditFinalSubmitController extends GetxController {
  Rx<FinalCcFormSumbitResp> resp = FinalCcFormSumbitResp().obs;

  /// Api loading
  final RxBool isLoading = false.obs;

  Future<void> checkBank() async {
    isLoading(true);

    try {
      resp(await CreditCardService.finalLoanSumbit());

      if (resp.value.chMessage?.message == 'Request processed successfully.') {
      } else {
        appSnackbar(
          message: resp.value.chMessage?.message.toString() ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }
}
