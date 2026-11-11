import 'dart:ui';

import 'package:get/get.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/store/user_provider.dart';
import '../../../data/model/address/AddressDet.dart';
import '../../../data/model/employee/employee_details.dart';
import '../../../data/model/loan/PersonalLoan/PLSubmitResp.dart';
import '../../../data/model/loan/forms/personal_form/GenDet.dart';
import '../../../data/model/user/documents/Documents.dart';
import '../../../data/remote/provider/CreditCardService.dart';
import '../../../data/remote/provider/address/address_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../data/remote/provider/personal_loan/professional_list_service.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/bottom_sheet_widget.dart';

class CreditReviewScreenController extends GetxController {
  /// Api loading
  final RxBool isLoading = true.obs;

  /// personal details list
  Rx<PersonalDet> personalDetails = PersonalDet().obs;

  /// contact details list
  Rx<EmployeeDetails?> contactDetails = EmployeeDetails().obs;

  /// emp details list
  Rx<AddressDet> addressdata = AddressDet().obs;

  /// documents list
  RxList<Documents>? arrDocuments = <Documents>[].obs;

  /// checkbox selected
  final RxBool isSelected = false.obs;

  RxList<Map<String, dynamic>> personalObjects = <Map<String, dynamic>>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getPersonalData();
    getContactData();
    getEmpData();
    getDocuments();
  }

  /// get loan details data
  Future<void> getPersonalData() async {
    isLoading(true);
    PersonalDet? resp = await PersonalListService.getPersonalDetails(
      'creditcard/get-cc-form-fields',
    );
    personalDetails(resp);
    isLoading(false);
  }

  /// get loan contact data
  Future<void> getContactData() async {
    isLoading(true);
    EmployeeDetails? resp = await ProfessionalListService.getProfessionDetails(
      'creditcard/get-cc-form-fields',
    );
    contactDetails(resp);
    isLoading(false);
  }

  /// get loan emp data
  Future<void> getEmpData() async {
    isLoading(true);
    AddressDet? resp = await AddressService.getPersonalDetails(
      'creditcard/get-cc-form-fields',
    );
    addressdata(resp);
    isLoading(false);
  }

  Future<void> getDocuments() async {
    Map<String, dynamic> data = {
      'addiParams': ["CREDIT_CARD"],
      "filterVal": LocalStore.bankId(),
      "reqSecureKey": UserProvider.currentUser?.addiParams[0] ?? '',
    };
    arrDocuments!(await CreditCardService.getUserDocuments(data));
  }

  /// On check box tap
  Future<void> getTermsConditions(dynamic data) async {
    await Get.bottomSheet(
      const BottomSheetWidget(
        data:
            "Important Information: This is in line with Central Bank’s efforts to provide an effective mechanism for exchange of information between banks and financial institutions, thereby enabling cardholders to avail of better credit terms from various institutions. The Cardholder acknowledges that the bank is authorized to share cardholder information to a Credit Information Company (that has obtained Certificate of Registration from Central bank). Bank shall provide information relating to repayment record of the cardholder to a Credit Information Company within a period of 45 – 60 days. In the event of a dispute, bank will make suitable amends to the reporting procedure before reporting the card holder as defaulter. However it may also be noted that such disclosure/release of information would be contingent on time available to investigate and settle such disputes raised. The Cardholder further acknowledges that bank is authorized to share Cardholder information, including default in payments with Financial Institution, employer and to other third parties engaged by bank for proper operation of card accounts, verification and other administrative services. Bank may also share Cardholder information with any parent, subsidiary, affiliate or associate of bank, for the purposes of marketing and offering various products and services of bank or its group companies, subsidiaries, affiliates and/or associates. Bank Card Most Important Terms and Conditions are also available at www.bank.com\nImportant Regulatory information •	The Card is valid for use both in UAE as well as abroad. Usage of the Card for transacting outside UAE must be made in accordance with applicable law including the Exchange Control Regulations of the Central bank and the Foreign Exchange Management Act. Foreign exchange trading through internet trading portals is not permitted. In the event of any violations or failure to comply, you may be liable for penal action. You should consult your Authorized Dealer (AD) regarding your Foreign Exchange Entitlement.\n•	If you have any credit balance on the credit card account, bank has the right to return this credit balance to you.\n•	As per Central Bank Master Circular- Master Circular on Miscellaneous Remittances from UAE facilities for Residents, use of Credit Card is prohibited for purchase of prohibited items like lottery tickets, banned or proscribed magazines, participation in sweepstakes, payment for call-back services, etc., since no drawal of foreign exchange is permitted for such items/activities. Please refer Master Circular on Miscellaneous Remittances from India facilities for Residents for more details. ",
      ),
      backgroundColor: AppColors.kffffff,
      clipBehavior: Clip.antiAlias,
    );
  }

  /// accept forms
  Future<void> onReviewSubmit() async {
    // formKey.currentState!.save();
    isLoading(true);

    try {
      PlSubmitResp? res = await CreditCardService.acceptForms();

      if (res?.chMessage?.type == 'SUCCESS') {
        await Get.toNamed<void>(Routes.CREDIT_FINAL_SUBMIT);
        // appSnackbar(
        //   message: 'successfully',
        //   snackbarState: SnackbarState.success,
        // );
      } else {
        appSnackbar(
          message: res?.chMessage?.message.toString() ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  /// Terms & conditions request params
  Map<String, dynamic> getTermsConditionsRequest(String filterVal) {
    Map<String, dynamic> jsonBody = {
      'filterVal': filterVal,
      'addiParams': ['CUSTOMER'],
    };
    return jsonBody;
  }
}
