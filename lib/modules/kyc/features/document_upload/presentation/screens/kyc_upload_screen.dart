import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/kyc_cubit.dart';
import '../cubit/kyc_state.dart';
import 'package:citizenone_app/modules/kyc/theme/kyc_colors.dart';

class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  String _selectedType = 'National ID Card';
  final _numberController = TextEditingController(text: 'A9821049182');

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<KycCubit>().submitDocument(
          type: _selectedType,
          number: _numberController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification Portal'),
        backgroundColor: KycColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const ModuleSwitcherBar(currentModuleId: 'kyc'),
          Expanded(
            child: BlocBuilder<KycCubit, KycState>(
              builder: (context, state) {
          if (state is KycLoading) {
            return const AppLoader(message: 'Verifying Identity Document...');
          }

          if (state is KycSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified,
                          size: 64, color: KycColors.primary),
                      const SizedBox(height: AppSpacing.md),
                      Text('KYC Verified Successfully!',
                          style: AppTypography.title),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Document ID: ${state.document.documentId}',
                          style: AppTypography.caption),
                      Text('Type: ${state.document.documentType}',
                          style: AppTypography.body),
                      Text('Status: ${state.document.status}',
                          style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Submit Another Document',
                        onPressed: () => context.read<KycCubit>().reset(),
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
                  Text('Document Identification',
                      style: AppTypography.title
                          .copyWith(color: KycColors.primary)),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration:
                        const InputDecoration(labelText: 'Document Type'),
                    items: const [
                      DropdownMenuItem(
                          value: 'National ID Card',
                          child: Text('National ID Card')),
                      DropdownMenuItem(
                          value: 'Passport', child: Text('Passport')),
                      DropdownMenuItem(
                          value: 'Driver License',
                          child: Text('Driver License')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedType = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Document Number',
                    controller: _numberController,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      label: 'Verify KYC Document',
                      backgroundColor: KycColors.primary,
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
