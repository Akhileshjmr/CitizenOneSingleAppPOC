import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/common_utilities.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/local_store.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/CreditCard/CreditCardBenefitOptionsList.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_fna_sub_resp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/CreditCardService.dart';
import 'package:citizenone_app/modules/loans_module/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditBenefitsOptionController extends GetxController {
  //TODO: Implement CreditBenefitsOptionController

  /// dropdown List
  final RxList<CreditCardBenefitOptionsList?> benefitList = <CreditCardBenefitOptionsList?>[].obs;

  /// List of selected benefits
  final RxList<String> selectedBenefitList = <String>[].obs;

  /// Api loading
  final RxBool isLoading = true.obs;
  final RxBool isEarnPoin = false.obs;
  final RxBool isSaveMoney = false.obs;
  final RxBool isCashBack = false.obs;

  /// get benefits list
  Future<void> getBenefits() async {
    isLoading(true);
    benefitList(await CreditCardService.getBenefitList());
    isLoading(false);
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    LocalStore.isCreditCard(true);
    getBenefits();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> onContinue() async {
    final String? str = LocalStore.salary();
    selectedBenefitList.insert(0, 'Salary ${CommonUtilities.AppCurrency} $str');
    if (selectedBenefitList.length >= 2){
      await getUpdateCC('EARN_POINTS,CASHBACK','BENEFIT_ENTERED');
    }else {
      await getUpdateCC('EARN_POINTS', 'BENEFIT_ENTERED');
    }
  }

  Future<void> onSkip() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('associations', []);
    await prefs.setStringList('providers', []);
    final String? str = LocalStore.salary();
    selectedBenefitList.insert(0, 'Salary ${CommonUtilities.AppCurrency} $str');
    await getUpdateCC('','INCOME_ENTERED');
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  Future<void> getUpdateCC(String remark,String action) async {
    isLoading(true);
    LimitFnaSubResp? resp = await CreditCardService.getApplyCC('','','','',remark,action);
    // homeCardList((await CreditCardService.getHomeCardList(filter)).cast<CreditCardsList>());
    isLoading(false);
    if (resp?.chMessage?.isError == false){
      await Get.toNamed(
          Routes.CREDIT_HOME,arguments:CartBenfitArguments(cashBack: isCashBack.value,earnPoint: isEarnPoin.value,saveMoney: isSaveMoney.value)
      );
    }
  }
}
