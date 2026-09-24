import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/core.dart';
import '../cubit/loan_cubit.dart';
import '../cubit/loan_state.dart';
import 'package:citizenone_app/modules/loans/theme/loans_colors.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _amountController = TextEditingController(text: '2500.00');
  int _selectedTenure = 12;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    context.read<LoanCubit>().submitLoanApplication(
          amount: amount,
          tenureMonths: _selectedTenure,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micro Loans Portal'),
        backgroundColor: LoansColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const ModuleSwitcherBar(currentModuleId: 'loans'),
          Expanded(
            child: BlocBuilder<LoanCubit, LoanState>(
              builder: (context, state) {
          if (state is LoanLoading) {
            return const AppLoader(
                message: 'Calculating credit eligibility...');
          }

          if (state is LoanSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.stars,
                          size: 64, color: LoansColors.accent),
                      const SizedBox(height: AppSpacing.md),
                      Text('Loan Pre-Approved!',
                          style: AppTypography.title
                              .copyWith(color: LoansColors.primary)),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Loan Ref: ${state.loan.loanId}',
                          style: AppTypography.caption),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                          'Principal: ${DateFormatter.formatCurrency(state.loan.requestedAmount)}',
                          style: AppTypography.body),
                      Text('Tenure: ${state.loan.tenureMonths} Months',
                          style: AppTypography.body),
                      Text(
                          'Est. Monthly Repayment: ${DateFormatter.formatCurrency(state.loan.monthlyRepayment)}',
                          style: AppTypography.subtitle.copyWith(
                              color: LoansColors.primary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Apply For Another Loan',
                        backgroundColor: LoansColors.primary,
                        onPressed: () => context.read<LoanCubit>().reset(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Micro Loan Application',
                      style: AppTypography.title
                          .copyWith(color: LoansColors.primary)),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Loan Amount (\$)',
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.monetization_on),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedTenure,
                    decoration: const InputDecoration(
                        labelText: 'Repayment Tenure (Months)'),
                    items: const [
                      DropdownMenuItem(value: 6, child: Text('6 Months')),
                      DropdownMenuItem(value: 12, child: Text('12 Months')),
                      DropdownMenuItem(value: 24, child: Text('24 Months')),
                      DropdownMenuItem(value: 36, child: Text('36 Months')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTenure = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Submit Loan Request',
                      backgroundColor: LoansColors.primary,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  ],
),
    );
  }
}
