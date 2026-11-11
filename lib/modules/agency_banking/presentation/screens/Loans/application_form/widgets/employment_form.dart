import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustAddressForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlEmpDetForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbLookupForm.dart';
import '../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import 'labeled_dateField.dart';
import 'labeled_textField.dart';

class EmploymentForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;
  final bool isCommDataPreFetched;
  final GdbCustRtlFormResponse custRtlFormResponse;
  EmploymentForm({
    Key? key,
    required this.onPrevious,
    required this.onNext,
    required this.lovValues,
    required this.isCommDataPreFetched,
    required this.custRtlFormResponse,
  }) : super(key: key);

  static void submitEmploymentDetails(BuildContext context) {
    final req = GdbCustRtlAppRequest<GdbCustRtlForm>();
    req.screenId = 'EMP_DATA';
    req.isDraft = true;
    GdbCustRtlForm form = GdbCustRtlForm();
    form.phone = AESEncryptionService.encrypt(mobileNoController.text);
    GdbCustRtlEmpDetForm empDetails = GdbCustRtlEmpDetForm();
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd/MM/yyyy');
    DateTime parsedDate = inputFormat.parse(hireDate.text);
    String formattedDob = outputFormat.format(parsedDate);
    empDetails.jobTitle = titleController.text;
    empDetails.hiringDate = formattedDob;
    empDetails.netMonthlyExpense =
        double.tryParse(netMonthlyExpenseController.text);
    empDetails.netMonthlyIncome =
        double.tryParse(netMonthlyIncomeController.text);
    GdbCustAddressForm workingAddress = GdbCustAddressForm();

    workingAddress.addressLine = workingAddressController.text;
    // workingAddress.emailAddress=workingEmail.text;
    workingAddress.phNum = mobileNoController.text;
    // workingAddress.emerContactPerson=emergencyContactPersonController.text;
    // workingAddress.emerContactPhNum=emergencyPhoneController.text;
    empDetails.workingAddress = workingAddress;
    GdbLookupForm empStatus = GdbLookupForm();
    empStatus.type = empStatusController.text;
    GdbLookupForm industry = GdbLookupForm();
    industry.type = "FINANCE_INTERMEDIATIONS";
    GdbLookupForm employerName = GdbLookupForm();
    employerName.type = currentEmployerController.text;
    empDetails.empStatus = empStatus;
    empDetails.industry = industry;
    empDetails.employerName = employerName;
    form.empDetails = empDetails;
    req.customerDet = form;
    AppLogger.debug('Submitting employment details');
    AppLogger.debug('Employment request prepared');
    AppLogger.debug('Employment form submission in progress');
    AppLogger.debug('Employment general details processed');
    context.read<CustomerRegistrationBloc>().add(
          CustomerRegistrationSubmitted<GdbCustRtlForm>(req),
        );
  }

  @override
  State<EmploymentForm> createState() => _EmploymentFormState();
}

class _EmploymentFormState extends State<EmploymentForm> {
  final _formKey = GlobalKey<FormState>();

  String? _conditionalValidator(String? value, String errorMsg) {
    if (widget.isCommDataPreFetched) return null; // skip validation
    if (value == null || value.isEmpty) return errorMsg;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Employer
          LabeledTextField(
            label: "Current Employer",
            controller: currentEmployerController,
            maxLength: 30,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.employerName != null,
            validator: (value) =>
                _conditionalValidator(value, "Current Employer is required"),
          ),

          // Employment Status
          LabeledTextField(
            label: "Employment Status",
            controller: empStatusController,
            maxLength: 30,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.empStatus != null,
            validator: (value) =>
                _conditionalValidator(value, "Employment Status is required"),
          ),

          // Job Title
          LabeledTextField(
            label: "Job Title",
            controller: titleController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.jobTitle != null,
            maxLength: 30,
            validator: (value) =>
                _conditionalValidator(value, "Job Title is required"),
          ),

          // Working Address
          LabeledTextField(
            label: "Working Address",
            controller: workingAddressController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.workingAddress
                        ?.addressLine !=
                    null,
            maxLength: 30,
            validator: (value) =>
                _conditionalValidator(value, "Working Address is required"),
          ),

          // Net Monthly Income
          LabeledTextField(
            label: "Net Monthly Income",
            controller: netMonthlyIncomeController,
            isMandatory: true,
            keyboardType: TextInputType.number,
            maxLength: 10,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.netMonthlyIncome != null,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) =>
                _conditionalValidator(value, "Net Monthly Income is required"),
          ),

          // Net Monthly Expense
          LabeledTextField(
            label: "Net Monthly Expense",
            controller: netMonthlyExpenseController,
            isMandatory: true,
            maxLength: 10,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.empDetails?.netMonthlyExpense !=
                    null,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) =>
                _conditionalValidator(value, "Net Monthly Expense is required"),
          ),

          // Hire Date
          LabeledDateField(
            label: "Hire Date",
            controller: hireDate,
            // enabled: !widget.isCommDataPreFetched && widget.custRtlFormResponse.empDetails?.hiringDate!=null,
            enabled: !widget.isCommDataPreFetched,
            isMandatory: true,
            validator: (value) =>
                _conditionalValidator(value, "Hire Date is required"),
            lastDate: DateTime.now(),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onPrevious: widget.onPrevious,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}
