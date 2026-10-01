import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import '../cubit/kyc_cubit.dart';
import '../cubit/kyc_state.dart';

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
    final primaryColor = Theme.of(context).colorScheme.primary;

    return BlocBuilder<KycCubit, KycState>(
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
                    Icon(Icons.verified_user, size: 64, color: primaryColor),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'KYC Verified Successfully!',
                      style: AppTypography.title.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Document ID: ${state.document.documentId}',
                        style: AppTypography.caption),
                    Text('Type: ${state.document.documentType}',
                        style: AppTypography.body),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text('Status: ${state.document.status}'),
                      backgroundColor: Colors.green.shade50,
                      labelStyle: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: 'Submit Another Document',
                      backgroundColor: primaryColor,
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
                          child: Icon(Icons.badge_outlined, color: primaryColor),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Identity Verification (KYC)',
                                style: AppTypography.title.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Provide government-issued document details for verification.',
                                style: AppTypography.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Document Type',
                        prefixIcon: Icon(Icons.file_present_outlined, color: primaryColor),
                      ),
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
                      label: 'Document Identification Number',
                      controller: _numberController,
                      prefixIcon: Icon(Icons.numbers, color: primaryColor),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        label: 'Verify KYC Document',
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
