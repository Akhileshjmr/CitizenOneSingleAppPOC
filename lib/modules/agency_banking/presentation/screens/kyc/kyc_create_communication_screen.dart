import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_create_document_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/dropdown/app_drop_down.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/form_header.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/ag_textfield.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  void initState() {
    super.initState();
    _phNoCtrl.text = context.read<KycBloc>().state.mobileNumber ?? "";
  }

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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  bool _locationsBuildWhen(KycState previous, KycState current) {
    return previous.countries != current.countries ||
        previous.filteredStates != current.filteredStates ||
        previous.districts != current.districts ||
        previous.filteredCities != current.filteredCities ||
        previous.selectedCountry != current.selectedCountry ||
        previous.selectedState != current.selectedState ||
        previous.selectedDistrict != current.selectedDistrict ||
        previous.selectedCity != current.selectedCity;
  }

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return bottomButtons(context, state);
        },
      ),
      appBar: const KycAppBar(title: "Communication  Details"),
      body: BlocBuilder<KycBloc, KycState>(
        buildWhen: _locationsBuildWhen,
        builder: (context, state) {
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

  Widget _buildDesktopScaffold(BuildContext context) {
    return Form(
      key: _formKey,
      child: KycDesktopScaffold(
        pageTitle: "Communication Details",
        pageSubtitle:
            "Provide contact and address information for correspondence.",
        maxContentWidth: 650,
        child: KycDesktopCard(
          child: BlocBuilder<KycBloc, KycState>(
            buildWhen: _locationsBuildWhen,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KycSectionLabel("CONTACT INFORMATION"),
                  _twoColumnRow(
                      _emailField(), _phoneField(label: "Phone Number")),
                  const SizedBox(height: 16),
                  _twoColumnRow(
                      _addressField(), _postBoxField(label: "Post Box Number")),
                  const SizedBox(height: 16),
                  if (state.countries.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else
                    _locationDropdowns(context, state, false),
                  const SizedBox(height: 32),
                  KycDesktopButtonRow(
                    onBack: () => Navigator.pop(context),
                    onContinue: () => _handleContinue(context, state),
                  ),
                ],
              );
            },
          ),
        ),
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

  Widget _addressField() => Column(
        children: [
          const FormHeader(label: "Address Line", isRequired: true),
          AppTextField(
            name: "Address Line",
            controller: _addressLineCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 70,
            requiredText: "Address Line is required",
            filled: true,
            fillColor: AppColors.white,
          )
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
            filled: true,
            fillColor: AppColors.white,
          ),
        ],
      );

  Widget _postBoxField({String label = "Post Box No"}) => Column(
        children: [
          FormHeader(label: label, isRequired: true),
          AppTextField(
            name: label,
            controller: _pbNoCtrl,
            inputType: AppTextInputType.numberOnly,
            isRequired: true,
            maxLength: 6,
            requiredText: "Post Box No is required",
            filled: true,
            fillColor: AppColors.white,
          ),
        ],
      );

  // /// Shared decoration for all location dropdowns
  // InputDecoration _dropdownDecoration(String hint) {
  //   return InputDecoration(
  //     hintText: hint,
  //     hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
  //     filled: true,
  //     fillColor: AppColors.white,
  //     contentPadding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
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
      BuildContext context, KycState state, bool isMobile) {
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
          12.verticalSpace,
          const FormHeader(label: "State", isRequired: true),
          stateDrop,
          12.verticalSpace,
          const FormHeader(label: "District", isRequired: true),
          districtDrop,
          12.verticalSpace,
          const FormHeader(label: "City", isRequired: true),
          cityDrop,
        ],
      );
    }

    return Column(
      children: [
        _twoColumnRow(
          _labeledDropdown("Country", countryDrop),
          _labeledDropdown("State", stateDrop),
        ),
        12.verticalSpace,
        _twoColumnRow(
          _labeledDropdown("District", districtDrop),
          _labeledDropdown("City", cityDrop),
        ),
      ],
    );
  }

  Widget _labeledDropdown(String label, Widget dropdown) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormHeader(label: label, isRequired: true),
          dropdown,
        ],
      );

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
            onTap: () => _handleContinue(context, state),
            backgroundColor: AppColors.teal1,
            height: 40.h,
            width: 150.w,
          ),
        ],
      ),
    );
  }

  void _handleContinue(BuildContext context, KycState state) {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateDropdowns(state)) return;
    context.read<KycBloc>().add(UpdateAddressInfoEvent(
        email: _emailCtrl.text,
        addressLine: _addressLineCtrl.text,
        phNumber: _phNoCtrl.text,
        pbNumber: _pbNoCtrl.text));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KycCreateDocumentScreen(),
      ),
    );
  }
}
