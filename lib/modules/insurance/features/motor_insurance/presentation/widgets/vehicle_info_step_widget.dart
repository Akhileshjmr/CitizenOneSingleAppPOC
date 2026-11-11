import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/assets/app_assets.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/api_constants.dart';
import 'package:citizenone_app/modules/insurance/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/modules/insurance/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/modules/insurance/core/network/session_image_headers.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_drop_down.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_network_image.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/form_header.dart';

import '../../../../design_system/atoms/app_text_field.dart';
import '../../data/models/risk_category_response_model.dart';

class VehicleInfoStepWidget extends StatelessWidget {
  const VehicleInfoStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VehicleInfoStepWidgetContent();
  }
}

class _VehicleInfoStepWidgetContent extends StatefulWidget {
  const _VehicleInfoStepWidgetContent();

  @override
  State<_VehicleInfoStepWidgetContent> createState() =>
      _VehicleInfoStepWidgetContentState();
}

class _VehicleInfoStepWidgetContentState
    extends State<_VehicleInfoStepWidgetContent> {
  late TextEditingController _regNoController;
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _yearOfManufacture;
  late TextEditingController _chasisNumber;
  late TextEditingController _engineNumber;
  late TextEditingController _colorController;
  late TextEditingController _riskCategoryController;
  late TextEditingController _motorRiskIdController;
  late TextEditingController _sumInsuredController;
  late TextEditingController _capacityNumberController;
  late TextEditingController _seatingCapacityController;
  late TextEditingController _tonnageController;

  @override
  void initState() {
    super.initState();
    final state = context.read<MotorInsuranceBloc>().state;
    _regNoController = TextEditingController(
        text: state.vehicleData?.registrationNumber ?? '');
    _makeController = TextEditingController(
        text: state.vehicleCreateEntity?.vehicleMake ?? '');
    _yearOfManufacture = TextEditingController(
        text: state.vehicleCreateEntity?.yearOfManufacture);
    _modelController = TextEditingController(
        text: state.vehicleCreateEntity?.vehicleModel ?? '');
    _chasisNumber = TextEditingController(
        text: state.vehicleCreateEntity?.chassisNumber ?? '');
    _engineNumber = TextEditingController(
        text: state.vehicleCreateEntity?.engineNumber ?? '');
    _colorController = TextEditingController(
        text: state.vehicleCreateEntity?.vehicleColor ?? '');
    _riskCategoryController = TextEditingController(
        text: state.vehicleCreateEntity?.riskCategoryName ?? '');
    _motorRiskIdController = TextEditingController(
        text: state.vehicleCreateEntity?.motorRiskCategoryId ?? '');
    _sumInsuredController = TextEditingController(
        text: (state.vehicleCreateEntity?.sumInsured == null ||
                state.vehicleCreateEntity?.sumInsured == 0)
            ? ''
            : state.vehicleCreateEntity!.sumInsured.toString());
    _capacityNumberController = TextEditingController(
        text: state.vehicleCreateEntity?.capacity?.toString() ?? '');
    _seatingCapacityController = TextEditingController(
        text: state.vehicleCreateEntity?.seatingCapacity?.toString() ?? '');
    _tonnageController = TextEditingController(
        text: state.vehicleCreateEntity?.tonnage?.toString() ?? '');
  }

  @override
  void dispose() {
    _regNoController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _chasisNumber.dispose();
    _engineNumber.dispose();
    _colorController.dispose();
    _riskCategoryController.dispose();
    _motorRiskIdController.dispose();
    _sumInsuredController.dispose();
    _capacityNumberController.dispose();
    _seatingCapacityController.dispose();
    _tonnageController.dispose();
    super.dispose();
  }

  void clearController() {
    _makeController.clear();
    _modelController.clear();
    _yearOfManufacture.clear();
    _chasisNumber.clear();
    _engineNumber.clear();
    _colorController.clear();
    _riskCategoryController.clear();
    _motorRiskIdController.clear();
    _sumInsuredController.clear();
    _capacityNumberController.clear();
    _seatingCapacityController.clear();
    _tonnageController.clear();
  }

  void _onManualDetailsChanged() {
    context.read<MotorInsuranceBloc>().add(
          UpdateVehicleManualDetailsEvent(
              motorRiskCategoryId: _motorRiskIdController.text,
              sumInsured: int.tryParse(_sumInsuredController.text) ?? 0,
              riskCategoryName: _riskCategoryController.text,
              vehicleRegNo: _regNoController.text.trim().toUpperCase(),
              vehicleMake: _makeController.text,
              vehicleModel: _modelController.text,
              chassisNumber: _chasisNumber.text,
              engineNumber: _engineNumber.text,
              yearOfManufacture: _yearOfManufacture.text,
              vehicleColor: _colorController.text,
              capacity: int.tryParse(_capacityNumberController.text),
              seatingCapacity: int.tryParse(_seatingCapacityController.text),
              tonnage: int.tryParse(_tonnageController.text)),
        );
  }

  void _onRiskCategoryChanged(RiskCategoryModel selectedRisk) {
    context
        .read<MotorInsuranceBloc>()
        .add(RiskCategoriesSelectedEvent(selectedRiskCategory: selectedRisk));
  }

  // void _onLookupRegNoChanged() {
  //   context.read<MotorInsuranceBloc>().add(
  //         UpdateVehicleInfoEvent(
  //           vehicleRegNo: _regNoController.text,
  //           vehicleMakeModel: '',
  //           vehicleYear: '',
  //         ),
  //       );
  // }

  Future<void> _performLookup() async {
    context.read<MotorInsuranceBloc>().add(ResetVehicleData());
    final regNo = _regNoController.text.trim().toUpperCase();
    if (regNo.isEmpty) {
      Snack.show(
        context,
        type: AppAlertType.warning,
        message: 'Please enter a registration number.',
      );
      return;
    }

    final zambiaRegExp = RegExp(r'^[A-Z]{3}\s?\d{4}(\s?ZM)?$');
    if (!zambiaRegExp.hasMatch(regNo)) {
      Snack.show(
        context,
        type: AppAlertType.warning,
        message:
            'Please enter a valid Zambia registration number (e.g. ZMW 1707 or e.g. ZMW 1707ZM).',
      );
      return;
    }

    _regNoController.text = regNo;
    _sumInsuredController.clear();

    context.read<MotorInsuranceBloc>().add(LookupVehicleEvent(regNo));

    context
        .read<MotorInsuranceBloc>()
        .add(FetchVehicleDetailsEvent(registrationNo: regNo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceBg),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 10,
                offset: Offset(3, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 17, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                'Vehicle Information',
                style: AppTextStyle.headlineMedium,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              if (state.isManualEntry) ...[
                _buildManualEntryForm(state),
              ] else ...[
                const VSpace(19),
                _buildLookupSection(state),
                const VSpace(24),
                if (_regNoController.text.isEmpty)
                  ...[]
                else if (state.vehicleInfoStatus ==
                    VehicleInformationStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (state.vehicleInfoStatus ==
                        VehicleInformationStatus.loaded &&
                    state.vehicleData != null) ...[
                  _buildVehicleFoundCard(state),
                  const VSpace(20),
                  _buildRiskCategorySelection(state),
                  const VSpace(20),
                  _buildBodyStyleSection(state),
                ] else if (state.vehicleInfoStatus ==
                        VehicleInformationStatus.error &&
                    state.vehicleData == null) ...[
                  _buildVehicleNotFoundCard(context),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildRiskCategorySelection(MotorInsuranceState state) {
    return state.vehicleData != null
        ? Column(
            children: [
              state.vehicleData?.riskCategoryId == null
                  ? AppDropDown<String>(
                      name: 'Risk Categories',
                      labelText: 'Risk Categories *',
                      labelStyle: const TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      borderColor: AppColors.textBorder,
                      initialValue: () {
                        final risk = state.selectedRiskCategory?.name;
                        if (risk == null || risk.isEmpty) return null;
                        final exists = state.riskCategoriesList
                                ?.any((e) => e.name == risk) ??
                            false;
                        return exists ? risk : null;
                      }(),
                      items: (state.riskCategoriesList ?? []).map((category) {
                        return DropdownMenuItem(
                          value: category.name,
                          child: Text(category.name!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          _onRiskCategoryChanged(
                              (state.riskCategoriesList ?? [])
                                  .firstWhere((e) => e.name == val));
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              const VSpace(15),
              (state.vehicleData?.sumInsured ?? 0.0) > 0.0
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const FormHeader(
                            label: 'Sum Insured', isRequired: true),
                        AppTextField(
                          controller: _sumInsuredController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            context.read<MotorInsuranceBloc>().add(
                                SumInsuredFieldChangeEvent(
                                    sumInusredValue: double.parse(
                                        _sumInsuredController.text)));
                          },
                          maxLength: 100,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Sum insured is required';
                            }
                            final val = int.tryParse(value.trim());
                            if (val == null || val <= 0) {
                              return 'Enter a valid sum insured';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ],
                    ),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildLookupSection(MotorInsuranceState state) {
    const String registrationValidatorMessage = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            AppText(
              'Vehicle Registration Number',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            AppText(
              ' *',
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ],
        ),
        const VSpace(4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                prefixIcon: AppAssets.iconSearchStar,
                controller: _regNoController,
                hintText: 'e.g. ZMW 1707',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  ZambiaPlateTextInputFormatter(),
                ],
              ),
            ),
            const HSpace(8),
            AppButton(
              text: 'Lookup',
              isFullWidth: false,
              width: 112,
              height: 50,
              isLoading: state.isSearchingVehicle,
              onPressed: _performLookup,
            ),
          ],
        ),
        const Text(registrationValidatorMessage)
      ],
    );
  }

  Widget _buildVehicleFoundCard(MotorInsuranceState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.brandLavender,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueShade),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                  package: AppConfig.packageName, AppAssets.iconSuccessCircle),
              const HSpace(10),
              const AppText(
                'Vehicle Found',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.blue700,
              ),
            ],
          ),
          const VSpace(16),
          _buildCardInfoRow('Make', state.vehicleData?.make ?? '-'),
          const VSpace(8),
          _buildCardInfoRow('Model', state.vehicleData?.model ?? '-'),
          const VSpace(8),
          _buildCardInfoRow('Color', state.vehicleData?.color ?? '-'),
        ],
      ),
    );
  }

  Widget _buildCardInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.3,
        ),
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleNotFoundCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.brandLavender,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blueShade),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                  package: AppConfig.packageName, AppAssets.iconSuccessCircle),
              const HSpace(10),
              const AppText(
                'Vehicle Not Found',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.bold,
                color: AppColors.blue700,
              ),
            ],
          ),
          const SizedBox(height: 32),
          InkWell(
              onTap: () {
                context
                    .read<MotorInsuranceBloc>()
                    .add(const SetVehicleManualEntryEvent(true));
                clearController();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceBgPurple)),
                child: const AppText(
                  'Enter Vehicle Details',
                  style: AppTextStyle.bodyMedium,
                  color: AppColors.surfaceBgPurple,
                  textAlign: TextAlign.center,
                ),
              )

              /*RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Click',
                    style: TextStyle(
                      color: AppColors.blue700,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: ' here to enter the details manually',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),*/
              ),
        ],
      ),
    );
  }

  Widget _buildManualEntryForm(MotorInsuranceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldWidget(
          label: 'Vehicle Registration Number',
          controller: _regNoController,
          inputType: AppTextInputType.alphaNumeric,
          length: 20,
          keyboardType: TextInputType.text,
          isRequired: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          additionalFormatters: [
            ZambiaPlateTextInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Registration number is required';
            }
            final regExp = RegExp(r'^[A-Z]{3}\s?\d{4}(\s?ZM)?$');
            if (!regExp.hasMatch(value.trim())) {
              return 'Enter a valid Zambia registration number (e.g. ZMW 1707)';
            }
            return null;
          },
        ),
        AppDropDown<String>(
          name: 'vehicleMake',
          labelText: 'Vehicle Make *',
          labelStyle: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
          borderColor: AppColors.textBorder,
          initialValue: () {
            final make = state.vehicleData?.make;
            if (make == null || make.isEmpty) return null;
            final exists =
                state.vehicleMakeList?.any((e) => e.name == make) ?? false;
            return exists ? make : null;
          }(),
          items: (state.vehicleMakeList ?? [])
              .map((e) => e.name)
              .whereType<String>()
              .toSet()
              .map((name) => DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) {
              _makeController.text = val;
              _onManualDetailsChanged();
            }
          },
        ),
        _fieldWidget(
          label: 'Vehicle Model',
          isRequired: true,
          controller: _modelController,
          inputType: AppTextInputType.alphaNumeric,
          length: 30,
          keyboardType: TextInputType.text,
        ),
        _fieldWidget(
          label: 'Year Of Manufacture',
          isRequired: true,
          controller: _yearOfManufacture,
          inputType: AppTextInputType.numberOnly,
          length: 4,
          keyboardType: TextInputType.number,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Year of manufacture is required';
            }
            final year = int.tryParse(value.trim());
            final currentYear = DateTime.now().year;
            if (year == null || value.trim().length != 4) {
              return 'Enter a valid 4-digit year';
            }
            if (year > currentYear) {
              return 'Year of manufacture cannot be in the future';
            }
            return null;
          },
        ),
        _fieldWidget(
          label: 'Engine Number',
          isRequired: true,
          controller: _engineNumber,
          inputType: AppTextInputType.alphaNumeric,
          length: 30,
          keyboardType: TextInputType.text,
          additionalFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            UpperCaseTextFormatter(),
          ],
        ),
        _fieldWidget(
            label: 'Sum Insured',
            isRequired: true,
            controller: _sumInsuredController,
            inputType: AppTextInputType.numberOnly,
            length: 8,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Sum insured is required';
              }
              final val = int.tryParse(value.trim());
              if (val == null || val <= 0) {
                return 'Enter a valid sum insured';
              }
              return null;
            }),
        _fieldWidget(
            label: 'Capacity',
            isRequired: false,
            controller: _capacityNumberController,
            inputType: AppTextInputType.numberOnly,
            length: 5,
            keyboardType: TextInputType.number),
        _fieldWidget(
            label: 'Seating Capacity',
            isRequired: false,
            controller: _seatingCapacityController,
            inputType: AppTextInputType.numberOnly,
            length: 2,
            keyboardType: TextInputType.number),
        _fieldWidget(
            label: 'Tonnage',
            isRequired: false,
            controller: _tonnageController,
            inputType: AppTextInputType.numberOnly,
            length: 2,
            keyboardType: TextInputType.number),
        _fieldWidget(
          label: 'Chassis Number',
          isRequired: true,
          controller: _chasisNumber,
          inputType: AppTextInputType.alphaNumeric,
          length: 30,
          keyboardType: TextInputType.text,
          additionalFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            UpperCaseTextFormatter(),
          ],
        ),
        AppDropDown<String>(
          name: 'Risk Categories',
          labelText: 'Risk Categories *',
          labelStyle: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
          borderColor: AppColors.textBorder,
          initialValue: () {
            final risk = state.selectedRiskCategory?.name;
            if (risk == null || risk.isEmpty) return null;
            final exists =
                state.riskCategoriesList?.any((e) => e.name == risk) ?? false;
            return exists ? risk : null;
          }(),
          items: (state.riskCategoriesList ?? []).map((category) {
            return DropdownMenuItem(
              value: category.name,
              child: Text(category.name!),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              _riskCategoryController.text = val;
              _motorRiskIdController.text = state.riskCategoriesList!
                  .firstWhere((e) => e.name == val)
                  .id
                  .toString();
              _onRiskCategoryChanged(
                  state.riskCategoriesList!.firstWhere((e) => e.name == val));
            }
          },
        ),
        _fieldWidget(
            label: 'Color',
            isRequired: true,
            controller: _colorController,
            inputType: AppTextInputType.stringOnly,
            length: 30,
            keyboardType: TextInputType.text),
        const VSpace(16),
        _buildBodyStyleSection(state),
      ],
    );
  }

  Widget _fieldWidget(
      {required String label,
      required TextEditingController controller,
      required AppTextInputType inputType,
      required int length,
      required TextInputType keyboardType,
      List<TextInputFormatter>? additionalFormatters,
      String? Function(String?)? validator,
      AutovalidateMode? autovalidateMode,
      int? errorMaxLines,
      bool isRequired = false}) {
    final formatters = AppTextFieldFormatters.getFormatters(inputType);
    if (additionalFormatters != null) {
      formatters.addAll(additionalFormatters);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VSpace(16),
        FormHeader(label: label, isRequired: isRequired),
        AppTextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) => _onManualDetailsChanged(),
          maxLength: length,
          inputFormatters: formatters,
          validator: validator,
          autovalidateMode: autovalidateMode,
          errorMaxLines: errorMaxLines,
        ),
        const VSpace(16),
      ],
    );
  }

  Widget _buildBodyStyleSection(MotorInsuranceState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Select Vehicle Body Style',
          style: AppTextStyle.headlineMedium,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisSpacing = 15.0;
            const mainAxisSpacing = 12.0;

            final width = constraints.maxWidth;

            final crossAxisCount = width < 600
                ? 3
                : width < 900
                    ? 4
                    : 5;

            final itemWidth =
                (width - (crossAxisCount - 1) * crossAxisSpacing) /
                    crossAxisCount;

            // Responsive height
            final itemHeight = (itemWidth * 0.9).clamp(100.0, 135.0);

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
                mainAxisExtent: itemHeight,
              ),
              itemCount: state.bodyStyleList?.length ?? 0,
              itemBuilder: (context, index) {
                final style = state.bodyStyleList![index];
                final name = style.name!;
                final image =
                    ApiConstants.insuranceBaseUrl + (style.imageUrl ?? '');
                final isSelected = state.vehicleBodyStyle == name;

                return InkWell(
                  onTap: () {
                    context
                        .read<MotorInsuranceBloc>()
                        .add(SelectVehicleBodyStyleEvent(name));
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.brandLavender
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.blue700
                            : AppColors.surfaceLight,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppNetworkImage(
                          image,
                          headers: {
                            ...sessionImageHeaders(),
                            'Authorization':
                                'Bearer ${AppConfig.staticInsuranceAccessToken}'
                          },
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AppText(
                            name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.caption,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                AdaptiveLayout.isMobile(context) ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
