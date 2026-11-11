import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/app_snackbar.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_arguments.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/limit/limit_fna_sub_resp.dart';
import 'package:citizenone_app/modules/loans_module/app/data/model/loan/PersonalLoan/FormData/LoanDetails.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/IncomeService.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/loan/auto_service.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/provider/personal_loan/personal_list_service.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../routes/app_pages.dart';

class IncomeDetailController extends GetxController {
  //TODO: Implement IncomeDetailController
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final RxBool isLoading = false.obs;
  Rx<LoanDetails> incomedata = LoanDetails().obs;

  TextEditingController MonthlyIncomeController = TextEditingController();
  TextEditingController OtherIncomeController = TextEditingController();
  TextEditingController AllowancesController = TextEditingController();
  TextEditingController DeducationController = TextEditingController();
  String mode = '';
  late LimitArguments args;

  final count = 0.obs;
  @override
  void onInit() {
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      if (args.LimitMode != null) {
        mode = args.LimitMode;
      } else {
        mode = '';
      }
    }
    if (mode == 'Auto') {
      getPeronalData('auto/orders/get-profile-forms');
    } else if (mode == 'CG') {
      getPeronalData('orders/cg/get-profile-forms');
    } else if (mode == 'REAL_ESTATE') {
      getPeronalData('realestate/home/orders/get-profile-forms');
    } else {
      getPeronalData(ApiEndPoints.getPlFinanceFields);
    }
    super.onInit();
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

  Future<void> getPeronalData(String geturl) async {
    isLoading(true);
    LoanDetails? resp = await IncomeService.getPersonalDetails(geturl);
    incomedata(resp);

    if (incomedata.value.monthlyIncome != null) {
      MonthlyIncomeController.text = incomedata.value.monthlyIncome.toString();
    }

    if (incomedata.value?.otherIncome != null) {
      OtherIncomeController.text = incomedata.value.otherIncome.toString();
    }

    if (incomedata.value?.allowances != null) {
      AllowancesController.text = incomedata.value.allowances.toString();
    }
    if (incomedata.value?.deductions != null) {
      DeducationController.text = incomedata.value.deductions.toString();
    }

    isLoading(false);
  }

  /// On login button tap
  Future<void> onSubmit(String suburl) async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      // formKey.currentState!.save();
      isLoading(true);
      Map<String, dynamic> formData = <String, dynamic>{};
      if (mode == 'LimitMode') {
        formData = <String, dynamic>{
          "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
          "addiParams": ["INCOME_DETAILS"],
          "filterVal": "PROFILE",
          "customerDet": {
            "loanDetails": {
              "monthlyIncome": MonthlyIncomeController.text.toString(),
              "otherIncome": OtherIncomeController.text.toString(),
              "allowances": AllowancesController.text.toString(),
              "deductions": DeducationController.text.toString(),
            },
          },
        };
      } else {
        formData = <String, dynamic>{
          "reqSecureKey": UserProvider.currentUser?.addiParams?[0] ?? '',
          "addiParams": ["INCOME_DETAILS"],
          "filterVal": "PROFILE",
          'orderId': LocalStore.buyNowFilterVal,
          "customerDet": {
            "loanDetails": {
              "monthlyIncome": MonthlyIncomeController.text.toString(),
              "otherIncome": OtherIncomeController.text.toString(),
              "allowances": AllowancesController.text.toString(),
              "deductions": DeducationController.text.toString(),
            },
          },
        };
      }

      print(formData.toString());

      try {
        final bool res = await PersonalListService.submitPersonal(
          suburl,
          formData: formData,
        );

        if (res) {
          if (mode == 'LimitMode') {
            /*Get.toNamed<void>(
                Routes.LIMIT_BANK_LIST,
                arguments: LimitArguments(LimitMode: 'LimitMode')
            );*/
            getProfileRetail();
          } else if (mode == 'Auto') {
            onSaveFinace(mode, 'auto/orders/save-profile-retail');
          } else if (mode == 'REAL_ESTATE') {
            onSaveFinace(mode, 'realestate/home/orders/save-profile-retail');
          } else if (mode == 'CG') {
            onSaveFinace(mode, 'orders/cg/save-profile-retail');
          } else {
            // Get.toNamed<void>(
            //   Routes.DOCUMENTS,
            // );
            // await Get.offAllNamed<void>(Routes.USER_PROFILE);
            Get.back(result: true);
            //  await Get.find<UserProfileController>().getProfileStatus();
          }
          // appSnackbar(
          //   message: 'updated successfully',
          //   snackbarState: SnackbarState.success,
          // );
        }
      } finally {
        isLoading(false);
      }
    }
  }

  Future<void> onSaveFinace(String mode, String geturl) async {
    isLoading(true);
    try {
      final bool res = await AutoService.submitFinaceFrom(geturl);

      if (res == true) {
        if (mode == 'Auto') {
          Get.toNamed<void>(
            Routes.AUTO_BANK_LIST,
            arguments: LimitArguments(LimitMode: 'Auto'),
          );
        } else if (mode == 'CG') {
          Get.toNamed<void>(
            Routes.AUTO_BANK_LIST,
            arguments: LimitArguments(LimitMode: 'CG'),
          );
        } else if (mode == 'REAL_ESTATE') {
          onPaymentType();
        }
      } else {
        appSnackbar(message: 'Faild', snackbarState: SnackbarState.warning);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> onPaymentType() async {
    isLoading(true);
    try {
      final bool res = await AutoService.realEstateSubmitPayment();
      if (res == true) {
        Get.toNamed<void>(
          Routes.AUTO_BANK_LIST,
          arguments: LimitArguments(LimitMode: 'REAL_ESTATE'),
        );
      } else {
        appSnackbar(message: 'Faild', snackbarState: SnackbarState.warning);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> getProfileRetail() async {
    isLoading(true);
    LimitFnaSubResp? resp = await AutoService.saveProfileRetail();
    isLoading(false);
    if (resp?.chMessage?.isError == false) {
      await Get.toNamed<void>(
        Routes.LIMIT_BANK_LIST,
        arguments: LimitArguments(LimitMode: 'LimitMode'),
      );
    }
  }
}
