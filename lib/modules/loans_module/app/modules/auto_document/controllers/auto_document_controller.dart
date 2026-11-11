import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/args/cart_arguments.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../routes/app_pages.dart';

class AutoDocumentController extends GetxController {
  RxList<Documents>? arrDocuments = <Documents>[].obs;
  final RxBool isLoading = true.obs;
  bool isAttached = false;
  String mode = '';

  late LimitArguments args;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      getDocuments();
    }
  }

  Future<void> getDocuments() async {
    isLoading(true);
    Map<String, dynamic> data = {
      'addiParams': ["PAYMENT_BANK_DOCS"],
      "filterVal": LocalStore.buyNowFilterVal,
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
    };

    if (args.LimitMode == 'CG') {
      arrDocuments!(await AutoService.getCGUserDocuments(data));
    } else if (args.LimitMode == 'REAL_ESTATE') {
      arrDocuments!(await AutoService.getRealEstateUserDocuments(data));
    } else {
      arrDocuments!(await AutoService.getUserDocuments(data));
    }

    isLoading(false);
  }

  Future<void> onDocSubmit(dynamic data) async {
    isLoading(true);
    final Map<String, dynamic> formData = data;

    try {
      LimitFnaSubResp? res;
      if (args.LimitMode == 'CG') {
        res = await AutoService.saveCGFinanceEMI(formData: formData);
      } else if (args.LimitMode == 'REAL_ESTATE') {
        res = await AutoService.saveRealEstateFinanceEMI(formData: formData);
        LocalStore.buyNowFilterVal = res?.addiParams[2] ?? '';
      } else {
        res = await AutoService.saveFinanceEMI(formData: formData);
      }

      if (res?.chMessage?.type == 'SUCCESS') {
        if (args.LimitMode == 'CG') {
          /*Get.offNamed<void>(
            Routes.CG_PAYMENT_S,
            arguments: CgStatusArguments(
              orderId: res?.addiParams[1] ?? '',
              catType: args.LimitMode,
              isFinance: false,
            ),
          );*/
        } else {
          Get.offNamed<void>(
            Routes.CG_PAYMENT_SUCCESS,
            arguments: CgStatusArguments(
              orderId: res?.addiParams[1] ?? '',
              catType: args.LimitMode,
              isFinance: false,
            ),
          );
        }
      } else {
        appSnackbar(
          message: res?.chMessage?.message.toString() ?? '',
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
      'addiParams': ['PAYMENT_BANK_DOCS', dockey, 'LINK'],
      "filterVal": LocalStore.buyNowFilterVal,
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
      "filterHashKey": 0,
      "hKey": 0,
    };
    try {
      bool res;
      if (args.LimitMode == 'CG') {
        res = await AutoService.LinkCGDocument(formData: formData);
      } else if (args.LimitMode == 'REAL_ESTATE') {
        res = await AutoService.LinkRealEstateDocument(formData: formData);
      } else {
        res = await AutoService.LinkDocument(formData: formData);
      }
      if (res == true) {
        getDocuments();
      }
    } finally {
      isLoading(false);
    }
  }
}
