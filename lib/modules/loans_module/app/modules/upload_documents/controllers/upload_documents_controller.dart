

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/UploadDocumentResp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/profile_service.dart';
import 'package:citizenone_app/modules/loans_module/app/modules/profile/UserProfViewResp.dart';

class UploadDocumentsController extends GetxController {

  RxList<Documents>? arrDocuments = <Documents>[].obs;

  late Documents? args;
  RxString docID = ''.obs;
  Rx<XFile?> docFile = XFile('').obs;
  Rx<PlatformFile?> docstFile = PlatformFile(name: '', size: 0).obs;
  RxBool isLoading = false.obs;
  RxBool isBootom = false.obs;
  final count = 0.obs;


  /*@override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments is Documents) {
      args = Get.arguments;
      if (args?.documentName != null) {
        docID(args?.originalDocName ?? '');
        await profileView();
      }
    }
    handleUploadDocClicked(isInit: true);
  }*/

  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments is Documents) {
      args = Get.arguments;

      docID(args?.originalDocName ?? '');

      // Only try preview if document is already attached
      if (args?.isAttachedInProcess == true) {
        await profileView();
      }
    }

    handleUploadDocClicked(isInit: true);
  }


  /*Future<void> profileView() async{
    if ((args?.isAttachedInProcess ?? false) == true) {
      String docKey = "";
      docKey = args?.document?["url"];
      print(docKey.toString());
      UserProfViewResp? resp = await ProfileService.getProfileView(docKey);
      String imgFile = resp?.file ?? "";
      XFile file = await CommonUtilities().base64ToXFile(imgFile);
      docFile(file);
    }
  }*/

  Future<void> profileView() async {
    if (args == null) return;

    if (args?.isAttachedInProcess == true) {

      final dynamic document = args?.document;

      // 🛡 Safe extraction
      final String? docKey =
      (document is Map && document['url'] is String)
          ? document['url'] as String
          : null;

      if (docKey == null || docKey.isEmpty) {
        print('⚠️ profileView skipped: document url is null');
        return;
      }

      print('Fetching document preview for key: $docKey');

      UserProfViewResp? resp =
      await ProfileService.getProfileView(docKey);

      final String imgFile = resp?.file ?? '';

      if (imgFile.isEmpty) return;

      final XFile file = await CommonUtilities().base64ToXFile(imgFile);
      docFile(file);
    }
  }


  Future<bool> uploadDocument(String extn, String base64string, String name, ) async{
    isLoading(true);
    Map<String, Object> data = {
      "comReq": { "reqSecureKey":UserProvider.currentUser?.addiParams?[0],'filterVal': (args?.key == '' || args?.key == null)?'':args?.key,},
      "doc": {
        "extn": extn,
        "fileBytes":"",
        "fileDataStr":base64string,
        "name": name,
        "storage": "Internal",
        "type": (args?.documentName?.type ?? "")
      }
    };

    UploadDocumentResp? response = await ProfileService.uploadListDocuments(data);
    if (response?.chMessage?.type == "SUCCESS"){
      isLoading(false);
      return true;
    }else{
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



  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;


  Future<bool> uploadLimitDocument(String extn, String base64string, String name, ) async{
    isLoading(true);
    Map<String, Object> data = {
      "comReq": { "reqSecureKey":UserProvider.currentUser?.addiParams?[0],'filterVal':(args?.key == '' || args?.key == null)?'':args?.key,},
      "doc": {
        "extn": extn,
        "fileBytes":"",
        "fileDataStr":base64string,
        "name": name,
        "storage": "Internal",
        "type": (args?.documentName?.type ?? "")
      }
    };

    UploadDocumentResp? response = await ProfileService.uploadLimitListDocuments(data);
    if (response?.chMessage?.type == "SUCCESS"){
      isLoading(false);
      return true;
    }else{
      isLoading(false);
      appSnackbar(
        message: response?.chMessage?.message.toString() ?? '',
        snackbarState: SnackbarState.warning,
      );
      isLoading(false);
      return true;
    }
  }

}
