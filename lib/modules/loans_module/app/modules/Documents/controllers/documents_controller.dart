import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/CustomerLimitDataResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_fna_sub_resp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/profile_service.dart';

import '../../../data/local/store/local_store.dart';
import '../../../routes/app_pages.dart';

class DocumentsController extends GetxController {
  final count = 0.obs;
  final RxBool isLoading = true.obs;
  String limitUploadKey = '';

  RxList<Documents>? arrDocuments = <Documents>[].obs;

  String? userName;
  late LimitArguments args;
  String mode = '';
  String custId = '';
  bool isAttached = false;
  bool _autoLinkDone = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode != null) {
        mode = args.LimitMode;
      } else {
        mode = '';
      }
    } else {
      mode = '';
    }
    print(limitUploadKey);
    if (mode == 'Auto') {
      getDocuments('auto/orders/profile-doc-list');
    } else if (mode == 'CG') {
      getDocuments('orders/cg/process-view-documents');
    } else if (mode == 'REAL_ESTATE') {
      getDocuments('realestate/home/orders/profile-doc-list');
    } else if (mode == 'LimitMode' || limitUploadKey == 'LimitMode') {
      getuserData('customer/profile/cust-limit-details');
      getDocumentsLimit('customer/profile/process-view-documents');
    } else {
      getDocuments('customer/profile/profile-doc-list');
    }
  }

  Future<void> getDocuments(String geturl) async {
    isLoading(true);
    Map<String, String> data = {
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
    };
    arrDocuments!(await ProfileService.getUserDocuments(geturl, data));
    isLoading(false);
  }

  /*Future<void> getDocumentsLimit(String geturl) async {
    isLoading(true);
    arrDocuments!(await ProfileService.getLimitDocuments(geturl));
    isLoading(false);
  }*/

  Future<void> getDocumentsLimit(String geturl) async {
    isLoading(true);
    arrDocuments!(await ProfileService.getLimitDocuments(geturl));
    isLoading(false);

    // 🔗 Auto-link once documents are visible
    await autoLinkDocumentsIfNeeded();
  }

  Future<void> getuserDocuments(String geturl) async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      "addiParams": ["PAYMENT_BANK_DOCS"],
      "filterHashKey": '0',
      "filterVal": LocalStore.buyNowFilterVal,
      "hKey": '0',
    };
    isLoading(false);
    arrDocuments!(
      await ProfileService.getCGUserDocuments(geturl, formData: formData),
    );
  }

  Future<void> autoLinkDocumentsIfNeeded() async {
    if (mode != 'LimitMode') return;
    if (_autoLinkDone) return;
    if (arrDocuments == null || arrDocuments!.isEmpty) return;
    if (custId.isEmpty) return;

    _autoLinkDone = true;

    for (final doc in arrDocuments!) {
      if ((doc.key ?? '').isNotEmpty &&
          (doc.originalDocName ?? '').isNotEmpty) {
        await DocumentsLink(doc.key!);
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> onDocSubmit(dynamic data, BuildContext context) async {
    isLoading(true);
    final Map<String, dynamic> formData = data;

    print(formData.toString());

    try {
      LimitFnaSubResp? res = await ProfileService.documentSubmit(
        formData: formData,
      );

      if (res?.chMessage?.type == 'SUCCESS') {
        isLoading(false);
        if (mode == 'REAL_ESTATE') {
          await Get.offNamed(
            Routes.AUTO_BANK_LIST,
            arguments: LimitArguments(LimitMode: 'REAL_ESTATE'),
          );
        } else if (mode == 'LimitMode') {
          await Get.toNamed<void>(
            Routes.LIMIT_APPROVED_STATUS,
            arguments: LimitArguments(LimitMode: 'LimitMode'),
          );
        } else {
          Navigator.pop(context);
          Get.back(result: true);
          //  await Get.find<UserProfileController>().getProfileStatus();
        }
      } else {
        isLoading(false);
        appSnackbar(
          message: res.chMessage?.message.toString() ?? '',
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
      'addiParams': ['FNA', dockey, 'LINK'],
      "filterVal": custId,
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
    };
    try {
      bool res;
      res = await ProfileService.LinkCGDocument(formData: formData);
      if (res) {
        isLoading(false);
        getDocumentsLimit('customer/profile/process-view-documents');
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getuserData(String geturl) async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
    };
    CustomerLimitDataResp? resp = await ProfileService.getCGUserData(
      geturl,
      formData: formData,
    );
    custId = resp?.currLimit?.custId ?? '';
    isLoading(false);
  }
}
