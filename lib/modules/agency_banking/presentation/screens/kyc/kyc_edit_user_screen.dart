import 'package:citizenone_app/modules/agency_banking/constants/AppConfig.dart';
import 'package:citizenone_app/modules/agency_banking/core/models/file_model.dart';
import 'package:citizenone_app/modules/agency_banking/core/services/file_picker_service.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/formatter.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/date_picker_field.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/drop_down.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/input_form_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/api/end_points/ApiEndPoints.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_dynamic_document_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';

class EditKycScreen extends StatefulWidget {
  const EditKycScreen({super.key});

  @override
  State<EditKycScreen> createState() => _EditKycScreenState();
}

class _EditKycScreenState extends State<EditKycScreen> {
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

  bool _validateMergedDocs(KycState state, BuildContext context) {
    for (final doc in state.mergedDocuments) {
      final alreadyExists = state.kycUserDocuments.any(
        (ud) =>
            ud.docName.trim().toLowerCase() == doc.name.trim().toLowerCase(),
      );
      if (alreadyExists) continue;

      if (doc.isMandatory && (doc.fileName ?? '').isEmpty) {
        Snack.show(context, message: 'Please upload ${doc.name} document');
        return false;
      }
      if (doc.showDates && (doc.fileName ?? '').isNotEmpty) {
        if (doc.issueDate == null) {
          Snack.show(context, message: 'Please select ${doc.name} Issue Date');
          return false;
        }
        if (doc.expiryDate == null) {
          Snack.show(context, message: 'Please select ${doc.name} Expiry Date');
          return false;
        }
      }
    }
    return true;
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
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
      exportBackgroundColor: AppColors.white,
    );

    final state = context.read<KycBloc>().state;
    context.read<KycBloc>().add(LoadLocationsEvent());

    _firstNameCtrl = TextEditingController(text: state.firstName);
    _lastNameCtrl = TextEditingController(text: state.lastName);
    _mobileCtrl = TextEditingController(text: state.mobileNumber.toString());
    _nationalIdCtrl = TextEditingController(
        text: Formatter.formatNationalId(state.nationalId.toString()));
    _monthlyIncomeCtrl = TextEditingController(text: state.monthlyIncome);
    _sourceFundsCtrl = TextEditingController(text: state.sourceFunds);
    _employerNameCtrl = TextEditingController(text: state.employerName);
    _businessNatureCtrl = TextEditingController(text: state.businessNature);
    _businessNameCtrl = TextEditingController(text: state.businessName);
    _emailCtrl = TextEditingController(text: state.email);
    _phNoCtrl = TextEditingController(text: state.phNumber);
    _pbNumberCtrl = TextEditingController(text: state.pbNumber);
    _addressCtrl = TextEditingController(text: state.addressLine);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _mobileCtrl.dispose();
    _nationalIdCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _sourceFundsCtrl.dispose();
    _employerNameCtrl.dispose();
    _businessNatureCtrl.dispose();
    _businessNameCtrl.dispose();
    _emailCtrl.dispose();
    _phNoCtrl.dispose();
    _pbNumberCtrl.dispose();
    _addressCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
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

  Future<void> _editListener(BuildContext context, KycState state) async {
    if (state.updateKyc) {
      context.read<KycBloc>().add(const ResetFormData());
      context.read<KycBloc>().add(
            FetchSearchUserEvent(
                mobileNumber: state.mobileNumber.toString(),
                nationalId: state.nationalId.toString()),
          );
      Navigator.pop(context);
      Snack.show(context, message: "KYC data has been updated");
    }

    if (state.errorMessage != null && !state.isUpdatingKyc) {
      Snack.show(context, message: state.errorMessage!);
      context.read<KycBloc>().add(ClearErrorEvent());
    }
  }

