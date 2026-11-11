import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardComparisionsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';

class CreditCompareCardsController extends GetxController {
  //TODO: Implement CreditCompareCardsController

  final RxList<CreditCardComparisionsList?> compareCards =
      <CreditCardComparisionsList>[].obs;

  final RxList<CreditCardsList> compareCardList = <CreditCardsList>[].obs;

  late RxList<String> compareListString = <String>[].obs;

  /// Api loading
  final RxBool isLoading = false.obs;

  List<String?> compareList = [
    'Add on Cards',
    'Airport Lounge  Access',
    'Balance Transfer',
    'Sharia Compliant',
    'Emi Conversion',
    'Travel Benefits',
    'Fuel surcharge waiver',
    'Fuel Card',
    'Insurance Coverage',
    'Internet Banking',
    'Travel Insurance',
    'Supplementary Card',
    'Student card'
  ];
  List<String> checkcompareList = [
    'addOnCards',
    'airportLoungeAccess',
    'balanceTransfer',
    'shariaCompliant',
    'emiConversion',
    'travelBenefits',
    'fuelSurchargeWaiver',
    'fuelCard',
    'insuranceCoverage',
    'internetBanking',
    'travelInsurance',
    'supplementaryCard',
    'studentCard'
  ];
  RxList<CompareProduct> compareProductList = <CompareProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    LocalStore.editString('');
    compareCardList(Get.arguments);
    getCompareData();
  }

  /// get compare product data
  Future<void> getCompareData() async {
    isLoading(true);
    compareCards(await CreditCardService.getCompareDate(
        compareCardList[0].cardId.toString() ?? '',
        compareCardList[1].cardId.toString() ?? ''));
    isLoading(false);
    compareProductList.clear();
    // if(compareCards.length==2){
    //   compareCards.forEach((element) {
    //     List<CompareItem> compareItemList = [];
    //     element?.toJson().forEach((key, value) {
    //       if(checkcompareList.contains(key)){
    //         compareItemList.add(CompareItem(key, value));
    //       }
    //     });
    //     compareProductList.add(CompareProduct(compareItemList));
    //   });
    // }

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class CompareProduct {
  List<CompareItem>? itemList;
  CompareProduct(this.itemList);
}

class CompareItem {
  String? itemName;
  bool? itemValue;
  CompareItem(this.itemName, this.itemValue);
}
