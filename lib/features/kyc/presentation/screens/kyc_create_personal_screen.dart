import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/formatter.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/design_system.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_professional_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/design_system/atoms/date_picker_field.dart';
import 'package:citizenone_app/design_system/atoms/app_drop_down.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/form_header.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycCreatePersonalScreen extends StatefulWidget {
  const KycCreatePersonalScreen({super.key});

  @override
  State<KycCreatePersonalScreen> createState() =>
      _KycCreatePersonalScreenState();
}

class _KycCreatePersonalScreenState extends State<KycCreatePersonalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  late TextEditingController _nationalIdNoCtrl;
  late TextEditingController _mobileCtrl;

  final List<String> genders = ["MALE", "FEMALE"];

  @override
  void initState() {
    super.initState();
    final state = context.read<KycBloc>().state;
    _mobileCtrl = TextEditingController(text: state.mobileNumber ?? "");
    _nationalIdNoCtrl = TextEditingController(
      text: Formatter.formatNationalId(state.nationalId.toString()),
    );
    context.read<KycBloc>().add(LoadLocationsEvent());
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _mobileCtrl.dispose();
    _nationalIdNoCtrl.dispose();
    super.dispose();
  }

  bool _validatePersonal(KycState state) {
    if (state.gender == null) {
      return _showError("Please select Gender");
    }

    if (state.dob == null) {
      return _showError("Please select Date of Birth");
    }

    if (state.selectedOriginCountry == null) {
      return _showError("Please select Origin Country");
    }

    return true;
  }

  bool _showError(String message) {
    Snack.show(context, message: message);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButtons(context, state);
        },
      ),
      appBar: AppStatusBar(title: "General Details"),
      body: BlocConsumer<KycBloc, KycState>(
        listener: (context, state) {
          if (state.isUserExists) {
            if (state.searchType == SearchType.mobileNumber) {
              _showError("The National ID already exists");
            } else if (state.searchType == SearchType.nationalId) {
              _showError("The Mobile Number already exists");
            }
          }
          if (state.navigateAfterUserCheck) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KycCreateProfessionalScreen(),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          return previous.countries != current.countries ||
              previous.filteredStates != current.filteredStates ||
              previous.districts != current.districts ||
              previous.filteredCities != current.filteredCities ||
              previous.selectedCountry != current.selectedCountry ||
              previous.selectedState != current.selectedState ||
              previous.selectedDistrict != current.selectedDistrict ||
              previous.selectedCity != current.selectedCity ||
              previous.gender != current.gender ||
              previous.dob != current.dob;
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
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
                        const VSpace(12),

                        if (isMobile) ...[
                          _firstNameField(),
                          const VSpace(12),
                          _lastNameField(),
                        ] else
                          _twoColumnRow(
                            _firstNameField(),
                            _lastNameField(),
                            _mobileField(state),
                          ),

                        const VSpace(12),

                        // Gender label + radio row
                        const FormHeader(label: "Gender", isRequired: true),
                        _genderRow(context, state, isMobile),

                        const VSpace(12),

                        // Mobile + DOB
                        if (isMobile) ...[
                          _mobileField(state),
                          const VSpace(12),
                          _dobField(context, state),
                        ],
                        // else
                        //   _twoColumnRow(
                        //       _mobileField(state), _dobField(context, state)),
                        const VSpace(12),

                        // National ID + Origin Country
                        if (isMobile) ...[
                          _nationalIdField(state),
                          const VSpace(12),
                          _originCountryDropdown(context, state),
                        ] else
                          _twoColumnRow(
                            _nationalIdField(state),
                            _dobField(context, state),
                            _originCountryDropdown(context, state),
                          ),

                        const SizedBox(height: 32),
                        //  _continueButton(context, state),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Layout helpers ───────────────────────────────────────────

  Widget _twoColumnRow(Widget left, Widget center, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        HSpace(12),
        Expanded(child: center),
        HSpace(12),
        Expanded(child: right),
      ],
    );
  }

  // ── Fields ───────────────────────────────────────────────────

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

  Widget _mobileField(KycState state) => Column(
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
        isEnabled: state.searchType == SearchType.nationalId,
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
        firstDate: DateTime(1900),
        onDateSelected: (date) =>
            context.read<KycBloc>().add(SelectDob(dob: date)),
      ),
    ],
  );

  Widget _nationalIdField(KycState state) => Column(
    children: [
      const FormHeader(label: "National ID", isRequired: true),
      AppTextField(
        controller: _nationalIdNoCtrl,
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

        isEnabled: state.searchType == SearchType.mobileNumber,
        fillColor: AppColors.surface,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
          SlashFormatter(),
        ],
      ),
    ],
  );

  Widget _genderRow(BuildContext context, KycState state, bool isMobile) {
    return Row(
      children: genders.map((e) {
        return SizedBox(
          height: 50,
          width: isMobile ? 170.0 : 200.0,
          child: RadioListTile<String>(
            title: AppText(
              e,
              style: AppTextStyle.bodySmall,
              color: AppColors.black,
            ),

            value: e,
            activeColor: AppColors.primary,
            groupValue: state.gender,
            contentPadding: EdgeInsets.zero,
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
        // DropdownButtonFormField<LocationOption>(
        //   value: state.originCountries.contains(state.selectedOriginCountry)
        //       ? state.selectedOriginCountry
        //       : null,
        //   decoration: InputDecoration(
        //     hintText: "Select Origin Country",
        //     hintStyle:  TextStyle(color: AppColors.textHint, fontSize: 14),
        //     filled: true,
        //     fillColor: AppColors.surface,
        //     contentPadding:
        //          EdgeInsets.symmetric(vertical: 13, horizontal: 16),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       borderSide: const BorderSide(color: AppColors.gray),
        //     ),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        //   ),
        //   items: state.originCountries.map((country) {
        //     return DropdownMenuItem(value: country, child: Text(country.name));
        //   }).toList(),
        //   onChanged: (value) {
        //     if (value != null) {
        //       context.read<KycBloc>().add(SelectOriginCountryEvent(value));
        //     }
        //   },
        // ),
      ],
    );
  }

  Widget bottomButtons(BuildContext context, KycState state) {
    final bool isMobile = AdaptiveLayout.isMobile(context);

    return Container(
      height: isMobile ? 100 : 80,
      color: AppColors.surface,
      padding: isMobile
          ? EdgeInsets.only(bottom: 20, right: 10, left: 10)
          : EdgeInsets.only(bottom: 4, right: 30, left: 30),
      child: Row(
        mainAxisAlignment: isMobile
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.center,
        children: [
          AppButton(
            text: "Back",
            onPressed: () => Navigator.pop(context),
            backgroundColor: AppColors.surface,
            borderColor: AppColors.primary,
            variant: AppButtonVariant.outline,
            textColor: AppColors.black,
            width: isMobile ? 150 : 80,
            height: 40,
          ),
          HSpace(20),
          AppButton(
            text: "Continue",
            onPressed: () {
              final currentState = context.read<KycBloc>().state;
              if (!_formKey.currentState!.validate()) return;
              if (!_validatePersonal(currentState)) return;
              if (currentState.searchType == SearchType.mobileNumber) {
                context.read<KycBloc>().add(
                  CheckUserExistsEvent(
                    mobileNumber: "",
                    nationalId: _nationalIdNoCtrl.text,
                  ),
                );
              } else {
                context.read<KycBloc>().add(
                  CheckUserExistsEvent(
                    mobileNumber: _mobileCtrl.text,
                    nationalId: "",
                  ),
                );
              }
              if (_formKey.currentState!.validate()) {
                context.read<KycBloc>().add(
                  UpdatePersonalInfoEvent(
                    firstName: _firstNameCtrl.text,
                    lastName: _lastNameCtrl.text,
                    nationalId: _nationalIdNoCtrl.text,
                    mobileNumber: _mobileCtrl.text,
                  ),
                );
              }
            },
            backgroundColor: AppColors.primary,
            height: 40,
            width: isMobile ? 150 : 80,
          ),
        ],
      ),
    );
  }
}
