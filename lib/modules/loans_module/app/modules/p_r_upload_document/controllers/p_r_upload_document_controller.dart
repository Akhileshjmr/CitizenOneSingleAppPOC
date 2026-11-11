import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/model/user/documents/UploadDocumentResp.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class PRUploadDocumentController extends GetxController {
  RxList<Documents>? arrDocuments = <Documents>[].obs;
  final RxBool isLoading = false.obs;

  late Documents? args;
  RxString docID = ''.obs;
  Rx<XFile?> docFile = XFile('').obs;
  RxBool isBootom = false.obs;
  Rx<PlatformFile?> docstFile = PlatformFile(name: '', size: 0).obs;

  Future<bool> uploadDocument(
    String extn,
    String base64string,
    String name,
  ) async {
    isLoading(true);
    Map<String, Object> data = {
      "comReq": {
        "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
        "filterVal": args?.key,
      },
      "doc": {
        "extn": extn,
        "fileBytes": "",
        "fileDataStr": base64string,
        "name": name,
        "storage": "Internal",
        "type": (args?.documentName?.type ?? ""),
      },
    };

    UploadDocumentResp? response;
    response = await PreApproveLoanService.uploadPRListDocuments(data);
    if (response?.chMessage?.type == "SUCCESS") {
      isLoading(false);
      return true;
    } else {
      isLoading(false);
      appSnackbar(
        message: response?.chMessage?.message.toString() ?? '',
        snackbarState: SnackbarState.warning,
      );
      isLoading(false);
      return true;
    }
  }

  void showLoader() {
    isLoading.value = true;
  }

  void hideLoader() {
    isLoading.value = false;
  }

  Future<void> handleUploadDocClicked({bool isInit = false}) async {
    if (isInit) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    print('Upload Doc');

    final result = await CommonUtilities().openCustomImagePickerActionSheet(
      Get.context!,
      (file) {
        docSelected(file);
      },
      (filePickerCallBack) {
        docFileSelected(filePickerCallBack);
      },
    );

    if (result == null) {
      Get.back();
    }
  }

  void docFileSelected(PlatformFile? file) {
    docstFile.value = file;
    isBootom(true);
  }

  void docSelected(XFile? file) {
    docFile(file);
    isBootom(true);
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Documents) {
      args = Get.arguments;
      print(args?.key);
      if (args?.documentName != null) {
        docID(args?.originalDocName ?? '');
      }
    }
    handleUploadDocClicked(isInit: true);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> DocumentsLink() async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'addiParams': ['HOUSE_LOAN', args?.key ?? '', 'LINK'],
      "filterVal": LocalStore.buyNowFilterVal,
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      "filterHashKey": 0,
      "hKey": 0,
    };
    try {
      bool res;
      res = await PreApproveLoanService.LinkPRDocument(formData: formData);
      if (res) {
        Get.back(result: true);
      }
    } finally {
      isLoading(false);
    }
  }
}
