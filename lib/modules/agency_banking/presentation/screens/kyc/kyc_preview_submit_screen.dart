import 'dart:io';
import 'package:citizenone_app/modules/agency_banking/core/models/file_model.dart';
import 'package:citizenone_app/modules/agency_banking/core/services/file_picker_service.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/date_picker_field.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/drop_down.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/input_form_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_otp_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/dropdown/app_drop_down.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/ag_textfield.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/document_upload_card.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/form_header.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_file_picker.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/signature_pad_dialog.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';

import '../../../utils/ImageCompressionHelper.dart';

class KycPreviewSubmitScreen extends StatefulWidget {
  const KycPreviewSubmitScreen({super.key});

  @override
  State<KycPreviewSubmitScreen> createState() => _KycPreviewSubmitScreenState();
}

class _KycPreviewSubmitScreenState extends State<KycPreviewSubmitScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> employmentTypes = ["Employed", "Self Employment"];
  final filePickerService = FilePickerService();

  late SignatureController _signatureController;

  Future<FileModel?> captureImage() async {
    try {
      final result = await filePickerService.pickImageFromCamera();

      if (result == null) return null;
      return result;
    } catch (e) {
      return null;
    }
  }

  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _nationalIdCtrl;
  late TextEditingController _monthlyIncomeCtrl;
  late TextEditingController _sourceFundsCtrl;
  late TextEditingController _employerNameCtrl;
  late TextEditingController _businessNatureCtrl;
  late TextEditingController _businessNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phNoCtrl;
  late TextEditingController _pbNumberCtrl;
  late TextEditingController _addressCtrl;
  final List<String> genders = ["MALE", "FEMALE"];

  @override
  void initState() {
    super.initState();
    final state = context.read<KycBloc>().state;
    _firstNameCtrl = TextEditingController(text: state.firstName);
    _lastNameCtrl = TextEditingController(text: state.lastName);
    _mobileCtrl = TextEditingController(text: state.mobileNumber);
    _nationalIdCtrl = TextEditingController(text: state.nationalId);
    _monthlyIncomeCtrl =
        TextEditingController(text: state.monthlyIncome?.toString());
    _sourceFundsCtrl = TextEditingController(text: state.sourceFunds);
    _employerNameCtrl = TextEditingController(text: state.employerName);
    _businessNatureCtrl = TextEditingController(text: state.businessNature);
    _businessNameCtrl = TextEditingController(text: state.businessName);
    _emailCtrl = TextEditingController(text: state.email);
    _phNoCtrl = TextEditingController(text: state.phNumber);
    _pbNumberCtrl = TextEditingController(text: state.pbNumber);
    _addressCtrl = TextEditingController(text: state.addressLine);
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: AppColors.black,
      exportBackgroundColor: AppColors.white,
    );
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

  bool _reviewBuildWhen(KycState previous, KycState current) =>
      previous.otpStatus != current.otpStatus ||
      previous.isSubmittingKyc != current.isSubmittingKyc ||
      previous.photoFile != current.photoFile ||
      previous.signatureFile != current.signatureFile ||
      previous.dynamicDocuments != current.dynamicDocuments ||
      previous.employmentType != current.employmentType ||
      previous.gender != current.gender ||
      previous.dob != current.dob ||
      previous.selectedCountry != current.selectedCountry ||
      previous.selectedState != current.selectedState ||
      previous.selectedDistrict != current.selectedDistrict ||
      previous.selectedCity != current.selectedCity ||
      previous.selectedSector != current.selectedSector ||
      previous.selectedOriginCountry != current.selectedOriginCountry ||
      previous.filteredStates != current.filteredStates ||
      previous.filteredDistricts != current.filteredDistricts ||
      previous.filteredCities != current.filteredCities;

  bool _reviewListenWhen(KycState previous, KycState current) =>
      previous.otpStatus != current.otpStatus ||
      previous.errorMessage != current.errorMessage;

  void _reviewListener(BuildContext context, KycState state) {
    if (state.otpStatus == OtpStatus.otpSent) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KycOtpScreen(
              mobile: _mobileCtrl.text.toString().trim(),
            ),
          ));
    }
    if (state.errorMessage != null && state.otpStatus == OtpStatus.error) {
      Snack.show(context, message: state.errorMessage.toString());
      context.read<KycBloc>().add(ClearErrorEvent());
    }
  }

  void _handleContinue(BuildContext context, KycState state) {
    if (!_formKey.currentState!.validate()) return;
    if (state.selectedCountry == null) {
      Snack.show(context,
          message: "Please choose country, state, district & cities");
    } else {
      context.read<KycBloc>().add(UpdatePersonalInfoEvent(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
          nationalId: _nationalIdCtrl.text,
          mobileNumber: _mobileCtrl.text));
      context.read<KycBloc>().add(UpdateProfessionalInfoEvent(
          monthlyIncome: _monthlyIncomeCtrl.text,
          sourceFunds: _sourceFundsCtrl.text,
          employerName: _employerNameCtrl.text,
          natureOfBusiness: _businessNatureCtrl.text,
          businessName: _businessNameCtrl.text));
      context.read<KycBloc>().add(UpdateAddressInfoEvent(
          email: _emailCtrl.text,
          addressLine: _addressCtrl.text,
          phNumber: _phNoCtrl.text,
          pbNumber: _pbNumberCtrl.text));

      context.read<KycBloc>().add(SendOtpEvent(_mobileCtrl.text.trim()));
    }
  }

  Widget _docTile(BuildContext context, dynamic doc) {
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
            title: doc.name,
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DatePickerField(
                    label: "Issue Date${doc.isMandatory ? "*" : ""}",
                    selectedDate: doc.issueDate ?? DateTime.now(),
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
                    selectedDate: doc.expiryDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
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
      ),
    );
  }

  /// Desktop-only compact document list for the review screen — file icon +
  /// label, an "Uploaded" pill, and a "Replace" link, matching the reference
  /// design (as opposed to the full upload tiles used on the Document
  /// Upload step itself).
  Widget _reviewDocsListDesktop(BuildContext context, List<dynamic> docs) {
    return Column(
      children: [
        for (final doc in docs) ...[
          KycUploadedDocRow(
            label: doc.name.toString(),
            isUploaded: (doc.fileName ?? "").isNotEmpty,
            onReplace: () async {
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
          const Divider(height: 1, color: AppColors.dividerLight),
        ],
      ],
    );
  }

  /// Desktop-only Selfie/Signature row using the same upload-tile styling as
  /// the Document Upload step, for visual consistency between the two
  /// screens. Tap targets still trigger the existing camera-capture /
  /// signature-pad flows.
  Widget _photoSignatureUploadRow(BuildContext context, KycState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: KycDesktopUploadTile(
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
                context.read<KycBloc>().add(PickPhotoEvent(
                    fileData: (kIsWeb) ? file.bytes! : finalBytes,
                    name: file.name));
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: KycDesktopSignatureTile(
            title: "Customer Signature",
            isRequired: true,
            signatureBytes: state.signatureFile != null
                ? Uint8List.fromList(state.signatureFile!)
                : null,
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
                    context.read<KycBloc>().add(PickSignatureEvent(
                        fileData: bytes.toList(), name: fileName));
                  }
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      buildWhen: _reviewBuildWhen,
      listenWhen: _reviewListenWhen,
      listener: _reviewListener,
      builder: (context, state) {
        final docs = state.dynamicDocuments;
        return Form(
          key: _formKey,
          child: KycDesktopScaffold(
            pageTitle: "Review & Submit",
            pageSubtitle:
                "Review all provided information before submitting for KYC verification.",
            maxContentWidth: 750,
            child: KycDesktopCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KycSectionLabel("PERSONAL INFORMATION"),
                  _twoColumnRow(_firstNameField(), _lastNameField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_genderDropdownDesktop(context, state),
                      _mobileField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_dobField(context, state), _nationalIdField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_monthlyIncomeField(), _sourceFundsField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(
                    _originCountryDropdown(context, state),
                    const SizedBox(),
                  ),
                  const SizedBox(height: 24),
                  const KycSectionLabel("EMPLOYMENT INFORMATION"),
                  const FormHeader(
                      label: "Employment Type", isRequired: true),
                  _employmentTypeCardsDesktop(context, state),
                  const SizedBox(height: 16),
                  _employmentFieldsDesktop(context, state),
                  const SizedBox(height: 24),
                  const KycSectionLabel("COMMUNICATION DETAILS"),
                  _twoColumnRow(
                      _emailField(), _phoneField(label: "Phone Number")),
                  const SizedBox(height: 16),
                  _twoColumnRow(_addressField(),
                      _postBoxField(label: "Post Box Number")),
                  const SizedBox(height: 16),
                  _locationDropdowns(context, state, false),
                  const SizedBox(height: 24),
                  const KycSectionLabel("UPLOADED DOCUMENTS"),
                  _reviewDocsListDesktop(context, docs),
                  const SizedBox(height: 16),
                  _photoSignatureUploadRow(context, state),
                  const SizedBox(height: 32),
                  KycDesktopButtonRow(
                    onBack: () => Navigator.pop(context),
                    onContinue: () => _handleContinue(context, state),
                    isLoading: state.otpStatus == OtpStatus.sendingOtp,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButton(context, state);
        },
      ),
      appBar: const KycAppBar(title: "Review Information"),
      body: BlocConsumer<KycBloc, KycState>(
        buildWhen: _reviewBuildWhen,
        listenWhen: _reviewListenWhen,
        listener: _reviewListener,
        builder: (context, state) {
          final docs = state.dynamicDocuments;

          // if (state.isSubmittingKyc) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

          return Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ── Personal ──────────────────────────────
                                _sectionTitle("Personal"),
                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _firstNameField(),
                                  const SizedBox(height: 12),
                                  _lastNameField(),
                                ] else
                                  _twoColumnRow(
                                      _firstNameField(), _lastNameField()),

                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _mobileField(),
                                  const SizedBox(height: 12),
                                  _dobField(context, state),
                                ] else
                                  _twoColumnRow(_mobileField(),
                                      _dobField(context, state)),

                                const SizedBox(height: 12),
                                const FormHeader(
                                    label: "Gender", isRequired: true),

                                _genderRow(context, state),
                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _nationalIdField(),
                                  const SizedBox(height: 12),
                                  _monthlyIncomeField(),
                                ] else
                                  _twoColumnRow(_nationalIdField(),
                                      _monthlyIncomeField()),

                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _sourceFundsField(),
                                  const SizedBox(height: 12),
                                  _originCountryDropdown(context, state),
                                ] else
                                  _twoColumnRow(_sourceFundsField(),
                                      _originCountryDropdown(context, state)),

                                const SizedBox(height: 20),

                                // ── Professional ──────────────────────────
                                _sectionTitle("Professional"),
                                const SizedBox(height: 8),
                                const FormHeader(
                                    label: "Employment Type", isRequired: true),
                                _employmentTypeRow(context, state),
                                const SizedBox(height: 12),
                                _employmentFields(context, state, isMobile),
                                const SizedBox(height: 12),
                                const FormHeader(
                                    label: "Sectors", isRequired: true),
                                _sectorDropdown(context, state),

                                const SizedBox(height: 20),

                                // ── Communication ─────────────────────────
                                _sectionTitle("Communication"),
                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _emailField(),
                                  const SizedBox(height: 12),
                                  _phoneField(),
                                ] else
                                  _twoColumnRow(_emailField(), _phoneField()),

                                const SizedBox(height: 12),

                                if (isMobile) ...[
                                  _postBoxField(),
                                  const SizedBox(height: 12),
                                  _addressField(),
                                ] else
                                  _twoColumnRow(
                                      _postBoxField(), _addressField()),

                                const SizedBox(height: 12),
                                _locationDropdowns(context, state, isMobile),

                                const SizedBox(height: 20),
                                const Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Documents",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...docs.map((doc) {
                                  return Column(
                                    children: [
                                      _docTile(context, doc),
                                      const SizedBox(height: 12),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 12),
                                _sectionTitle("Photo & Signature"),
                                const SizedBox(height: 12),
                                _photoSignatureSection(context, state),

                                const SizedBox(height: 30),
                                //  _submitButton(context, state),
                                const SizedBox(height: 24),
                              ])))));
        },
      ),
    );
  }

  Widget _twoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Responsive.fontSize(context, mobile: 14, web: 8),
        fontWeight: FontWeight.bold,
      ),
    );
  }

