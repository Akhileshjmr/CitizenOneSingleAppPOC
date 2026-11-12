import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/design_system/design_system.dart';

class AgencyMicroLoansScreen extends StatefulWidget {
  const AgencyMicroLoansScreen({super.key});

  @override
  State<AgencyMicroLoansScreen> createState() => _AgencyMicroLoansScreenState();
}

class _AgencyMicroLoansScreenState extends State<AgencyMicroLoansScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmerNameController = TextEditingController(text: 'Mulenga Banda');
  final _farmerPhoneController = TextEditingController(text: '0977223344');
  final _loanAmountController = TextEditingController(text: '2500.00');
  String _loanProduct = 'Agri-Input Credit';
  bool _isSuccess = false;
  String _loanId = '';

  @override
  void dispose() {
    _farmerNameController.dispose();
    _farmerPhoneController.dispose();
    _loanAmountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSuccess = true;
      _loanId = 'LON-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
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
                  'Micro-Loan Approved & Disbursed',
                  style: AppTypography.title.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text('Application ID: $_loanId', style: AppTypography.caption),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Beneficiary:', style: AppTypography.body),
                    Text(_farmerNameController.text, style: AppTypography.subtitle),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Product:', style: AppTypography.body),
                    Text(_loanProduct, style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Approved Principal:', style: AppTypography.body),
                    Text('ZMW ${_loanAmountController.text}', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tenure:', style: AppTypography.body),
                    Text('6 Months (Harvest Bullet)', style: AppTypography.caption),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'New Loan Application',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agri & SME Credit Hub',
                  style: AppTypography.title.copyWith(color: primaryColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Facilitate seasonal crop inputs, livestock micro-credit, and SME capital disbursals.',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Disbursed MTD', style: AppTypography.caption.copyWith(color: Colors.green.shade800)),
                            const SizedBox(height: 2),
                            Text('ZMW 48,200', style: AppTypography.subtitle.copyWith(color: Colors.green.shade900, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Repayment Rate', style: AppTypography.caption.copyWith(color: Colors.blue.shade800)),
                            const SizedBox(height: 2),
                            Text('98.4%', style: AppTypography.subtitle.copyWith(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Form(
            key: _formKey,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Initiate Fast Disbursal', style: AppTypography.subtitle),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: _loanProduct,
                    decoration: InputDecoration(
                      labelText: 'Loan Scheme',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm)),
                      prefixIcon: Icon(Icons.agriculture, color: primaryColor),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Agri-Input Credit', child: Text('Agri-Input Credit')),
                      DropdownMenuItem(value: 'Livestock Working Capital', child: Text('Livestock Capital')),
                      DropdownMenuItem(value: 'Solar Irrigation Finance', child: Text('Solar Irrigation')),
                      DropdownMenuItem(value: 'SME Micro Trade Facility', child: Text('SME Trade Loan')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _loanProduct = val);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Farmer / Borrower Name',
                    controller: _farmerNameController,
                    prefixIcon: Icon(Icons.person_outline, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter borrower name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Borrower Phone Number',
                    controller: _farmerPhoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(Icons.phone, color: primaryColor),
                    validator: (val) => val == null || val.trim().isEmpty ? 'Enter phone number' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Principal Amount (ZMW)',
                    controller: _loanAmountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixIcon: Icon(Icons.payments_outlined, color: primaryColor),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Enter amount';
                      final parsed = double.tryParse(val);
                      if (parsed == null || parsed <= 0) return 'Enter valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Verify Credit & Disburse',
                      backgroundColor: primaryColor,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

