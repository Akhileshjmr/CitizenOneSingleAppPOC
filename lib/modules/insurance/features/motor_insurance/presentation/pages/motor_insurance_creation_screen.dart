// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/presentation/widgets/spacing.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/molecules/quote_summary_card.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/vehicle_create_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/kyc_user_details_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/pages/motor_insurance_screen.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/custom_stepper.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/desktop_payment_panel.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/desktop_stepper.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/policy_details_step_widget.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/purchase_step_widget.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/quick_comparison_step_widget.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/quote_step_widget.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/vehicle_info_step_widget.dart';

import '../../../../core/utils/snack.dart';
import '../widgets/motor_insurance_payment_bottom_sheet.dart';

class MotorInsuranceCreationScreen extends StatefulWidget {
  const MotorInsuranceCreationScreen({super.key});

  @override
  State<MotorInsuranceCreationScreen> createState() =>
      _MotorInsuranceCreationScreenState();
}

class _MotorInsuranceCreationScreenState
    extends State<MotorInsuranceCreationScreen> {
  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<KycManualEntryScreenState> _kycScreenKey =
      GlobalKey<KycManualEntryScreenState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final insuranceBloc = context.read<MotorInsuranceBloc>();
    insuranceBloc.add(const CustomStepEvent(index: 0));
    insuranceBloc.add(FetchMotorMaintainenceEvent());
    insuranceBloc.add(FetchRiskCategoriesEvent());
    shouldContinue = false;
  }

  bool _validateVehicleStep(BuildContext context, MotorInsuranceState state) {
    final zambiaRegExp = RegExp(r'^[A-Z]{3}\s?\d{4}(\s?ZM)?$');
    if (state.isManualEntry) {
      final entity = state.vehicleCreateEntity;

      if (entity?.registrationNumber == null ||
          entity!.registrationNumber.isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the registration number.');
        return false;
      }
      if (!zambiaRegExp.hasMatch(entity.registrationNumber)) {
        Snack.show(
          context,
          type: AppAlertType.warning,
          message:
              'Please enter a valid Zambia registration number (e.g. ZMW 1707 or e.g. ZMW 1707ZM).',
        );
        return false;
      }
      if (entity.vehicleMake.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please select a vehicle make.');
        return false;
      }
      if (entity.vehicleModel.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the vehicle model.');
        return false;
      }
      if (entity.yearOfManufacture.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the year of manufacture.');
        return false;
      }
      if (entity.yearOfManufacture.trim().isNotEmpty) {
        final year = int.tryParse(entity.yearOfManufacture.trim());
        final currentYear = DateTime.now().year;
        if (year == null || entity.yearOfManufacture.trim().length != 4) {
          Snack.show(context,
              type: AppAlertType.warning,
              message: 'Enter a valid 4-digit year.');
          return false;
        }
        if (year > currentYear) {
          Snack.show(context,
              type: AppAlertType.warning,
              message: 'Year of manufacture cannot be in the future');
          return false;
        }
      }
      if (entity.chassisNumber.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the chassis number.');
        return false;
      }
      if (entity.engineNumber.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the engine number.');
        return false;
      }
      if (state.selectedRiskCategory == null) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please select a risk category.');
        return false;
      }
      if (entity.vehicleColor.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter the vehicle color.');
        return false;
      }
      if (entity.sumInsured <= 0) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please enter a valid sum insured.');
        return false;
      }
      if (state.vehicleBodyStyle.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning, message: 'Please select a body style.');
        return false;
      }
      return true;
    } else {
      // Lookup flow
      final regNo = state.vehicleRegNo.trim();
      if (regNo.isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning,
            message:
                'Please enter a registration number and lookup the vehicle.');
        return false;
      }
      if (!zambiaRegExp.hasMatch(regNo)) {
        Snack.show(
          context,
          type: AppAlertType.warning,
          message:
              'Please enter a valid Zambia registration number (e.g. ZMW 1707 or e.g ZMW 1707 ZM).',
        );
        return false;
      }
      if (state.vehicleInfoStatus != VehicleInformationStatus.loaded ||
          state.vehicleData == null) {
        Snack.show(context,
            type: AppAlertType.warning,
            message: 'Please lookup a valid vehicle to proceed.');
        return false;
      }
      if (state.vehicleData != null &&
          state.vehicleData?.riskCategoryId == null) {
        if (state.selectedRiskCategory == null) {
          Snack.show(context, message: 'Please select a risk category.');
          return false;
        }
      }

      if (state.vehicleData != null &&
          (state.vehicleData?.sumInsured ?? 0) < 1) {
        if (state.sumInsuredField < 1) {
          Snack.show(context, message: 'Please Enter Sum Insured');
          return false;
        }
      }
      if (state.vehicleBodyStyle.trim().isEmpty) {
        Snack.show(context,
            type: AppAlertType.warning, message: 'Please select a body style.');
        return false;
      }
      return true;
    }
  }

  bool _isVehicleFoundViaLookup(MotorInsuranceState state) {
    return state.vehicleInfoStatus == VehicleInformationStatus.loaded &&
        state.vehicleData != null;
  }

  void onBackPop() {
    final insuranceBloc = context.read<MotorInsuranceBloc>();
    if (insuranceBloc.state.currentStep == 0 &&
        insuranceBloc.state.isManualEntry == false) {
      context.pop();
    } else if (insuranceBloc.state.currentStep == 3) {
      insuranceBloc.add(ResetVehicleData());
      insuranceBloc.add(const CustomStepEvent(index: 2));
    } else {
      insuranceBloc.add(PrevStepEvent());
    }
  }

  void goBack() {
    final insuranceBloc = context.read<MotorInsuranceBloc>();
    if (insuranceBloc.state.currentStep == 0 &&
        insuranceBloc.state.isManualEntry == false) {
      context.pop();
    } else if (insuranceBloc.state.currentStep == 1) {
      insuranceBloc.add(ResetVehicleData());
      insuranceBloc.add(const CustomStepEvent(index: 0));
    } else {
      insuranceBloc.add(PrevStepEvent());
    }
  }

  void _continueUserDetails() {
    _kycScreenKey.currentState?.onContinue();
  }

  bool? shouldContinue = false;

  @override
  Widget build(BuildContext context) {
    final insuranceBloc = context.read<MotorInsuranceBloc>();
    final isMobile = AdaptiveLayout.isMobile(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        isMobile ? onBackPop() : goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: !isMobile
            ? null
            : AppStatusBar(
                showBack: true,
                centerTitle: false,
                bgColor: AppColors.surface,
                onPressed: onBackPop,
                actionList: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
                title: 'Motor Insurance'),
        body: BlocListener<MotorInsuranceBloc, MotorInsuranceState>(
          listenWhen: (previous, current) =>
              previous.currentStep != current.currentStep,
          listener: (context, state) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
          },
          child: BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
            listenWhen: (previous, current) =>
                previous.submissionErrorToken != current.submissionErrorToken &&
                current.submissionError != null,
            listener: (context, state) {
              if (state.isSuccess) {}
              if (state.submissionError != null) {
                Snack.show(
                  context,
                  type: AppAlertType.error,
                  message: state.submissionError!,
                );
              }
            },
            builder: (context, state) {
              if (!isMobile) {
                return _buildDesktopLayout(context, state);
              }
              return Column(
                children: [
                  CustomStepper(currentStep: state.currentStep),
                  Expanded(
                    child: _buildMobileLayout(context, state),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: !isMobile
            ? null
            : BlocBuilder<MotorInsuranceBloc, MotorInsuranceState>(
                builder: (context, state) {
                  if (state.currentStep < 1) {
                    return const SizedBox.shrink();
                  }
                  if (state.currentStep == 2 &&
                      !state.isManualEntry &&
                      !_isVehicleFoundViaLookup(state)) {
                    return const SizedBox.shrink();
                  }
                  return SafeArea(
                    child: Container(
                      height: 102,
                      color: AppColors.surface,
                      padding: const EdgeInsets.only(
                        bottom: 38,
                        right: 16,
                        left: 16,
                        top: 16,
                      ),
                      child: AppButton(
                        text: state.currentStep == 6 ? 'Process' : 'Continue',
                        isLoading: state.isSubmitting,
                        onPressed: () async {
                          switch (state.currentStep) {
                            case 1:
                              _continueUserDetails();
                            case 2:
                              if (state.isManualEntry) {
                                if (!_validateVehicleStep(context, state)) {
                                  return;
                                }
                                if (shouldContinue == false) {
                                  shouldContinue = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const AppText(
                                                  'Confirm Vehicle Details',
                                                  style: AppTextStyle
                                                      .headlineSmall),
                                              const SizedBox(height: 12),
                                              const AppText(
                                                  'Please ensure that all vehicle details are correct. Once submitted, the vehicle will be created and the entered details cannot be modified.',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTextStyle.bodyLarge),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  AppButton(
                                                    width: 100,
                                                    height: 35,
                                                    borderColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    textColor:
                                                        AppColors.glassWhite,
                                                    text: 'Ok',
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, true),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  insuranceBloc.add(
                                    VehicleCreateEvent(
                                        clientId: state.createIndividualResponse
                                                ?.data?.id ??
                                            '',
                                        vehicleCreateEntity:
                                            state.vehicleCreateEntity!),
                                  );
                                }
                              } else {
                                if (!_validateVehicleStep(context, state))
                                  return;
                                final vehicle = state.vehicleData;
                                final riskCategory = state.selectedRiskCategory;
                                if (vehicle?.id == null) {
                                  insuranceBloc.add(
                                    VehicleCreateEvent(
                                      clientId: state.createIndividualResponse
                                              ?.data?.id ??
                                          '',
                                      vehicleCreateEntity: VehicleCreateEntity(
                                        registrationNumber:
                                            vehicle?.registrationNumber ?? '',
                                        vehicleMake: vehicle?.make ?? '',
                                        vehicleModel: vehicle?.model ?? '',
                                        vehicleColor: vehicle?.color ?? '',
                                        engineNumber:
                                            vehicle?.engineNumber ?? '',
                                        yearOfManufacture: vehicle
                                                ?.yearOfManufacture
                                                ?.toString() ??
                                            '',
                                        chassisNumber:
                                            vehicle?.chassisNumber ?? '',
                                        motorRiskCategoryId:
                                            vehicle?.riskCategoryId ??
                                                riskCategory?.id ??
                                                '',
                                        riskCategoryName:
                                            vehicle?.riskCategory?.name ??
                                                riskCategory?.name ??
                                                '',
                                        sumInsured:
                                            vehicle?.sumInsured?.toInt() ?? 0,
                                      ),
                                    ),
                                  );
                                } else {
                                  _scrollController.animateTo(
                                    0,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                  );

                                  insuranceBloc.add(NextStepEvent());
                                }
                              }
                              return;

                            case 3:
                              if (state.vehicleData?.riskCategoryId == null &&
                                  state.selectedRiskCategory == null) {
                                Snack.show(
                                  context,
                                  message: 'Please Select Risk Category.',
                                );
                              } else {
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                );
                                insuranceBloc.add(NextStepEvent());
                              }
                              return;

                            case 4:
                              if (state.selectedInsuranceQuotation == null) {
                                Snack.show(context,
                                    message: 'Please Select Quotation.');
                              } else {
                                context
                                    .read<MotorInsuranceBloc>()
                                    .add(CreateQuotationEvent());
                              }
                              return;

                            case 5:
                              return showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<MotorInsuranceBloc>(),
                                  child:
                                      const MotorInsurancePaymentBottomSheet(),
                                ),
                              );

                            default:
                              _scrollController.animateTo(
                                0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeInOut,
                              );
                              insuranceBloc.add(NextStepEvent());
                          }

                          // if (state.currentStep == 1) {
                          //   _continueUserDetails();
                          // } else if (state.currentStep == 2) {
                          //   if (state.isManualEntry) {
                          //     if (!_validateVehicleStep(context, state)) return;
                          //     insuranceBloc.add(VehicleCreateEvent(
                          //         clientId: state
                          //                 .createIndividualResponse?.data?.id ??
                          //             '',
                          //         vehicleCreateEntity:
                          //             state.vehicleCreateEntity!));
                          //   } else {
                          //     if (!_validateVehicleStep(context, state)) return;
                          //     insuranceBloc.add(NextStepEvent());
                          //   }
                          // } else if (state.currentStep == 3) {
                          //   if (state.vehicleData?.riskCategoryId == null &&
                          //       state.selectedRiskCategory == null) {
                          //     Snack.show(
                          //       context,
                          //       type: AppAlertType.warning,
                          //       message: 'Please Select Risk Category.',
                          //     );
                          //   } else {
                          //     insuranceBloc.add(NextStepEvent());
                          //   }
                          // } else if (state.currentStep == 4) {
                          //   if (state.selectedInsuranceQuotation == null) {
                          //     Snack.show(context,
                          //         type: AppAlertType.warning,
                          //         message: 'Please Select Quotation.');
                          //   } else {
                          //     context
                          //         .read<MotorInsuranceBloc>()
                          //         .add(CreateQuotationEvent());
                          //   }
                          //   return;
                          // } else if (state.currentStep == 5) {
                          //   showModalBottomSheet<void>(
                          //     context: context,
                          //     isScrollControlled: true,
                          //     backgroundColor: Colors.transparent,
                          //     builder: (_) => BlocProvider.value(
                          //       value: context.read<MotorInsuranceBloc>(),
                          //       child: const MotorInsurancePaymentBottomSheet(),
                          //     ),
                          //   );
                          // } else {
                          //   insuranceBloc.add(NextStepEvent());
                          // }
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStepWidget(int step) {
    if (!AdaptiveLayout.isMobile(context)) {
      switch (step) {
        case 0:
          return const VehicleInfoStepWidget();
        case 1:
          return const MotorInsurancePolicyDetailsScreen();
        case 2:
          return const MotorInsuranceComparisonScreen();
        case 3:
          return const MotorInsurancePurchase();
        case 4:
          return const QuoteStepWidget();
        default:
          return const VehicleInfoStepWidget();
      }
    }
    switch (step) {
      case 0:
        return const MotorInsuranceScreen(isStepper: true);
      case 1:
        return KycManualEntryScreen(
          key: _kycScreenKey,
          isStepper: true,
        );
      case 2:
        return const VehicleInfoStepWidget();
      case 3:
        return const MotorInsurancePolicyDetailsScreen();
      case 4:
        return const MotorInsuranceComparisonScreen();
      case 5:
        return const MotorInsurancePurchase();
      case 6:
        return const QuoteStepWidget();
      default:
        return const VehicleInfoStepWidget();
    }
  }

  Widget _buildMobileLayout(BuildContext context, MotorInsuranceState state) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        children: [
          _buildStepWidget(state.currentStep),
          const VSpace(20),
          if (state.currentStep > 1 && state.currentStep < 5) ...[
            QuoteSummaryCard(
              coverage: state.coverageType,
              policyFor: state.isForMyself,
              policyStartDate: state.currentStep == 2 ? null : state.startDate,
              policyEndDate:
                  state.currentStep == 2 ? null : state.calculatedPolicyEndDate,
              selectedQuarters:
                  state.currentStep == 2 ? null : state.selectedQuarters,
              selectedMonths:
                  state.currentStep == 2 ? null : state.selectedPolicyMonths,
            ),
            const VSpace(16),
          ],
        ],
      ),
    );
  }

  // ── Desktop / tablet: Vehicle Info, Policy Details, Quote Comparison,
  //    Insurance Details & Purchase — steps 3-6 of 7 ───────────────────────
  Widget _buildDesktopLayout(BuildContext context, MotorInsuranceState state) {
    final insuranceBloc = context.read<MotorInsuranceBloc>();
    final isPurchaseStep = state.currentStep == 3;
    final hideContinueForVehicleLookup = state.currentStep == 0 &&
        !state.isManualEntry &&
        !_isVehicleFoundViaLookup(state);

    Future<dynamic> goNext() async {
      switch (state.currentStep) {
        // case 1:
        //   _continueUserDetails();
        case 0:
          if (state.isManualEntry) {
            if (!_validateVehicleStep(context, state)) {
              return;
            }
            if (shouldContinue == false) {
              shouldContinue = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppText('Confirm Vehicle Details',
                              style: AppTextStyle.headlineSmall),
                          const SizedBox(height: 12),
                          const AppText(
                              'Please ensure that all vehicle details are correct. Once submitted, the vehicle will be created and the entered details cannot be modified.',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyLarge),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppButton(
                                width: 100,
                                height: 35,
                                borderColor: Colors.transparent,
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.glassWhite,
                                text: 'Ok',
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              insuranceBloc.add(
                VehicleCreateEvent(
                    clientId: state.createIndividualResponse?.data?.id ?? '',
                    vehicleCreateEntity: state.vehicleCreateEntity!),
              );
            }
          } else {
            if (!_validateVehicleStep(context, state)) return;
            final vehicle = state.vehicleData;
            final riskCategory = state.selectedRiskCategory;
            if (vehicle?.id == null) {
              insuranceBloc.add(
                VehicleCreateEvent(
                  clientId: state.createIndividualResponse?.data?.id ?? '',
                  vehicleCreateEntity: VehicleCreateEntity(
                    registrationNumber: vehicle?.registrationNumber ?? '',
                    vehicleMake: vehicle?.make ?? '',
                    vehicleModel: vehicle?.model ?? '',
                    vehicleColor: vehicle?.color ?? '',
                    engineNumber: vehicle?.engineNumber ?? '',
                    yearOfManufacture:
                        vehicle?.yearOfManufacture?.toString() ?? '',
                    chassisNumber: vehicle?.chassisNumber ?? '',
                    motorRiskCategoryId:
                        vehicle?.riskCategoryId ?? riskCategory?.id ?? '',
                    riskCategoryName:
                        vehicle?.riskCategory?.name ?? riskCategory?.name ?? '',
                    sumInsured: (vehicle?.sumInsured ?? 0) > 0
                        ? vehicle?.sumInsured?.toInt() ?? 0
                        : state.sumInsuredField.toInt(),
                  ),
                ),
              );
            } else {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );

              insuranceBloc.add(NextStepEvent());
            }
          }
          return;
        case 2:
          if (state.selectedInsuranceQuotation == null) {
            Snack.show(context, message: 'Please Select Quotation.');
          } else {
            context.read<MotorInsuranceBloc>().add(CreateQuotationEvent());
          }
          return;

        default:
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
          insuranceBloc.add(NextStepEvent());

        // case 3:
        //   if (state.vehicleData?.riskCategoryId == null &&
        //       state.selectedRiskCategory == null) {
        //     Snack.show(
        //       context,
        //       message: 'Please Select Risk Category.',
        //     );
        //   } else {
        //     _scrollController.animateTo(
        //       0,
        //       duration: const Duration(milliseconds: 100),
        //       curve: Curves.easeInOut,
        //     );
        //     insuranceBloc.add(NextStepEvent());
        //   }
        //   return;

        // case 5:
        //   return showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     backgroundColor: Colors.transparent,
        //     builder: (_) => BlocProvider.value(
        //       value: context.read<MotorInsuranceBloc>(),
        //       child: const MotorInsurancePaymentBottomSheet(),
        //     ),
        //   );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        state.currentStep > 3
            ? const SizedBox.shrink()
            : DesktopStepper(
                currentStep: 3 + state.currentStep, onBack: goBack),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: ResponsiveContainer(
              padHorizontal: false,
              maxWidth: 1440,
              child: ResponsiveTwoPane(
                main: Column(
                  children: [
                    _buildStepWidget(state.currentStep),
                    if (!isPurchaseStep && !hideContinueForVehicleLookup) ...[
                      const VSpace(24),
                      AppButton(
                        text: 'Continue',
                        // icon: Icons.arrow_forward,
                        isLoading: state.isSubmitting,
                        onPressed: goNext,
                      ),
                    ],
                  ],
                ),
                rail: isPurchaseStep
                    ? const DesktopPaymentPanel()
                    : state.currentStep == 0
                        ? QuoteSummaryCard(
                            coverage: state.coverageType,
                            policyFor: state.isForMyself,
                          )
                        : state.currentStep > 0 && state.currentStep < 3
                            ? QuoteSummaryCard(
                                coverage: state.coverageType,
                                policyFor: state.isForMyself,
                                policyStartDate: state.startDate,
                                policyEndDate: state.calculatedPolicyEndDate,
                                selectedQuarters: state.selectedQuarters,
                                selectedMonths: state.selectedPolicyMonths,
                              )
                            : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
