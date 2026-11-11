import 'package:citizenone_app/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/core/theme/tokens/colors.dart';
import 'package:citizenone_app/core/utils/snack.dart';
import 'package:citizenone_app/design_system/atoms/app_button.dart';
import 'package:citizenone_app/design_system/atoms/app_text.dart';
import 'package:citizenone_app/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/presentation/screens/kyc_create_communication_screen.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_bloc.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/design_system/atoms/app_drop_down.dart';
import 'package:citizenone_app/features/kyc/presentation/widgets/form_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final bool isMobile = AdaptiveLayout.isMobile(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BlocBuilder<KycBloc, KycState>(
        builder: (context, state) {
          return _bottomButtons(context, state);
        },
      ),
      appBar: AppStatusBar(title: "Professional Details"),
      body: Form(
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
                  const FormHeader(label: "Employment Type", isRequired: true),
                  _employmentTypeRow(context),
                  const VSpace(12),

                  // Employed/Self-employment fields
                  _employmentFields(context, isMobile),
                  const VSpace(12),

                  const FormHeader(label: "Sectors", isRequired: true),
                  _sectorDropdown(context),
                  const VSpace(12),

                  // Monthly Income + Source of Funds
                  if (isMobile) ...[
                    _monthlyIncomeField(),
                    const VSpace(12),
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
    final bool isMobile = AdaptiveLayout.isMobile(context);

    return BlocSelector<KycBloc, KycState, String?>(
      selector: (state) => state.employmentType,
      builder: (context, employmentType) {
        return Row(
          children: employmentTypes.map((e) {
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
                  const VSpace(12),
                  _businessNameField(),
                ],
              )
            : _twoColumnRow(_natureOfBusinessField(), _businessNameField());
      },
    );
  }

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

  Widget _natureOfBusinessField() => Column(
    children: [
      const FormHeader(label: "Nature of Business", isRequired: true),
      AppTextField(
        controller: _natureOfBusinessCtrl,
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

  Widget _bottomButtons(BuildContext context, KycState state) {
    return Container(
      height: 100,
      color: AppColors.surface,
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
              final state = context.read<KycBloc>().state;
              if (!_formKey.currentState!.validate()) return;
              if (!_validateProfessional(state)) return;
              context.read<KycBloc>().add(
                UpdateProfessionalInfoEvent(
                  employerName: _employerNameCtrl.text,
                  monthlyIncome: _monthlyIncomeCtrl.text,
                  sourceFunds: _sourceFundsCtrl.text,
                  natureOfBusiness: _natureOfBusinessCtrl.text,
                  businessName: _businessNameCtrl.text,
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KycCreateCommunicationScreen(),
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
