import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/bank_list/BankListResp.dart';
import '../../../data/model/loan/bank_list/EmiInfoDetails.dart';
import '../../../data/model/loan/bank_list/GdbShopEmiRespList.dart';
import '../../../data/model/loan/fee_charges/FeeChargesResp.dart';
import '../../../data/model/loan/fee_charges/FeesAndCharges.dart';
import '../../../data/model/loan/save_emi_resp.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../utils/aes_encoder.dart';

class AutoBankListController extends GetxController {
  RxList<GdbShopEmiRespList?> arrList = <GdbShopEmiRespList?>[].obs;

  Rx<GdbShopEmiRespList> selectedBank = GdbShopEmiRespList().obs;

  RxBool isLoading = true.obs;
  Rx<EmiInfoDetails> selectedEMIPlan = EmiInfoDetails().obs;
  RxList<FeesAndCharges> feeAndCharges = <FeesAndCharges>[].obs;
  late LimitArguments args;
  String totalCharge = '';
  bool isSelected = false;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode == 'Auto') {
        getBankList();
      } else if (args.LimitMode == 'CG') {
        getCGBankList();
      } else if (args.LimitMode == 'REAL_ESTATE') {
        getRealEstateBankList();
      } else {
        getBankList();
      }
    }
  }

  Future<void> getBankList() async {
    try {
      isLoading(true);
      BankListResp? resp = await AutoService.fetchBankList(
        LocalStore.buyNowFilterVal,
      );
      arrList(resp.gdbShopEmiRespList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getCGBankList() async {
    try {
      isLoading(true);
      BankListResp? resp = await AutoService.fetchCGBankList(
        LocalStore.buyNowFilterVal,
      );
      arrList(resp.gdbShopEmiRespList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getRealEstateBankList() async {
    try {
      isLoading(true);
      BankListResp? resp = await AutoService.fetchRealEstateBankList(
        LocalStore.buyNowFilterVal,
      );
      arrList(resp.gdbShopEmiRespList);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> onSubmit(
    String downPayment,
    String emiAmount,
    String intersetRate,
    String tenure,
    String totalAmount,
  ) async {
    // formKey.currentState!.save();
    final encryptedInterset = AesEncryption.encrypt(intersetRate);
    final encryptedTenure = AesEncryption.encrypt(tenure);
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      "orderId": LocalStore.buyNowFilterVal.toString(),
      "filterHashKey": 0,
      "addiParams": [LocalStore.BankId.toString()],
      "emiInfo": {
        "downPayment": downPayment,
        "emiAmount": emiAmount,
        "interestRate": encryptedInterset,
        "tenure": encryptedTenure,
        "totalAmount": totalAmount,
      },
    };
    print(formData.toString());
    SaveEmiResp? res;
    try {
      if (args.LimitMode == 'CG') {
        res = await AutoService.saveCGEMIDetails(formData: formData);
      } else if (args.LimitMode == 'REAL_ESTATE') {
        res = await AutoService.saveRealEstateEMIDetails(formData: formData);
      } else {
        res = await AutoService.saveEMIDetails(formData: formData);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> onFeeSubmit() async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
      "orderId": LocalStore.buyNowFilterVal.toString(),
    };
    FeeChargesResp? res;
    try {
      if (args.LimitMode == 'CG') {
        res = await AutoService.getConsumerGoodsFeeCharges(formData: formData);
        feeAndCharges(res?.feesAndCharges);
        totalCharge = res?.totalCharge ?? '';
      } else if (args.LimitMode == 'REAL_ESTATE') {
        res = await AutoService.saveRealEstateFeeCharges(formData: formData);
        feeAndCharges(res?.feesAndCharges);
        totalCharge = res?.totalCharge ?? '';
      } else {
        res = await AutoService.saveAutoFeeCharges(formData: formData);
        feeAndCharges(res?.feesAndCharges);
        totalCharge = res?.totalCharge ?? '';
      }

      if (res?.chMessage?.type == 'SUCCESS') {
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  Row buildRow({required String title, required String subTitle}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: kw400Black12, textAlign: TextAlign.start),
      Text(subTitle, style: kw400Black12, textAlign: TextAlign.start),
    ],
  );

  Text buildTitle({required String title}) =>
      Text(title, style: kw400Black12, textAlign: TextAlign.start);
}
