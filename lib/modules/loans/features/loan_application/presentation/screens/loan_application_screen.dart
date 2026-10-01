import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/core/core.dart';
import '../cubit/loan_cubit.dart';
import '../cubit/loan_state.dart';

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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<LoanCubit, LoanState>(
      builder: (context, state) {
        if (state is LoanLoading) {
          return const AppLoader(message: 'Calculating credit eligibility...');
        }

        if (state is LoanSuccess) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars, size: 64, color: Colors.amber),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Loan Pre-Approved!',
                      style: AppTypography.title.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Loan Ref: ${state.loan.loanId}',
                        style: AppTypography.caption),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Principal: ${DateFormatter.formatCurrency(state.loan.requestedAmount)}',
                      style: AppTypography.body,
                    ),
                    Text(
                      'Tenure: ${state.loan.tenureMonths} Months',
                      style: AppTypography.body,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Est. Monthly Repayment: ${DateFormatter.formatCurrency(state.loan.monthlyRepayment)}',
                      style: AppTypography.subtitle.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Apply For Another Loan',
                      backgroundColor: primaryColor,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor.withValues(alpha: 0.15),
                          child: Icon(Icons.monetization_on, color: primaryColor),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Micro Loan Application',
                                style: AppTypography.title.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Instant credit decision with flexible repayment terms.',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Requested Loan Amount (\$)',
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icon(Icons.attach_money, color: primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedTenure,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Repayment Tenure (Months)',
                        prefixIcon: Icon(Icons.calendar_today_outlined, color: primaryColor),
                      ),
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
                        label: 'Submit Loan Application',
                        backgroundColor: primaryColor,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
