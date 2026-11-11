import 'package:flutter/material.dart';
import 'package:citizenone_app/modules/agency_banking/constants/controllers.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lov_models/AbGenLovValDesc.dart';
import '../application_form/widgets/LabeledRadioGroup.dart';
import '../application_form/widgets/labeled_dropdown.dart';
import '../application_form/widgets/labeled_textField.dart';

class CashFlowStatementForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues ;
  const CashFlowStatementForm({Key? key, required this.onNext, required this.lovValues, required this.onPrevious}) : super(key: key);

  @override
  State<CashFlowStatementForm> createState() => _CashFlowStatementFormState();
}

class _CashFlowStatementFormState extends State<CashFlowStatementForm> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledRadioGroup<String>(
          label: "Track Limit",
          options: ["Yes", "No",],
          value: selectedGender,
          isMandatory: true,
          onChanged: (val) {
            setState(() {
              selectedGender = val;
              gender = val;
            });
          },
        ),
        LabeledTextField(label: "Liability Name", controller: liaNameController, isMandatory: true),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Liability Branch",
          items: widget.lovValues["ab-cust-brn"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Currency",
          items: widget.lovValues["ab-cust-currency"] ?? [],
          value: selectedNationality,
          display: (item) => item.val ?? "", // 👈 show value
          onChanged: (val) => setState(() => selectedNationality = val),
          isMandatory: true,
        ),
        LabeledTextField(label: "Eligibility Points", controller: tenureController, isMandatory: true),

        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
              ),
              onPressed: widget.onPrevious,
              child: const Text("Previous"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // or AppColors.primary
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onNext,
              child: const Text("Next"),
            ),
          ],
        ),
      ],
    );
  }
}
