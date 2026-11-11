import 'package:get/get.dart';

import '../modules/Documents/bindings/documents_binding.dart';
import '../modules/Documents/views/documents_view.dart';
import '../modules/IncomeDetail/bindings/income_detail_binding.dart';
import '../modules/IncomeDetail/views/income_detail_view.dart';
import '../modules/PreApproveDashbord/bindings/pre_approve_dashbord_binding.dart';
import '../modules/PreApproveDashbord/views/pre_approve_dashbord_view.dart';
import '../modules/PreApproveFinacePartner/bindings/pre_approve_finace_partner_binding.dart';
import '../modules/PreApproveFinacePartner/views/pre_approve_finace_partner_view.dart';
import '../modules/address_details/bindings/address_details_binding.dart';
import '../modules/address_details/views/address_details_view.dart';
import '../modules/auto_bank_list/bindings/auto_bank_list_binding.dart';
import '../modules/auto_bank_list/views/auto_bank_list_view.dart';
import '../modules/auto_document/bindings/auto_document_binding.dart';
import '../modules/auto_document/views/auto_document_view.dart';
import '../modules/auto_loan_history/bindings/auto_loan_history_binding.dart';
import '../modules/auto_loan_history/views/auto_loan_history_view.dart';
import '../modules/auto_loan_insurance/bindings/auto_loan_insurance_binding.dart';
import '../modules/auto_loan_insurance/views/auto_loan_insurance_view.dart';
import '../modules/auto_loan_order_status/bindings/auto_loan_order_status_binding.dart';
import '../modules/auto_loan_order_status/views/auto_loan_order_status_view.dart';
import '../modules/auto_loan_track_order_status/bindings/auto_loan_track_order_status_binding.dart';
import '../modules/auto_loan_track_order_status/views/auto_loan_track_order_status_view.dart';
import '../modules/auto_orders/bindings/auto_orders_binding.dart';
import '../modules/auto_orders/views/auto_orders_view.dart';
import '../modules/auto_upload_document/bindings/auto_upload_document_binding.dart';
import '../modules/auto_upload_document/views/auto_upload_document_view.dart';
import '../modules/auto_vehicle_form/bindings/auto_vehicle_form_binding.dart';
import '../modules/auto_vehicle_form/views/auto_vehicle_form_view.dart';
import '../modules/borrow_amt/bindings/borrow_amt_binding.dart';
import '../modules/borrow_amt/views/borrow_amt_view.dart';
import '../modules/cg_payment_success/bindings/cg_payment_success_binding.dart';
import '../modules/cg_payment_success/views/cg_payment_success_view.dart';
import '../modules/co_applicant/bindings/co_applicant_binding.dart';
import '../modules/co_applicant/views/co_applicant_view.dart';
import '../modules/co_referal/bindings/co_referal_binding.dart';
import '../modules/co_referal/views/co_referal_view.dart';
import '../modules/credit_CardDeatils/bindings/credit_card_deatils_binding.dart';
import '../modules/credit_CardDeatils/views/credit_card_deatils_view.dart';
import '../modules/credit_Filters/bindings/credit_filters_binding.dart';
import '../modules/credit_Filters/views/credit_filters_view.dart';
import '../modules/credit_before_start/bindings/credit_before_start_binding.dart';
import '../modules/credit_before_start/views/credit_before_start_view.dart';
import '../modules/credit_benefitsOption/bindings/credit_benefits_option_binding.dart';
import '../modules/credit_benefitsOption/views/credit_benefits_option_view.dart';
import '../modules/credit_compareCards/bindings/credit_compare_cards_binding.dart';
import '../modules/credit_compareCards/views/credit_compare_cards_view.dart';
import '../modules/credit_documentsUpload/bindings/credit_documents_upload_binding.dart';
import '../modules/credit_documentsUpload/views/credit_documents_upload_view.dart';
import '../modules/credit_documents_view/bindings/credit_documents_view_binding.dart';
import '../modules/credit_documents_view/views/credit_documents_view_view.dart';
import '../modules/credit_final_submit/bindings/credit_final_submit_binding.dart';
import '../modules/credit_final_submit/views/credit_final_submit_view.dart';
import '../modules/credit_get_start/bindings/credit_get_start_binding.dart';
import '../modules/credit_get_start/views/credit_get_start_view.dart';
import '../modules/credit_home/bindings/credit_home_binding.dart';
import '../modules/credit_home/views/credit_home_view.dart';
import '../modules/credit_review_screen/bindings/credit_review_screen_binding.dart';
import '../modules/credit_review_screen/views/credit_review_screen_view.dart';
import '../modules/credit_salary/bindings/credit_salary_binding.dart';
import '../modules/credit_salary/views/credit_salary_view.dart';
import '../modules/credit_third_screen/bindings/credit_third_screen_binding.dart';
import '../modules/credit_third_screen/views/credit_third_screen_view.dart';
import '../modules/creditcard_history/bindings/creditcard_history_binding.dart';
import '../modules/creditcard_history/views/creditcard_history_view.dart';
import '../modules/creditcard_track/bindings/creditcard_track_binding.dart';
import '../modules/creditcard_track/views/creditcard_track_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/income_type/bindings/income_type_binding.dart';
import '../modules/income_type/views/income_type_view.dart';
import '../modules/insurance_acceptance/bindings/insurance_acceptance_binding.dart';
import '../modules/insurance_acceptance/views/insurance_acceptance_view.dart';
import '../modules/insurance_detail/bindings/insurance_detail_binding.dart';
import '../modules/insurance_detail/views/insurance_detail_view.dart';
import '../modules/loan_details/bindings/loan_details_binding.dart';
import '../modules/loan_details/views/loan_details_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/monthly_income/bindings/monthly_income_binding.dart';
import '../modules/monthly_income/views/monthly_income_view.dart';
import '../modules/order/bindings/order_binding.dart';
import '../modules/order/views/order_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/p_r_check_eligible/bindings/p_r_check_eligible_binding.dart';
import '../modules/p_r_check_eligible/views/p_r_check_eligible_view.dart';
import '../modules/p_r_check_emi/bindings/p_r_check_emi_binding.dart';
import '../modules/p_r_check_emi/views/p_r_check_emi_view.dart';
import '../modules/p_r_document_list/bindings/p_r_document_list_binding.dart';
import '../modules/p_r_document_list/views/p_r_document_list_view.dart';
import '../modules/p_r_emi_calculator/bindings/p_r_emi_calculator_binding.dart';
import '../modules/p_r_emi_calculator/views/p_r_emi_calculator_view.dart';
import '../modules/p_r_upload_document/bindings/p_r_upload_document_binding.dart';
import '../modules/p_r_upload_document/views/p_r_upload_document_view.dart';
import '../modules/p_r_uploan_history/bindings/p_r_uploan_history_binding.dart';
import '../modules/p_r_uploan_history/views/p_r_uploan_history_view.dart';
import '../modules/personal_info/bindings/personal_info_binding.dart';
import '../modules/personal_info/views/personal_info_view.dart';
import '../modules/pl_chat/bindings/pl_chat_binding.dart';
import '../modules/pl_chat/views/pl_chat_view.dart';
import '../modules/pl_check_emi/bindings/pl_check_emi_binding.dart';
import '../modules/pl_check_emi/views/pl_check_emi_view.dart';
import '../modules/pl_compare_product/bindings/pl_compare_product_binding.dart';
import '../modules/pl_compare_product/views/pl_compare_product_view.dart';
import '../modules/pl_documents/bindings/pl_documents_binding.dart';
import '../modules/pl_documents/views/pl_documents_view.dart';
import '../modules/pl_features_filter/bindings/pl_features_filter_binding.dart';
import '../modules/pl_features_filter/views/pl_features_filter_view.dart';
import '../modules/pl_filter_product/bindings/pl_filter_product_binding.dart';
import '../modules/pl_filter_product/views/pl_filter_product_view.dart';
import '../modules/pl_final_submit/bindings/pl_final_submit_binding.dart';
import '../modules/pl_final_submit/views/pl_final_submit_view.dart';
import '../modules/pl_history/bindings/pl_history_binding.dart';
import '../modules/pl_history/views/pl_history_view.dart';
import '../modules/pl_home_screen/bindings/pl_home_screen_binding.dart';
import '../modules/pl_home_screen/views/pl_home_screen_view.dart';
import '../modules/pl_review_submit/bindings/pl_review_submit_binding.dart';
import '../modules/pl_review_submit/views/pl_review_submit_view.dart';
import '../modules/pl_status/bindings/pl_status_binding.dart';
import '../modules/pl_status/views/pl_status_view.dart';
import '../modules/pl_status_update/bindings/pl_status_update_binding.dart';
import '../modules/pl_status_update/views/pl_status_update_view.dart';
import '../modules/pl_upload_documents/bindings/pl_upload_documents_binding.dart';
import '../modules/pl_upload_documents/views/pl_upload_documents_view.dart';
import '../modules/pre_approve_finance_partner/bindings/pre_approve_finance_partner_binding.dart';
import '../modules/pre_approve_finance_partner/views/pre_approve_finance_partner_view.dart';
import '../modules/professional_details/bindings/professional_details_binding.dart';
import '../modules/professional_details/views/professional_details_view.dart';
import '../modules/property_form/bindings/property_form_binding.dart';
import '../modules/property_form/views/property_form_view.dart';
import '../modules/real_estate_loan_history/bindings/real_estate_loan_history_binding.dart';
import '../modules/real_estate_loan_history/views/real_estate_loan_history_view.dart';
import '../modules/upload_documents/bindings/upload_documents_binding.dart';
import '../modules/upload_documents/views/upload_documents_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOANS_LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOANS_LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BORROW_AMT,
      page: () => const BorrowAmtView(),
      binding: BorrowAmtBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_VEHICLE_FORM,
      page: () => const AutoVehicleFormView(),
      binding: AutoVehicleFormBinding(),
    ),
    GetPage(
      name: _Paths.PROPERTY_FORM,
      page: () => const PropertyFormView(),
      binding: PropertyFormBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_GET_START,
      page: () => const CreditGetStartView(),
      binding: CreditGetStartBinding(),
    ),
    GetPage(
      name: _Paths.INCOME_TYPE,
      page: () => const IncomeTypeView(),
      binding: IncomeTypeBinding(),
    ),
    GetPage(
      name: _Paths.MONTHLY_INCOME,
      page: () => const MonthlyIncomeView(),
      binding: MonthlyIncomeBinding(),
    ),
    GetPage(
      name: _Paths.IncomeDetails,
      page: () => const IncomeDetailView(),
      binding: IncomeDetailBinding(),
    ),
    GetPage(
      name: _Paths.PL_HOME_SCREEN,
      page: () => const PlHomeScreenView(),
      binding: PlHomeScreenBinding(),
    ),
    GetPage(
      name: _Paths.DOCUMENTS,
      page: () => const DocumentsView(),
      binding: DocumentsBinding(),
    ),
    GetPage(
      name: _Paths.PL_COMPARE_PRODUCT,
      page: () => const PlCompareProductView(),
      binding: PlCompareProductBinding(),
    ),
    GetPage(
      name: _Paths.PL_FEATURES_FILTER,
      page: () => const PlFeaturesFilterView(),
      binding: PlFeaturesFilterBinding(),
    ),
    GetPage(
      name: _Paths.PL_FILTER_PRODUCT,
      page: () => const PlFilterProductView(),
      binding: PlFilterProductBinding(),
    ),
    GetPage(
      name: _Paths.LOAN_DETAILS,
      page: () => const LoanDetailsView(),
      binding: LoanDetailsBinding(),
    ),
    GetPage(
      name: _Paths.PL_CHECK_EMI,
      page: () => PlCheckEmiView(),
      binding: PlCheckEmiBinding(),
    ),
    GetPage(
      name: _Paths.PERSONAL_INFO,
      page: () => const PersonalInfoView(),
      binding: PersonalInfoBinding(),
    ),
    GetPage(
      name: _Paths.PROFESSIONAL_DETAILS,
      page: () => const ProfessionalDetailsView(),
      binding: ProfessionalDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADDRESS_DETAILS,
      page: () => const AddressDetailsView(),
      binding: AddressDetailsBinding(),
    ),
    GetPage(
      name: _Paths.CO_APPLICANT,
      page: () => const CoApplicantView(),
      binding: CoApplicantBinding(),
    ),
    GetPage(
      name: _Paths.PL_DOCUMENTS,
      page: () => const PlDocumentsView(),
      binding: PlDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.CO_REFERAL,
      page: () => const CoReferalView(),
      binding: CoReferalBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_DOCUMENTS_VIEW,
      page: () => const CreditDocumentsViewView(),
      binding: CreditDocumentsViewBinding(),
    ),
    GetPage(
      name: _Paths.P_R_CHECK_ELIGIBLE,
      page: () => const PRCheckEligibleView(),
      binding: PRCheckEligibleBinding(),
    ),
    GetPage(
      name: _Paths.PL_REVIEW_SUBMIT,
      page: () => const PlReviewSubmitView(),
      binding: PlReviewSubmitBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: _Paths.PL_UPLOAD_DOCUMENTS,
      page: () => const PlUploadDocumentsView(),
      binding: PlUploadDocumentsBinding(),
    ),
    GetPage(
      name: _Paths.PL_FINAL_SUBMIT,
      page: () => const PlFinalSubmitView(),
      binding: PlFinalSubmitBinding(),
    ),
    GetPage(
      name: _Paths.PL_HISTORY,
      page: () => const PlHistoryView(),
      binding: PlHistoryBinding(),
    ),
    GetPage(
      name: _Paths.PL_STATUS_UPDATE,
      page: () => const PlStatusUpdateView(),
      binding: PlStatusUpdateBinding(),
    ),
    GetPage(
      name: _Paths.PL_STATUS,
      page: () => const PlStatusView(),
      binding: PlStatusBinding(),
    ),
    GetPage(
      name: _Paths.PL_CHAT,
      page: () => const PlChatView(),
      binding: PlChatBinding(),
    ),
    GetPage(
      name: _Paths.PRE_APPROVE_FINANCE_PARTNER,
      page: () => const PreApproveFinancePartnerView(),
      binding: PreApproveFinancePartnerBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_BANK_LIST,
      page: () => const AutoBankListView(),
      binding: AutoBankListBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_DOCUMENT,
      page: () => const AutoDocumentView(),
      binding: AutoDocumentBinding(),
    ),
    GetPage(
      name: _Paths.CG_PAYMENT_SUCCESS,
      page: () => const CgPaymentSuccessView(),
      binding: CgPaymentSuccessBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_UPLOAD_DOCUMENT,
      page: () => const AutoUploadDocumentView(),
      binding: AutoUploadDocumentBinding(),
    ),
    GetPage(
      name: _Paths.P_R_EMI_CALCULATOR,
      page: () => const PREmiCalculatorView(),
      binding: PREmiCalculatorBinding(),
    ),
    GetPage(
      name: _Paths.P_R_UPLOAN_HISTORY,
      page: () => const PRUploanHistoryView(),
      binding: PRUploanHistoryBinding(),
    ),
    GetPage(
      name: _Paths.UPLOAD_DOCUMENTS,
      page: () => const UploadDocumentsView(),
      binding: UploadDocumentsBinding(),
    ),

    // GetPage(
    //   name: _Paths.LIMIT_APPROVED_STATUS,
    //   page: () => const LimitApprovedStatusView(),
    //   binding: LimitApprovedStatusBinding(),
    // ),
    GetPage(
      name: _Paths.AUTO_LOAN_HISTORY,
      page: () => const AutoLoanHistoryView(),
      binding: AutoLoanHistoryBinding(),
    ),
    GetPage(
      name: _Paths.CREDITCARD_HISTORY,
      page: () => const CreditcardHistoryView(),
      binding: CreditcardHistoryBinding(),
    ),
    GetPage(
      name: _Paths.REAL_ESTATE_LOAN_HISTORY,
      page: () => const RealEstateLoanHistoryView(),
      binding: RealEstateLoanHistoryBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_LOAN_ORDER_STATUS,
      page: () => const AutoLoanOrderStatusView(),
      binding: AutoLoanOrderStatusBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_LOAN_INSURANCE,
      page: () => const AutoLoanInsuranceView(),
      binding: AutoLoanInsuranceBinding(),
    ),
    GetPage(
      name: _Paths.P_R_CHECK_EMI,
      page: () => const PRCheckEmiView(),
      binding: PRCheckEmiBinding(),
    ),
    GetPage(
      name: _Paths.LIMIT_BANK_LIST,
      page: () => const AutoBankListView(),
      binding: AutoBankListBinding(),
    ),
    GetPage(
      name: _Paths.P_R_DOCUMENT_LIST,
      page: () => const PRDocumentListView(),
      binding: PRDocumentListBinding(),
    ),
    GetPage(
      name: _Paths.P_R_UPLOAD_DOCUMENT,
      page: () => const PRUploadDocumentView(),
      binding: PRUploadDocumentBinding(),
    ),
    GetPage(
      name: _Paths.INSURANCE_DETAIL,
      page: () => const InsuranceDetailView(),
      binding: InsuranceDetailBinding(),
    ),
    GetPage(
      name: _Paths.PRE_APPROVE_DASHBORD,
      page: () => const PreApproveDashbordView(),
      binding: PreApproveDashbordBinding(),
    ),
    GetPage(
      name: _Paths.PRE_APPROVE_FINACE_PARTNER,
      page: () => const PreApproveFinacePartnerView(),
      binding: PreApproveFinacePartnerBinding(),
    ),
    GetPage(
      name: _Paths.INSURANCE_ACCEPTANCE,
      page: () => const InsuranceAcceptanceView(),
      binding: InsuranceAcceptanceBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_LOAN_TRACK_ORDER_STATUS,
      page: () => const AutoLoanTrackOrderStatusView(),
      binding: AutoLoanTrackOrderStatusBinding(),
    ),
    GetPage(
      name: _Paths.CREDITCARD_TRACK,
      page: () => const CreditcardTrackView(),
      binding: CreditcardTrackBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_BEFORE_START,
      page: () => const CreditBeforeStartView(),
      binding: CreditBeforeStartBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_THIRD_SCREEN,
      page: () => const CreditThirdScreenView(),
      binding: CreditThirdScreenBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_SALARY,
      page: () => const CreditSalaryView(),
      binding: CreditSalaryBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_BENEFITS_OPTION,
      page: () => CreditBenefitsOptionView(),
      binding: CreditBenefitsOptionBinding(),
    ),

    GetPage(
      name: _Paths.CREDIT_HOME,
      page: () => CreditHomeView(),
      binding: CreditHomeBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_COMPARE_CARDS,
      page: () => const CreditCompareCardsView(),
      binding: CreditCompareCardsBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_FILTERS,
      page: () => const CreditFiltersView(),
      binding: CreditFiltersBinding(),
    ),

    GetPage(
      name: _Paths.CREDIT_CARD_DEATILS,
      page: () => const CreditCardDeatilsView(),
      binding: CreditCardDeatilsBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_CARD_DEATILS,
      page: () => const CreditCardDeatilsView(),
      binding: CreditCardDeatilsBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_DOCUMENTS_UPLOAD,
      page: () => const CreditDocumentsUploadView(),
      binding: CreditDocumentsUploadBinding(),
    ),
    GetPage(
      name: _Paths.AUTO_ORDERS,
      page: () => const AutoOrdersView(),
      binding: AutoOrdersBinding(),
    ),
    GetPage(
      name: _Paths.ORDER,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_REVIEW_SCREEN,
      page: () => const CreditReviewScreenView(),
      binding: CreditReviewScreenBinding(),
    ),
    GetPage(
      name: _Paths.CREDIT_FINAL_SUBMIT,
      page: () => const CreditFinalSubmitView(),
      binding: CreditFinalSubmitBinding(),
    ),
  ];
}
