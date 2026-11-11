import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_appbar.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/ag_button.dart';
import 'package:citizenone_app/modules/loans_module/app/components/ui/base_screen.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_colors.dart';
import '../../address_details/controllers/address_details_controller.dart';
import '../../personal_info/controllers/personal_info_controller.dart';
import '../../professional_details/controllers/professional_details_controller.dart';
import '../controllers/credit_review_screen_controller.dart';

class CreditReviewScreenView extends GetView<CreditReviewScreenController> {
  const CreditReviewScreenView({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: Obx(
      () => Visibility(
        visible: !controller.isLoading.value,
        child: AgButton(
          title: 'SUBMIT',
          onTap: () async {
            if (controller.isSelected.value == true) {
              await controller.onReviewSubmit();
            } else {
              appSnackbar(
                snackbarState: SnackbarState.warning,
                message: 'Please agree the form declaration',
              );
            }
          },
        ).paddingOnly(right: 30.w, left: 30.w, bottom: 20.h),
      ),
    ),
    appBar: AgAppbar(title: 'Review & Submit'),
    body: Obx(
      () => BaseScreen(
        isLoading: controller.isLoading.value,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Personal Info", style: kw400Black14),
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                AppColors.kffffff,
                              ),
                            ),
                            onPressed: () async {
                              // LocalStore.editString('CC_Review');
                              // final PersonalInfoController contrer =
                              //     Get.find();
                              // contrer.refresh();
                              PersonalInfoController groceryProductController =
                                  Get.put(PersonalInfoController());
                              Get.find<PersonalInfoController>().mode.value =
                                  'CreditReview';
                              Get.find<PersonalInfoController>().getPeronalData(
                                'creditcard/get-cc-form-fields',
                              );
                              await Get.toNamed(
                                Routes.PERSONAL_INFO,
                                arguments: LimitArguments(
                                  LimitMode: 'CreditReview',
                                ),
                              )?.then((value) {
                                if (value is bool) {
                                  controller.getPersonalData();
                                }
                              });
                            },
                            child: Text("EDIT", style: kw400Black14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15),
                20.verticalSpace,
                Column(
                  children: [
                    _buildDetailRow(
                      key: 'Face Match %',
                      value1:
                          controller
                              .personalDetails()
                              .facematchPercentage
                              ?.toStringAsFixed(2) ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'Liveness match %',
                      value1:
                          controller
                              .personalDetails()
                              .livelinessPercentage
                              ?.toStringAsFixed(2) ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'Title',
                      value1: controller.personalDetails().title ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Gender',
                      value1: controller.personalDetails().gender ?? '',
                    ),
                    _buildDetailRow(
                      key: 'First Name',
                      value1: controller.personalDetails().firstName ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Middle Name',
                      value1: controller.personalDetails().middleName ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Last Name',
                      value1: controller.personalDetails().lastName ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Mobile Number',
                      value1: controller.personalDetails().pNumber ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Email ID',
                      value1: controller.personalDetails().email ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Date of Birth',
                      value1: controller.personalDetails().dob ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Date since in UAE',
                      value1: controller.personalDetails().dateSinceInUAE ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Marital Status',
                      value1:
                          controller
                              .personalDetails()
                              .maritalStatus
                              ?.friendlyType ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'No of Dependents',
                      value1: controller.personalDetails().noOfDependents ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Special Persons birthday',
                      value1:
                          controller.personalDetails().birthday?.friendlyType ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'Anniversary',
                      value1:
                          controller
                              .personalDetails()
                              .anniversary
                              ?.friendlyType ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'Emirates ID',
                      value1: controller.personalDetails().emiratesId ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Name as per ID',
                      value1: controller.personalDetails().fullName ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Eimrates ID expiry date',
                      value1: controller.personalDetails().expiryDate ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Nationality',
                      value1:
                          controller.personalDetails().nationality?.type ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Country of birth',
                      value1:
                          controller.personalDetails().countryOfBirth?.type ??
                          '',
                    ),
                    _buildDetailRow(
                      key: 'Passport No',
                      value1: controller.personalDetails().passportNum ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Passport expiry date',
                      value1:
                          controller.personalDetails().passportExpDate ?? '',
                    ),
                    _buildDetailRow(
                      key: 'Education Qualification',
                      value1:
                          controller
                              .personalDetails()
                              .levelOfEducation
                              ?.friendlyType ??
                          '',
                    ),
                  ],
                ),
                20.verticalSpace,
                Container(
                  child: const LinearProgressIndicator(
                    minHeight: 1,
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.grey),
                    backgroundColor: Colors.grey,
                  ),
                ),
                20.verticalSpace,
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Employee Info",
                            style: kTitleMetropolis14,
                          ),
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                AppColors.kffffff,
                              ),
                            ),
                            onPressed: () async {
                              // LocalStore.editString('CC_Review');
                              ProfessionalDetailsController
                              groceryProductController = Get.put(
                                ProfessionalDetailsController(),
                              );
                              Get.find<ProfessionalDetailsController>().mode =
                                  'CreditReview';
                              Get.find<ProfessionalDetailsController>()
                                  .getProffesionData(
                                    'creditcard/get-cc-form-fields',
                                  );
                              await Get.toNamed(
                                Routes.PROFESSIONAL_DETAILS,
                              )?.then((value) {
                                if (value is bool) {
                                  controller.getContactData();
                                }
                              });
                            },
                            child: Text("EDIT", style: kw400Black14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15),
                20.verticalSpace,
                ((controller.contactDetails()?.empStatus?.type ?? '') ==
                        'SELF_EMPLOYED')
                    ? Container(
                      child: Column(
                        children: [
                          _buildDetailRow(
                            key: 'AnnualIncome',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.annualIncome
                                    .toString() ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Years In Business',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.yearsInBusiness
                                    .toString() ??
                                '',
                          ),
                        ],
                      ),
                    )
                    : Container(
                      child: Column(
                        children: [
                          _buildDetailRow(
                            key: 'Name of the Organisation ( Current)',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.employerName
                                    ?.friendlyType ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Type of Industry',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.industry
                                    ?.friendlyType ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Date of joining',
                            value1:
                                controller.contactDetails()?.dateOfJoining ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Designation',
                            value1:
                                controller.contactDetails()?.designation ?? '',
                          ),
                          _buildDetailRow(
                            key: 'Experience (Yrs)',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.lenthOfService
                                    .toString() ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Monthly Income',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.netMonthlyIncome
                                    .toString()
                                    .replaceAll('.0', '.00') ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Other Income',
                            value1:
                                controller.contactDetails()?.othrIncome ?? '',
                          ),
                          _buildDetailRow(
                            key: 'House Allowance',
                            value1:
                                controller.contactDetails()?.houseAllowance ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Spouse income',
                            value1:
                                controller.contactDetails()?.spouseIncome ?? '',
                          ),
                          _buildDetailRow(
                            key: 'Monthly Commitments',
                            value1:
                                controller
                                    .contactDetails()
                                    ?.monthlyCommitments ??
                                '',
                          ),
                          _buildDetailRow(
                            key: 'Employee no.',
                            value1: controller.contactDetails()?.empNum ?? '',
                          ),
                          _buildDetailRow(
                            key: 'Office telephone No.',
                            value1:
                                controller.contactDetails()?.officeTelNum ?? '',
                          ),
                          _buildDetailRow(
                            key: 'Office mail id',
                            value1:
                                controller.contactDetails()?.officeMailId ?? '',
                          ),
                          _buildDetailRow(
                            key: 'Extention',
                            value1:
                                controller.contactDetails()?.extension ?? '',
                          ),
                        ],
                      ),
                    ),
                20.verticalSpace,
                Container(
                  child: const LinearProgressIndicator(
                    minHeight: 1,
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.grey),
                    backgroundColor: Colors.grey,
                  ),
                ),
                20.verticalSpace,
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Address Info", style: kTitleMetropolis14),
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                AppColors.kffffff,
                              ),
                            ),
                            onPressed: () async {
                              // LocalStore.editString('CC_Review');

                              AddressDetailsController
                              groceryProductController = Get.put(
                                AddressDetailsController(),
                              );
                              Get.find<AddressDetailsController>().mode =
                                  'CreditReview';
                              Get.find<AddressDetailsController>()
                                  .getPeronalData(
                                    'creditcard/get-cc-form-fields',
                                  );
                              await Get.toNamed(Routes.ADDRESS_DETAILS)?.then((
                                value,
                              ) {
                                if (value is bool) {
                                  controller.getEmpData();
                                }
                              });
                            },
                            child: Text("EDIT", style: kw400Black14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15),
                20.verticalSpace,
                Container(
                  child: Column(
                    children: [
                      _buildDetailRow(
                        key: 'Name',
                        value1: controller.addressdata()?.personName ?? '',
                      ),
                      _buildDetailRow(
                        key: 'Mobile Number',
                        value1:
                            controller.addressdata()?.contactNum.toString() ??
                            '',
                      ),
                      _buildDetailRow(
                        key: 'PO Number',
                        value1: controller.addressdata()?.postBoxNum ?? '',
                      ),
                      _buildDetailRow(
                        key: 'Location',
                        value1: controller.addressdata()?.landMark ?? '',
                      ),
                      _buildDetailRow(
                        key: 'Emirate',
                        value1: controller.addressdata()?.stateName ?? '',
                      ),
                      _buildDetailRow(
                        key: 'Country',
                        value1:
                            controller.addressdata()?.country?.friendlyType ??
                            '',
                      ),
                      _buildDetailRow(
                        key: 'Type of address',
                        value1: controller.addressdata()?.typeOfAddress ?? '',
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                Container(
                  child: const LinearProgressIndicator(
                    minHeight: 1,
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.grey),
                    backgroundColor: Colors.grey,
                  ),
                ),
                20.verticalSpace,
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Documents', style: kTitleMetropolis14),
                          Spacer(),
                          ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                AppColors.kffffff,
                              ),
                            ),
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.CREDIT_DOCUMENTS_VIEW,
                              )?.then((value) {
                                if (value is bool) {
                                  controller.getDocuments();
                                }
                              });
                            },
                            child: Text("EDIT", style: kw400Black14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).paddingSymmetric(horizontal: 15),
                20.verticalSpace,
                Container(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.arrDocuments?.length ?? 0,
                    separatorBuilder:
                        (BuildContext context, int index) => 10.verticalSpace,
                    itemBuilder:
                        (BuildContext context, int index) =>
                            _buildDocumentsList(index, context),
                  ),
                ),
                20.verticalSpace,
                Container(
                  child: const LinearProgressIndicator(
                    minHeight: 1,
                    value: 1.0,
                    valueColor: AlwaysStoppedAnimation(AppColors.grey),
                    backgroundColor: Colors.grey,
                  ),
                ),
                30.verticalSpace,
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: controller.isSelected.value ? true : false,
                          checkColor: Colors.white,
                          // color of tick Mark
                          activeColor: AppColors.primary,
                          onChanged: (bool? result) async {
                            if (controller.isSelected.value == true) {
                              controller.isSelected.value = false;
                            } else {
                              controller.isSelected.value = true;
                            }
                            controller.isSelected.refresh();
                          },
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: RichText(
                            maxLines: 10,
                            softWrap: true,
                            //overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text:
                                  'Please tick this box if you have read and agree to the Eligibility Requirements. Annual Card Fees, the',
                              style: kSubTitleMetropolis14,
                              children: [
                                TextSpan(
                                  text:
                                      ' Declaration & Authorisation, the Card Member Agreement and Benefits Terms and Conditions ',
                                  style: kw400Black14,
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          controller.getTermsConditions(
                                            controller
                                                .getTermsConditionsRequest(
                                                  'TERMS_OF_USE',
                                                ),
                                          );
                                        },
                                ),
                                const TextSpan(
                                  text:
                                      ' and consent to the collection, use, disclosure and processing of your Personal Information in accordance with the terms therein. ',
                                  style: kSubTitleMetropolis14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildDocumentsList(int index, BuildContext context) =>
      GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      controller.arrDocuments?[index].documentName?.type ?? '',
                      style: kSubTitleMetropolis14.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      controller.arrDocuments?[index].originalDocName ?? '',
                      style: kSubTitleMetropolis14.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _buildDetailRow({required String key, required String value1}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Text(
          key,
          style: kSubTitleMetropolis14.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(width: 30),
      Expanded(
        child: Text(
          value1,
          style: kSubTitleMetropolis14.copyWith(fontWeight: FontWeight.w400),
          textAlign: TextAlign.left,
        ),
      ),
    ],
  ).paddingSymmetric(horizontal: 15, vertical: 5);
}
