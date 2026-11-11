import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_controllers.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/CommSuccessDialogues.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../../Loans/application_form/widgets/labeled_dateField.dart';
import '../../../../../../Loans/application_form/widgets/labeled_dropdown.dart';
import '../../../../../../Loans/application_form/widgets/labeled_textField.dart';


class BasicDetails extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;

  const BasicDetails({
    Key? key,
    required this.onNext,
    required this.lovValues,
  }) : super(key: key);

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey, // 👈 attach form
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledTextField(
              label: "First Name",
              controller: fNameController,
              isMandatory: true,
          maxLength: 10,
          validator: (value) => value == null || value.isEmpty ? "First Name is required" : null,
        ),
            LabeledTextField(
              label: "Middle Name",
              maxLength: 10,
              controller: mNameController,
              isMandatory: false,
            ),
            LabeledTextField(
              label: "Last Name",
              maxLength: 10,
              controller: lNameController,
              isMandatory: true,
              validator: (value) => value == null || value.isEmpty ? "last Name is required" : null,

            ),
            LabeledDateField(
              label: "Date of Birth",
              controller: dobController,
              isMandatory: true,
              validator: (value) => value == null || value.isEmpty ? "Dob is required" : null,
              lastDate: DateTime.now(),
            ),

            LabeledDropdown<AbGenLovValDesc>(
              label: "Gender",
              items: widget.lovValues["ab-cust-gender"] ?? [],
              value: selectedGender,
              display: (item) => item.desc ?? "", // 👈 show description
              onChanged: (val) => setState(() => selectedGender = val),
              isMandatory: true,
              validator: (value) => value == null  ? "Gender  is required" : null,
            ),

            LabeledDropdown<AbGenLovValDesc>(
              label: "Nationality",
              items: widget.lovValues["ab-cust-nationality"] ?? [],
              value: selectedNationality,
              display: (item) => item.desc ?? "", // 👈 show description
              onChanged: (val) => setState(() => selectedNationality = val),
              isMandatory: true,
              validator: (value) => value == null  ? "Country  is required" : null,
            ),

            const SizedBox(height: 20),
            FormButtons.navigation(
              context: context,
              formKey: _formKey,
              onNext: widget.onNext,
            ),
          ],
        )
    );
  }
}
