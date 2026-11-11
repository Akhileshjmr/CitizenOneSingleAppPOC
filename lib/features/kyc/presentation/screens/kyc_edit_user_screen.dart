import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/constants/api_constants.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/models/file_model.dart';
import 'package:citizenone_app/core/network/session_image_headers.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/services/file_picker_service.dart';
import 'package:citizenone_app/core/theme/app_theme_extensions.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/formatter.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_dynamic_document_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/design_system/atoms/date_picker_field.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/document_upload_card.dart';
import 'package:citizenone_app/design_system/atoms/app_drop_down.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/form_header.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/kyc_file_picker.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/signature_pad_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  bool _validateDropdowns(KycState state) {
    if (state.selectedCountry == null) {
      return _showError("Please select Country");
    }

    if (state.selectedState == null) {
      return _showError("Please select State");
    }

    if (state.selectedDistrict == null) {
      return _showError("Please select District");
    }

    if (state.selectedCity == null) {
      return _showError("Please select City");
    }

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
      exportBackgroundColor: AppColors.surface,
    );

    final state = context.read<KycBloc>().state;
    context.read<KycBloc>().add(LoadLocationsEvent());

    _firstNameCtrl = TextEditingController(text: state.firstName);
    _lastNameCtrl = TextEditingController(text: state.lastName);
    _mobileCtrl = TextEditingController(text: state.mobileNumber.toString());
    _nationalIdCtrl = TextEditingController(
      text: Formatter.formatNationalId(state.nationalId.toString()),
    );
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
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButton(context, state);
        },
      ),
      appBar: AppStatusBar(title: "Edit User"),
      body: BlocConsumer<KycBloc, KycState>(
        listener: (context, state) async {
          if (state.updateKyc) {
            Snack.show(context, message: "KYC data has been updated");

            context.read<KycBloc>().add(const ResetFormData());
            context.read<KycBloc>().add(
              SearchUserEvent(
                mobileNumber: state.mobileNumber.toString(),
                nationalId: state.nationalId.toString(),
              ),
            );
            Navigator.pop(context);

            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const KycDetailsScreen()),
            // );
          }

          if (state.errorMessage != null && !state.isUpdatingKyc) {
            Snack.show(context, message: state.errorMessage!);
            context.read<KycBloc>().add(ClearErrorEvent());
          }
        },
        builder: (context, state) {
          final mergedDocs = state.mergedDocuments;
          if (state.isUpdatingKyc) {
            return const Center(child: CircularProgressIndicator());
          }
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                AdaptiveLayout.horizontalPadding(context),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Personal"),
                      VSpace(12),

                      if (isMobile) ...[
                        _firstNameField(),
                        VSpace(12),
                        _lastNameField(),
                        VSpace(12),
                        _mobileField(),
                      ] else
                        _threeColumnRow(
                          _firstNameField(),
                          _lastNameField(),
                          _mobileField(),
                        ),

                      VSpace(12),

                      if (isMobile) ...[
                        _dobField(context, state),
                        VSpace(12),
                        _nationalIdField(),
                        VSpace(12),
                        _monthlyIncomeField(),
                      ] else
                        _threeColumnRow(
                          _dobField(context, state),
                          _nationalIdField(),
                          _monthlyIncomeField(),
                        ),

                      VSpace(12),

                      if (isMobile) ...[
                        _sourceFundsField(),
                        VSpace(12),
                        _originCountryDropdown(context, state),
                        VSpace(12),
                        const FormHeader(label: "Gender", isRequired: true),
                        _genderRow(context, state),
                      ] else
                        _threeColumnRow(
                          _sourceFundsField(),
                          _originCountryDropdown(context, state),
                          const SizedBox(),
                        ),
                      VSpace(12),
                      if (!isMobile) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormHeader(label: "Gender", isRequired: true),
                            _genderRow(context, state),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
                      _sectionTitle("Professional"),
                      VSpace(12),

                      const FormHeader(
                        label: "Employment Type",
                        isRequired: true,
                      ),
                      _employmentTypeRow(context, state),
                      VSpace(12),
                      _employmentFields(context, state, isMobile),
                      VSpace(12),

                      // const FormHeader(label: "Sectors", isRequired: true),
                      // _sectorDropdown(context, state),
                      const SizedBox(height: 20),
                      _sectionTitle("Photo & Signature"),
                      VSpace(12),
                      _photoSignatureSection(context, state, isMobile),

                      const SizedBox(height: 20),
                      _sectionTitle("Communication"),
                      VSpace(12),

                      // ── Row 4: Email | Phone | Post Box ──
                      if (isMobile) ...[
                        _emailField(),
                        VSpace(12),
                        _phoneField(),
                        VSpace(12),
                        _postBoxField(),
                      ] else
                        _threeColumnRow(
                          _emailField(),
                          _phoneField(),
                          _postBoxField(),
                        ),

                      VSpace(12),

                      // ── Row 5: Address (full width on web too, or pair with empty) ──
                      // if (isMobile) ...[
                      //   _addressField(),
                      // ] else
                      //   _threeColumnRow(
                      //     _addressField(),
                      //     const SizedBox.shrink(),
                      //     const SizedBox.shrink(),
                      //   ),
                      VSpace(12),
                      _locationDropdowns(context, state, isMobile),

                      const SizedBox(height: 20),
                      _sectionTitle("Documents"),
                      VSpace(12),
                      _mergedDocumentsList(context, state, mergedDocs),

                      VSpace(30),
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
    BuildContext context,
    KycState state,
    List<KycDynamicDocument> docs,
  ) {
    if (state.mergedDocuments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: docs.map((doc) {
        final isUploaded = (doc.fileName ?? '').isNotEmpty;
        return Container(
          key: ValueKey(doc.name),
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.serviceCommon.withValues(alpha: 0.2),
            ),
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
                          : await FilePickerService().fileToBytes(file.file!),
                      fileName: file.name,
                    ),
                  );
                },
              ),
              if (doc.showDates) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
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

  /// Three fields side by side with equal width
  Widget _threeColumnRow(Widget left, Widget center, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: center),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
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

  /// Section heading
  Widget _sectionTitle(String title) {
    return AppText(
      title,
      style: AppTextStyle.bodyMedium,
      color: AppColors.black,
    );
  }
  // ── Field widgets ────────────────────────────────────────────

  Widget _firstNameField() => Column(
    children: [
      const FormHeader(label: "First Name", isRequired: true),
      AppTextField(
        controller: _firstNameCtrl,
        maxLength: 35,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "First name is required";
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _lastNameField() => Column(
    children: [
      const FormHeader(label: "Last Name", isRequired: true),
      AppTextField(
        controller: _lastNameCtrl,
        maxLength: 35,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Last name is required";
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _mobileField() => Column(
    children: [
      const FormHeader(label: "Mobile Number", isRequired: true),
      AppTextField(
        controller: _mobileCtrl,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Mobile Number is required";
          }
          if (value.length != 9) {
            return 'Please enter a valid 9 digits Mobile Number';
          }
          return null;
        },
        maxLength: 9,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.numberOnly,
        ),
        isEnabled: false,
        fillColor: AppColors.surface,
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

  Widget _nationalIdField() => Column(
    children: [
      const FormHeader(label: "National ID", isRequired: true),
      AppTextField(
        controller: _nationalIdCtrl,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'National ID is required';
          }
          if (value.length != 11) {
            return 'Please enter a valid National ID';
          }
          return null;
        },

        isEnabled: false,
        fillColor: AppColors.surface,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
          SlashFormatter(),
        ],
      ),
    ],
  );

  Widget _monthlyIncomeField() => Column(
    children: [
      const FormHeader(label: "Monthly Income", isRequired: true),
      AppTextField(
        controller: _monthlyIncomeCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.decimal,
        ),
        maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Monthly Income is required';
          }
          return null;
        },

        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _sourceFundsField() => Column(
    children: [
      const FormHeader(label: "Source of Funds", isRequired: true),
      AppTextField(
        controller: _sourceFundsCtrl,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.alphaNumeric,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Source of Funds is required';
          }
          return null;
        },
        maxLength: 60,

        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _emailField() => Column(
    children: [
      const FormHeader(label: "Email", isRequired: true),
      AppTextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        maxLength: 40,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._%+\-@]')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          if (!regex.hasMatch(value)) {
            return 'Enter valid email';
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _phoneField() => Column(
    children: [
      const FormHeader(label: "Phone No", isRequired: true),
      AppTextField(
        controller: _emailCtrl,
        keyboardType: TextInputType.emailAddress,
        maxLength: 40,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._%+\-@]')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
          if (!regex.hasMatch(value)) {
            return 'Enter valid email';
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _postBoxField() => Column(
    children: [
      const FormHeader(label: "Post Box No", isRequired: true),
      AppTextField(
        controller: _pbNumberCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.numberOnly,
        ),
        maxLength: 6,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Post Box No is required";
          }
          return null;
        },
        fillColor: AppColors.glassWhite,
      ),
    ],
  );

  Widget _addressField() => Column(
    children: [
      const FormHeader(label: "Address Line", isRequired: true),
      AppTextField(
        controller: _addressCtrl,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.alphaNumeric,
        ),
        maxLength: 70,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Address Line is required";
          }
          return null;
        },
        fillColor: AppColors.glassWhite,
      ),
    ],
  );

  // ── Section widgets ──────────────────────────────────────────

  Widget _genderRow(BuildContext context, KycState state) {
    final bool isMobile = ResponsiveLayout.isMobile(context);

    return Row(
      children: genders.map((e) {
        return SizedBox(
          width: isMobile ? 180 : 300,

          child: RadioListTile<String>(
            title: AppText(
              e,
              style: AppTextStyle.bodySmall,
              color: AppColors.black,
            ),
            contentPadding: EdgeInsets.zero,
            value: e,
            activeColor: AppColors.primary,
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
        AppDropDown<LocationOption>(
          name: "Select Origin Country",
          initialValue:
              state.originCountries.contains(state.selectedOriginCountry)
              ? state.selectedOriginCountry
              : null,
          hintText: "Select Origin Country",
          items: state.originCountries.map((country) {
            return DropdownMenuItem(value: country, child: Text(country.name));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<KycBloc>().add(SelectOriginCountryEvent(value));
            }
          },
        ),
        // Dropdown(
        //   value: state.selectedOriginCountry?.name,
        //   items: state.originCountries.map((e) => e.name).toList(),
        //   hintText: "Select Origin Country",
        //   onChanged: (value) {
        //     final country = state.countries.firstWhere((e) => e.name == value);
        //     context.read<KycBloc>().add(SelectOriginCountryEvent(country));
        //   },
        // ),
      ],
    );
  }

  Widget _employmentTypeRow(BuildContext context, KycState state) {
    final bool isMobile = ResponsiveLayout.isMobile(context);
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: employmentTypes.map((e) {
            return SizedBox(
              height: 70,
              width: isMobile ? 180 : 300,
              child: RadioListTile<String>(
                title: AppText(
                  e,
                  style: AppTextStyle.bodySmall,
                  color: AppColors.black,
                ),
                value: e,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                groupValue: employmentType,
                onChanged: (value) => context.read<KycBloc>().add(
                  SelectEmploymentType(employmentType: value),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _employmentFields(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
    if (state.employmentType == employmentTypes[0]) {
      return isMobile
          ? Column(
              children: [
                const FormHeader(label: "Employer Name", isRequired: true),
                AppTextField(
                  controller: _employerNameCtrl,
                  inputFormatters: AppTextFieldFormatters.getFormatters(
                    AppTextInputType.alphaNumeric,
                  ),
                  maxLength: 60,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Employer Name is required';
                    }
                    return null;
                  },
                  fillColor: AppColors.surface,
                ),
                VSpace(12),
                const FormHeader(label: "Sectors", isRequired: true),
                _sectorDropdown(context, state),
              ],
            )
          : _twoColumnRow(
              Column(
                children: [
                  const FormHeader(label: "Employer Name", isRequired: true),
                  AppTextField(
                    controller: _employerNameCtrl,
                    inputFormatters: AppTextFieldFormatters.getFormatters(
                      AppTextInputType.alphaNumeric,
                    ),
                    maxLength: 60,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Employer Name is required';
                      }
                      return null;
                    },
                    fillColor: AppColors.surface,
                  ),
                ],
              ),
              Column(
                children: [
                  const FormHeader(label: "Sectors", isRequired: true),
                  _sectorDropdown(context, state),
                ],
              ),
            );
    }
    // Self Employment: Nature of Business | Business Name | (empty)
    return isMobile
        ? Column(
            children: [
              _businessNatureField(),
              VSpace(12),
              _businessNameField(),
              VSpace(23),
              Column(
                children: [
                  const FormHeader(label: "Sectors", isRequired: true),
                  _sectorDropdown(context, state),
                ],
              ),
            ],
          )
        : _threeColumnRow(
            _businessNatureField(),
            _businessNameField(),
            Column(
              children: [
                const FormHeader(label: "Sectors", isRequired: true),
                _sectorDropdown(context, state),
              ],
            ),
          );
  }

  Widget _businessNatureField() => Column(
    children: [
      const FormHeader(label: "Nature of Business", isRequired: true),
      AppTextField(
        controller: _businessNameCtrl,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.alphaNumeric,
        ),
        maxLength: 60,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nature of Business is required';
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
    ],
  );

  Widget _businessNameField() => Column(
    children: [
      const FormHeader(label: "Business Name", isRequired: true),
      AppTextField(
        controller: _businessNameCtrl,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.alphaNumeric,
        ),
        maxLength: 60,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Business Name is required';
          }
          return null;
        },
        fillColor: AppColors.surface,
      ),
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
  }

  Widget _photoSignatureSection(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
    final tokens = context.appTokens;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tokens.outline, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _photoTile(context, state, isMobile),
          _signatureTile(context, state, isMobile),
        ],
      ),
    );
  }

  Widget _photoTile(BuildContext context, KycState state, bool isMobile) {
    final boxSize = isMobile ? 100.0 : 120.0;
    return GestureDetector(
      onTap: () async {
        final file = await captureImage();
        if (file != null) {
          dynamic data;
          if (!kIsWeb) {
            data = await FilePickerService().fileToBytes(file.file!);
          }
          if (!context.mounted) return;

          context.read<KycBloc>().add(
            PickPhotoEvent(
              fileData: (kIsWeb) ? file.bytes! : data,
              name: file.name,
            ),
          );
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

  Widget _signatureTile(BuildContext context, KycState state, bool isMobile) {
    final boxSize = isMobile ? 100.0 : 120.0;
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (dialogueContext) => SignaturePadDialog(
          controller: _signatureController,
          onClear: () => _signatureController.clear(),
          onSave: () async {
            final bytes = await _signatureController.toPngBytes();
            if (bytes != null) {
              final fileName =
                  "signature_${DateTime.now().millisecondsSinceEpoch}.png";
              if (!context.mounted) return;
              context.read<KycBloc>().add(
                PickSignatureEvent(fileData: bytes.toList(), name: fileName),
              );
            }
            if (!dialogueContext.mounted) return;
            Navigator.pop(dialogueContext);
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
          const Text(
            "Signature",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _locationDropdowns(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
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

    if (isMobile) {
      return Column(
        children: [
          _addressField(),
          VSpace(12),
          const FormHeader(label: "Country", isRequired: true),
          countryDrop,
          VSpace(12),
          const FormHeader(label: "State", isRequired: true),
          stateDrop,
          VSpace(12),
          const FormHeader(label: "District", isRequired: true),
          districtDrop,
          VSpace(12),
          const FormHeader(label: "City", isRequired: true),
          cityDrop,
        ],
      );
    }

    // Web/tablet: Country | State | District on row 1, City | (empty) | (empty) on row 2
    return Column(
      children: [
        _threeColumnRow(
          _addressField(),
          Column(
            children: [
              const FormHeader(label: "Country", isRequired: true),
              countryDrop,
            ],
          ),
          Column(
            children: [
              const FormHeader(label: "State", isRequired: true),
              stateDrop,
            ],
          ),
        ),
        VSpace(12),
        _threeColumnRow(
          Column(
            children: [
              const FormHeader(label: "District", isRequired: true),
              districtDrop,
            ],
          ),
          Column(
            children: [
              const FormHeader(label: "City", isRequired: true),
              cityDrop,
            ],
          ),
          const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildImageBox(Widget child, {double size = 100}) {
    final tokens = context.appTokens;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: tokens.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: child),
    );
  }

  Widget _buildImageContent({
    String? url,
    List<int>? fileBytes,
    required IconData defaultIcon,
  }) {
    final cleanUrl = (url ?? '').trim();
    if (fileBytes != null && fileBytes.isNotEmpty) {
      return Image.memory(Uint8List.fromList(fileBytes), fit: BoxFit.fill);
    }

    if (cleanUrl.isNotEmpty && cleanUrl != "null" && cleanUrl != "NA") {
      return Image.network(
        "${ApiConstants.profittoBaseUrl}/$cleanUrl",
        headers: sessionImageHeaders(),
        fit: BoxFit.fill,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.surfaceLight,
            child: const Icon(Icons.draw, color: AppColors.textSecondary),
          );
        },
      );
    }

    return Icon(defaultIcon, size: 40, color: AppColors.textTertiary);
  }

  Widget bottomButton(BuildContext context, KycState state) {
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Container(
      height: 100,
      color: AppColors.surface,
      padding: isMobile
          ? EdgeInsets.only(bottom: 30, right: 20, left: 20, top: 30)
          : EdgeInsets.only(bottom: 5, right: 130, left: 130, top: 5),
      child: (state.isUpdatingKyc)
          ? AppButton(
              text: "",
              backgroundColor: AppColors.primary,
              isLoading: true,
              onPressed: () {},
            )
          : AppButton(
              text: "Update",
              backgroundColor: AppColors.primary,
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (!_validateMergedDocs(state, context)) return;
                if (!_validateDropdowns(state)) return;

                context.read<KycBloc>().add(
                  UpdateKycEvent(
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
                    businessName: _businessNameCtrl.text,
                  ),
                );
              },
            ),
    );
  }
}
