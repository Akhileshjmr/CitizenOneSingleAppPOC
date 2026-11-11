import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_fna_sub_resp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';

class CreditHomeController extends GetxController {
  //TODO: Implement CreditHomeController

  /// List of home card
  final RxList<CreditCardsList> homeCardList = <CreditCardsList>[].obs;

  /// List of campare card
  final RxList<CreditCardsList> compareCardList = <CreditCardsList>[].obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  /// List of selected benefits
  List<String> selectedBenefitList = <String>[];

  List<String> filterList = ['Earn Points, Miles or Travel Perks','Bank','Salary','Loan Amount'];

  final count = 0.obs;
  late CartBenfitArguments args;

  @override
  void onInit() {
    super.onInit();
    // selectedBenefitList = Get.arguments;
    // print(selectedBenefitList);
    if (Get.arguments is CartBenfitArguments) {
      args = Get.arguments;
      getBankList();
    }
    // if (selectedBenefitList.length > 1){
    //   getBankList('true');
    // }else{
    //   getBankList('');
    // }
    LocalStore.editString('');
  }

  /// get home screen bank list
  Future<void> getBankList() async {
    isLoading(true);
    homeCardList((await CreditCardService.getHomeCardList(args.cashBack,args.saveMoney,args.earnPoint)).cast<CreditCardsList>());
    isLoading(false);
  }

  Future<void> getUpdateCC(String cardname,String bkName,String bkID,String bkurl) async {
    isLoading(true);
    LimitFnaSubResp? resp = await CreditCardService.getApplyCC(cardname,bkName,bkID,bkurl,'Card has been selected','CARD_SELECTED');
    // homeCardList((await CreditCardService.getHomeCardList(filter)).cast<CreditCardsList>());
    isLoading(false);
      if (resp?.chMessage?.isError == false){
        await Get.toNamed<void>(Routes.PERSONAL_INFO,
            arguments: LimitArguments(LimitMode: 'Credit'));
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

  void insertbenefits() {

  }
}
