import 'dart:io';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/models/file_model.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/services/file_picker_service.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/image_compressor.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_icon.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_preview_submit_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/design_system/atoms/date_picker_field.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/document_upload_card.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/kyc_file_picker.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/signature_pad_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';

class KycCreateDocumentScreen extends StatefulWidget {
  const KycCreateDocumentScreen({super.key});

  @override
  State<KycCreateDocumentScreen> createState() =>
      KycCreateDocumentScreenState();
}

class KycCreateDocumentScreenState extends State<KycCreateDocumentScreen> {
  // final _formKey = GlobalKey<FormState>();
  late SignatureController _signatureController;
  final filePickerService = FilePickerService();

  @override
  void initState() {
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: AppColors.surface,
    );
    super.initState();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  bool _validateForm(KycState state) {
    for (var doc in state.dynamicDocuments) {
      if (doc.isMandatory && (doc.fileName ?? "").isEmpty) {
        return _showError("Please upload ${doc.name} document");
      }

      if (doc.showDates) {
        if (doc.issueDate == null) {
          return _showError("Please select ${doc.name} Issue Date");
        }
        if (doc.expiryDate == null) {
          return _showError("Please select ${doc.name} Expiry Date");
        }
      }
    }

    if (state.photoFile == null) return _showError("Please Capture Photo");
    if (state.signatureFile == null) return _showError("Please Add Signature");

    return true;
  }

  bool _showError(String message) {
    Snack.show(context, message: message);
    return false;
  }

  Future<FileModel?> captureImage() async {
    try {
      final result = await filePickerService.pickImageFromCamera();

      if (result == null) return null;
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButtons(context, state);
        },
      ),
      appBar: AppStatusBar(title: "Document  Details"),
      body: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          final docs = state.dynamicDocuments;

          if (docs.isEmpty) {
            return const SizedBox();
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AdaptiveLayout.horizontalPadding(context),
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AdaptiveLayout.contentMaxWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...docs.map((doc) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFC6C6C6),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                DocumentUploadCard(
                                  title: doc.name,
                                  isRequired: doc.isMandatory,
                                  isUploaded: (doc.fileName ?? "").isNotEmpty,
                                  fileName: doc.fileName.toString(),
                                  onTap: () async {
                                    final file = await pickFile(context);
                                    if (file == null) return;
                                    if (!context.mounted) return;

                                    context.read<KycBloc>().add(
                                      PickDynamicDocumentEvent(
                                        name: doc.name,
                                        fileData: (kIsWeb)
                                            ? file.bytes!
                                            : await FilePickerService()
                                                  .fileToBytes(file.file!),
                                        fileName: file.name,
                                      ),
                                    );
                                  },
                                ),
                                if (doc.showDates) ...[
                                  VSpace(12),
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DatePickerField(
                                            label:
                                                "Issue Date${doc.isMandatory ? "*" : ""}",
                                            selectedDate: doc.issueDate,
                                            lastDate: DateTime.now(),
                                            onDateSelected: (date) {
                                              context.read<KycBloc>().add(
                                                UpdateDynamicDocIssueDate(
                                                  doc.name,
                                                  date,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: DatePickerField(
                                            label:
                                                "Expiry Date${doc.isMandatory ? "*" : ""}",
                                            selectedDate: doc.expiryDate,
                                            firstDate:
                                                doc.issueDate ?? DateTime.now(),
                                            selectableDayPredicate: (d) =>
                                                isValidExpiry(doc.issueDate, d),
                                            onDateSelected: (date) {
                                              context.read<KycBloc>().add(
                                                UpdateDynamicDocExpiryDate(
                                                  doc.name,
                                                  date,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),
                    const SizedBox(height: 2),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFC6C6C6)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final file = await captureImage();
                              if (file == null) return;
                              dynamic finalBytes;
                              if (!kIsWeb) {
                                final bytes = await File(
                                  file.path,
                                ).readAsBytes();
                                final compressedBytes = await ImageCompressor()
                                    .compress(bytes);
                                finalBytes = compressedBytes;
                              }

                              if (context.mounted) {
                                context.read<KycBloc>().add(
                                  PickPhotoEvent(
                                    fileData: (kIsWeb)
                                        ? file.bytes!
                                        : finalBytes,
                                    name: file.name,
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(
                                      color: const Color(0xFFC6C6C6),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: state.photoFile != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          child: Image.memory(
                                            Uint8List.fromList(
                                              state.photoFile!,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : AppIcon(
                                          Icons.camera_alt,
                                          size: AppIconSize.xl,
                                        ),
                                ),
                                const SizedBox(height: 8),
                                const AppText(
                                  "Photo",
                                  style: AppTextStyle.bodyMedium,
                                  color: AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (dialogueContext) => SignaturePadDialog(
                                controller: _signatureController,
                                onClear: () => _signatureController.clear(),
                                onSave: () async {
                                  final bytes = await _signatureController
                                      .toPngBytes();

                                  if (bytes != null) {
                                    final fileName =
                                        "signature_${DateTime.now().millisecondsSinceEpoch}.png";
                                    if (!context.mounted) return;

                                    context.read<KycBloc>().add(
                                      PickSignatureEvent(
                                        fileData: bytes.toList(),
                                        name: fileName,
                                      ),
                                    );
                                  }
                                  if (!dialogueContext.mounted) return;
                                  Navigator.pop(dialogueContext);
                                },
                              ),
                            ), //_showSignaturePad,
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(
                                      color: const Color(0xFFC6C6C6),
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: state.signatureFile != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.0,
                                          ),
                                          child: Image.memory(
                                            Uint8List.fromList(
                                              state.signatureFile!,
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        )
                                      : AppIcon(
                                          Icons.edit,
                                          size: AppIconSize.xl,
                                        ),
                                ),
                                const SizedBox(height: 8),
                                const AppText(
                                  "Signature",
                                  style: AppTextStyle.bodyMedium,
                                  color: AppColors.textPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    VSpace(20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomButtons(BuildContext context, KycState state) {
    return Container(
      height: 100,
      color: AppColors.surface,
      padding: EdgeInsets.only(bottom: 20, right: 10, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppButton(
            text: "Back",
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.surface,
            variant: AppButtonVariant.outline,
            borderColor: AppColors.primary,
            textColor: AppColors.black,
            width: 150,
            height: 40,
          ),
          HSpace(20),
          AppButton(
            text: "Continue",
            onPressed: () {
              final state = context.read<KycBloc>().state;
              if (!_validateForm(state)) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KycPreviewSubmitScreen(),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            height: 40,
            width: 150,
          ),
        ],
      ),
    );
  }
}
