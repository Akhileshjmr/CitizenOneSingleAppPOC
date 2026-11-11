import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/data/local/store/user_provider.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/address/AddressDet.dart';
import '../../../data/model/args/pl_review_args.dart';
import '../../../data/model/employee/employee_details.dart';
import '../../../data/model/loan/PersonalLoan/FormData/LoanDetails.dart';
import '../../../data/model/loan/PersonalLoan/PLSubmitResp.dart';
import '../../../data/model/loan/forms/personal_form/GenDet.dart';
import '../../../data/remote/api_service/ApiEndPoints.dart';
import '../../../data/remote/provider/address/address_service.dart';
import '../../../data/remote/provider/personal_loan/personal_list_service.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../../../data/remote/provider/personal_loan/professional_list_service.dart';
import '../../../utils/app_colors.dart';
import '../../../widget/bottom_sheet_widget.dart';

class PlReviewSubmitController extends GetxController {
  final Rx<PlSubmitResp> allFormsData = PlSubmitResp().obs;

  Rx<PersonalDet> personalDetails = PersonalDet().obs;

  TextEditingController remarkController = TextEditingController();

  /// contact details list
  Rx<EmployeeDetails?> contactDetails = EmployeeDetails().obs;

  /// emp details list
  Rx<AddressDet> addressdata = AddressDet().obs;

  Rx<LoanDetails> loandata = LoanDetails().obs;

  /// Api loading
  final RxBool isLoading = true.obs;

  /// checkbox selected
  final RxBool isSelected = false.obs;

  late PLReviewArgs args;

  Future<void> getPersonalData() async {
    isLoading(true);
    PersonalDet? resp = await PersonalListService.getPersonalDetails(
      ApiEndPoints.getPlFinanceFields,
    );

    personalDetails(resp);
    isLoading(false);
  }

  /// get loan contact data
  Future<void> getContactData() async {
    isLoading(true);
    EmployeeDetails? resp = await ProfessionalListService.getProfessionDetails(
      ApiEndPoints.getPlFinanceFields,
    );
    contactDetails(resp);
    isLoading(false);
  }

  /// get loan emp data
  Future<void> getEmpData() async {
    isLoading(true);
    AddressDet? resp = await AddressService.getPersonalDetails(
      ApiEndPoints.getPlFinanceFields,
    );
    addressdata(resp);
    isLoading(false);
  }

  Future<void> getLoanData() async {
    isLoading(true);
    LoanDetails? resp = await PersonalLoanService.getLoanDetails();
    loandata(resp);
    isLoading(false);
  }

  /// get final sumbit data
  Future<void> getFinalSubmitData() async {
    isLoading(true);
    allFormsData(await PersonalLoanService.plFinalSubmitData());
    isLoading(false);
  }

  /// Terms & conditions request params
  Map<String, dynamic> getTermsConditionsRequest(String filterVal) {
    Map<String, dynamic> jsonBody = {
      'filterVal': filterVal,
      'addiParams': ['CUSTOMER'],
    };
    return jsonBody;
  }

  Future<void> getMobileNumber() async {
    String mobile = await UserProvider.getMobileNumber();
    personalDetails().pNumber = mobile;
  }

  /// On check box tap
  Future<void> getTermsConditions(dynamic data) async {
    /*final String returnedResult = await AuthService.getTermSAndCondition(
      formData: data,
    );*/
    await Get.bottomSheet(
      const BottomSheetWidget(
        data:
            "Important Information: We wish to inform you that we shall now be reporting the data pertaining to your account with us to the concerned Credit Information Company. This data will be updated on a regular basis for all our customers. Other Information: • Part Payment is allowed. In case you wish to avail this option, 2% part payment charges is applicable on partial payment. Part payment to be made from customer’s own fund. This facility is allowed only for customers who have opted for Smart Personal Loan. Part payment is not allowed for customers who have opted for Simple Personal Loan. • Loan Account number must invariably be mentioned on reverse of the cheques submitted for Pre-payment of Loan, replacement PDCs, swap orany other charges. • Any change in mailing address, telephone numbers and other contact details must be intimated to Bank, quoting the Loan Account Number along with a valid documentary proof • Interest Certificate will be provided on request at the end of each financial year • Should you require any further information / assistance from our Bank Loan Centers, we request you to carry a Valid Photo ID card to be furnished or provide a proper authority letter and self-attested photo ID to your representative along with his / her photo ID • Kindly ensure that your account is funded with sufficient funds at least a day prior to your EMI date, to avoid bounce charges • Non-payment of any of the charges levied will be reported to the Credit information company and will affect the credit score. • If any of the deemed address proofs is provided, then within 3 months from date of disbursal, the updated Officially Valid Document with the current address should be submitted by the customer to the bank. General Information: • Repayment Schedule: Repayment Schedule provides the amount of each EMI, due dates and break-up between principal and interest components. It also provides the outstanding principal realization of each installment. Please note that you can access the repayment schedule by logging into the Customer Portal IMPORTANT: The outstanding principal should not be taken as the only obligation to the Company under this Loan Agreement. Prepayment penalty, other charges, if applicable, all other monies that may be due and payable by the borrower to the Bank, including its subsidiaries/affiliates/assignee on any account whatsoever, whether present of future, including any liability of the Borrower as a surety or co-obligor either singly or along with any other person are also payable at the time of full and final settlement. • Swap of the Mode of Repayment: The facility of substituting the existing instructions for repayment of EMIs can be allowed. This can be done by submitting set of fresh instructions along with cheque at any of our Branches. IMPORTANT: Please note that from the date of receipt of fresh instructions, 30 working days are required for affecting the swap. Till such time, the existing instructions will remain in operation for the installment falling due during the intervening period, and necessary cover funds must be provided for the same. Once the Swap is activated, the cheques will be retained at our end. In case you wish these to be returned, kindly lodge a request through our call center within 7 days. • Statement of Account: Statement of Loan Account provides details of repayments and can be furnished upon request • Pre-Payment of Loans: Any payment made towards pre-payment of loan should be done at least 5 working days before the validity date to factor Cheque /cash clearing timelines. The interest will stop accruing on your loan account from the date of clearing and excess funds, if any, will be credited to the bank account registered with us. Refer schedule of charges for further details.",
      ),
      backgroundColor: AppColors.kffffff,
      clipBehavior: Clip.antiAlias,
    );
  }

  Future<void> onReviewSubmit(String args) async {
    // formKey.currentState!.save();
    isLoading(true);

    try {
      PlSubmitResp? res = await PersonalLoanService.plApplyLoanCheck();

      if (res?.chMessage?.type == 'SUCCESS') {
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

  @override
  Future<void> onInit() async {
    super.onInit();

    if (Get.arguments is PLReviewArgs) {
      args = Get.arguments;
    }
    await getPersonalData();
    await getContactData();
    await getEmpData();
    await getLoanData();
    await getMobileNumber();
  }
}
