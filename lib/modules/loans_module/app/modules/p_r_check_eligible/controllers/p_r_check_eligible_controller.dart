import 'package:get/get.dart';

import '../../../data/local/store/user_provider.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/loan/PreApprove/PreApproveCheckEligible/PRCheckEligiblaResp.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class PRCheckEligibleController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs; // 👈 Add this

  Rx<PrCheckEligiblaResp> EligibleListData = PrCheckEligiblaResp().obs;

  late PRArguments args;

  @override
  void onInit() {
    if (Get.arguments is PRArguments) {
      args = Get.arguments;
      onGet();
    }
    super.onInit();
  }

  Future<void> onGet() async {
    isLoading(true);
    errorMessage('');

    try {
      Map<String, dynamic> formData = {
        "filterVal": args.filterval,
        "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
        "bankId": args.bankid,
        "customerDet": {
          "empDetails": {
            "monthlyExpenseInc": args.montlyExc,
            "monthlyIncomeEnc": args.montlyInc,
          },
        },
        "isDraft": false,
        "screenId": "CHECK_ELIGIBILITY",
      };

      PrCheckEligiblaResp res = await PreApproveLoanService.PrCheckElig(
        'pl/pre-approved-loan/online-application-for-loan',
        formData: formData,
      );

      if (res.chMessage?.isError ?? false) {
        errorMessage(res.chMessage?.message ?? "Something went wrong!");
        return;
      }

      EligibleListData(res);
    } catch (e) {
      errorMessage("Something went wrong!");
    } finally {
      isLoading(false);
    }
  }
}
