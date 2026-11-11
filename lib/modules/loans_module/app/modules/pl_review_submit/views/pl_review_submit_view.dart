import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/ui/ag_appbar.dart';
import '../../../components/ui/ag_button.dart';
import '../../../components/ui/base_screen.dart';
import '../../../components/utils/app_snackbar.dart';
import '../../../data/local/store/local_store.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/ag_text_styles.dart';
import '../../../utils/app_colors.dart';
import '../../address_details/controllers/address_details_controller.dart';
import '../../loan_details/controllers/loan_details_controller.dart';
import '../../personal_info/controllers/personal_info_controller.dart';
import '../../professional_details/controllers/professional_details_controller.dart';
import '../controllers/pl_review_submit_controller.dart';

class PlReviewSubmitView extends GetView<PlReviewSubmitController> {
  const PlReviewSubmitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AgAppbar(title: 'Review & Submit'),

      bottomNavigationBar: Obx(
        () => Visibility(
          visible: controller.isLoading.isFalse,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              child: AgButton(
                title: 'Submit',
                onTap: () async {
                  if (controller.isSelected.value == true) {
                    // Generate OTP and navigate to OTP verification screen
                    final verified = await Get.toNamed(Routes.OTP_VERIFICATION);
                    if (verified == true) {
                      if (LocalStore.loanStatus() == false) {
                        await controller.onReviewSubmit(
                          LocalStore.bankId.toString(),
                        );
                      }

                      await Get.toNamed(
                        Routes.PL_FINAL_SUBMIT,
                        arguments: [
                          controller.loandata().tenure.toString(),
                          controller.remarkController.text,
                        ],
                      );
                    } else {
                      // OTP verification failed or cancelled
                      appSnackbar(
                        snackbarState: SnackbarState.warning,
                        message:
                            'OTP verification failed. Submission cancelled.',
                      );
                    }
                  } else {
                    appSnackbar(
                      snackbarState: SnackbarState.success,
                      message: 'Please agree the loan declaration',
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),

      body: Obx(
        () => BaseScreen(
          isLoading: controller.isLoading.value,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                /// ------------------ APPLICATION DETAILS ------------------
                _buildSection(
                  title: "Application Details",
                  onEdit: () async {
                    Get.find<PersonalInfoController>().mode.value =
                        'PersonalReview';
                    Get.find<PersonalInfoController>().getPeronalData(
                      'loan-service/customer/get-profile-forms',
                    );

                    await Get.toNamed(Routes.PERSONAL_INFO)?.then((value) {
                      if (value is bool) controller.getPersonalData();
                    });
                  },
                  children: [
                    _buildGridRow(
                      key1: 'Title',
                      value1: controller.personalDetails().title ?? '',
                      key2: 'Gender',
                      value2: controller.personalDetails().gender ?? '',
                    ),
                    _buildGridRow(
                      key1: 'First Name',
                      value1: controller.personalDetails().firstName ?? '',
                      key2: 'Middle Name',
                      value2: controller.personalDetails().middleName ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Last Name',
                      value1: controller.personalDetails().lastName ?? '',
                      key2: 'Mobile Number',
                      value2: controller.personalDetails().pNumber ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Email ID',
                      value1: controller.personalDetails().email ?? '',
                      key2: 'Date of Birth',
                      value2: (controller.personalDetails().dob ?? '')
                          .replaceAll('-', '/'),
                    ),
                    _buildGridRow(
                      key1: 'Current Country Residence Since',
                      value1: (controller.personalDetails().dateSinceInUAE ??
                              '')
                          .replaceAll('-', '/'),
                      key2: 'Marital Status',
                      value2:
                          controller
                              .personalDetails()
                              .maritalStatus
                              ?.friendlyType ??
                          '',
                    ),
                    /* _buildGridRow(
                      key1: 'No of Dependents',
                      value1: controller.personalDetails().noOfDependents ?? '',
                      key2: 'Special Persons Birthday',
                      value2:
                          controller
                              .personalDetails()
                              .birthday
                              ?.friendlyType
                              .toString()
                              .replaceAll('-', '/') ??
                          '',
                    ),*/
                    _buildGridRow(
                      key1: 'No of Dependents',
                      value1: controller.personalDetails().noOfDependents ?? '',
                      key2: 'National ID',
                      value2: controller.personalDetails().emiratesId ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Name as per ID',
                      value1: controller.personalDetails().fullName ?? '',
                      key2: 'National ID Expiry Date',
                      value2:
                          controller
                              .personalDetails()
                              .expiryDate
                              .toString()
                              .replaceAll('-', '/') ??
                          '',
                    ),
                    _buildGridRow(
                      key1: 'Nationality',
                      value1:
                          controller.personalDetails().nationality?.type ?? '',
                      key2: 'Country of Birth',
                      value2:
                          controller.personalDetails().countryOfBirth?.type ??
                          '',
                    ),
                    _buildGridRow(
                      key1: 'Passport No',
                      value1: controller.personalDetails().passportNum ?? '',
                      key2: 'Passport Expiry Date',
                      value2: (controller.personalDetails().passportExpDate ??
                              '')
                          .replaceAll('-', '/'),
                    ),
                    _buildGridRow(
                      key1: 'Education Qualification',
                      value1:
                          controller
                              .personalDetails()
                              .levelOfEducation
                              ?.friendlyType ??
                          '',
                    ),
                  ],
                ),

                /// ------------------ EMPLOYEE INFO ------------------
                _buildSection(
                  title: "Employee Info",
                  onEdit: () async {
                    Get.find<ProfessionalDetailsController>().mode =
                        'PersonalReview';
                    Get.find<ProfessionalDetailsController>().getProffesionData(
                      'loan-service/customer/get-profile-forms',
                    );

                    await Get.toNamed(Routes.PROFESSIONAL_DETAILS)?.then((
                      value,
                    ) {
                      if (value is bool) controller.getContactData();
                    });
                  },
                  children: [
                    _buildGridRow(
                      key1: 'Name of Organisation',
                      value1:
                          controller
                              .contactDetails()
                              ?.employerName
                              ?.friendlyType ??
                          '',
                      key2: 'Type of Industry',
                      value2:
                          controller.contactDetails()?.industry?.friendlyType ??
                          '',
                    ),
                    _buildGridRow(
                      key1: 'Date of Joining',
                      value1: controller.contactDetails()?.dateOfJoining ?? '',
                      key2: 'Designation',
                      value2: controller.contactDetails()?.designation ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Experience (Yrs)',
                      value1:
                          controller
                              .contactDetails()
                              ?.lenthOfService
                              .toString() ??
                          '',
                      key2: 'Monthly Income',
                      value2:
                          controller
                              .contactDetails()
                              ?.netMonthlyIncome
                              .toString()
                              .replaceAll('.0', '.00') ??
                          '',
                    ),
                    _buildGridRow(
                      key1: 'Other Income',
                      value1: controller.contactDetails()?.othrIncome ?? '',
                      key2: 'House Allowance',
                      value2: controller.contactDetails()?.houseAllowance ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Spouse Income',
                      value1: controller.contactDetails()?.spouseIncome ?? '',
                      key2: 'Monthly Commitments',
                      value2:
                          controller.contactDetails()?.monthlyCommitments ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Employee No.',
                      value1: controller.contactDetails()?.empNum ?? '',
                      key2: 'Office Telephone No.',
                      value2: controller.contactDetails()?.officeTelNum ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Office Mail ID',
                      value1: controller.contactDetails()?.officeMailId ?? '',
                      key2: 'Extension',
                      value2: controller.contactDetails()?.extension ?? '',
                    ),
                  ],
                ),

                /// ------------------ ADDRESS INFO ------------------
                _buildSection(
                  title: "Address Info",
                  onEdit: () async {
                    Get.put(AddressDetailsController());
                    Get.find<AddressDetailsController>().mode =
                        'PersonalReview';
                    Get.find<AddressDetailsController>().getPeronalData(
                      'creditcard/get-cc-form-fields',
                    );

                    await Get.toNamed(Routes.ADDRESS_DETAILS)?.then((value) {
                      if (value is bool) controller.getEmpData();
                    });
                  },
                  children: [
                    _buildGridRow(
                      key1: 'Name',
                      value1: controller.addressdata().personName ?? '',
                      key2: 'Mobile Number',
                      value2:
                          controller.addressdata().contactNum.toString() ?? '',
                    ),
                    _buildGridRow(
                      key1: 'PO Box Number',
                      value1: controller.addressdata().postBoxNum ?? '',
                      key2: 'Location',
                      value2: controller.addressdata().landMark ?? '',
                    ),
                    _buildGridRow(
                      key1: 'State',
                      value1: controller.addressdata().stateName ?? '',
                      key2: 'Country',
                      value2:
                          controller.addressdata().country?.friendlyType ?? '',
                    ),
                    _buildGridRow(
                      key1: 'Type of Address',
                      value1: controller.addressdata().typeOfAddress ?? '',
                    ),
                  ],
                ),

                /// ------------------ LOAN DETAILS ------------------
                _buildSection(
                  title: "Loan Details",
                  onEdit: () async {
                    LocalStore.editString('Review');
                    Get.put(LoanDetailsController());
                    Get.find<LoanDetailsController>().getLoanData();

                    await Get.toNamed(Routes.LOAN_DETAILS)?.then((value) {
                      if (value is bool) controller.getLoanData();
                    });
                  },
                  children: [
                    _buildGridRow(
                      key1: 'Purpose of Loan',
                      value1: controller.loandata().purposeOfLoan ?? '',
                      key2: 'Loan Amount',
                      value2:
                          controller
                              .loandata()
                              .loanAmount
                              .toString()
                              .replaceAll('.0', '.00') ??
                          '',
                    ),
                    _buildGridRow(
                      key1: 'Tenure (Months)',
                      value1: controller.loandata().tenure.toString(),
                    ),
                  ],
                ),

                10.verticalSpace,

                /// ------------------ CHECKBOX ------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.isSelected.value,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          controller.isSelected.value =
                              !controller.isSelected.value;
                        },
                      ),
                    ),

                    SizedBox(width: 10.w),

                    /// ✅ ONLY ONE FLEXIBLE (NO NESTED ROW)
                    Flexible(
                      fit: FlexFit.loose,
                      child: RichText(
                        maxLines: 10,
                        softWrap: true,
                        text: TextSpan(
                          text:
                              'Please tick this box if you have read and agree to the Eligibility Requirements. Annual Card Fees, the',
                          style: kw400Black14,
                          children: [
                            TextSpan(
                              text:
                                  ' Declaration & Authorisation, the Card Member Agreement and Benefits Terms and Conditions ',
                              style: kw400Black14.copyWith(
                                color: AppColors.primary,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      controller.getTermsConditions(
                                        controller.getTermsConditionsRequest(
                                          'TERMS_OF_USE',
                                        ),
                                      );
                                    },
                            ),
                            const TextSpan(
                              text:
                                  ' and consent to the collection, use, disclosure and processing of your Personal Information in accordance with the terms therein.',
                              style: kw400Black14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ------------------ SECTION CARD ------------------
  Widget _buildSection({
    required String title,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: kw600Black16),
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  "Edit",
                  style: kw500Black14.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          ...children,
        ],
      ),
    );
  }

  /// ------------------ GRID ROW ------------------
  Widget _buildGridRow({
    required String key1,
    required String value1,
    String? key2,
    String? value2,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(child: _buildItem(key1, value1)),
          SizedBox(width: 12.w),
          Expanded(
            child:
                key2 != null
                    ? _buildItem(key2, value2 ?? '')
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kw400Black12.copyWith(color: Colors.grey)),
        4.verticalSpace,
        Text(value, style: kw500Black14),
      ],
    );
  }
}
