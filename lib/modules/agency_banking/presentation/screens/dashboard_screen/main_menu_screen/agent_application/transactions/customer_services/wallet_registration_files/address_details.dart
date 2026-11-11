import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_controllers.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../../Loans/application_form/widgets/labeled_dropdown.dart';
import '../../../../../../Loans/application_form/widgets/labeled_textField.dart';


class AddressDetails extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;

  const AddressDetails({
    Key? key,
    required this.onNext,
    required this.lovValues, required this.onPrevious,
  }) : super(key: key);

  @override
  State<AddressDetails> createState() => _AddressDetailsState();
}

class _AddressDetailsState extends State<AddressDetails> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledDropdown<AbGenLovValDesc>(
          label: "Country Code",
          items: widget.lovValues["ab-country-codes"] ?? [],
          value: selectedCountryCode,
          display: (item) => item.val ?? "", // 👈 show description
          onChanged: (val) => setState(() => selectedCountryCode = val),
          isMandatory: true,
    validator: (value) => value == null  ? "Code  is required" : null,
        ),

        LabeledTextField(
          label: "Mobile Number",
          controller: mobileNumberController,
          isMandatory: true,
          maxLength: 10,
          keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => value == null  ? "Number  is required" : null,
        ),
        LabeledTextField(
          label: "Residential Number",
          controller: residentialNumberController,
          isMandatory: false,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        LabeledTextField(
          label: "Office Number",
          controller: officeNumberController,
          isMandatory: false,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        LabeledTextField(
          label: "House No",
          maxLength: 10,
          controller: houseNoController,
          isMandatory: true,
    validator: (value) => value == null  ? "House No is required" : null,
        ),
        LabeledTextField(
          label: "Sub City",
          maxLength: 15,
          controller: subCityController,
          isMandatory: true,
          validator: (value) => value == null  ? "Sub City  is required" : null,
        ),
        LabeledTextField(
          label: "City",
          maxLength: 15,
          controller: cityController,
          isMandatory: true,
          validator: (value) => value == null  ? "City  is required" : null,
        ),
        LabeledTextField(
          label: "Zip",
          maxLength: 6,
          controller: zipController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          isMandatory: true,
          validator: (value) => value == null  ? "Zip  is required" : null,
        ),

        LabeledDropdown<AbGenLovValDesc>(
          label: "Country",
          items: widget.lovValues["ab-cust-nationality"] ?? [],
          value: selectedCountry,
          display: (item) => item.desc ?? "", // 👈 show description
          onChanged: (val) => setState(() => selectedCountry = val),
          isMandatory: true,
    validator: (value) => value == null  ? "Country  is required" : null,
        ),

        const SizedBox(height: 20),
        FormButtons.navigation(
          context: context,
          formKey: _formKey,
          onPrevious: widget.onPrevious,
          onNext: widget.onNext,
        ),
      ],
        )
    );
  }
}
