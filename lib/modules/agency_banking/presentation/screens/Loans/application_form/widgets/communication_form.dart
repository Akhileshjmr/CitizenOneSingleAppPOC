import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustAddressForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlCommDetForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlForm.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbCustRtlFormResponse.dart';
import '../../../../../data/models/lms_models/customer_registration_models/GdbLookupForm.dart';
import '../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../utils/AESEncryption.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_bloc.dart';
import '../../../../blocs/lms_blocs/customer_registration_bloc/customer_registration_event.dart';
import 'labeled_dropdown_search.dart';
import 'labeled_textField.dart';

class CommunicationForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool isCommDataPreFetched;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;
  final GdbCustRtlFormResponse custRtlFormResponse;
  const CommunicationForm({
    Key? key,
    required this.onPrevious,
    required this.onNext,
    required this.lovValues,
    required this.isCommDataPreFetched,
    required this.custRtlFormResponse,
  }) : super(key: key);

  static void submitCommunicationDetails(BuildContext context) {
    if (emergencyPhoneController.length != 9) {
      showCustomBottomPopup(context, "Enter a valid 9 digit mobile number");
      return;
    }
    // setState(() {
    //   _isCustomerRegistrationSuccessful = false;
    // });
    final req = GdbCustRtlAppRequest<GdbCustRtlForm>();
    GdbCustRtlForm custRtlForm = GdbCustRtlForm();
    req.screenId = 'CONTACT_INFO';
    req.isDraft = true;
    custRtlForm.phone = AESEncryptionService.encrypt(mobileNoController.text);
    // custRtlForm.genDet=genDetForm;
    // GdbCustGenDetForm genDetForm=GdbCustGenDetForm();
    // genDetForm.emailAddress=
    GdbCustRtlCommDetForm commDetForm = GdbCustRtlCommDetForm();
    GdbCustAddressForm addressForm = GdbCustAddressForm();
    addressForm.addressLine = addresscontroller.text;
    addressForm.phNum = mobileNoController.text;
    addressForm.emailAddress = emailController.text;
    addressForm.emerContactPhNum = emergencyPhoneController.text;
    addressForm.emerContactPerson = emergencyContactPersonController.text;
    addressForm.buildingNo = buildingNoController.text;
    // addressForm.streatNumber=streetNumberController.text;
    // addressForm.distictName=districtController.text;
    // addressForm.flatNumber=flatNumberController.text;
    // addressForm.floorNumber=floorNumberController.text;
    GdbLookupForm city = GdbLookupForm();
    city.id = int.tryParse(selectedCity?.val ?? '');
    GdbLookupForm area = GdbLookupForm();
    area.id = int.tryParse(selectedArea?.val ?? '');
    // GdbLookupForm city=GdbLookupForm();
    // city.id=128477;
    // GdbLookupForm area=GdbLookupForm();
    // area.id=1005;
    addressForm.city = city;
    addressForm.area = area;
    commDetForm.primaryAddress = addressForm;
    custRtlForm.commDet = commDetForm;
    req.customerDet = custRtlForm;
    AppLogger.debug('Submitting communication details');
    AppLogger.debug('Communication request prepared');
    AppLogger.debug('Communication form submission in progress');
    context.read<CustomerRegistrationBloc>().add(
          CustomerRegistrationSubmitted<GdbCustRtlForm>(req),
        );
  }

  @override
  State<CommunicationForm> createState() => _CommunicationFormState();
}

class _CommunicationFormState extends State<CommunicationForm> {
  String? _conditionalValidator(String? value, String errorMsg) {
    if (widget.isCommDataPreFetched) return null; // skip validation
    if (value == null || value.isEmpty) return errorMsg;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledTextField(
            label: "Address",
            controller: addresscontroller,
            isMandatory: true,
            maxLength: 30,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.commDet?.primaryAddress
                        ?.addressLine !=
                    null,
            validator: (value) =>
                _conditionalValidator(value, "Address is required"),
          ),
          LabeledDropdownSearch<AbGenLovValDesc>(
            label: "City",
            items: widget.lovValues["ch-lov-city"]
                    ?.map((e) => e.value!)
                    .toList() ??
                [],
            value: selectedCity,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedCity = val),
            isMandatory: true,
            validator: (value) => value == null ? "City is required" : null,
          ),
          LabeledDropdownSearch<AbGenLovValDesc>(
            label: "Area",
            items: widget.lovValues["ch-lov-area"]
                    ?.map((e) => e.value!)
                    .toList() ??
                [],
            value: selectedArea,
            display: (item) => item.desc ?? "",
            enabled: !widget.isCommDataPreFetched,
            onChanged: (val) => setState(() => selectedArea = val),
            isMandatory: true,
            validator: (value) => value == null ? "Area is required" : null,
          ),
          LabeledTextField(
            label: "Emergency Contact Person",
            controller: emergencyContactPersonController,
            isMandatory: true,
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.commDet?.primaryAddress
                        ?.emerContactPerson !=
                    null,
            validator: (value) => value == null || value.isEmpty
                ? "Emergency Contact Person is required"
                : null,
            maxLength: 30,
          ),
          LabeledTextField(
            label: "Emergency Phone",
            controller: emergencyPhoneController,
            keyboardType: TextInputType.phone,
            isMandatory: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 9,
            allowedPattern: r'[0-9]',
            readOnly: widget.isCommDataPreFetched &&
                widget.custRtlFormResponse.commDet?.primaryAddress
                        ?.emerContactPhNum !=
                    null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Emergency Phone is required";
              }
              return null;
            },
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
