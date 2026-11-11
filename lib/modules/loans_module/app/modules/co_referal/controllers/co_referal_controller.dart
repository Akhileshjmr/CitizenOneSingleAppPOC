import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/config/logger.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pr_arguments.dart';
import '../../../data/model/loan/refer/LoanRefDetails.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/model/select_box_model/SelectOptionList.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/loan/auto_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../routes/app_pages.dart';

class CoReferalController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  /// If the form is submitting or not
  final RxBool isLoading = false.obs;

  RxList<LoanRefDetails> coReferaldata = <LoanRefDetails>[].obs;

  /// Course List
  final RxList<SelectOptionList?> selectoptionList = <SelectOptionList?>[].obs;

  // late RxList<Options?> optionList = <Options?>[].obs;
  RxList<Options> optionList = <Options>[].obs;
  RxList<Options> optionList1 = <Options>[].obs;

  TextEditingController NameController = TextEditingController();
  final TextEditingController CompanyNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  TextEditingController RefNameController = TextEditingController();
  TextEditingController RefCompanyNameController = TextEditingController();
  TextEditingController RefmobileNoController = TextEditingController();

  final RxString Relation = ''.obs;
  Map relationMap = {};

  final RxString RefRelation = ''.obs;
  Map refRelationMap = {};

  late LimitArguments args;

  late PRArguments preArgs;

  String mode = '';

  final count = 0.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    if (Get.arguments is LimitArguments) {
      args = Get.arguments;
      mode = args.LimitMode;
    }
    if (Get.arguments is PRArguments) {
      preArgs = Get.arguments;
      mode = preArgs.LimtMode;
    }
    // if (mode == 'Auto') {
    //   await getRefferalData('auto/orders/get-profile-forms');
    // } else if (mode == 'CG') {
    //   await getRefferalData('orders/cg/get-profile-forms');
    // } else if (mode == 'REAL_ESTATE') {
    //   await getRefferalData('realestate/home/orders/get-profile-forms');
    // } else if (mode == 'Credit' || mode == 'CreditReview') {
    //   getRefferalData('creditcard/get-cc-form-fields');
    // } else if (mode == 'Personal' || mode == 'PersonalReview') {
    //   getRefferalData('pl/get-pl-finance-fields');
    // }else if (mode == 'AutoLoan'){
    //   getRefferalData('pl/pre-approved-loan/get-profile-forms');
    // }
    getDroupDownList();
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

  Future<void> getDroupDownList() async {
    isLoading(true);
    try {
      selectoptionList(await PersonalListService.getListView());
      optionList(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'RELATIONSHIP',
            )
            ?.options,
      );
      optionList1(
        selectoptionList
            .firstWhereOrNull(
              (SelectOptionList? option) => option?.key == 'RELATIONSHIP',
            )
            ?.options,
      );
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> getRefferalData(String url) async {
    isLoading(true);
    List<LoanRefDetails>? resp = await PersonalListService.getCoReferal(url);
    coReferaldata(resp);

    await getDroupDownList();
    if (coReferaldata.length > 1) {
      if (resp?.first.name != null) {
        NameController.text = resp?.first.name.toString() ?? '';
      }

      if (resp?.first.mobNum != null) {
        mobileNoController.text = resp?.first.mobNum.toString() ?? '';
      }
      if (resp?.first.relationship?.type?.isNotEmpty ?? false) {
        Relation(resp?.first.relationship?.type ?? '');
        relationMap = {
          'id':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.first.relationship?.type,
                  )
                  ?.id,
          'type':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.first.relationship?.type,
                  )
                  ?.type,
          'friendlyType':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?.first.relationship?.type,
                  )
                  ?.friendlyType,
        };
      } else if (optionList.isNotEmpty) {
        Relation('');
      }

      if (resp?.first.companyName != null) {
        CompanyNameController.text = resp?.first.companyName.toString() ?? '';
      }

      if (resp?[1].companyName != null) {
        RefCompanyNameController.text =
            resp?.first.companyName.toString() ?? '';
      }

      if (resp?[1].name != null) {
        RefNameController.text = resp?[1].name.toString() ?? '';
      }

      if (resp?[1].mobNum != null) {
        RefmobileNoController.text = resp?[1].mobNum.toString() ?? '';
      }
      if (resp?[1].relationship?.type?.isNotEmpty ?? false) {
        RefRelation(resp?[1].relationship?.type ?? '');
        refRelationMap = {
          'id':
              optionList1()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[1].relationship?.type,
                  )
                  ?.id,
          'type':
              optionList1()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[1].relationship?.type,
                  )
                  ?.type,
          'friendlyType':
              optionList1()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[1].relationship?.type,
                  )
                  ?.friendlyType,
        };
      } else if (optionList1.isNotEmpty) {
        RefRelation('');
      }
    } else if (coReferaldata.isNotEmpty) {
      if (resp?.first.name != null) {
        NameController.text = resp?.first.name.toString() ?? '';
      }

      if (resp?.first.mobNum != null) {
        mobileNoController.text = resp?.first.mobNum.toString() ?? '';
      }
      if (resp?[0].relationship?.type?.isNotEmpty ?? false) {
        Relation(resp?[0].relationship?.friendlyType ?? '');
        relationMap = {
          'id':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[0].relationship?.type,
                  )
                  ?.id,
          'type':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[0].relationship?.type,
                  )
                  ?.type,
          'friendlyType':
              optionList()
                  .firstWhereOrNull(
                    (Options industryType) =>
                        industryType.type == resp?[0].relationship?.type,
                  )
                  ?.friendlyType,
        };
      } else if (optionList.isNotEmpty) {
        Relation('');
      }
    }
    isLoading(false);
  }

  Future<void> onSubmit(String suburl) async {
    // if (formKey.currentState?.saveAndValidate() ?? false) {
    // formKey.currentState!.save();
    isLoading(true);
    Map<String, dynamic> formData = <String, dynamic>{};
    try {
      formData = <String, dynamic>{
        'reqSecureKey': UserProvider.currentUser?.addiParams?[0] ?? '',
        'filterVal': 'PROFILE',
        "addiParams": ["LOAN_REFERENCE"],
        'orderId': LocalStore.buyNowFilterVal ?? '',
        "customerDet": {
          "loanRefDetails": [
            {
              "name": NameController.text ?? '',
              "mobNum": mobileNoController.text ?? '',
              "companyName": CompanyNameController.text ?? '',
              "relationship": relationMap,
            },
            {
              "name": RefNameController.text ?? '',
              "mobNum": RefmobileNoController.text ?? '',
              "companyName": RefCompanyNameController.text ?? '',
              "relationship": refRelationMap,
            },
          ],
        },
      };
      logD(formData.toString());
      final bool res = await PersonalListService.submitPersonal(
        suburl,
        formData: formData,
      );
      // if (res) {
      if (mode == 'LimitMode') {
      } else if (mode == 'Auto') {
        onSaveFinace(mode, 'auto/orders/save-profile-retail');
      } else if (mode == 'REAL_ESTATE') {
        onSaveFinace(mode, 'realestate/home/orders/save-profile-retail');
      } else if (mode == 'CG') {
        onSaveFinace(mode, 'orders/cg/save-profile-retail');
      } else if (mode == 'Credit') {
        onSaveFinace(mode, 'creditcard/save-profile-retail');
      } else if (mode == 'CreditReview' || mode == 'PersonalReview') {
        Navigator.pop(Get.context!, true);
      } else if (mode == 'Personal') {
        onSaveFinace(mode, ApiEndPoints.plReviewList);
      } else if (mode == 'AutoLoan') {
        onSaveFinace(mode, 'pl/pre-approved-loan/save-profile-retail');
      } else {
        Get.back(result: true);
        // await Get.find<UserProfileController>().getProfileStatus();
      }
      // }
    } on Exception catch (e) {
      logE(e);
      isLoading(false);
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
          /*Get.toNamed<void>(
              Routes.AUTO_BANK_LIST,
              arguments: LimitArguments(LimitMode: 'CG')
          );*/
        } else if (mode == 'REAL_ESTATE') {
          onPaymentType();
        } else if (mode == 'Personal') {
          await Get.toNamed(Routes.PL_DOCUMENTS);
        } else if (mode == 'Credit') {
          await Get.toNamed(Routes.CREDIT_DOCUMENTS_VIEW);
        } else if (mode == 'AutoLoan') {
          Get.toNamed<void>(
            Routes.P_R_CHECK_ELIGIBLE,
            arguments: PRArguments(
              filterval: preArgs.filterval ?? '',
              montlyInc: preArgs.montlyInc ?? '',
              montlyExc: preArgs.montlyExc ?? '',
              bankid: preArgs.bankid ?? '',
              bankName: '',
              LimtMode: 'AutoLoan',
            ),
          );
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
}
