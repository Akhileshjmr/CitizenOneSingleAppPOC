import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/user/documents/Documents.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';class CreditDocumentsViewController extends GetxController {

  final RxBool isLoading = false.obs;

  RxList<Documents>? arrDocuments = <Documents>[].obs;

  String? userName;
  late LimitArguments args;
  String mode = '';

  bool isAttached = false;

  final count = 0.obs;
  @override
  void onInit() {
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode != null) {
        mode = args.LimitMode;
      }else{
        mode = '';
      }
    }
    getDocuments();
    super.onInit();
  }

  Future<void> getDocuments() async {
    Map<String,dynamic> data = {
      'addiParams': [
        "CREDIT_CARD"
      ],
      "filterVal": LocalStore.bankId(),
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? ''
    };
    arrDocuments!(await CreditCardService.getUserDocuments(data));
  }

  Future<void> DocumentsLink(String dockey) async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'addiParams': [
        'CREDIT_CARD',dockey,'LINK'
      ],
      "filterVal": LocalStore.bankId.toString(),
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? ''
    };
    try {
      bool res;
      res =
      await CreditCardService.LinkCGDocument(formData: formData);
      if (res) {
        getDocuments();
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
