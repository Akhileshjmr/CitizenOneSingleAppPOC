import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/cash_deposit_cubit.dart';
import '../cubit/cash_deposit_state.dart';
import '../widgets/cash_deposit_card.dart';

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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<CashDepositCubit, CashDepositState>(
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
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Deposit funds instantly into customer bank account.',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Customer Account Number',
                        controller: _accountController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(Icons.account_balance, color: primaryColor),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Enter account number'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        label: 'Depositor Name',
                        controller: _depositorController,
                        prefixIcon: Icon(Icons.person, color: primaryColor),
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
                        prefixIcon: Icon(Icons.attach_money, color: primaryColor),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Enter deposit amount';
                          }
                          final parsed = double.tryParse(val);
                          if (parsed == null || parsed <= 0) {
                            return 'Enter a valid positive amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: 'Submit Cash Deposit',
                          backgroundColor: primaryColor,
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
    );
  }
}
