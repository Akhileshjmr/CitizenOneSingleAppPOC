import 'package:citizenone_app/modules/agency_banking/core/utils/repsonsive_helper.dart';
import 'package:citizenone_app/modules/agency_banking/core/utils/snack.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/responsive/breakpoints.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/screens/kyc/kyc_create_communication_screen.dart';
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

class KycCreateProfessionalScreen extends StatefulWidget {
  const KycCreateProfessionalScreen({super.key});

  @override
  State<KycCreateProfessionalScreen> createState() =>
      _KycCreateProfessionalScreenState();
}

class _KycCreateProfessionalScreenState
    extends State<KycCreateProfessionalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _employerNameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();
  final _monthlyIncomeCtrl = TextEditingController();
  final _sourceFundsCtrl = TextEditingController();
  final _natureOfBusinessCtrl = TextEditingController();

  final List<String> employmentTypes = ["Employed", "Self Employment"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _employerNameCtrl.dispose();
    _businessNameCtrl.dispose();
    _monthlyIncomeCtrl.dispose();
    _sourceFundsCtrl.dispose();
    _natureOfBusinessCtrl.dispose();
    super.dispose();
  }

  bool _validateProfessional(KycState state) {
    if (state.employmentType == null) {
      return _showError("Please select Employment Type");
    }

    if (state.selectedSector == null) {
      return _showError("Please select Sector");
    }

    if (state.employmentType == "Employed") {
      if (_employerNameCtrl.text.trim().isEmpty) {
        return _showError("Please enter Employer Name");
      }
    } else if (state.employmentType == "Self Employment") {
      if (_natureOfBusinessCtrl.text.trim().isEmpty) {
        return _showError("Please enter Nature of Business");
      }
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

  Widget _buildMobileTabletScaffold(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return _bottomButtons(context, state);
        },
      ),
      appBar: const KycAppBar(title: "Professional Details"),
      body: Form(
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
                  const FormHeader(label: "Employment Type", isRequired: true),
                  _employmentTypeRow(context),
                  const SizedBox(height: 12),

                  // Employed/Self-employment fields
                  _employmentFields(context, isMobile),
                  const SizedBox(height: 12),

                  const FormHeader(label: "Sectors", isRequired: true),
                  _sectorDropdown(context),
                  const SizedBox(height: 12),

                  // Monthly Income + Source of Funds
                  if (isMobile) ...[
                    _monthlyIncomeField(),
                    const SizedBox(height: 12),
                    _sourceFundsField(),
                  ] else
                    _twoColumnRow(_monthlyIncomeField(), _sourceFundsField()),

                  const SizedBox(height: 32),
                  //  _continueButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopScaffold(BuildContext context) {
    return Form(
      key: _formKey,
      child: KycDesktopScaffold(
        pageTitle: "Employment Type",
        pageSubtitle:
            "Provide employment and income details for KYC compliance.",
        maxContentWidth: 650,
        child: KycDesktopCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KycSectionLabel("EMPLOYMENT TYPE"),
              _employmentTypeCardsDesktop(context),
              const SizedBox(height: 16),
              _employmentFieldsDesktop(context),
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

// ── Section widgets ──────────────────────────────────────────

  Widget _employmentTypeRow(BuildContext context) {
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
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.green,
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

  Widget _employmentFields(BuildContext context, bool isMobile) {
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        if (employmentType == employmentTypes[0]) {
          // Employed — single field, full width
          return _employerNameField();
        }
        // Self Employment — two fields, side by side on web
        return isMobile
            ? Column(
                children: [
                  _natureOfBusinessField(),
                  const SizedBox(height: 12),
                  _businessNameField(),
                ],
              )
            : _twoColumnRow(_natureOfBusinessField(), _businessNameField());
      },
    );
  }

  /// Desktop-only bordered selector cards ("Salaried Employee" / "Self
  /// Employed") — replaces the plain `RadioListTile` row used on mobile,
  /// matching the reference designs. Underlying values stay
  /// `employmentTypes` ("Employed"/"Self Employment"); only the on-screen
  /// labels differ from the stored value.
  Widget _employmentTypeCardsDesktop(BuildContext context) {
    const desktopLabels = ["Salaried Employee", "Self Employed"];
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: [
            for (var i = 0; i < employmentTypes.length; i++) ...[
              if (i > 0) const SizedBox(width: 16),
              Expanded(
                child: KycSelectorCard(
                  label: desktopLabels[i],
                  selected: employmentType == employmentTypes[i],
                  onTap: () => context.read<KycBloc>().add(
                      SelectEmploymentType(employmentType: employmentTypes[i])),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  /// Desktop-only field pairing matching the reference designs: Salaried
  /// pairs Employer Name with Sectors, then Monthly Income with Source of
  /// Funds; Self Employed pairs Nature of Business with Business Name, then
  /// Sectors with Monthly Income, then Source of Funds alone.
  Widget _employmentFieldsDesktop(BuildContext context) {
    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        if (employmentType == employmentTypes[0]) {
          return Column(
            children: [
              _twoColumnRow(_employerNameField(), _sectorField(context)),
              const SizedBox(height: 16),
              _twoColumnRow(_monthlyIncomeField(), _sourceFundsField()),
            ],
          );
        }
        return Column(
          children: [
            _twoColumnRow(_natureOfBusinessField(), _businessNameField()),
            const SizedBox(height: 16),
            _twoColumnRow(_sectorField(context), _monthlyIncomeField()),
            const SizedBox(height: 16),
            _twoColumnRow(_sourceFundsField(), const SizedBox()),
          ],
        );
      },
    );
  }

  Widget _sectorField(BuildContext context) => Column(
        children: [
          const FormHeader(label: "Sectors", isRequired: true),
          _sectorDropdown(context),
        ],
      );

  Widget _sectorDropdown(BuildContext context) {
    return BlocSelector<KycBloc, KycState, LocationOption?>(
      selector: (state) => state.sectors.contains(state.selectedSector)
          ? state.selectedSector
          : null,
      builder: (context, selectedSector) {
        final sectors = context.select((KycBloc bloc) => bloc.state.sectors);
        return AppDropDown<LocationOption>(
          name: "Sectors",
          initialValue: selectedSector,
          items: sectors.map((sector) {
            return DropdownMenuItem(value: sector, child: Text(sector.name));
          }).toList(),
          hintText: "Select Sector",
          onChanged: (value) {
            if (value != null) {
              context.read<KycBloc>().add(SelectSectorEvent(value));
            }
          },
        );
      },
    );
    // return BlocSelector<KycBloc, KycState, LocationOption?>(
    //   selector: (state) => state.sectors.contains(state.selectedSector)
    //       ? state.selectedSector
    //       : null,
    //   builder: (context, selectedSector) {
    //     final sectors = context.select((KycBloc bloc) => bloc.state.sectors);
    //     return Dropdown(
    //       value: selectedSector?.name,
    //       items: sectors.map((e) => e.name).toList(),
    //       hintText: "Select Sector",
    //       onChanged: (value) {
    //         final sector = sectors.firstWhere((e) => e.name == value);
    //         context.read<KycBloc>().add(SelectSectorEvent(sector));
    //       },
    //     );
    //   },
    // );
  }

// ── Fields ───────────────────────────────────────────────────

  Widget _employerNameField() => Column(
        key: const ValueKey("employer_name_field"),
        children: [
          const FormHeader(label: "Employer Name", isRequired: true),
          AppTextField(
            name: "Employer Name",
            controller: _employerNameCtrl,
            inputType: AppTextInputType.alphaNumeric,
            isRequired: true,
            maxLength: 60,
            requiredText: "Employer Name is required",
            filled: true,
            fillColor: AppColors.white,
          )
        ],
      );

  Widget _natureOfBusinessField() => Column(
        key: const ValueKey("nature_of_business_field"),
        children: [
          const FormHeader(label: "Nature of Business", isRequired: true),
          AppTextField(
            name: "Nature of Business",
            controller: _natureOfBusinessCtrl,
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
        key: const ValueKey("business_name_field"),
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

  Widget _bottomButtons(BuildContext context, KycState state) {
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
    final state = context.read<KycBloc>().state;
    if (!_formKey.currentState!.validate()) return;
    if (!_validateProfessional(state)) return;
    context.read<KycBloc>().add(UpdateProfessionalInfoEvent(
        employerName: _employerNameCtrl.text,
        monthlyIncome: _monthlyIncomeCtrl.text,
        sourceFunds: _sourceFundsCtrl.text,
        natureOfBusiness: _natureOfBusinessCtrl.text,
        businessName: _businessNameCtrl.text));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const KycCreateCommunicationScreen(),
      ),
    );
  }
}
