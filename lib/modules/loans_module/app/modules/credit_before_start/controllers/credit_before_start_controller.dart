import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

import '../../../data/local/store/local_store.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/remote/provider/credit_card/credit_card_service.dart';
import '../../../routes/app_pages.dart';

class CreditBeforeStartController extends GetxController {
  /// Form key for name
  final GlobalKey<FormBuilderState> datFormKey = GlobalKey<FormBuilderState>();

  /// Api loading
  final RxBool isLoading = true.obs;

  int amt = 0;

  TextEditingController nameController = TextEditingController();

  /// Student ID field validators
  final String? Function(String?) nameValidators =
      FormBuilderValidators.compose(<String? Function(String?)>[
        FormBuilderValidators.required(errorText: 'Name is required'),
      ]);

  Future<void> onContinue() async {
    if (datFormKey.currentState?.saveAndValidate() ?? false) {
      LocalStore.firstName(datFormKey.currentState?.value['First Name']);
      await Get.toNamed(Routes.CREDIT_THIRD_SCREEN, arguments: amt);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await getUpdateCC('Shown interest on credit card.', 'INTERESTED');
  }

  Future<void> getUpdateCC(String remark, String action) async {
    isLoading(true);
    LimitFnaSubResp? resp = await CreditCardService.getApplyCC(
      '',
      '',
      '',
      '',
      remark,
      action,
    );
    isLoading(false);
    if (resp?.chMessage?.isError == false) {
      nameController.text = resp?.firstName ?? '';
      amt = resp?.monthlyIncome ?? 0;
      print(amt);
    }
  }
}
