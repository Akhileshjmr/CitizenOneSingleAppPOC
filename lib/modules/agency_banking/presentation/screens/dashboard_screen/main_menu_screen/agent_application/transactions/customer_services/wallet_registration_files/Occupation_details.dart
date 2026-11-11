import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/step_placeholder.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:citizenone_app/modules/agency_banking/utils/UICleanupHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../../../data/models/lov_models/AbGenLovValDesc.dart';
import '../../../../../../Loans/application_form/widgets/labeled_dropdown.dart';
import '../../../../../../Loans/application_form/widgets/labeled_textField.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/dashboard_screen/main_menu_screen/agent_application/transactions/customer_services/wallet_registration_files/wallet_controllers.dart';
import 'package:flutter/material.dart';

class OccupationDetails extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Map<String, List<DropdownMenuItem<AbGenLovValDesc>>> lovValues;

  const OccupationDetails({
    Key? key,
    required this.onNext,
    required this.lovValues, required this.onPrevious,
  }) : super(key: key);

  @override
  State<OccupationDetails> createState() => _OccupationDetailsState();
}

class _OccupationDetailsState extends State<OccupationDetails> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledTextField(
          label: "Designation",
          controller: designationController,
          maxLength: 15,
          isMandatory: false,
        ),
        LabeledTextField(
          label: "Employer",
          maxLength: 15,
          controller: employerController,
          isMandatory: false,
        ),
        LabeledTextField(
          label: "Average Monthly Income",
          controller: monthlyIncomeController,
          maxLength: 7,
          isMandatory: false,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        LabeledTextField(
          label: "Average Annual Income",
          controller: annualIncomeController,
          isMandatory: false,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Customer Type",
          items: widget.lovValues["wallet_cust_type"] ?? [],
          value: selectedCustType,
          display: (item) => item.desc ?? "", // 👈 show description
          onChanged: (val) => setState(() => selectedCustType = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "Account Type",
          items: widget.lovValues["ab_acc_type"] ?? [],
          value: selectedAccType,
          display: (item) => item.desc ?? "", // 👈 show description
          onChanged: (val) => setState(() => selectedAccType = val),
          isMandatory: true,
        ),
        LabeledDropdown<AbGenLovValDesc>(
          label: "ID Type",
          items: widget.lovValues["ab-sm-id-type"] ?? [],
          value: selectedIdType,
          display: (item) => item.desc ?? "", // 👈 show description
          onChanged: (val) => setState(() => selectedIdType = val),
          isMandatory: true,
        ),
        LabeledTextField(
          label: "ID Number",
          controller: idNumberController,
          isMandatory: true,
          maxLength: 7,
        ),
        LabeledTextField(
          label: "Issued By",
          controller: issuedByController,
          isMandatory: true,
          maxLength: 10,
        ),
        const SizedBox(height: 20),

        SafeArea(
          bottom: true, // ignore bottom SafeArea
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.btnBackground,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.onPrevious,
                child: const Text("Previous"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.btnBackground,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.onNext,

                child: const Text("Next"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
