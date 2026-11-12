import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class CustomerOnboardingScreen extends StatefulWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  State<CustomerOnboardingScreen> createState() => _CustomerOnboardingScreenState();
}

class _CustomerOnboardingScreenState extends State<CustomerOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nrcController = TextEditingController(text: '394821/11/1');
  final _fullNameController = TextEditingController(text: 'Chileshe Mwamba');
  final _phoneController = TextEditingController(text: '0977123456');
  final _initialDepositController = TextEditingController(text: '100.00');

  String _accountType = 'Savings Account';
  bool _isSuccess = false;
  String _generatedAccountNo = '';

  @override
  void dispose() {
    _nrcController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _initialDepositController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSuccess = true;
      _generatedAccountNo = '100${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
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
                  'KYC Customer Onboarded',
                  style: AppTypography.title.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Account Number: $_generatedAccountNo', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Customer Name:', style: AppTypography.body),
                    Text(_fullNameController.text, style: AppTypography.subtitle),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('NRC Number:', style: AppTypography.body),
                    Text(_nrcController.text, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Account Type:', style: AppTypography.body),
                    Text(_accountType, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Opening Deposit:', style: AppTypography.body),
                    Text('ZMW ${_initialDepositController.text}', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Onboard Another Customer',
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
                    'Instant Customer Onboarding',
                    style: AppTypography.title.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Open instant tiered savings and farmer accounts with National Registration Card (NRC).',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'National Registration ID (NRC)',
                    controller: _nrcController,
                    prefixIcon: Icon(Icons.badge, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter valid NRC number' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Full Legal Name',
                    controller: _fullNameController,
                    prefixIcon: Icon(Icons.person, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter full name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Mobile Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(Icons.phone_android, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _accountType,
                    decoration: InputDecoration(
                      labelText: 'Account Product',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
                      prefixIcon: Icon(Icons.account_balance_wallet, color: primaryColor),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Savings Account', child: Text('Tier 1 Savings')),
                      DropdownMenuItem(value: 'Agri-Wallet Account', child: Text('Agri-Wallet')),
                      DropdownMenuItem(value: 'SME Merchant Account', child: Text('SME Merchant')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _accountType = val);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Initial Opening Deposit (ZMW)',
                    controller: _initialDepositController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.attach_money, color: primaryColor),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Enter deposit amount';
                      final parsed = double.tryParse(val);
                      if (parsed == null || parsed < 0) return 'Enter valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Complete Customer Registration',
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

