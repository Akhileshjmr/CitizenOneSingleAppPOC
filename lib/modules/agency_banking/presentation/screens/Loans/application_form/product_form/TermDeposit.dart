import 'package:flutter/material.dart';
import '../../../../../constants/AppStrings.dart';
import '../../../../../constants/controllers.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../../../../utils/UICleanupHelper.dart';
import '../widgets/LabeledRadioGroup.dart';
import '../widgets/labeled_dateField.dart';
import '../widgets/labeled_textField.dart';
import '../widgets/labeled_dropdown.dart';


class TermDepositForm extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const TermDepositForm({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<TermDepositForm> createState() => _TermDepositFormState();
}

class _TermDepositFormState extends State<TermDepositForm> {
  bool hasNominee = true;
  bool isExistingNominee = true;

  String? customerType;
  String? customer;
  String? customerName;
  String? product;
  String? productName;
  String? bookingBy;
  String? draweeAccountNo;
  String? accountName;
  String? relationship;
  DateTime? selectedValueDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'TD Account Opening',
            style: TextStyle(
              color: AppColors.fbLiteDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),

        LabeledDropdown<String>(
          label: AppStrings.customerType,
          value: customerType,
          items: ['Individual', 'Corporate'],
          onChanged: (val) => setState(() => customerType = val),
          isMandatory: true,
        ),
        LabeledDropdown<String>(
          label: AppStrings.customer,
          value: customer,
          items: ['John Doe', 'Jane Smith'],
          onChanged: (val) => setState(() => customer = val),
          isMandatory: true,
        ),
        LabeledTextField(
          label: AppStrings.customerName,
          controller: customerNameController,
        ),
        LabeledDropdown<String>(
          label: AppStrings.product,
          value: product,
          items: ['Fixed Deposit', 'Recurring Deposit'],
          onChanged: (val) => setState(() => product = val),
        ),
        LabeledTextField(
          label: AppStrings.productName,
          controller: productNameController,
        ),
        LabeledDropdown<String>(
          label: AppStrings.bookingBy,
          value: bookingBy,
          items: ['Branch', 'Online'],
          onChanged: (val) => setState(() => bookingBy = val),
        ),
        LabeledDropdown<String>(
          label: AppStrings.draweeCasaAccountNumber,
          value: draweeAccountNo,
          items: ['1234567890', '9876543210'],
          onChanged: (val) => setState(() => draweeAccountNo = val),
        ),
        LabeledTextField(
          label: AppStrings.accountName,
          controller: accountNameController,
        ),
        LabeledDateField(
          label: AppStrings.valueDate, controller: valueDateController, isMandatory: true,),

        const SizedBox(height: 20),

        const Center(
          child: Text(
            'Nominee',
            style: TextStyle(
              color: AppColors.fbTooLite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LabeledRadioGroup<bool>(
          label: AppStrings.nominee,
          options: const [true, false],
          value: hasNominee,
          onChanged: (val) => setState(() => hasNominee = val ?? true),
          labelBuilder: (v) => v ? "Yes" : "No",
        ),
        LabeledRadioGroup<bool>(
          label: AppStrings.isExistingNominee,
          options: const [true, false],
          value: isExistingNominee,
          onChanged: (val) => setState(() => isExistingNominee = val ?? true),
          labelBuilder: (v) => v ? "Yes" : "No",
        ),

        if (hasNominee) ...[
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Nominee Details',
              style: TextStyle(
                color: AppColors.fbTooLite,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          LabeledDropdown<String>(
            label: AppStrings.customerId,
            value: customer,
            items: ['CUST001', 'CUST002'],
            onChanged: (val) => setState(() => customer = val),
          ),
          LabeledTextField(
            label: AppStrings.customerName,
            controller: customerNameController,
          ),
          LabeledDateField(
            label: AppStrings.dob, controller: dobController, isMandatory: true,),
          LabeledTextField(
            label: AppStrings.address,
            controller: addressController,
          ),
          LabeledDropdown<String>(
            label: AppStrings.relationship,
            value: relationship,
            items: ['Spouse', 'Child', 'Parent'],
            onChanged: (val) => setState(() => relationship = val),
          ),
        ],

        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Deposit Details',
            style: TextStyle(
              color: AppColors.fbTooLite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LabeledTextField(
          label: AppStrings.initialDepositAmount,
          controller: initialDepositAmountController,
        ),
        LabeledTextField(
          label: AppStrings.depositTenorMonths,
          controller: depositTenorMonthsController,
        ),
        LabeledTextField(
          label: AppStrings.spread,
          controller: spreadController,
        ),
        LabeledTextField(
          label: AppStrings.appliedInterestRate,
          controller: appliedInterestRateController,
        ),
      ],
    );
  }
}

