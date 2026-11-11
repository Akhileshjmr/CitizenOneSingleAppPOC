import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../components/utils/common_utilities.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/model/user/documents/UploadDocumentResp.dart';
import '../../../data/remote/provider/loan/auto_service.dart';

class AutoUploadDocumentController extends GetxController {
  RxList<Documents>? arrDocuments = <Documents>[].obs;
  final RxBool isLoading = false.obs;
  var isDocUploaded = false.obs;
  var isReUploadClicked = false.obs;

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
      'comReq': {
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
        'filterVal': args?.key,
      },
      'doc': {
        'extn': extn,
        'fileBytes': '',
        'fileDataStr': base64string,
        'name': name,
        'storage': 'Internal',
        'type': (args?.documentName?.type ?? ''),
      },
    };

    UploadDocumentResp? response;
    if (args?.LimitMode == 'CG') {
      response = await AutoService.uploadCGListDocuments(data);
    } else if (args?.LimitMode == 'REAL_ESTATE') {
      response = await AutoService.uploadRealEstateListDocuments(data);
    } else {
      response = await AutoService.uploadListDocuments(data);
    }

    if (response?.chMessage?.type == 'SUCCESS') {
      isLoading(false);
      return true;
    } else {
      isLoading(true);
      appSnackbar(
        message: response?.chMessage?.message.toString() ?? '',
        snackbarState: SnackbarState.warning,
      );
      return true;
    }
  }

  void showLoader() {
    isLoading.value = true;
  }

  void hideLoader() {
    isLoading.value = false;
  }

  /*Future<void> handleUploadDocClicked({bool isInit = false}) async {
    if(isInit){
     await  Future.delayed(Duration(milliseconds: 500));
    }
    print("Upload Doc");
    CommonUtilities().openCustomImagePickerActionSheet(Get.context!, (file) {
      docSelected(file);
    }, (filePickerCallBack) {
      docFileSelected(filePickerCallBack);
    });
  }*/

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

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is Documents) {
      args = Get.arguments;
      print(args?.key);
      if (args?.documentName != null) {
        docID(args?.originalDocName ?? '');
        //await profileView();
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

  void increment() => count.value++;

  Future<void> DocumentsLink() async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'addiParams': ['PAYMENT_BANK_DOCS', args?.key ?? '', 'LINK'],
      'filterVal': LocalStore.buyNowFilterVal,
      'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
      'filterHashKey': 0,
      'hKey': 0,
    };
    try {
      bool res;
      if (args?.LimitMode == 'CG') {
        res = await AutoService.LinkCGDocument(formData: formData);
      } else if (args?.LimitMode == 'REAL_ESTATE') {
        res = await AutoService.LinkRealEstateDocument(formData: formData);
      } else {
        res = await AutoService.LinkDocument(formData: formData);
      }
      if (res) {
        Get.back(result: true);
      }
    } finally {
      isLoading(false);
    }
  }
}
