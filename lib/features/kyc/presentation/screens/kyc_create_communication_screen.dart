import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_document_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/design_system/atoms/app_drop_down.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/form_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycCreateCommunicationScreen extends StatefulWidget {
  const KycCreateCommunicationScreen({super.key});

  @override
  State<KycCreateCommunicationScreen> createState() =>
      KycCreateCommunicationScreenState();
}

class KycCreateCommunicationScreenState
    extends State<KycCreateCommunicationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _addressLineCtrl = TextEditingController();
  final _phNoCtrl = TextEditingController();
  final _pbNoCtrl = TextEditingController();
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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _addressLineCtrl.dispose();
    _phNoCtrl.dispose();
    _pbNoCtrl.dispose();

    super.dispose();
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
      appBar: AppStatusBar(title: "Communication  Details"),
      body: BlocBuilder<KycBloc, KycState>(
        buildWhen: (previous, current) {
          return previous.countries != current.countries ||
              previous.filteredStates != current.filteredStates ||
              previous.districts != current.districts ||
              previous.filteredCities != current.filteredCities ||
              previous.selectedCountry != current.selectedCountry ||
              previous.selectedState != current.selectedState ||
              previous.selectedDistrict != current.selectedDistrict ||
              previous.selectedCity != current.selectedCity;
        },
        builder: (context, state) {
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
                      const SizedBox(height: 12),

                      // Email + Phone
                      if (isMobile) ...[
                        _emailField(),
                        const SizedBox(height: 12),
                        _phoneField(),
                      ] else
                        _twoColumnRow(_emailField(), _phoneField()),

                      const SizedBox(height: 12),

                      // Address + Post Box
                      if (isMobile) ...[
                        _addressField(),
                        const SizedBox(height: 12),
                        _postBoxField(),
                      ] else
                        _twoColumnRow(_addressField(), _postBoxField()),

                      const SizedBox(height: 20),

                      if (state.countries.isEmpty)
                        const Center(child: CircularProgressIndicator())
                      else
                        _locationDropdowns(context, state, isMobile),

                      const SizedBox(height: 32),
                      //  _continueButton(context, state),
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
  // ── Layout helpers ───────────────────────────────────────────

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

  // ── Fields ───────────────────────────────────────────────────

  Widget _emailField() => Column(
    children: [
      const FormHeader(label: "Email ID", isRequired: true),
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

  Widget _addressField() => Column(
    children: [
      const FormHeader(label: "Address Line", isRequired: true),
      AppTextField(
        controller: _addressLineCtrl,
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

  // /// Shared decoration for all location dropdowns
  // InputDecoration _dropdownDecoration(String hint) {
  //   return InputDecoration(
  //     hintText: hint,
  //     hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
  //     filled: true,
  //     fillColor: AppColors.glassWhite,
  //     contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 16.w),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10),
  //       borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(10.sp),
  //       borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
  //     ),
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
  //   );
  // }

  Widget _locationDropdowns(
    BuildContext context,
    KycState state,
    bool isMobile,
  ) {
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

    //  DropdownButtonFormField<LocationOption>(
    //   value: state.countries.contains(state.selectedCountry)
    //       ? state.selectedCountry
    //       : null,
    //   decoration: _dropdownDecoration("Select Country"),
    //   items: state.countries
    //       .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
    //       .toList(),
    //   onChanged: (value) {
    //     if (value != null) {
    //       context.read<KycBloc>().add(SelectCountryEvent(value));
    //     }
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

    //  DropdownButtonFormField<LocationOption>(
    //   value: state.filteredStates.contains(state.selectedState)
    //       ? state.selectedState
    //       : null,
    //   decoration: _dropdownDecoration("Select State"),
    //   items: state.filteredStates
    //       .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
    //       .toList(),
    //   onChanged: state.filteredStates.isEmpty
    //       ? null
    //       : (value) {
    //           if (value != null) {
    //             context.read<KycBloc>().add(SelectStateEvent(value));
    //           }
    //         },
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

    // DropdownButtonFormField<LocationOption>(
    //   value: state.filteredDistricts.contains(state.selectedDistrict)
    //       ? state.selectedDistrict
    //       : null,
    //   decoration: _dropdownDecoration("Select District"),
    //   items: state.filteredDistricts
    //       .map((d) => DropdownMenuItem(value: d, child: Text(d.name)))
    //       .toList(),
    //   onChanged: state.filteredDistricts.isEmpty
    //       ? null
    //       : (value) {
    //           if (value != null) {
    //             context.read<KycBloc>().add(SelectDistrictEvent(value));
    //           }
    //         },
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

    // DropdownButtonFormField<LocationOption>(
    //   value: state.filteredCities.contains(state.selectedCity)
    //       ? state.selectedCity
    //       : null,
    //   decoration: _dropdownDecoration("Select City"),
    //   items: state.filteredCities
    //       .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
    //       .toList(),
    //   onChanged: state.filteredCities.isEmpty
    //       ? null
    //       : (value) {
    //           if (value != null) {
    //             context.read<KycBloc>().add(SelectCityEvent(value));
    //           }
    //         },
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

  Widget bottomButtons(BuildContext context, KycState state) {
    return Container(
      height: 100,
      color: AppColors.glassWhite,
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
              if (!_formKey.currentState!.validate()) return;
              if (!_validateDropdowns(state)) return;
              context.read<KycBloc>().add(
                UpdateAddressInfoEvent(
                  email: _emailCtrl.text,
                  addressLine: _addressLineCtrl.text,
                  phNumber: _phNoCtrl.text,
                  pbNumber: _pbNoCtrl.text,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KycCreateDocumentScreen(),
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
