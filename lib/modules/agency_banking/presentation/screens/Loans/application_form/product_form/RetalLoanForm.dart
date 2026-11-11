import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/loan_product_models/CollateralDetailsReqRes.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/lms_models/loan_product_models/CollateralPoolNameList.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/collatral_bloc/collateral_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/collatral_bloc/collateral_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/lms_blocs/collatral_bloc/collateral_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/controllers.dart';
import '../../../../../data/models/lms_models/emi_calculation_models/GdbChScoreReqRes.dart';
import '../../../../../data/models/lms_models/emi_calculation_models/L2lEmiCalculateRequest.dart';
import '../../../../../theme/colors/Appcolors.dart';
import '../../../../../utils/CommSuccessDialogues.dart';
import '../../../../blocs/lms_blocs/eligibility_score_bloc/eligibility_score_bloc.dart';
import '../../../../blocs/lms_blocs/eligibility_score_bloc/eligibility_score_event.dart';
import '../../../../blocs/lms_blocs/emi_calculation_bloc/emi_calculation_bloc.dart';
import '../../../../blocs/lms_blocs/emi_calculation_bloc/emi_calculation_event.dart';
import '../widgets/labeled_dropdown.dart';
import '../widgets/labeled_textField.dart';

class LoanForm extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String? productId;

  const LoanForm({
    super.key,
    required this.onPrevious,
    required this.onNext,
    this.productId,
  });

  @override
  State<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  bool isCalculatingEmi = false;
  bool isScoreCheck = false;
  List<CollateralPoolNameList> collateralList = [];
  String? selectedCollateralCode; // store CODE
  CollateralPoolNameList? selectedCollateral;

  @override
  void initState() {
    super.initState();
    CollateralDetailsReqRes req = CollateralDetailsReqRes();
    req.collateralType = null;
    context.read<CollateralBloc>().add(
          CollateralSubmitted(req),
        );
  }

  final _formKey = GlobalKey<FormState>();
  void emi_calci(BuildContext context) {
    L2lEmiCalculateRequest emiCalculateRequest = L2lEmiCalculateRequest();
    emiCalculateRequest.loanAmount = double.tryParse(amountController.text);
    emiCalculateRequest.intCalcMethod = "THIRTY_ONE_BY_THREE_SXTY";
    emiCalculateRequest.interestRateList = [9.5];
    final String tenureText = tenureMonthsController.text.trim();
    final int? tenureMonths = int.tryParse(tenureText);

    if (tenureMonths == null) {
      AppLogger.debug('Invalid tenure input');
      return;
    }

    AppLogger.debug('Tenure validated successfully');
    emiCalculateRequest.tenorList = [tenureMonths];

    context.read<EmiCalculationBloc>().add(
          EmiCalculationSubmitted(emiCalculateRequest),
        );
  }

  void score_calci(BuildContext context) {
    GdbChScoreReqRes req = GdbChScoreReqRes();
    // req.customerCode=customerCode;
    context.read<EligibilityScoreBloc>().add(
          EligibilityScoreSubmitted(req),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CollateralBloc, CollateralState>(
      listener: (context, state) {
        if (state is CollateralSuccess) {
          setState(() {
            collateralList = state.collateralDetailsReqRes.lstCollateral ?? [];
          });
        }
      },
      child: BlocBuilder<CollateralBloc, CollateralState>(
          builder: (context, state) {
        return Form(
            key: _formKey, // 👈 attach form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Loan Details',
                    style: TextStyle(
                      color: AppColors.fbTooLite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Loan Fields
                LabeledTextField(
                  label: "Tenure (Months)",
                  controller: tenureMonthsController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  isMandatory: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Tenure is required" : null,
                ),

                LabeledTextField(
                  label: "Amount",
                  controller: amountController,
                  isMandatory: true,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Amount is required" : null,
                ),
                LabeledTextField(
                  label: "Down Payment Amount",
                  controller: downPaymentAmountController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                LabeledDropdown<String>(
                  label: "EMI Frequency",
                  items: ["Monthly", "Weekly", "Quarterly"],
                  //value: "Monthly",
                  onChanged: (val) {
                    AppLogger.debug('EMI frequency selected');
                  },
                ),
                LabeledDropdown(
                  label: "Collateral Name",
                  value: selectedCollateral?.collateralName,
                  // dropdown shows NAME
                  items: collateralList
                      .where(
                          (c) => c.collateralName != null) // only valid names
                      .map((c) => c.collateralName!) // pass names only (String)
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      // find the object by name
                      selectedCollateral = collateralList.firstWhere(
                        (c) => c.collateralName == val,
                        orElse: () => CollateralPoolNameList(),
                      );
                      selectedCollateralCode =
                          selectedCollateral?.collateralCode;
                    });

                    AppLogger.debug('Collateral name selected');
                    AppLogger.debug('Collateral code resolved');
                  },
                ),

                const SizedBox(height: 20),

                // EMI Calculator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "EMI Calculator",
                        style: TextStyle(
                          color: AppColors.fbTooLite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: "Calculate EMI",
                      onPressed: isCalculatingEmi
                          ? null
                          : () async {
                              final amountText = amountController.text.trim();
                              final tenureText =
                                  tenureMonthsController.text.trim();

                              final amountVal = double.tryParse(amountText);
                              final tenureVal = int.tryParse(tenureText);

                              if (amountVal == null || tenureVal == null) {
                                showCustomBottomPopup(
                                    context, "Please Enter Amount & Tenure");
                                return;
                              }

                              setState(() {
                                isCalculatingEmi = true;
                              });
                              try {
                                emi_calci(context);
                              } finally {
                                setState(() {
                                  isCalculatingEmi = false;
                                });
                              }
                            },
                      icon: isCalculatingEmi
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.calculate, color: AppColors.fbTooLite),
                    ),
                  ],
                ),

                LabeledTextField(
                  label: "EMI",
                  controller: emiController,
                  readOnly: true,
                  isMandatory: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? "EMI is required" : null,
                ),

                const SizedBox(height: 10),

                // Score Section
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Check Score",
                        style: TextStyle(
                          color: AppColors.fbTooLite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: "Calculate Score",
                      onPressed: isScoreCheck
                          ? null
                          : () async {
                              setState(() {
                                isScoreCheck = true;
                              });
                              try {
                                score_calci(context);
                              } finally {
                                setState(() {
                                  isScoreCheck = false;
                                });
                              }
                            },
                      icon: isScoreCheck
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.calculate, color: AppColors.fbTooLite),
                    ),
                  ],
                ),

                LabeledTextField(
                  label: "Score",
                  controller: scoreController,
                  readOnly: true,
                  isMandatory: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? "Score is required" : null,
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
                            widget.onNext(); // Proceed to next page
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
            ));
      }),
    );
  }
}