  void _handleUpdate(BuildContext context, KycState state) {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateMergedDocs(state, context)) return;
    if (state.selectedCountry == null) {
      Snack.show(context,
          message: "Please select Country, State, District, City");
    } else {
      context.read<KycBloc>().add(UpdateKycEvent(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
          mobileNumber: _mobileCtrl.text,
          email: _emailCtrl.text,
          addressLine: _addressCtrl.text,
          phNumber: _phNoCtrl.text,
          pbNumber: _pbNumberCtrl.text,
          nationalId: _nationalIdCtrl.text,
          monthlyIncome: _monthlyIncomeCtrl.text,
          sourceFunds: _sourceFundsCtrl.text,
          employerName: _employerNameCtrl.text,
          natureOfBusiness: _businessNatureCtrl.text,
          businessName: _businessNameCtrl.text));
    }
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return KycDesktopScaffold(
      pageTitle: "Edit User",
      maxContentWidth: 750,
      child: BlocConsumer<KycBloc, KycState>(
        listener: _editListener,
        builder: (context, state) {
          final mergedDocs = state.mergedDocuments;
          if (state.isUpdatingKyc) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: KycDesktopCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KycSectionLabel("PERSONAL INFORMATION"),
                  _twoColumnRow(_firstNameField(), _lastNameField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_mobileField(), _dobField(context, state)),
                  const SizedBox(height: 16),
                  const FormHeader(label: "Gender", isRequired: true),
                  _genderRow(context, state),
                  const SizedBox(height: 16),
                  _twoColumnRow(_nationalIdField(), _monthlyIncomeField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(
                    _sourceFundsField(),
                    _originCountryDropdown(context, state),
                  ),
                  const SizedBox(height: 24),
                  const KycSectionLabel("PROFESSIONAL INFORMATION"),
                  const FormHeader(label: "Employment Type", isRequired: true),
                  _employmentTypeRow(context, state),
                  const SizedBox(height: 16),
                  _employmentFields(context, state, false),
                  const SizedBox(height: 16),
                  const FormHeader(label: "Sectors", isRequired: true),
                  _sectorDropdown(context, state),
                  const SizedBox(height: 24),
                  const KycSectionLabel("PHOTO & SIGNATURE"),
                  _photoSignatureSection(context, state),
                  const SizedBox(height: 24),
                  const KycSectionLabel("COMMUNICATION"),
                  _twoColumnRow(_emailField(), _phoneField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_postBoxField(), _addressField()),
                  const SizedBox(height: 16),
                  _locationDropdowns(context, state, false),
                  const SizedBox(height: 24),
                  const KycSectionLabel("DOCUMENTS"),
                  _mergedDocumentsList(context, state, mergedDocs),
                  const SizedBox(height: 32),
                  AppButton(
                    title: "Update",
                    isLoading: state.isUpdatingKyc,
                    onTap: () => _handleUpdate(context, state),
                    backgroundColor: AppColors.teal1,
                    height: 48,
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
      appBar: const KycAppBar(title: "Edit User"),
      body: BlocConsumer<KycBloc, KycState>(
        listener: _editListener,
        builder: (context, state) {
          // final docs = List<Document>.from(state.kycUserDocuments);
          final mergedDocs = state.mergedDocuments;
          if (state.isUpdatingKyc) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
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
                      _sectionTitle("Personal"),
                      const SizedBox(height: 12),

                      // First Name + Last Name
                      if (isMobile) ...[
                        _firstNameField(),
                        const SizedBox(height: 12),
                        _lastNameField(),
                      ] else
                        _twoColumnRow(_firstNameField(), _lastNameField()),

                      const SizedBox(height: 12),

                      // Mobile + DOB
                      if (isMobile) ...[
                        _mobileField(),
                        const SizedBox(height: 12),
                        _dobField(context, state),
                      ] else
                        _twoColumnRow(
                            _mobileField(), _dobField(context, state)),

                      const SizedBox(height: 12),
                      const FormHeader(label: "Gender", isRequired: true),
                      _genderRow(context, state),
                      const SizedBox(height: 12),

                      // National ID + Monthly Income
                      if (isMobile) ...[
                        _nationalIdField(),
                        const SizedBox(height: 12),
                        _monthlyIncomeField(),
                      ] else
                        _twoColumnRow(
                            _nationalIdField(), _monthlyIncomeField()),

                      const SizedBox(height: 12),

                      // Source Funds + Origin Country
                      if (isMobile) ...[
                        _sourceFundsField(),
                        const SizedBox(height: 12),
                        _originCountryDropdown(context, state),
                      ] else
                        _twoColumnRow(
                          _sourceFundsField(),
                          _originCountryDropdown(context, state),
                        ),

                      const SizedBox(height: 20),
                      _sectionTitle("Professional"),
                      const SizedBox(height: 12),
                      const FormHeader(
                          label: "Employment Type", isRequired: true),
                      _employmentTypeRow(context, state),
                      const SizedBox(height: 12),
                      _employmentFields(context, state, isMobile),
                      const SizedBox(height: 12),
                      const FormHeader(label: "Sectors", isRequired: true),
                      _sectorDropdown(context, state),

                      const SizedBox(height: 20),
                      _sectionTitle("Photo & Signature"),
                      const SizedBox(height: 12),
                      _photoSignatureSection(context, state),

                      const SizedBox(height: 20),
                      _sectionTitle("Communication"),
                      const SizedBox(height: 12),

                      // Email + Phone
                      if (isMobile) ...[
                        _emailField(),
                        const SizedBox(height: 12),
                        _phoneField(),
                      ] else
                        _twoColumnRow(_emailField(), _phoneField()),

                      const SizedBox(height: 12),

                      // Post Box + Address
                      if (isMobile) ...[
                        _postBoxField(),
                        const SizedBox(height: 12),
                        _addressField(),
                      ] else
                        _twoColumnRow(_postBoxField(), _addressField()),

                      const SizedBox(height: 12),
                      _locationDropdowns(context, state, isMobile),

                      const SizedBox(height: 20),
                      _sectionTitle("Documents"),
                      const SizedBox(height: 12),
                      // _documentsList(context, docs),
                      _mergedDocumentsList(context, state, mergedDocs),

                      const SizedBox(height: 30),
                      //  _submitButton(context, state),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// ── Layout helpers ──────────────────────────────────────────
  Widget _mergedDocumentsList(
      BuildContext context, KycState state, List<KycDynamicDocument> docs) {
    if (state.mergedDocuments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: docs.map((doc) {
        final isUploaded = (doc.fileName ?? '').isNotEmpty;
        return Container(
          key: ValueKey(doc.name),
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(
            Responsive.value(context, mobile: 10.0, web: 14.0),
          ),
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              DocumentUploadCard(
                title: 'Upload ${doc.name}',
                isRequired: doc.isMandatory,
                isUploaded: isUploaded,
                fileName: doc.fileName ?? '',
                onTap: () async {
                  final file = await pickFile(context);
                  if (file == null) return;
                  if (!context.mounted) return;
                  context.read<KycBloc>().add(
                        PickMergedDocumentEvent(
                          name: doc.name,
                          fileData: kIsWeb
                              ? file.bytes!
                              : await FilePickerService()
                                  .fileToBytes(file.file!),
                          fileName: file.name,
                        ),
                      );
                },
              ),
              if (doc.showDates) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: DatePickerField(
                          label: 'Issue Date${doc.isMandatory ? "*" : ""}',
                          selectedDate: doc.issueDate,
                          lastDate: DateTime.now(),
                          onDateSelected: (date) {
                            context.read<KycBloc>().add(
                                  UpdateMergedDocIssueDate(doc.name, date),
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DatePickerField(
                          label: 'Expiry Date${doc.isMandatory ? "*" : ""}',
                          selectedDate: doc.expiryDate,
                          firstDate: doc.issueDate ?? DateTime.now(),
                          selectableDayPredicate: (d) =>
                              isValidExpiry(doc.issueDate, d),
                          onDateSelected: (date) {
                            context.read<KycBloc>().add(
                                  UpdateMergedDocExpiryDate(doc.name, date),
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
      }).toList(),
    );
  }

  /// Two fields side by side with equal width
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

  /// Section heading
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Responsive.fontSize(context, mobile: 14, web: 8),
        fontWeight: FontWeight.bold,
      ),
    );
  }

// ── Field widgets ────────────────────────────────────────────

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
            filled: true,
            fillColor: AppColors.white,
          )
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
            filled: true,
            fillColor: AppColors.white,
          )
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
            filled: true,
            isEnabled: false,
            fillColor: AppColors.white,
          ),
        ],
      );

  Widget _dobField(BuildContext context, KycState state) => Column(
        children: [
          const FormHeader(label: "Date of Birth", isRequired: true),
          DatePickerField(
            label: '',
            selectedDate: state.dob,
            lastDate: DateTime.now(),
            onDateSelected: (date) =>
                context.read<KycBloc>().add(SelectDob(dob: date)),
          ),
        ],
      );

  Widget _nationalIdField() => Column(children: [
        const FormHeader(label: "National ID", isRequired: true),
        AppTextField(
          name: "National ID",
          controller: _nationalIdCtrl,
          inputType: AppTextInputType.numberOnly,
          isRequired: true,
          requiredText: "National ID is required",
          filled: true,
          isEnabled: false,
          fillColor: AppColors.white,
        ),
      ]);

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
            filled: true,
            fillColor: AppColors.white,
          )
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
            filled: true,
            fillColor: AppColors.white,
          )
        ],
      );

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
            filled: true,
            fillColor: AppColors.white,
          )
        ],
      );

  Widget _phoneField() => Column(
        children: [
          const FormHeader(label: "Phone No", isRequired: true),
          AppTextField(
            name: "Phone No",
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
            filled: true,
            fillColor: AppColors.white,
          ),
        ],
      );

  Widget _postBoxField() => Column(
        children: [
          const FormHeader(label: "Post Box No", isRequired: true),
          AppTextField(
            name: "Mobile Number",
            controller: _pbNumberCtrl,
            inputType: AppTextInputType.numberOnly,
            isRequired: true,
            maxLength: 6,
            requiredText: "Post Box No is required",
            filled: true,
            fillColor: AppColors.white,
          ),
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
            filled: true,
            fillColor: AppColors.white,
          )
        ],
      );

