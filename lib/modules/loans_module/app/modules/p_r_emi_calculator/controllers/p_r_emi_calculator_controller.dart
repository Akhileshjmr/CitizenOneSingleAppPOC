import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/utils/date_ext.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../data/model/loan/PreApprove/prEmiCalculator/PRCalculatorResp.dart';
import '../../../data/model/loan/eligibility_entity.dart';
import '../../../data/model/select_box_model/Options.dart';
import '../../../data/remote/provider/loan/pre_approve_loan_service.dart';

class PREmiCalculatorController extends GetxController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  final items = ['1', '2', '3', '4', '5'];

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final TextEditingController dobController = TextEditingController();
  final TextEditingController reqFinAmtController = TextEditingController();

  ///
  final RxDouble reqFinanceAmt = 0.0.obs;
  final TextEditingController monthlyIncomeController = TextEditingController();

  ///
  final RxDouble monthlyIncome = 0.0.obs;
  final TextEditingController otherIncomeController = TextEditingController();

  ///
  final RxDouble otherIncome = 0.0.obs;
  final TextEditingController housingFinController = TextEditingController();

  ///
  final RxDouble housingFin = 0.0.obs;
  final TextEditingController personalFinController = TextEditingController();

  ///
  final RxDouble personalFin = 0.0.obs;
  final TextEditingController othersController = TextEditingController();

  ///
  final RxDouble others = 0.0.obs;

  final TextEditingController creditCardController = TextEditingController();

  ///
  final RxDouble creditCard = 0.0.obs;

  final TextEditingController autoController = TextEditingController();

  ///
  final RxDouble auto = 0.0.obs;

  final TextEditingController businessController = TextEditingController();

  ///
  final RxDouble business = 0.0.obs;

  Rx<Nationality> selectedNationality = Nationality.uae.obs;
  Rx<Income> selectedIncome = Income.rentalIncome.obs;

  RxBool isLoading = false.obs;

  var tenureval = '0';

  var requestFnaAmt = 500000.0;

  Rx<EligibilityEntity> eligibilityEntity = EligibilityEntity().obs;
  Rx<PrCalculatorResp> autoeligibilityEntity = PrCalculatorResp().obs;

  final RxString nationality = ''.obs;
  var nationalityMap = {};
  RxList<Options>? nationalityOptions = <Options>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    nationalityOptions?.add(
      Options(id: 0, type: 'EXPATRIATE', friendlyType: 'Expatriate'),
    );
    nationalityOptions?.add(
      Options(id: 1, type: 'UAE_NATIONAL', friendlyType: 'UAE National'),
    );
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

  Future<void> checkPREligibility() async {
    isLoading(true);
    if (formKey.currentState?.saveAndValidate() ?? false) {
      try {
        await PreApproveLoanService.prCalculator(
          data: {
            'age': selectedDate().age,
            'autoFinance': autoController.text,
            'businessIncome': otherIncomeController.text,
            'creditCardLimit': creditCardController.text,
            'homeFinance': housingFinController.text,
            'loanReqAmount': reqFinAmtController.text,
            'monthlyFixedSalary': monthlyIncomeController.text,
            'otherInstallments': othersController.text,
            'personalFinance': personalFinController.text,
            'residentialType': nationalityMap['type'].toString(),
            'filterHashKey': 0,
            'hKey': 0,
            'reqSecureKey': null,
          },
        ).then((value) {
          autoeligibilityEntity(value);
          if (autoeligibilityEntity().chMessage?.isError == false) {
            showDialog(
              context: Get.context!,
              builder:
                  (BuildContext context) => Dialog(
                    insetPadding: EdgeInsets.symmetric(
                      vertical: 50.h,
                      horizontal: 10.w,
                    ),
                    child:
                        (value.isEligible == false)
                            ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTitle(
                                  title:
                                      'EligibleMessage : ${value.message ?? ''}',
                                ),
                                5.verticalSpace,
                                15.verticalSpace,
                                AgButton(
                                  title: 'OK',
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ).paddingAll(20.r)
                            : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTitle(
                                  title: value.message?.toString() ?? ' ',
                                ),
                                10.verticalSpace,
                                _buildTitle(
                                  title:
                                      'Tenure : ${value.tenure?.toString() ?? ' '}',
                                ),
                                15.verticalSpace,
                                AgButton(
                                  title: 'OK',
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ],
                            ).paddingAll(20.r),
                  ),
            );
          }
        });
        autoeligibilityEntity.refresh();
      } finally {
        isLoading(false);
      }
    } else {
      isLoading(false);
    }
  }

  Text _buildTitle({required String title}) =>
      Text(title, style: kw400Black14, textAlign: TextAlign.center);
}

enum Nationality { uae, expatriate }

enum Income { rentalIncome, other }
