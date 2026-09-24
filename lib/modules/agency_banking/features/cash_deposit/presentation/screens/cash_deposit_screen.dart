import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/cash_deposit_cubit.dart';
import '../cubit/cash_deposit_state.dart';
import '../widgets/cash_deposit_card.dart';
import 'package:citizenone_app/modules/agency_banking/theme/agency_banking_colors.dart';

class CashDepositScreen extends StatefulWidget {
  const CashDepositScreen({super.key});

  @override
  State<CashDepositScreen> createState() => _CashDepositScreenState();
}

class _CashDepositScreenState extends State<CashDepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController(text: '1002893847');
  final _amountController = TextEditingController(text: '500.00');
  final _depositorController = TextEditingController(text: 'Jane Doe');

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _depositorController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;
      context.read<CashDepositCubit>().submit(
            accountNumber: _accountController.text,
            amount: amount,
            depositorName: _depositorController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Deposit'),
        backgroundColor: AgencyBankingColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CashDepositCubit, CashDepositState>(
        builder: (context, state) {
          if (state is CashDepositLoading) {
            return const AppLoader(message: 'Processing Cash Deposit...');
          }

          if (state is CashDepositSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: CashDepositCard(
                entity: state.result,
                onNewTransaction: () {
                  context.read<CashDepositCubit>().reset();
                },
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is CashDepositFailure) ...[
                    AppErrorView(
                      message: state.errorMessage,
                      onRetry: _submit,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agent Cash Deposit Form',
                          style: AppTypography.title.copyWith(
                            color: AgencyBankingColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Customer Account Number',
                          controller: _accountController,
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(Icons.account_balance),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Enter account number'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Depositor Name',
                          controller: _depositorController,
                          prefixIcon: const Icon(Icons.person),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? 'Enter depositor name'
                              : null,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        AppTextField(
                          label: 'Deposit Amount (\$)',
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          prefixIcon: const Icon(Icons.attach_money),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty)
                              return 'Enter deposit amount';
                            final parsed = double.tryParse(val);
                            if (parsed == null || parsed <= 0)
                              return 'Enter a valid positive amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            label: 'Submit Cash Deposit',
                            backgroundColor: AgencyBankingColors.primary,
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