// ── Section widgets ──────────────────────────────────────────

  Widget _genderRow(BuildContext context, KycState state) {
    return Row(
      children: genders.map((e) {
        return SizedBox(
          width: Responsive.value(context, mobile: 160.0, web: 180.0),
          child: RadioListTile<String>(
            title: Text(e),
            contentPadding: EdgeInsets.zero,
            value: e,
            activeColor: AppColors.green,
            groupValue: state.gender!.toUpperCase(),
            onChanged: (value) =>
                context.read<KycBloc>().add(SelectGender(gender: value)),
          ),
        );
      }).toList(),
    );
  }

  Widget _originCountryDropdown(BuildContext context, KycState state) {
    if (state.countries.isEmpty) {
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

  Widget _employmentTypeRow(BuildContext context, KycState state) {
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: employmentTypes.map((e) {
            return SizedBox(
              height: 70,
              width: Responsive.value(context, mobile: 170.0, web: 200.0),
              child: RadioListTile<String>(
                title: Text(e, style: const TextStyle(fontSize: 12)),
                value: e,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.green,
                groupValue: employmentType,
                onChanged: (value) => context
                    .read<KycBloc>()
                    .add(SelectEmploymentType(employmentType: value)),
              ),
            );
          }).toList(),
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
          InputTextFormField(
            controller: _employerNameCtrl,
            validationMessage: "Employer Name",
            maxLength: 60,
            fieldType: FieldType.name,
            isRequired: true,
          ),
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
            filled: true,
            fillColor: AppColors.white,
          )
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
            filled: true,
            fillColor: AppColors.white,
          )
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

  Widget _photoSignatureSection(BuildContext context, KycState state) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.2), width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(
        Responsive.value(context, mobile: 12.0, web: 20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _photoTile(context, state),
          _signatureTile(context, state),
        ],
      ),
    );
  }

  Widget _photoTile(BuildContext context, KycState state) {
    final boxSize =
        Responsive.value<double>(context, mobile: 100, tablet: 110, web: 120);
    return GestureDetector(
      onTap: () async {
        final file = await captureImage();
        if (file != null) {
          dynamic data;
          if (!kIsWeb) {
            data = await FilePickerService().fileToBytes(file.file!);
          }
          if (!context.mounted) return;

          context.read<KycBloc>().add(PickPhotoEvent(
              fileData: (kIsWeb) ? file.bytes! : data, name: file.name));
        }
      },
      child: Column(
        children: [
          _buildImageBox(
            _buildImageContent(
              url: state.photoUrl,
              fileBytes: state.photoFile,
              defaultIcon: Icons.camera_alt,
            ),
            size: boxSize,
          ),
          const SizedBox(height: 8),
          const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _signatureTile(BuildContext context, KycState state) {
    final boxSize =
        Responsive.value<double>(context, mobile: 100, tablet: 110, web: 120);
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
                    PickSignatureEvent(
                        fileData: bytes.toList(), name: fileName),
                  );
            }
            if (!context.mounted) return;
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          _buildImageBox(
            _buildImageContent(
              url: state.signatureUrl,
              fileBytes: state.signatureFile,
              defaultIcon: Icons.edit,
            ),
            size: boxSize,
          ),
          const SizedBox(height: 8),
          const Text("Signature",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

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

    //  Dropdown(
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

    // Dropdown(
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
    //Dropdown(
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
      return Column(
        children: [
          const FormHeader(label: "Country", isRequired: true),
          countryDrop,
          const SizedBox(height: 12),
          const FormHeader(label: "State", isRequired: true),
          stateDrop,
          const SizedBox(height: 12),
          const FormHeader(label: "Distrtict", isRequired: true),
          districtDrop,
          const SizedBox(height: 12),
          const FormHeader(label: "City", isRequired: true),
          cityDrop,
        ],
      );
    }

    // Web/tablet: Country+State on one row, District+City on the next
    return Column(
      children: [
        _twoColumnRow(countryDrop, stateDrop),
        const SizedBox(height: 12),
        _twoColumnRow(districtDrop, cityDrop),
      ],
    );
  }

  // Widget _documentsList(BuildContext context, List<Document> docs) {
  //   return Column(
  //     children: docs.map((doc) {
  //       return Container(
  //         key: ValueKey(doc.docId),
  //         margin: const EdgeInsets.only(bottom: 12),
  //         padding: EdgeInsets.all(
  //           Responsive.value(context, mobile: 10.0, web: 14.0),
  //         ),
  //         decoration: BoxDecoration(
  //           border:
  //               Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Column(
  //           children: [
  //             DocumentUploadCard(
  //               title: doc.docName,
  //               isUploaded: (doc.fileName ?? "").isNotEmpty,
  //               fileName: doc.fileName.toString(),
  //               onTap: () async {
  //                 final file = await pickFile(context);
  //                 if (file == null) return;
  //                 if (!context.mounted) return;
  //                 context.read<KycBloc>().add(
  //                       EditDynamicDocumentEvent(
  //                         docId: doc.docId,
  //                         fileData: (kIsWeb)
  //                             ? file.bytes!
  //                             : await FilePickerService()
  //                                 .fileToBytes(file.file!),
  //                         fileName: file.name,
  //                       ),
  //                     );
  //               },
  //             ),
  //             if (doc.issuingDate != null || doc.expiryDate != null) ...[
  //               const SizedBox(height: 12),
  //               Row(
  //                 children: [
  //                   if (doc.issuingDate != null)
  //                     Expanded(
  //                       child: DatePickerField(
  //                         key: ValueKey("issue_${doc.docId}"),
  //                         label: "Issue Date",
  //                         selectedDate: doc.issuingDate!,
  //                         lastDate: DateTime.now(),
  //                         onDateSelected: (date) => context
  //                             .read<KycBloc>()
  //                             .add(EditDynamicDocIssueDate(doc.docId, date)),
  //                       ),
  //                     ),
  //                   if (doc.issuingDate != null && doc.expiryDate != null)
  //                     const SizedBox(width: 12),
  //                   if (doc.expiryDate != null)
  //                     Expanded(
  //                       child: DatePickerField(
  //                         key: ValueKey("expiry_${doc.docId}"),
  //                         label: "Expiry Date",
  //                         selectedDate: doc.expiryDate!,
  //                         firstDate: doc.issuingDate ?? DateTime.now(),
  //                         selectableDayPredicate: (d) =>
  //                             isValidExpiry(doc.issuingDate, d),
  //                         onDateSelected: (date) => context
  //                             .read<KycBloc>()
  //                             .add(EditDynamicDocExpiryDate(doc.docId, date)),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ],
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildImageBox(Widget child, {double size = 100}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: child,
      ),
    );
  }

  Widget _buildImageContent({
    String? url,
    List<int>? fileBytes,
    required IconData defaultIcon,
  }) {
    final cleanUrl = (url ?? '').trim();
    if (fileBytes != null && fileBytes.isNotEmpty) {
      return Image.memory(
        Uint8List.fromList(fileBytes),
        fit: BoxFit.fill,
      );
    }

    if (cleanUrl.isNotEmpty && cleanUrl != "null" && cleanUrl != "NA") {
      return Image.network(
        "${ApiEndpoints.profittoBaseUrl}/$cleanUrl",
        headers: const {
          'Authorization': 'Bearer ${AppConfig.staticProfittoAccessToken}'
        },
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
              color: AppColors.lightGrey,
              child: const Icon(
                Icons.draw,
                color: AppColors.darkGray,
              ));
        },
      );
    }

    return Icon(
      defaultIcon,
      size: 40,
      color: AppColors.fbLiteDark,
    );
  }

  Widget bottomButton(BuildContext context, KycState state) {
    return Container(
        height: 100.h,
        color: AppColors.white,
        padding: EdgeInsets.only(
            bottom: 30.sp, right: 20.sp, left: 20.sp, top: 30.sp),
        child: (state.isUpdatingKyc)
            ? AppButton(
                title: "",
                backgroundColor: AppColors.teal1,
                isLoading: true,
                onTap: () {})
            : AppButton(
                title: "Update",
                backgroundColor: AppColors.teal1,
                onTap: () => _handleUpdate(context, state)));
  }
}
