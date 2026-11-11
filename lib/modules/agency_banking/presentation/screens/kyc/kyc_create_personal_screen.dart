import 'package:citizenone_app/modules/agency_banking/core/utils/formatter.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/date_picker_field.dart';
import 'package:citizenone_app/modules/agency_banking/core/widgets/input_form_field.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_create_professional_screen.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/app_bar/kyc_app_bar.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/button/kyc_custom_button.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/dropdown/app_drop_down.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/form_header.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_form_bits.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/kyc_desktop_scaffold.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/widgets/text_field/ag_textfield.dart';
import 'package:citizenone_app/modules/agency_banking/theme/colors/Appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        text: Formatter.formatNationalId(state.nationalId.toString()));
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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Breakpoints.isDesktop(constraints.maxWidth)) {
          return _buildDesktopScaffold(context);
        }
        return _buildMobileTabletScaffold(context);
      },
    );
  }

  void _onUserCheckListener(BuildContext context, KycState state) {
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
        appBar: const KycAppBar(title: "General Details"),
        body: BlocConsumer<KycBloc, KycState>(
          listener: _onUserCheckListener,
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

                          if (isMobile) ...[
                            _firstNameField(),
                            const SizedBox(height: 12),
                            _lastNameField(),
                          ] else
                            _twoColumnRow(_firstNameField(), _lastNameField()),

                          const SizedBox(height: 12),

                          // Gender label + radio row
                          const FormHeader(label: "Gender", isRequired: true),
                          _genderRow(context, state),

                          const SizedBox(height: 12),

                          // Mobile + DOB
                          if (isMobile) ...[
                            _mobileField(state),
                            const SizedBox(height: 12),
                            _dobField(context, state),
                          ] else
                            _twoColumnRow(
                                _mobileField(state), _dobField(context, state)),

                          const SizedBox(height: 12),

                          // National ID + Origin Country
                          if (isMobile) ...[
                            _nationalIdField(state),
                            const SizedBox(height: 12),
                            _originCountryDropdown(context, state),
                          ] else
                            _twoColumnRow(
                              _nationalIdField(state),
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
        ));
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return BlocConsumer<KycBloc, KycState>(
      listener: _onUserCheckListener,
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
        return Form(
          key: _formKey,
          child: KycDesktopScaffold(
            pageTitle: "General Details",
            pageSubtitle:
                "Enter the customer's personal information to proceed.",
            maxContentWidth: 650,
            child: KycDesktopCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KycSectionLabel("PERSONAL INFORMATION"),
                  _twoColumnRow(_firstNameField(), _lastNameField()),
                  const SizedBox(height: 16),
                  _twoColumnRow(_genderDropdownDesktop(context, state),
                      _mobileField(state)),
                  const SizedBox(height: 16),
                  _twoColumnRow(
                      _dobField(context, state), _nationalIdField(state)),
                  const SizedBox(height: 16),
                  _twoColumnRow(
                    _originCountryDropdown(context, state),
                    const SizedBox(),
                  ),
                  const SizedBox(height: 32),
                  KycDesktopButtonRow(
                    onBack: () => Navigator.pop(context),
                    onContinue: () => _handleContinue(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Layout helpers ───────────────────────────────────────────

  Widget _twoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        12.horizontalSpace,
        Expanded(child: right),
      ],
    );
  }

// ── Fields ───────────────────────────────────────────────────

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

  Widget _mobileField(KycState state) => Column(
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
            isRequired: true,
            maxLength: 9,
            requiredText: "Mobile Number is required",
            hintText: "e.g. 566789901",
            filled: true,
            isEnabled: state.searchType == SearchType.nationalId,
            fillColor: AppColors.white,
          ),
        ],
      );

  Widget _dobField(BuildContext context, KycState state) => Column(
        children: [
          const FormHeader(label: "Date of Birth", isRequired: true),
          DatePickerField(
            label: 'e.g. 09/02/1998',
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
            name: "National ID",
            controller: _nationalIdNoCtrl,
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
            isEnabled: state.searchType == SearchType.mobileNumber,
            fillColor: AppColors.white,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
              SlashFormatter(),
            ],
          ),
        ],
      );

  Widget _genderRow(BuildContext context, KycState state) {
    return Row(
      children: genders.map((e) {
        return SizedBox(
          width: Responsive.value(context, mobile: 160.0, web: 180.0),
          child: RadioListTile<String>(
            title: Text(
              e,
              style: TextStyle(fontSize: 14.sp),
            ),
            value: e,
            activeColor: AppColors.green,
            groupValue: state.gender,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) =>
                context.read<KycBloc>().add(SelectGender(gender: value)),
          ),
        );
      }).toList(),
    );
  }

  /// Desktop-only Gender control — the reference design renders Gender as a
  /// dropdown rather than the radio-pill row used on mobile/tablet.
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
        AppDropDown<LocationOption>(
            name: "Select Origin Country",
            initialValue:
                state.originCountries.contains(state.selectedOriginCountry)
                    ? state.selectedOriginCountry
                    : null,
            hintText: "Select Origin Country",
            items: state.originCountries.map((country) {
              return DropdownMenuItem(
                  value: country, child: Text(country.name));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<KycBloc>().add(SelectOriginCountryEvent(value));
              }
            }),
        // DropdownButtonFormField<LocationOption>(
        //   value: state.originCountries.contains(state.selectedOriginCountry)
        //       ? state.selectedOriginCountry
        //       : null,
        //   decoration: InputDecoration(
        //     hintText: "Select Origin Country",
        //     hintStyle:  TextStyle(color: AppColors.textHint, fontSize: 14.sp),
        //     filled: true,
        //     fillColor: AppColors.white,
        //     contentPadding:
        //          EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10.sp),
        //       borderSide: const BorderSide(color: Color(0xFFC6C6C6)),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10.sp),
        //       borderSide: const BorderSide(color: AppColors.gray),
        //     ),
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.sp)),
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

  void _handleContinue(BuildContext context) {
    final currentState = context.read<KycBloc>().state;
    if (!_formKey.currentState!.validate()) return;
    if (!_validatePersonal(currentState)) return;
    if (currentState.searchType == SearchType.mobileNumber) {
      context.read<KycBloc>().add(CheckUserExistsEvent(
          mobileNumber: "", nationalId: _nationalIdNoCtrl.text));
    } else {
      context.read<KycBloc>().add(
          CheckUserExistsEvent(mobileNumber: _mobileCtrl.text, nationalId: ""));
    }
    if (_formKey.currentState!.validate()) {
      context.read<KycBloc>().add(UpdatePersonalInfoEvent(
            firstName: _firstNameCtrl.text,
            lastName: _lastNameCtrl.text,
            nationalId: _nationalIdNoCtrl.text,
            mobileNumber: _mobileCtrl.text,
          ));
    }
  }
}
