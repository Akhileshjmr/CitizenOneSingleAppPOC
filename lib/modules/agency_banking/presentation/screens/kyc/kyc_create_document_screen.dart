import 'dart:io';
import 'package:citizenone_app/modules/agency_banking/core/models/file_model.dart';
import 'package:citizenone_app/modules/agency_banking/core/services/file_picker_service.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/date_picker_field.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_preview_submit_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/document_upload_card.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_file_picker.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/signature_pad_dialog.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';

import '../../../utils/ImageCompressionHelper.dart';

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
      exportBackgroundColor: AppColors.white,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  void _handleContinue(BuildContext context) {
    final state = context.read<KycBloc>().state;
    if (!_validateForm(state)) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KycPreviewSubmitScreen(),
      ),
    );
  }

  Widget _documentTile(BuildContext context, dynamic doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          DocumentUploadCard(
            title: "Upload ${doc.name}",
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
                            : await FilePickerService().fileToBytes(
                                file.file!),
                        fileName: file.name),
                  );
            },
          ),
          if (doc.showDates) ...[
            12.verticalSpace,
            SizedBox(
              height: 50.h,
              child: Row(
                children: [
                  Expanded(
                    child: DatePickerField(
                      label: "Issue Date${doc.isMandatory ? "*" : ""}",
                      selectedDate: doc.issueDate,
                      lastDate: DateTime.now(),
                      onDateSelected: (date) {
                        context.read<KycBloc>().add(
                              UpdateDynamicDocIssueDate(doc.name, date),
                            );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DatePickerField(
                      label: "Expiry Date${doc.isMandatory ? "*" : ""}",
                      selectedDate: doc.expiryDate,
                      firstDate: doc.issueDate ?? DateTime.now(),
                      selectableDayPredicate: (d) =>
                          isValidExpiry(doc.issueDate, d),
                      onDateSelected: (date) {
                        context.read<KycBloc>().add(
                              UpdateDynamicDocExpiryDate(doc.name, date),
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
    );
  }

  Widget _photoSignatureRow(BuildContext context, KycState state) {
    return Container(
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
                final bytes = await File(file.path).readAsBytes();
                final compressedBytes = await compressIfNeeded(bytes);
                finalBytes = compressedBytes ?? bytes;
              }

              if (context.mounted) {
                context.read<KycBloc>().add(
                      PickPhotoEvent(
                        fileData: (kIsWeb) ? file.bytes! : finalBytes,
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
                    border: Border.all(color: const Color(0xFFC6C6C6)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: state.photoFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            Uint8List.fromList(state.photoFile!),
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(Icons.camera_alt, size: 40),
                ),
                const SizedBox(height: 8),
                const Text("Photo",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => SignaturePadDialog(
                controller: _signatureController,
                onClear: () => _signatureController.clear(),
                onSave: () async {
                  final bytes = await _signatureController.toPngBytes();

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
                  if (!context.mounted) return;
                  Navigator.pop(context);
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
                    border: Border.all(color: const Color(0xFFC6C6C6)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: state.signatureFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            Uint8List.fromList(state.signatureFile!),
                            fit: BoxFit.fill,
                          ),
                        )
                      : const Icon(Icons.edit, size: 40),
                ),
                const SizedBox(height: 8),
                const Text("Signature",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop-only upload tile — dashed box matching the reference design,
  /// replacing the bordered-title-row `_documentTile` used on mobile.
  Widget _documentTileDesktop(BuildContext context, dynamic doc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KycDesktopUploadTile(
          title: doc.name.toString(),
          isRequired: doc.isMandatory,
          isUploaded: (doc.fileName ?? "").isNotEmpty,
          fileName: doc.fileName?.toString(),
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
                      fileName: file.name),
                );
          },
        ),
        if (doc.showDates) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DatePickerField(
                  label: "Issue Date${doc.isMandatory ? "*" : ""}",
                  selectedDate: doc.issueDate,
                  lastDate: DateTime.now(),
                  onDateSelected: (date) {
                    context.read<KycBloc>().add(
                          UpdateDynamicDocIssueDate(doc.name, date),
                        );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DatePickerField(
                  label: "Expiry Date${doc.isMandatory ? "*" : ""}",
                  selectedDate: doc.expiryDate,
                  firstDate: doc.issueDate ?? DateTime.now(),
                  selectableDayPredicate: (d) =>
                      isValidExpiry(doc.issueDate, d),
                  onDateSelected: (date) {
                    context.read<KycBloc>().add(
                          UpdateDynamicDocExpiryDate(doc.name, date),
                        );
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// Desktop-only Selfie/Portrait tile — same dashed-box upload styling as
  /// documents, still triggers the existing camera-capture flow on tap.
  Widget _selfieTileDesktop(BuildContext context, KycState state) {
    return KycDesktopUploadTile(
      title: "Selfie / Portrait",
      isRequired: true,
      isUploaded: state.photoFile != null,
      fileName: state.photoName,
      onTap: () async {
        final file = await captureImage();
        if (file == null) return;
        dynamic finalBytes;
        if (!kIsWeb) {
          final bytes = await File(file.path).readAsBytes();
          final compressedBytes = await compressIfNeeded(bytes);
          finalBytes = compressedBytes ?? bytes;
        }

        if (context.mounted) {
          context.read<KycBloc>().add(
                PickPhotoEvent(
                  fileData: (kIsWeb) ? file.bytes! : finalBytes,
                  name: file.name,
                ),
              );
        }
      },
    );
  }

  /// Desktop-only Customer Signature tile — same dashed-box shell with a
  /// "Draw signature here" placeholder; still opens the existing
  /// `SignaturePadDialog` on tap.
  Widget _signatureTileDesktop(BuildContext context, KycState state) {
    return KycDesktopSignatureTile(
      title: "Customer Signature",
      isRequired: true,
      signatureBytes:
          state.signatureFile != null ? Uint8List.fromList(state.signatureFile!) : null,
      onTap: () => showDialog(
        context: context,
        builder: (_) => SignaturePadDialog(
          controller: _signatureController,
          onClear: () => _signatureController.clear(),
          onSave: () async {
            final bytes = await _signatureController.toPngBytes();

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
            if (!context.mounted) return;
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget _desktopUploadGrid(List<Widget> tiles) {
    final rows = <Widget>[];
    for (var i = 0; i < tiles.length; i += 2) {
      final left = tiles[i];
      final right = (i + 1 < tiles.length) ? tiles[i + 1] : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 16),
              Expanded(child: right ?? const SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return BlocBuilder<KycBloc, KycState>(
      builder: (context, state) {
        final docs = state.dynamicDocuments;
        if (docs.isEmpty) return const SizedBox();

        final tiles = [
          ...docs.map((doc) => _documentTileDesktop(context, doc)),
          _selfieTileDesktop(context, state),
          _signatureTileDesktop(context, state),
        ];

        return KycDesktopScaffold(
          pageTitle: "Document Upload",
          pageSubtitle:
              "Upload required identity and verification documents, then provide a signature.",
          maxContentWidth: 700,
          child: KycDesktopCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const KycSectionLabel("IDENTITY DOCUMENTS"),
                _desktopUploadGrid(tiles),
                const SizedBox(height: 12),
                KycDesktopButtonRow(
                  onBack: () => Navigator.pop(context),
                  onContinue: () => _handleContinue(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButtons(context, state);
        },
      ),
      appBar: const KycAppBar(title: "Document  Details"),
      body: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          final docs = state.dynamicDocuments;

          if (docs.isEmpty) {
            return const SizedBox();
          }

          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Responsive.contentMaxWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...docs.map((doc) {
                        return Column(
                          children: [
                            _documentTile(context, doc),
                            const SizedBox(height: 12),
                          ],
                        );
                      }),
                      const SizedBox(height: 2),
                      _photoSignatureRow(context, state),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget bottomButtons(BuildContext context, KycState state) {
    return Container(
      height: 100.h,
      color: AppColors.white,
      padding: EdgeInsets.only(bottom: 20.sp, right: 10.sp, left: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppButton(
            title: "Back",
            onTap: () => Navigator.pop(context),
            backgroundColor: AppColors.white,
            isOutlined: true,
            outlineColor: AppColors.teal1,
            width: 150.w,
            height: 40.h,
          ),
          20.horizontalSpace,
          AppButton(
            title: "Continue",
            onTap: () => _handleContinue(context),
            backgroundColor: AppColors.teal1,
            height: 40.h,
            width: 150.w,
          ),
        ],
      ),
    );
  }
}
