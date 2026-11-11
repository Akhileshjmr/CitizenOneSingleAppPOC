import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/NationalIdFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustGenDetForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustSearchRequest.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbLookupForm.dart';
import '../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import '../../../../blocs/lms_blocs/customer_search/customer_search_bloc.dart';
import '../../../../blocs/lms_blocs/customer_search/customer_search_event.dart';
import 'LabeledRadioGroup.dart';
import 'labeled_dateField.dart';
import 'labeled_dropdown_search.dart';
import 'labeled_textField.dart';

class GeneralDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;
  final bool isCommDataPreFetched;
  const GeneralDetailsForm(
      {Key? key,
      required this.onNext,
      required this.lovValues,
      required this.isCommDataPreFetched})
      : super(key: key);

  static void submitGenDetails(BuildContext context) {
    if (mobileNoController.text.isEmpty) {
      showCustomBottomPopup(context, "Mobile Number is required");
      return;
    }
    if (mobileNoController.length != 9) {
      showCustomBottomPopup(context, "Enter a valid 9 digit mobile number");
      return;
    }
    if (nationalIdController.length != 14) {
      showCustomBottomPopup(context, "Enter a valid 14 digit national id");
      return;
    }
    final req = GdbCustRtlAppRequest<GdbCustRtlForm>();
    req.screenId = 'PERSONAL_DETAILS';
    req.isDraft = true;

    GdbCustRtlForm form = GdbCustRtlForm();
    form.genDet = GdbCustGenDetForm();

    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd/MM/yyyy');
    DateTime parsedDate = inputFormat.parse(dofbController.text);
    String formattedDob = outputFormat.format(parsedDate);

    form.genDet?.dob = formattedDob;
    form.phone = AESEncryptionService.encrypt(mobileNoController.text);
    form.genDet?.emailAddress =
        AESEncryptionService.encrypt(emailController.text);
    form.genDet?.firstName = fNameController.text;
    form.genDet?.middleName = middleNameController.text;
    form.genDet?.lastName = lController.text;
    form.genDet?.fullName = fullNameController.text;
    form.genDet?.pNumber =
        AESEncryptionService.encrypt(mobileNoController.text);

    // 🔹 Gender will be set via widget state
    form.genDet?.gender = gender;

    form.genDet?.nationalIdNo =
        AESEncryptionService.encrypt(nationalIdController.text);
    DateTime parsed = inputFormat.parse(dateofExpiryController.text);
    String formatted = outputFormat.format(parsed);

    form.genDet?.nationalIdDoe = formatted;

    req.customerDet = form;

    GdbLookupForm nationality = GdbLookupForm();
    nationality.type = selectedNationality?.desc;
    form.genDet?.nationality = nationality;

    AppLogger.debug('Submitting general details');

    context.read<CustomerRegistrationBloc>().add(
          CustomerRegistrationSubmitted<GdbCustRtlForm>(req),
        );
  }

  @override
  State<GeneralDetailsForm> createState() => _GeneralDetailsFormState();
}

class _GeneralDetailsFormState extends State<GeneralDetailsForm> {
  void initState() {
    super.initState();
    AppLogger.debug('General form initialized');
  }

  final _formKey = GlobalKey<FormState>();

  void customerSearch(BuildContext context) {
    if (mobileNoController.text.isEmpty) {
      showCustomBottomPopup(context, "Mobile Number is required");
      return;
    }
    if (mobileNoController.length != 9) {
      showCustomBottomPopup(context, "Enter a valid 9 digit mobile number");
      return;
    }
    GdbCustSearchRequest request = GdbCustSearchRequest();
    request.mobileNumber =
        AESEncryptionService.encrypt(mobileNoController.text);
    context.read<CustomerSearchBloc>().add(CustomerSearchSubmitted(request));
  }

  String? _conditionalValidator(String? value, String errorMsg) {
    if (widget.isCommDataPreFetched) return null; // skip validation
    if (value == null || value.isEmpty) return errorMsg;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 👈 attach form
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            label: "Mobile Number",
            keyboardType: TextInputType.number,
            controller: mobileNoController,
            isMandatory: true,
            maxLength: 9,
            allowedPattern: r'[0-9]',
            readOnly: widget.isCommDataPreFetched,
            validator: (value) {
              if (!widget.isCommDataPreFetched) {
                return (value == null || value.isEmpty)
                    ? "Mobile Number is required"
                    : null;
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: AppColors.fbTooLite),
              onPressed: () {
                customerSearch(context);
                AppLogger.debug('Customer search initiated');
              },
            ),
          ),
          LabeledTextField(
            label: "First Name",
            controller: fNameController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched,
            maxLength: 30,
            validator: (value) =>
                _conditionalValidator(value, "First Name Number is required"),
          ),
          LabeledTextField(
            label: "Middle Name",
            controller: middleNameController,
            readOnly: widget.isCommDataPreFetched,
            isMandatory: false,
            maxLength: 30,
          ),
          LabeledTextField(
            label: "Last Name",
            controller: lController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched,
            maxLength: 30,
            validator: (value) =>
                value == null || value.isEmpty ? "Last Name is required" : null,
          ),
          LabeledTextField(
            label: "Full Name",
            controller: fullNameController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched,
            maxLength: 30,
            validator: (value) =>
                value == null || value.isEmpty ? "Full Name is required" : null,
          ),
          LabeledDateField(
            label: "Date of Birth",
            controller: dofbController,
            isMandatory: true,
            enabled: !widget.isCommDataPreFetched,
            validator: (value) => value == null || value.isEmpty
                ? "Date of Birth is required"
                : null,
            lastDate: DateTime.now(),
          ),
          LabeledTextField(
            label: "Email ID",
            controller: emailController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched,
            maxLength: 30,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }

              // Email regex validation
              final emailRegex =
                  RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

              if (!emailRegex.hasMatch(value)) {
                return "Enter a valid email address";
              }
              return null;
            },
          ),

          // 🔹 Radio Group for Gender
          LabeledRadioGroup<String>(
            label: "Gender",
            options: ["Male", "Female"],
            value: selectedGender,
            isMandatory: true,
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) {
              setState(() {
                selectedGender = val;
                gender = val;
              });
            },
            validator: (value) =>
                _conditionalValidator(value, "Gender is required"),
          ),

          LabeledDropdownSearch<AbGenLovValDesc>(
            label: "Nationality",
            items: widget.lovValues["ch-lov-nationality"]
                    ?.map((e) => e.value!)
                    .toList() ??
                [],
            value: selectedNationality,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedNationality = val),
            isMandatory: true,
            validator: (value) =>
                value == null ? "Nationality is required" : null,
          ),
          LabeledTextField(
            label: "National ID",
            controller: nationalIdController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched,
            keyboardType: TextInputType.number,
            maxLength: 14,
            inputFormatters: [
              NationalIdFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "National ID is required";
              }

              if (value.length != 14) {
                return "Please enter a valid National ID";
              }

              return null;
            },
          ),
          LabeledDateField(
            label: "National ID Expiry Date",
            controller: dateofExpiryController,
            isMandatory: true,
            enabled: !widget.isCommDataPreFetched,
            firstDate: DateTime.now(),
            validator: (value) => _conditionalValidator(
                value, "National ID Expiry Date is required"),
          ),

          const SizedBox(height: 20),
          FormButtons.navigation(
            context: context,
            formKey: _formKey,
            onNext: widget.onNext,
          ),
        ],
      ),
    );
  }
}
