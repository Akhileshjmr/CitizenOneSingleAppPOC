import 'package:citizenone_app/modules/agency_banking/presentation/screens/Loans/application_form/widgets/LabeledRadioGroup.dart';
import 'package:flutter/material.dart';
import '../../../../../constants/controllers.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../../utils/UICleanupHelper.dart';
import '../widgets/labeled_dateField.dart';
import '../widgets/labeled_textField.dart';
import '../widgets/labeled_dropdown.dart';

class SavingsAccountForm extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const SavingsAccountForm({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<SavingsAccountForm> createState() => _SavingsAccountFormState();
}

class _SavingsAccountFormState extends State<SavingsAccountForm> {
  String? accountType;
  String? selectedCustomer;
  String? modeOfOperation;

  String? isVendorAccount; // "Yes"/"No"
  String? hasChequeBook;
  String? hasPassbook;
  String? hasATM;
  String? hasMobileBanking;
  String? hasSMSAlert;
  String? hasEmailAlert;
  final _formKey = GlobalKey<FormState>();
  final yesNoOptions = const ["Yes", "No"];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        child: Column(// 👈 attach form
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Savings Account Details',
            style: TextStyle(
              color: AppColors.fbLiteDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),

        LabeledDropdown<String>(
          label: "Account Type",
          value: accountType,
          items: ["Single", "Joint"],
          onChanged: (val) => setState(() => accountType = val),
          isMandatory: false,
        ),
        LabeledDateField(
          label: "Opening Date",
          controller: openingDate,
          isMandatory: true,
        ),
        LabeledTextField(
          label: "Opening Balance",
          controller: openingBalance,
          maxLength: 10,
          keyboardType: TextInputType.number,
          isMandatory: true,
    validator: (v) =>
    v == null || v.isEmpty ? "Opening Balance is required" : null,
        ),
        LabeledTextField(
          label: "Account Opening Charges",
          controller: accountOpeningCharges,
          maxLength: 10,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        LabeledDropdown<String>(
          label: "Mode of Operation",
          value: modeOfOperation,
          items: ["Single", "Joint", "Either or Survivor"],
          onChanged: (val) => setState(() => modeOfOperation = val),
        ),

        const SizedBox(height: 20),
        // ----------- Replace _buildRadioGroup with LabeledRadioGroup -----------
        LabeledRadioGroup<String>(
          label: "Is Vendor Account",
          options: yesNoOptions,
          value: isVendorAccount,
          onChanged: (val) => setState(() => isVendorAccount = val),
        ),
        LabeledRadioGroup<String>(
          label: "Cheque Book",
          options: yesNoOptions,
          value: hasChequeBook,
          onChanged: (val) => setState(() => hasChequeBook = val),
        ),
        LabeledRadioGroup<String>(
          label: "Passbook",
          options: yesNoOptions,
          value: hasPassbook,
          onChanged: (val) => setState(() => hasPassbook = val),
        ),
        LabeledRadioGroup<String>(
          label: "ATM",
          options: yesNoOptions,
          value: hasATM,
          onChanged: (val) => setState(() => hasATM = val),
        ),
        LabeledRadioGroup<String>(
          label: "Mobile Banking",
          options: yesNoOptions,
          value: hasMobileBanking,
          onChanged: (val) => setState(() => hasMobileBanking = val),
        ),
        LabeledRadioGroup<String>(
          label: "SMS Alerts",
          options: yesNoOptions,
          value: hasSMSAlert,
          onChanged: (val) => setState(() => hasSMSAlert = val),
        ),
        LabeledRadioGroup<String>(
          label: "Email Alerts",
          options: yesNoOptions,
          value: hasEmailAlert,
          onChanged: (val) => setState(() => hasEmailAlert = val),
        ),

        const SizedBox(height: 20),
    SafeArea(
    bottom: true, // ignore bottom SafeArea
    child: Row(
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
    backgroundColor: AppColors.btnBackground,
    foregroundColor: Colors.white,
    ),
    onPressed: () {
    if (_formKey.currentState?.validate() ?? false) {
    widget.onNext!(); // Proceed to next page
    } else {
    showCustomBottomPopup(
    context,
    "Please fill all mandatory fields",
    );
    }
    },
    child: const Text("Next"),
    ),

    ],
        ),
    )
      ],
        )
    );
  }
}


