import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/UploadDocumentResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';

class CreditDocumentsUploadController extends GetxController {

  RxList<Documents>? arrDocuments = <Documents>[].obs;

  final RxBool isLoading = true.obs;

  late Documents? args;
  RxString docID = ''.obs;
  Rx<XFile?> docFile = XFile('').obs;
  RxBool isBootom = false.obs;
  Rx<PlatformFile?> docstFile = PlatformFile(name: '', size: 0).obs;

  Future<bool> uploadDocument(String extn, String base64string, String name, ) async{
    isLoading(true);
    Map<String, Object> data = {
      "comReq": { "reqSecureKey":UserProvider.currentUser?.addiParams?[0] ?? '', "filterVal":args?.key},
      "doc": {
        "extn": extn,
        "fileBytes":"",
        "fileDataStr":base64string,
        "name": name,
        "storage": "Internal",
        "type": (args?.documentName?.type ?? "")
      }
    };

    UploadDocumentResp? response = await CreditCardService.uploadListDocuments(data);
    if (response?.chMessage?.type == "SUCCESS"){
      isLoading(false);
      return true;
    }else{
      isLoading(false);
      appSnackbar(
        message: response?.chMessage?.message.toString() ?? '',
        snackbarState: SnackbarState.warning,
      );
      return true;
    }
  }

  Future<void> handleUploadDocClicked({bool isInit = false}) async {
    if (isInit) {
      await Future.delayed(Duration(milliseconds: 500));
    }
    print("Upload Doc");

    final result = await CommonUtilities().openCustomImagePickerActionSheet(Get.context!, (file) {
      docSelected(file);
    }, (filePickerCallBack) {
      docFileSelected(filePickerCallBack);
    });

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

  void showLoader() {
    isLoading.value = true;
  }

  void hideLoader() {
    isLoading.value = false;
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading(false);
    if (Get.arguments is Documents) {
      args = Get.arguments;
      print(args?.key);
      if (args?.documentName != null) {
        docID(args?.originalDocName ?? '');
      }
    }

    handleUploadDocClicked(isInit: true);
  }

  Future<void> DocumentsLink() async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'addiParams': [
        'CREDIT_CARD',args?.key ?? '','LINK'
      ],
      "filterVal": LocalStore.bankId(),
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      "filterHashKey": 0,
      "hKey": 0,
    };
    try {
      bool res;
      res =
      await CreditCardService.LinkCGDocument(formData: formData);
      if (res) {
        isLoading(false);
        Get.back(result: true);
      }
    } finally {
      isLoading(false);
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
}
