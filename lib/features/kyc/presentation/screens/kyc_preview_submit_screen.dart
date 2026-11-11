import 'dart:io';
import 'package:citizenone_app/components/foundation/responsive.dart';
import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/models/file_model.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/services/file_picker_service.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_otp_screen.dart';
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
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';

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
  late TextEditingController _pbNoCtrl;
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
    _monthlyIncomeCtrl = TextEditingController(
      text: state.monthlyIncome?.toString(),
    );
    _sourceFundsCtrl = TextEditingController(text: state.sourceFunds);
    _employerNameCtrl = TextEditingController(text: state.employerName);
    _businessNatureCtrl = TextEditingController(text: state.businessNature);
    _businessNameCtrl = TextEditingController(text: state.businessName);
    _emailCtrl = TextEditingController(text: state.email);
    _phNoCtrl = TextEditingController(text: state.phNumber);
    _pbNoCtrl = TextEditingController(text: state.pbNumber);
    _addressCtrl = TextEditingController(text: state.addressLine);
    _signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: AppColors.black,
      exportBackgroundColor: AppColors.surface,
    );
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
      appBar: AppStatusBar(title: "Review Information"),
      body: BlocConsumer<KycBloc, KycState>(
        buildWhen: (previous, current) =>
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
            previous.filteredCities != current.filteredCities,
        listenWhen: (previous, current) =>
            previous.otpStatus != current.otpStatus ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.otpStatus == OtpStatus.otpSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    KycOtpScreen(mobile: _mobileCtrl.text.toString().trim()),
              ),
            );
          }
          if (state.errorMessage != null &&
              state.otpStatus == OtpStatus.error) {
            Snack.show(context, message: state.errorMessage.toString());
            context.read<KycBloc>().add(ClearErrorEvent());
          }
          // if (state.submitKyc) {
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const KycSubmitStatusScreen(),
          //     ),
          //     (Route<dynamic> route) => false,
          //   );
          // }
          // if (state.errorMessage != null && !state.isSubmittingKyc) {
          //   Snack.show(context, message: state.errorMessage!);
          //   context.read<KycBloc>().add(ClearErrorEvent());
          // }
        },
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
                horizontal: AdaptiveLayout.horizontalPadding(context),
                vertical: 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AdaptiveLayout.contentMaxWidth(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Personal ──────────────────────────────
                      _sectionTitle("Personal"),
                      const VSpace(12),

                      if (isMobile) ...[
                        _firstNameField(),
                        const VSpace(12),
                        _lastNameField(),
                      ] else
                        _twoColumnRow(_firstNameField(), _lastNameField()),

                      const VSpace(12),

                      if (isMobile) ...[
                        _mobileField(),
                        const VSpace(12),
                        _dobField(context, state),
                      ] else
                        _twoColumnRow(
                          _mobileField(),
                          _dobField(context, state),
                        ),

                      const VSpace(12),
                      const FormHeader(label: "Gender", isRequired: true),

                      _genderRow(context, state, isMobile),
                      const VSpace(12),

                      if (isMobile) ...[
                        _nationalIdField(),
                        const VSpace(12),
                        _monthlyIncomeField(),
                      ] else
                        _twoColumnRow(
                          _nationalIdField(),
                          _monthlyIncomeField(),
                        ),

                      const VSpace(12),

                      if (isMobile) ...[
                        _sourceFundsField(),
                        const VSpace(12),
                        _originCountryDropdown(context, state),
                      ] else
                        _twoColumnRow(
                          _sourceFundsField(),
                          _originCountryDropdown(context, state),
                        ),

                      const SizedBox(height: 20),

                      // ── Professional ──────────────────────────
                      _sectionTitle("Professional"),
                      const SizedBox(height: 8),
                      const FormHeader(
                        label: "Employment Type",
                        isRequired: true,
                      ),
                      _employmentTypeRow(context, state, isMobile),
                      const VSpace(12),
                      _employmentFields(context, state, isMobile),
                      const VSpace(12),
                      const FormHeader(label: "Sectors", isRequired: true),
                      _sectorDropdown(context, state),

                      const SizedBox(height: 20),

                      // ── Communication ─────────────────────────
                      _sectionTitle("Communication"),
                      const VSpace(12),

                      if (isMobile) ...[
                        _emailField(),
                        const VSpace(12),
                        _phoneField(),
                      ] else
                        _twoColumnRow(_emailField(), _phoneField()),

                      const VSpace(12),

                      if (isMobile) ...[
                        _postBoxField(),
                        const VSpace(12),
                        _addressField(),
                      ] else
                        _twoColumnRow(_postBoxField(), _addressField()),

                      const VSpace(12),
                      _locationDropdowns(context, state, isMobile),

                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "Documents",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const VSpace(12),
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
                                    const VSpace(12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DatePickerField(
                                            label:
                                                "Issue Date${doc.isMandatory ? "*" : ""}",
                                            selectedDate:
                                                doc.issueDate ?? DateTime.now(),
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
                                            selectedDate:
                                                doc.expiryDate ??
                                                DateTime.now(),
                                            firstDate: DateTime.now(),
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
                                  ],
                                ],
                              ),
                            ),
                            const VSpace(12),
                          ],
                        );
                      }),
                      const VSpace(12),
                      _sectionTitle("Photo & Signature"),
                      const VSpace(12),
                      _photoSignatureSection(context, state, isMobile),

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
    return AppText(
      title,
      style: AppTextStyle.bodyMedium,
      color: AppColors.black,
    );
  }

  // ── Personal fields ──────────────────────────────────────────

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

  Widget _genderRow(BuildContext context, KycState state, bool isMobile) {
    return Row(
      children: genders.map((e) {
        return SizedBox(
          width: isMobile ? 160.0 : 180.0,
          child: RadioListTile<String>(
            title: AppText(
              e,
              style: AppTextStyle.bodySmall,
              color: AppColors.black,
            ),
            value: e,
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
            groupValue: state.gender,
            onChanged: (value) =>
                context.read<KycBloc>().add(SelectGender(gender: value)),
          ),
        );
      }).toList(),
    );
  }

  Widget _originCountryDropdown(BuildContext context, KycState state) {
    if (state.originCountries.isEmpty) {
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
      ],
    );
  }

  // ── Professional fields ──────────────────────────────────────

  Widget _employmentTypeRow(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: employmentTypes.map((e) {
            return SizedBox(
              height: 50,
              width: isMobile ? 180.0 : 200.0,
              child: RadioListTile<String>(
                title: AppText(
                  e,
                  style: AppTextStyle.bodySmall,
                  color: AppColors.black,
                ),
                value: e,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
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
      return Column(
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
      );
    }
    return isMobile
        ? Column(
            children: [
              _businessNatureField(),
              const VSpace(12),
              _businessNameField(),
            ],
          )
        : _twoColumnRow(_businessNatureField(), _businessNameField());
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
        controller: _phNoCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: AppTextFieldFormatters.getFormatters(
          AppTextInputType.numberOnly,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Phone no is required";
          }
          if (value.length != 9) {
            return 'Please enter a valid 9 digits Phone Number';
          }
          return null;
        },
        maxLength: 9,
        fillColor: AppColors.glassWhite,
      ),
      // InputTextFormField(
      //   controller: _phNoCtrl,
      //   validationMessage: "Phone No",
      //   fieldType: FieldType.phone,
      //   isRequired: true,
      // ),
    ],
  );

  Widget _postBoxField() => Column(
    children: [
      const FormHeader(label: "Post Box No", isRequired: true),
      AppTextField(
        controller: _pbNoCtrl,
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
      return Column(
        children: [
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

    return Column(
      children: [
        _twoColumnRow(countryDrop, stateDrop),
        VSpace(12),
        _twoColumnRow(districtDrop, cityDrop),
      ],
    );
  }

  Widget _photoSignatureSection(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
    final boxSize = isMobile ? 100.0 : 120.0;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6), width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(AdaptiveLayout.horizontalPadding(context)),
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
          // final compressedBytes = await compressIfNeeded(bytes);
          finalBytes = bytes;
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
          _mediaBox(
            size: boxSize,
            child: state.photoFile != null
                ? Image.memory(
                    Uint8List.fromList(state.photoFile!),
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.camera_alt,
                    size: 40,
                    color: AppColors.textSecondary,
                  ),
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
          _mediaBox(
            size: boxSize,
            child: state.signatureFile != null
                ? Image.memory(
                    Uint8List.fromList(state.signatureFile!),
                    fit: BoxFit.fill,
                  )
                : const Icon(Icons.edit, size: 40),
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

  Widget _mediaBox({required double size, required Widget child}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC6C6C6)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(10.0), child: child),
    );
  }

  Widget bottomButton(BuildContext context, KycState state) {
    return Container(
      height: 100,
      color: AppColors.surface,
      padding: EdgeInsets.only(bottom: 30, right: 20, left: 20, top: 30),
      child: (state.isSubmittingKyc)
          ? AppButton(
              text: "",
              backgroundColor: AppColors.primary,
              isLoading: true,
              onPressed: () {},
            )
          : AppButton(
              text: "Continue",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (!_validateDropdowns(state)) return;

                context.read<KycBloc>().add(
                  UpdatePersonalInfoEvent(
                    firstName: _firstNameCtrl.text,
                    lastName: _lastNameCtrl.text,
                    nationalId: _nationalIdCtrl.text,
                    mobileNumber: _mobileCtrl.text,
                  ),
                );
                context.read<KycBloc>().add(
                  UpdateProfessionalInfoEvent(
                    monthlyIncome: _monthlyIncomeCtrl.text,
                    sourceFunds: _sourceFundsCtrl.text,
                    employerName: _employerNameCtrl.text,
                    natureOfBusiness: _businessNatureCtrl.text,
                    businessName: _businessNameCtrl.text,
                  ),
                );
                context.read<KycBloc>().add(
                  UpdateAddressInfoEvent(
                    email: _emailCtrl.text,
                    addressLine: _addressCtrl.text,
                    phNumber: _phNoCtrl.text,
                    pbNumber: _pbNoCtrl.text,
                  ),
                );

                context.read<KycBloc>().add(
                  SendOtpEvent(_mobileCtrl.text.trim()),
                );
              },
              backgroundColor: AppColors.primary,
              height: 40,
              width: 150,
            ),
    );
  }
}
