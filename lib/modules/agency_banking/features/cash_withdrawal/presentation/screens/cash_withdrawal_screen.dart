import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class CashWithdrawalScreen extends StatefulWidget {
  const CashWithdrawalScreen({super.key});

  @override
  State<CashWithdrawalScreen> createState() => _CashWithdrawalScreenState();
}

class _CashWithdrawalScreenState extends State<CashWithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController(text: '1002893847');
  final _amountController = TextEditingController(text: '200.00');
  final _otpController = TextEditingController(text: '882194');
  bool _isSuccess = false;
  String _txnId = '';

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSuccess = true;
      _txnId = 'TXN-WTH-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (_isSuccess) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Withdrawal Completed',
                  style: AppTypography.title.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Transaction ID: $_txnId', style: AppTypography.caption),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Account Number:', style: AppTypography.body),
                    Text('******${_accountController.text.substring(_accountController.text.length - 4)}', style: AppTypography.subtitle),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Amount Paid Out:', style: AppTypography.body),
                    Text('ZMW ${_amountController.text}', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'New Withdrawal',
                    backgroundColor: primaryColor,
                    onPressed: () {
                      setState(() {
                        _isSuccess = false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: () => context.go('/agency-banking'),
                  child: const Text('Back to Banking Hub'),
                ),
              ],
            ),
          ),
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
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agent Cash Withdrawal',
                    style: AppTypography.title.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Process customer cash payout with OTP authorization.',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Customer Account Number',
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.account_balance, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter account number' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Withdrawal Amount (ZMW)',
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.money_off, color: primaryColor),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Enter amount';
                      final parsed = double.tryParse(val);
                      if (parsed == null || parsed <= 0) return 'Enter valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Customer One-Time PIN (OTP)',
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(Icons.pin, color: primaryColor),
                    validator: (val) => val == null || val.trim().length < 4 ? 'Enter 6-digit OTP' : null,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Authorize & Dispense Cash',
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
  }
}

