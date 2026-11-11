import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/constants/controllers.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbGenLovValDesc.dart';
import '../application_form/widgets/LabeledRadioGroup.dart';
import '../application_form/widgets/labeled_dateField.dart';
import '../application_form/widgets/labeled_dropdown.dart';
import '../application_form/widgets/labeled_textField.dart';

class CompanyDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues ;
  const CompanyDetailsForm({Key? key, required this.onNext, required this.lovValues}) : super(key: key);

  @override
  State<CompanyDetailsForm> createState() => _CompanyDetailsFormState();
}

class _CompanyDetailsFormState extends State<CompanyDetailsForm> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextField(label: "Customer Type", controller: customerTypeController, isMandatory: true),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Customer Category",
          items: widget.lovValues["ab-cust-category"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Language",
          items: widget.lovValues["ab-cust-language"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Title",
          items: widget.lovValues["ab-cust-title"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledTextField(label: "First Name", controller: firstNameController, isMandatory: true),
        LabeledTextField(label: "Middle Name", controller: middleNameController, isMandatory: true),
        LabeledTextField(label: "Last Name", controller: lastNameController, isMandatory: true),
        LabeledTextField(label: "Short Name", controller: shortNameController, isMandatory: true),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Nationality",
          items: widget.lovValues["ab-cust-nationality"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Gender",
          items: widget.lovValues["ab-cust-gender"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDateField(label: "Date of Birth", controller: dofbController, isMandatory: true,),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Birth Country",
          items: widget.lovValues["ab-cust-nationality"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledTextField(label: "Birth Place", controller: birthPlaceController, isMandatory: true),
        LabeledTextField(label: "National Id", controller: nationalIdController, isMandatory: true),
        LabeledTextField(label: "Passport Number", controller: passportNoController, isMandatory: true),
        LabeledDateField(label: "Passport Issue Date", controller: dofbController, isMandatory: true,),
        LabeledDateField(label: "Passport Expiry Date", controller: dofbController, isMandatory: true,),

        // 🔹 Radio Group for Gender
        LabeledRadioGroup<String>(
          label: "Resident status",
          options: ["Permanent US Resident Status", "Visited US in the last 3 years",],
          value: selectedGender,
          isMandatory: true,
          onChanged: (val) {
            setState(() {
              selectedGender = val;
              gender = val;
            });
          },
        ),

        LabeledTextField(label: "Email ID", controller: emailIdController, isMandatory: true),
        LabeledDateField(
          label: "Mobile No", controller: mobileNoController, isMandatory: true,),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Mobile ISD Code",
          items: widget.lovValues["ab-country-codes"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Marital Status",
          items: widget.lovValues["ab-marital-status"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Communication",
          items: widget.lovValues["ab-cust-comm-mode"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Media",
          items: widget.lovValues["ab-cust-media"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledTextField(label: "KYC Reference Number", controller: emailIdController, isMandatory: true),
        LabeledTextField(label: "KYC Reference", controller: emailIdController, isMandatory: true),

        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: widget.onNext,
            child: const Text("Next"),
          ),
        ),
      ],
    );
  }
}
