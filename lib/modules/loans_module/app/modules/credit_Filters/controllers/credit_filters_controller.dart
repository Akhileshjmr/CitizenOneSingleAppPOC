import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardAssociationsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardBanksList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';

class CreditFiltersController extends GetxController {
  //TODO: Implement CreditFiltersController

  /// List of association list
  final RxList<CreditCardAssociationsList> assciationList = <CreditCardAssociationsList>[].obs;

  /// List of provider list
  final RxList<CreditCardBanksList> providerList = <CreditCardBanksList>[].obs;

  /// List of association
  late RxList<String> selectedAssociation = <String>[].obs;

  /// List of providers
  late RxList<String> selectedProviders = <String>[].obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != 0){
      selectedAssociation(Get.arguments[0]);
      selectedProviders(Get.arguments[1]);
    }
    getAssociationList();
    getProviderList();
  }

  /// get association list
  Future<void> getAssociationList() async {
    isLoading(true);
    assciationList((await CreditCardService.getAssociationList()).cast<CreditCardAssociationsList>());
    isLoading(false);
  }

  /// get provider list
  Future<void> getProviderList() async {
    isLoading(true);
    providerList((await CreditCardService.getProviderList()).cast<CreditCardBanksList>());
    isLoading(false);
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
