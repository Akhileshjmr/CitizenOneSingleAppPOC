import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAddiInfoForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbLookupForm.dart';
import '../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../../utils/UICleanupHelper.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import 'labeled_dropdown.dart';
import 'labeled_textField.dart';

class AdditionalForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues ;
  final GdbCustRtlFormResponse custRtlFormResponse;
  final bool isCommDataPreFetched;
  const AdditionalForm({
    Key? key,
    required this.onPrevious,
    required this.onNext,
    required this.lovValues,
    required this.isCommDataPreFetched,
    required this.custRtlFormResponse,
  }) : super(key: key);

  static void submitAdditionalDetails(BuildContext context) {
    final req = GdbCustRtlAppRequest<GdbCustRtlForm>();
    req.screenId = 'MORE_INFO';
    req.isDraft = true;

    GdbCustRtlForm form = GdbCustRtlForm();
    form.phone=AESEncryptionService.encrypt(mobileNoController.text);

    GdbCustRtlAddiInfoForm addiInfoForm = GdbCustRtlAddiInfoForm();

    GdbLookupForm academicDeg = GdbLookupForm()..type = academicDegree.text;
    GdbLookupForm bankAccType = GdbLookupForm()..type = bankaccTypecontroller.text;
    GdbLookupForm existingAppCust = GdbLookupForm()..type = "NEW_CUSTOMER";
    GdbLookupForm levelOfEducation = GdbLookupForm()..type = selectedEducationLevel?.val;
    GdbLookupForm maritalStatus = GdbLookupForm()..type = selectedMaritalStatus?.val;
    GdbLookupForm nationalityOrResidency = GdbLookupForm()..type = selectedNationalityResidency?.val;
    GdbLookupForm noOfDependents = GdbLookupForm()..type = "1  -  3 ";
    GdbLookupForm profession = GdbLookupForm()..type = selectedProfession?.desc;
    GdbLookupForm residentialStatus = GdbLookupForm()..type =selectedResidentialStatus?.val;
    GdbLookupForm timeAtCurrAddress = GdbLookupForm()..type = "> 8_YEARS";
    GdbLookupForm timeWithCurrEmployer = GdbLookupForm()..type = "2  year";
    addiInfoForm.academicDeg = academicDeg;
    addiInfoForm.bankAccType = bankAccType;
    addiInfoForm.existingAppCust = existingAppCust;
    addiInfoForm.levelOfEducation = levelOfEducation;
    addiInfoForm.maritalStatus = maritalStatus;
    addiInfoForm.nationalityOrResidency = nationalityOrResidency;
    addiInfoForm.noOfDependents = noOfDependents;
    addiInfoForm.profession = profession;
    addiInfoForm.residentialStatus = residentialStatus;
    addiInfoForm.timeAtCurrAddress = timeAtCurrAddress;
    addiInfoForm.timeWithCurrEmployer = timeWithCurrEmployer;
    form.addiDet = addiInfoForm;
    req.customerDet = form;
    context.read<CustomerRegistrationBloc>().add(
      CustomerRegistrationSubmitted<GdbCustRtlForm>(req),
    );
  }

  @override
  State<AdditionalForm> createState() => _AdditionalFormState();
}

class _AdditionalFormState extends State<AdditionalForm> {
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
          // Bank Account Type
          LabeledTextField(
            label: "Bank Account Type",
            controller: bankaccTypecontroller,
            maxLength: 30,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched && widget.custRtlFormResponse.addiDet?.bankAccType!=null,
            validator: (value) => _conditionalValidator(value, "Bank Account Type is required"),
          ),

          // Residential Status
          LabeledDropdown<AbGenLovValDesc>(
            label: "Residential Status",
            items: widget.lovValues["ch-lov-residential-status"] ?? [],
            value: selectedResidentialStatus,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedResidentialStatus = val),
            isMandatory: true,
            validator: (value) => _conditionalValidator(value?.val, "Residential Status is required"),
          ),

          // Nationality/Residency
          LabeledDropdown<AbGenLovValDesc>(
            label: "Nationality/Residency",
            items: widget.lovValues["ch-lov-nationality-type"] ?? [],
            value: selectedNationalityResidency,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedNationalityResidency = val),
            isMandatory: true,
            validator: (value) => _conditionalValidator(value?.val, "Nationality/Residency is required"),
          ),

          // Marital Status
          LabeledDropdown<AbGenLovValDesc>(
            label: "Marital Status",
            items: widget.lovValues["ch-lov-marital-status"] ?? [],
            value: selectedMaritalStatus,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedMaritalStatus = val),
            isMandatory: true,
            validator: (value) => _conditionalValidator(value?.val, "Marital Status  is required"),

          ),

          // Profession
          LabeledDropdown<AbGenLovValDesc>(
            label: "Profession",
            items: widget.lovValues["ch-lov-profession"] ?? [],
            value: selectedProfession,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedProfession = val),
            isMandatory: true,
            validator: (value) => _conditionalValidator(value?.desc, "Profession is required"),
          ),

          // Level of Education
          LabeledDropdown<AbGenLovValDesc>(
            label: "Level Of Education",
            items: widget.lovValues["ch-lov-level-of-education"] ?? [],
            value: selectedEducationLevel,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedEducationLevel = val),
            isMandatory: true,
            validator: (value) => _conditionalValidator(value?.val, "Education Level is required"),
          ),

          // Academic Degree
          LabeledTextField(
            label: "Academic Degree",
            controller: academicDegree,
            maxLength: 30,
            readOnly: widget.isCommDataPreFetched && widget.custRtlFormResponse.addiDet?.academicDeg!=null,
            validator: (value) => _conditionalValidator(value, "Academic Degree is required"),
            isMandatory: true,
          ),

          const SizedBox(height: 20),

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
