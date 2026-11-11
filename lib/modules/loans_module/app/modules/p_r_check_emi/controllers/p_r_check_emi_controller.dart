import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/config/logger.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/loan/bank_list/BankListResp.dart';
import '../../../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../../../data/model/loan/bank_list/GdbShopEmiRespList.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';
import '../../../routes/app_pages.dart';

class PRCheckEmiController extends GetxController {
  RxList<GdbShopEmiRespList?> arrList = <GdbShopEmiRespList?>[].obs;
  Rx<GdbShopEmiRespList> selectedBank = GdbShopEmiRespList().obs;
  RxBool isLoading = true.obs;
  Rx<EmiInfoDetails> selectedEMIPlan = EmiInfoDetails().obs;
  late PRArguments args;

  String bankname = '';
  String bank_id = '';
  String product_id = '';

  var emiMap = <String, dynamic>{};

  @override
  void onInit() {
    if (Get.arguments is PRArguments) {
      args = Get.arguments;
      onBankEMi();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onBankEMi() async {
    // formKey.currentState!.save();
    String myString = args.montlyInc;
    final withoutEquals = myString.replaceAll(",", "");
    print(withoutEquals);
    isLoading(true);
    Map<String, dynamic> formData = <String, dynamic>{};
    try {
      formData = <String, dynamic>{
        "filterVal": withoutEquals,
        "paging": {"pageNum": 1},
        "addiParams": ["LOAN_PRODUCTS", args.filterval, args.bankName],
        "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      };

      BankListResp res = await PreApproveLoanService.PrCheckEmiList(
        'pl/pre-approved-loan/get-emi-details',
        formData: formData,
      );
      arrList(res.gdbShopEmiRespList);
    } on Exception catch (e) {
      logE(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> onSubmitBankEMi(Map<String, dynamic> formData) async {
    // formKey.currentState!.save();
    String myString = args.montlyInc;
    final withoutEquals = myString.replaceAll(",", "");
    print(withoutEquals);
    isLoading(true);
    // Map<String, dynamic> formData = <String, dynamic>{};
    try {
      formData = formData;

      LimitFnaSubResp res = await PreApproveLoanService.PrSubmitEmi(
        'pl/pre-approved-loan/bank-loan-submit',
        formData: formData,
      );
      if (res.chMessage?.isError == false) {
        LocalStore.buyNowFilterVal = res.addiParams[0] ?? '';
        await Get.toNamed<void>(
          Routes.P_R_DOCUMENT_LIST,
          arguments: PRArguments(
            filterval: args.filterval,
            montlyExc: product_id,
            montlyInc: args.montlyInc,
            bankid: args.bankid,
            bankName: bankname,
            LimtMode: '',
          ),
        );
      } else {
        appSnackbar(
          message: res.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } on Exception catch (e) {
      logE(e);
    } finally {
      isLoading(false);
    }
  }
}
