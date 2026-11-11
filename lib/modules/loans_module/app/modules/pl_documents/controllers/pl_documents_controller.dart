import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';

import '../../../data/extension/document_extension.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../pl_home_screen/controllers/pl_home_screen_controller.dart';

class PlDocumentsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Documents> arrDocuments = <Documents>[].obs;

  late final LimitArguments args;
  String mode = '';

  final RxInt selectedIndex = 6.obs;

  late final PlHomeScreenController homeController;

  @override
  void onInit() {
    super.onInit();

    homeController = Get.find<PlHomeScreenController>();

    final arguments = Get.arguments;

    if (arguments is LimitArguments) {
      args = arguments;
      mode = args.LimitMode ?? '';
    }

    getDocuments();
  }

  Future<void> getDocuments() async {
    try {
      isLoading(true);

      final data = _baseRequest(addiParams: ["PERSONAL_LOAN"]);

      final result = await PersonalLoanService.getUserDocuments(data);

      arrDocuments.assignAll(result ?? []);
    } catch (e) {
      _handleError(e, "getDocuments");
    } finally {
      isLoading(false);
    }
  }

  Future<void> linkDocument(String docKey) async {
    try {
      isLoading(true);

      final formData = _baseRequest(
        addiParams: ['PERSONAL_LOAN', docKey, 'LINK'],
      )..addAll({"filterHashKey": 0, "hKey": 0});

      final res = await PersonalLoanService.LinkCGDocument(formData: formData);

      if (res) {
        await getDocuments();
      }
    } catch (e) {
      _handleError(e, "linkDocument");
    } finally {
      isLoading(false);
    }
  }

  bool validateMandatoryDocuments() {
    final pendingDocs =
        arrDocuments.where((doc) {
          return doc.isRequired && !doc.isUploaded;
        }).toList();

    if (pendingDocs.isEmpty) {
      return true;
    }

    final names = pendingDocs.map((e) => e.documentName?.type ?? "").join(", ");

    appSnackbar(
      message: "Please upload mandatory document(s): $names",
      snackbarState: SnackbarState.warning,
    );

    return false;
  }

  Map<String, dynamic> _baseRequest({required List<String> addiParams}) {
    return {
      "addiParams": addiParams,
      "filterVal": homeController.selectedBank.value.bankId,
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? "",
    };
  }

  void _handleError(Object e, String method) {
    print("❌ $method : $e");
  }
}
