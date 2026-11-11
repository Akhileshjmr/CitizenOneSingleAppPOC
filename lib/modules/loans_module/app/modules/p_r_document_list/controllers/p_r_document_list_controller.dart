import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';
import '../../../routes/app_pages.dart';

class PRDocumentListController extends GetxController {
  RxList<Documents>? arrDocuments = <Documents>[].obs;
  final RxBool isLoading = true.obs;
  bool isAttached = false;
  late PRArguments args;
  String bankid = '';
  String mode = '';

  @override
  Future<void> onInit() async {
    if (Get.arguments is PRArguments) {
      args = Get.arguments;
      bankid = args.bankid;
    }
    await getDocuments();
    super.onInit();
  }

  Future<void> getDocuments() async {
    isLoading(true);
    Map<String, dynamic> data = {
      'addiParams': [
        ((args.filterval == '/vehicleloan') ? 'CAR_LOAN' : 'HOUSE_LOAN'),
      ],
      "filterVal": LocalStore.buyNowFilterVal,
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
    };
    arrDocuments!(await PreApproveLoanService.getPRUserDocuments(data));
    isLoading(false);
  }

  Future<void> onDocSubmit(dynamic data) async {
    print(args.bankid.toString());
    print(bankid.toString());
    isLoading(true);
    final Map<String, dynamic> formData = data;

    print(formData.toString());

    try {
      LimitFnaSubResp? res;
      res = await PreApproveLoanService.savePRFinanceEMI(formData: formData);

      if (res?.chMessage?.type == 'SUCCESS') {
        Get.toNamed<void>(
          Routes.P_R_UPLOAN_HISTORY,
          arguments: [args.filterval.toString(), args.bankid.toString()],
        );
      } else {
        appSnackbar(
          message: res?.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> DocumentsLink(String dockey) async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'addiParams': [
        ((args.filterval == '/vehicleloan') ? 'CAR_LOAN' : 'HOUSE_LOAN'),
        dockey,
        'LINK',
      ],
      "filterVal": LocalStore.buyNowFilterVal,
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
      "filterHashKey": 0,
      "hKey": 0,
    };
    try {
      bool res;
      res = await PreApproveLoanService.LinkPRDocument(formData: formData);
      if (res == true) {
        getDocuments();
      }
    } finally {
      isLoading(false);
    }
  }
}