// ── Personal fields ──────────────────────────────────────────

  Widget _firstNameField() => Column(
        children: [
          const FormHeader(label: "First Name", isRequired: true),
          AppTextField(
            name: "First Name",
            controller: _firstNameCtrl,
            inputType: AppTextInputType.stringOnly,
            isRequired: true,
            maxLength: 35,
            requiredText: "First name is required",
            hintText: "e.g. John",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _firstNameCtrl,
          //   validationMessage: "First Name",
          //   maxLength: 35,
          //   fieldType: FieldType.name,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _lastNameField() => Column(
        children: [
          const FormHeader(label: "Last Name", isRequired: true),
          AppTextField(
            name: "Last Name",
            controller: _lastNameCtrl,
            inputType: AppTextInputType.stringOnly,
            isRequired: true,
            maxLength: 35,
            requiredText: "Last name is required",
            hintText: "e.g. Doe",
            filled: true,
            fillColor: AppColors.white,
          )

          // InputTextFormField(
          //   controller: _lastNameCtrl,
          //   validationMessage: "Last Name",
          //   maxLength: 35,
          //   fieldType: FieldType.name,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _mobileField() => Column(
        children: [
          const FormHeader(label: "Mobile Number", isRequired: true),
          AppTextField(
            name: "Mobile Number",
            controller: _mobileCtrl,
            inputType: AppTextInputType.numberOnly,
            validator: (value) {
              if (value!.length != 9) {
                return 'Please enter a valid 9 digits Mobile Number';
              }
              return null;
            },
            maxLength: 9,
            requiredText: "Mobile Number is required",
            hintText: "e.g. 566789901",
            filled: true,
            isEnabled: false,
            fillColor: AppColors.white,
          ),
          // InputTextFormField(
          //   enable: false,
          //   controller: _mobileCtrl,
          //   fieldType: FieldType.phone,
          //   validationMessage: "Mobile Number",
          //   isRequired: true,
          // ),
        ],
      );

  Widget _dobField(BuildContext context, KycState state) => Column(
        children: [
          const FormHeader(label: "Date of Birth", isRequired: true),
          DatePickerField(
            label: 'e.g. 09/02/1998',
            selectedDate: state.dob,
            lastDate: DateTime.now(),
            onDateSelected: (date) =>
                context.read<KycBloc>().add(SelectDob(dob: date)),
          ),
        ],
      );

  Widget _nationalIdField() => Column(
        children: [
          const FormHeader(label: "National ID", isRequired: true),
          AppTextField(
            name: "National ID",
            controller: _nationalIdCtrl,
            inputType: AppTextInputType.numberOnly,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'National ID is required';
              }
              if (value.length != 11) {
                return 'Please enter a valid National ID';
              }
              return null;
            },
            isRequired: true,
            requiredText: "National ID is required",
            hintText: "e.g. 123456/78/1",
            filled: true,
            isEnabled: false,
            fillColor: AppColors.white,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
              SlashFormatter(),
            ],
          ),
          // TextFormField(
          //   enabled: false,
          //   controller: _nationalIdCtrl,
          //   validator: (value) =>
          //       value == null ? "This field is required" : null,
          //   inputFormatters: [
          //     LengthLimitingTextInputFormatter(11),
          //     SlashFormatter(),
          //   ],
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: AppColors.white,
          //     contentPadding:
          //         const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          //     enabledBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: BorderSide(
          //           color: AppColors.primaryBlue.withValues(alpha: 0.2)),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10),
          //       borderSide: const BorderSide(color: AppColors.primaryBlue),
          //     ),
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          //   ),
          // ),
        ],
      );

  Widget _monthlyIncomeField() => Column(
        children: [
          const FormHeader(label: "Monthly Income", isRequired: true),
          AppTextField(
            name: "Monthly Income",
            controller: _monthlyIncomeCtrl,
            inputType: AppTextInputType.decimal,
            isRequired: true,
            maxLength: 10,
            requiredText: "Monthly Income is required",
            hintText: "e.g. 40000",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _monthlyIncomeCtrl,
          //   fieldType: FieldType.decimal,
          //   validationMessage: "Monthly Income",
          //   maxLength: 10,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _sourceFundsField() => Column(
        children: [
          const FormHeader(label: "Source of Funds", isRequired: true),
          AppTextField(
            name: "Source of Funds",
            controller: _sourceFundsCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Source of Funds is required",
            hintText: "e.g. Salary, Business",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _sourceFundsCtrl,
          //   validationMessage: "Source of Funds",
          //   maxLength: 60,
          //   fieldType: FieldType.alphanumeric,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _genderRow(BuildContext context, KycState state) {
    return Row(
      children: genders.map((e) {
        return SizedBox(
          width: Responsive.value(context, mobile: 160.0, web: 180.0),
          child: RadioListTile<String>(
            title: Text(e),
            value: e,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.green,
            groupValue: state.gender,
            onChanged: (value) =>
                context.read<KycBloc>().add(SelectGender(gender: value)),
          ),
        );
      }).toList(),
    );
  }

  /// Desktop-only Gender control — mirrors the dropdown used on the General
  /// Details step so the review screen's field styling matches its source.
  Widget _genderDropdownDesktop(BuildContext context, KycState state) {
    return Column(
      children: [
        const FormHeader(label: "Gender", isRequired: true),
        AppDropDown<String>(
          name: "Gender",
          initialValue: genders.contains(state.gender) ? state.gender : null,
          hintText: "Select Gender",
          items: genders
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (value) =>
              context.read<KycBloc>().add(SelectGender(gender: value)),
        ),
      ],
    );
  }

  Widget _originCountryDropdown(BuildContext context, KycState state) {
    if (state.originCountries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        const FormHeader(label: "Origin Country", isRequired: true),
        Dropdown(
          value: state.selectedOriginCountry?.name,
          items: state.originCountries.map((e) => e.name).toList(),
          hintText: "Select Origin Country",
          onChanged: (value) {
            final country = state.countries.firstWhere((e) => e.name == value);
            context.read<KycBloc>().add(SelectOriginCountryEvent(country));
          },
        ),
      ],
    );
  }

// ── Professional fields ──────────────────────────────────────

  Widget _employmentTypeRow(BuildContext context, KycState state) {
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: [
            for (var i = 0; i < employmentTypes.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: RadioListTile<String>(
                    title: Text(employmentTypes[i],
                        style: const TextStyle(fontSize: 12)),
                    value: employmentTypes[i],
                    activeColor: AppColors.green,
                    contentPadding: EdgeInsets.zero,
                    groupValue: employmentType,
                    onChanged: (value) => context
                        .read<KycBloc>()
                        .add(SelectEmploymentType(employmentType: value)),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _employmentFields(
      BuildContext context, KycState state, bool isMobile) {
    if (state.employmentType == employmentTypes[0]) {
      return Column(
        children: [
          const FormHeader(label: "Employer Name", isRequired: true),
          AppTextField(
            name: "Employer Name",
            controller: _employerNameCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Employer Name is required",
            hintText: "Enter employer name",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _employerNameCtrl,
          //   validationMessage: "Employer Name",
          //   maxLength: 60,
          //   fieldType: FieldType.name,
          //   isRequired: true,
          // ),
        ],
      );
    }
    return isMobile
        ? Column(
            children: [
              _businessNatureField(),
              const SizedBox(height: 12),
              _businessNameField(),
            ],
          )
        : _twoColumnRow(_businessNatureField(), _businessNameField());
  }

  Widget _employerNameField() => Column(
        children: [
          const FormHeader(label: "Employer Name", isRequired: true),
          AppTextField(
            name: "Employer Name",
            controller: _employerNameCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Employer Name is required",
            hintText: "Enter employer name",
            filled: true,
            fillColor: AppColors.white,
          )
        ],
      );

  Widget _businessNatureField() => Column(
        children: [
          const FormHeader(label: "Nature of Business", isRequired: true),
          AppTextField(
            name: "Nature of Business",
            controller: _businessNatureCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Nature of Business is required",
            hintText: "e.g. Retail",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _businessNatureCtrl,
          //   validationMessage: "Nature of Business",
          //   fieldType: FieldType.name,
          //   maxLength: 60,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _businessNameField() => Column(
        children: [
          const FormHeader(label: "Business Name", isRequired: true),
          AppTextField(
            name: "Business Name",
            controller: _businessNameCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Business Name is required",
            hintText: "Enter business name",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _businessNameCtrl,
          //   validationMessage: "Business Name",
          //   maxLength: 60,
          //   fieldType: FieldType.alphanumeric,
          //   isRequired: true,
          // ),
        ],
      );

  /// Desktop-only bordered selector cards, mirroring the Employment Type
  /// step's styling. Underlying values stay `employmentTypes`; only the
  /// on-screen labels differ.
  Widget _employmentTypeCardsDesktop(BuildContext context, KycState state) {
    const desktopLabels = ["Salaried Employee", "Self Employed"];
    return Row(
      children: [
        for (var i = 0; i < employmentTypes.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          Expanded(
            child: KycSelectorCard(
              label: desktopLabels[i],
              selected: state.employmentType == employmentTypes[i],
              onTap: () => context.read<KycBloc>().add(
                  SelectEmploymentType(employmentType: employmentTypes[i])),
            ),
          ),
        ],
      ],
    );
  }

  /// Desktop-only field pairing mirroring the Employment Type step: Employer
  /// Name pairs with Sectors for Salaried; Nature of Business pairs with
  /// Business Name for Self Employed, with Sectors on its own row below.
  Widget _employmentFieldsDesktop(BuildContext context, KycState state) {
    if (state.employmentType == employmentTypes[0]) {
      return _twoColumnRow(
          _employerNameField(), _sectorFieldWithLabel(context, state));
    }
    return Column(
      children: [
        _twoColumnRow(_businessNatureField(), _businessNameField()),
        const SizedBox(height: 16),
        _sectorFieldWithLabel(context, state),
      ],
    );
  }

  Widget _sectorFieldWithLabel(BuildContext context, KycState state) =>
      Column(
        children: [
          const FormHeader(label: "Sectors", isRequired: true),
          _sectorDropdown(context, state),
        ],
      );

  Widget _sectorDropdown(BuildContext context, KycState state) {
    if (state.sectors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return AppDropDown<LocationOption>(
      name: "Sectors",
      initialValue: state.sectors.contains(state.selectedSector)
          ? state.selectedSector
          : null,
      items: state.sectors.map((sector) {
        return DropdownMenuItem(value: sector, child: Text(sector.name));
      }).toList(),
      hintText: "Select Sector",
      onChanged: (value) {
        if (value != null) {
          context.read<KycBloc>().add(SelectSectorEvent(value));
        }
      },
    );

    // Dropdown(
    //   value: state.selectedSector?.name,
    //   items: state.sectors.map((e) => e.name).toList(),
    //   hintText: "Select Sector",
    //   onChanged: (value) {
    //     final sector = state.sectors.firstWhere((e) => e.name == value);
    //     context.read<KycBloc>().add(SelectSectorEvent(sector));
    //   },
    // );
  }

// ── Communication fields ─────────────────────────────────────

  Widget _emailField() => Column(
        children: [
          const FormHeader(label: "Email", isRequired: true),
          AppTextField(
            name: "Email ID",
            controller: _emailCtrl,
            inputType: AppTextInputType.email,
            isRequired: true,
            maxLength: 40,
            requiredText: "Email ID is required",
            hintText: "e.g. john.doe@email.com",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _emailCtrl,
          //   fieldType: FieldType.email,
          //   validationMessage: "Email",
          //   maxLength: 40,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _phoneField({String label = "Phone No"}) => Column(
        children: [
          FormHeader(label: label, isRequired: true),
          AppTextField(
            name: label,
            controller: _phNoCtrl,
            inputType: AppTextInputType.numberOnly,
            validator: (value) {
              if (value!.length != 9) {
                return 'Please enter a valid 9 digits Phone Number';
              }
              return null;
            },
            isRequired: true,
            maxLength: 9,
            requiredText: "Phone No is required",
            hintText: "e.g. 566789901",
            filled: true,
            fillColor: AppColors.white,
          ),
          // InputTextFormField(
          //   controller: _phNoCtrl,
          //   validationMessage: "Phone No",
          //   fieldType: FieldType.phone,
          //   isRequired: true,
          // ),
        ],
      );

  Widget _postBoxField({String label = "Post Box No"}) => Column(
        children: [
          FormHeader(label: label, isRequired: true),
          AppTextField(
            name: label,
            controller: _pbNumberCtrl,
            inputType: AppTextInputType.numberOnly,
            isRequired: true,
            maxLength: 6,
            requiredText: "Post Box No is required",
            hintText: "e.g. 12345",
            filled: true,
            fillColor: AppColors.white,
          ),
          // InputTextFormField(
          //     controller: _pbNumberCtrl,
          //     validationMessage: "Post Box No",
          //     maxLength: 6,
          //     isRequired: true,
          //     fieldType: FieldType.number),
        ],
      );

  Widget _addressField() => Column(
        children: [
          const FormHeader(label: "Address Line", isRequired: true),
          AppTextField(
            name: "Address Line",
            controller: _addressCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 70,
            requiredText: "Address Line is required",
            hintText: "e.g. 14 Westlands Road",
            filled: true,
            fillColor: AppColors.white,
          )
          // InputTextFormField(
          //   controller: _addressCtrl,
          //   validationMessage: "Address Line",
          //   maxLength: 70,
          //   isRequired: true,
          //   fieldType: FieldType.alphanumeric,
          // ),
        ],
      );

  Widget _locationDropdowns(
      BuildContext context, KycState state, bool isMobile) {
    if (state.countries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final countryDrop = AppDropDown<LocationOption>(
      name: "Countries",
      initialValue: state.countries.contains(state.selectedCountry)
          ? state.selectedCountry
          : null,
      items: state.countries.map((country) {
        return DropdownMenuItem(value: country, child: Text(country.name));
      }).toList(),
      hintText: "Select Country",
      onChanged: (value) {
        if (value != null) {
          context.read<KycBloc>().add(SelectCountryEvent(value));
        }
      },
    );

    // Dropdown(
    //   value: state.selectedCountry?.name,
    //   items: state.countries.map((e) => e.name).toList(),
    //   hintText: "Select Country",
    //   onChanged: (value) {
    //     final country = state.countries.firstWhere((e) => e.name == value);
    //     context.read<KycBloc>().add(SelectCountryEvent(country));
    //   },
    // );

    final stateDrop = AppDropDown<LocationOption>(
      name: "States",
      initialValue: state.filteredStates.contains(state.selectedState)
          ? state.selectedState
          : null,
      items: state.filteredStates
          .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
          .toList(),
      hintText: "Select State",
      onChanged: state.filteredStates.isEmpty
          ? null
          : (value) {
              if (value != null) {
                context.read<KycBloc>().add(SelectStateEvent(value));
              }
            },
    );

    //  Dropdown(
    //   value: state.filteredStates.contains(state.selectedState)
    //       ? state.selectedState!.name
    //       : null,
    //   items: state.filteredStates.map((e) => e.name).toList(),
    //   hintText: "Select State",
    //   onChanged: (value) {
    //     final s = state.filteredStates.firstWhere((e) => e.name == value);
    //     context.read<KycBloc>().add(SelectStateEvent(s));
    //   },
    // );
    final districtDrop = AppDropDown<LocationOption>(
      name: "Districts",
      initialValue: state.filteredDistricts.contains(state.selectedDistrict)
          ? state.selectedDistrict
          : null,
      items: state.filteredDistricts
          .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
          .toList(),
      hintText: "Select District",
      onChanged: state.filteredDistricts.isEmpty
          ? null
          : (value) {
              if (value != null) {
                context.read<KycBloc>().add(SelectDistrictEvent(value));
              }
            },
    );

    //  Dropdown(
    //   value: state.filteredDistricts.contains(state.selectedDistrict)
    //       ? state.selectedDistrict!.name
    //       : null,
    //   items: state.filteredDistricts.map((e) => e.name).toList(),
    //   hintText: "Select District",
    //   onChanged: (value) {
    //     final d = state.filteredDistricts.firstWhere((e) => e.name == value);
    //     context.read<KycBloc>().add(SelectDistrictEvent(d));
    //   },
    // );

    final cityDrop = AppDropDown<LocationOption>(
      name: "Cities",
      initialValue: state.filteredCities.contains(state.selectedCity)
          ? state.selectedCity
          : null,
      items: state.filteredCities
          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
          .toList(),
      hintText: "Select City",
      onChanged: state.filteredCities.isEmpty
          ? null
          : (value) {
              if (value != null) {
                context.read<KycBloc>().add(SelectCityEvent(value));
              }
            },
    );

    // Dropdown(
    //   value: state.filteredCities.contains(state.selectedCity)
    //       ? state.selectedCity!.name
    //       : null,
    //   items: state.filteredCities.map((e) => e.name).toList(),
    //   hintText: "Select City",
    //   onChanged: (value) {
    //     final c = state.filteredCities.firstWhere((e) => e.name == value);
    //     context.read<KycBloc>().add(SelectCityEvent(c));
    //   },
    // );

    if (isMobile) {
      return Column(children: [
        const FormHeader(label: "Country", isRequired: true),
        countryDrop,
        12.verticalSpace,
        const FormHeader(label: "State", isRequired: true),
        stateDrop,
        12.verticalSpace,
        const FormHeader(label: "District", isRequired: true),
        districtDrop,
        12.verticalSpace,
        const FormHeader(label: "City", isRequired: true),
        cityDrop,
      ]);
    }

    return Column(children: [
      _twoColumnRow(
        _labeledDropdown("Country", countryDrop),
        _labeledDropdown("State", stateDrop),
      ),
      12.verticalSpace,
      _twoColumnRow(
        _labeledDropdown("District", districtDrop),
        _labeledDropdown("City", cityDrop),
      ),
    ]);
  }

  Widget _labeledDropdown(String label, Widget dropdown) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormHeader(label: label, isRequired: true),
          dropdown,
        ],
      );

  Widget _photoSignatureSection(BuildContext context, KycState state) {
    final boxSize =
        Responsive.value<double>(context, mobile: 100, tablet: 110, web: 120);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6), width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(
        Responsive.value(context, mobile: 12.0, web: 20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _photoTile(context, state, boxSize),
          _signatureTile(context, state, boxSize),
        ],
      ),
    );
  }

  Widget _photoTile(BuildContext context, KycState state, double boxSize) {
    return GestureDetector(
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
          context.read<KycBloc>().add(PickPhotoEvent(
              fileData: (kIsWeb) ? file.bytes! : finalBytes, name: file.name));
        }
      },
      child: Column(
        children: [
          _mediaBox(
            size: boxSize,
            child: state.photoFile != null
                ? Image.memory(Uint8List.fromList(state.photoFile!),
                    fit: BoxFit.cover)
                : const Icon(Icons.camera_alt,
                    size: 40, color: AppColors.fbLiteDark),
          ),
          const SizedBox(height: 8),
          const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _signatureTile(BuildContext context, KycState state, double boxSize) {
    return GestureDetector(
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
                  PickSignatureEvent(fileData: bytes.toList(), name: fileName));
            }
            if (!context.mounted) return;
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          _mediaBox(
            size: boxSize,
            child: state.signatureFile != null
                ? Image.memory(Uint8List.fromList(state.signatureFile!),
                    fit: BoxFit.fill)
                : const Icon(Icons.edit, size: 40),
          ),
          const SizedBox(height: 8),
          const Text("Signature",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _mediaBox({required double size, required Widget child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: child,
      ),
    );
  }

  Widget bottomButton(BuildContext context, KycState state) {
    return Container(
      height: 100.h,
      color: AppColors.white,
      padding:
          EdgeInsets.only(bottom: 30.sp, right: 20.sp, left: 20.sp, top: 30.sp),
      child: (state.otpStatus == OtpStatus.sendingOtp)
          ? AppButton(
              title: "",
              backgroundColor: AppColors.teal1,
              isLoading: true,
              onTap: () {})
          : AppButton(
              title: "Continue",
              onTap: () => _handleContinue(context, state),
              backgroundColor: AppColors.teal1,
              height: 40.h,
              width: 150.w,
            ),
    );
  }
}
