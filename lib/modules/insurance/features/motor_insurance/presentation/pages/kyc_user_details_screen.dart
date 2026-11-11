import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/adaptive_layout.dart';
import 'package:citizenone_app/modules/insurance/core/adaptive/responsive_widgets.dart';
import 'package:citizenone_app/modules/insurance/core/constants/routes_constants.dart';
import 'package:citizenone_app/modules/insurance/core/forms/enums/app_text_input_type.dart';
import 'package:citizenone_app/modules/insurance/core/forms/formatters/app_text_field_formatters.dart';
import 'package:citizenone_app/modules/insurance/core/theme/app_colors.dart';
import 'package:citizenone_app/modules/insurance/core/utils/snack.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_alert_icon.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_bar.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_button.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text.dart';
import 'package:citizenone_app/modules/insurance/design_system/atoms/app_text_field.dart';
import 'package:citizenone_app/modules/insurance/design_system/organisms/best_practices_panel.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_bloc.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_event.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/bloc/motor_insurance_state.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/desktop_stepper.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/presentation/widgets/form_header.dart';

class KycManualEntryScreen extends StatefulWidget {
  final bool isStepper;
  const KycManualEntryScreen({super.key, this.isStepper = false});

  @override
  State<KycManualEntryScreen> createState() => KycManualEntryScreenState();
}

class KycManualEntryScreenState extends State<KycManualEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final _genderOptions = const ['Male', 'Female', 'Other'];
  final _idTypeOptions = const ['National ID'];

  String? _selectedGender;
  String? _selectedIdType;
  bool _isPrepopulated = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<MotorInsuranceBloc>().state;
    _mobileController.text = state.mobileNumber ?? '';
    _firstNameController.text = state.firstName ?? '';
    _lastNameController.text = state.lastName ?? '';
    _idNumberController.text = state.nationalId ?? '';
    _emailController.text = state.email ?? '';
    _addressController.text = state.addressLine ?? '';
    _selectedGender = _normalizeGender(
      state.customerDetails?.gender ?? state.gender,
    );
    _selectedIdType = _normalizeIdType(
          state.customerDetails?.idType,
        ) ??
        _idTypeOptions.first;

    if (_firstNameController.text.isNotEmpty ||
        _lastNameController.text.isNotEmpty ||
        _idNumberController.text.isNotEmpty) {
      _isPrepopulated = true;
    }
    // _mobileController.addListener(_onMobileNumberChanged);
  }

  void _onMobileNumberChanged() {
    if (_isPrepopulated) {
      setState(() {
        _isPrepopulated = false;
      });
    }
    _clearFieldsExceptMobile();
  }

  void _populateFields(MotorInsuranceState state) {
    setState(() {
      _firstNameController.text = state.firstName ?? '';
      _lastNameController.text = state.lastName ?? '';
      _idNumberController.text = state.nationalId ?? '';
      _emailController.text = state.email ?? '';
      _addressController.text = state.addressLine ?? '';
      _selectedGender = _normalizeGender(
        state.customerDetails?.gender ?? state.gender,
      );
      _selectedIdType = _normalizeIdType(
            state.customerDetails?.idType,
          ) ??
          _idTypeOptions.first;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  void _clearFieldsExceptMobile() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _idNumberController.clear();
      _emailController.clear();
      _addressController.clear();
      _selectedGender = null;
      _selectedIdType = _idTypeOptions.first;
    });
  }

  @override
  void dispose() {
    // _mobileController.removeListener(_onMobileNumberChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _idNumberController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String? _normalizeGender(String? gender) {
    switch ((gender ?? '').toUpperCase()) {
      case 'M':
      case 'MALE':
        return 'Male';
      case 'F':
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      default:
        return null;
    }
  }

  String? _normalizeIdType(String? idType) {
    switch ((idType ?? '').toUpperCase()) {
      case 'NRC':
        return 'National ID';
      case 'PASSPORT':
        return 'Passport';
      case 'DL':
      case 'DRIVER LICENSE':
      case 'DRIVER LICENCE':
        return 'Driver License';
      default:
        return idType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = AdaptiveLayout.contentMaxWidth(context);

    return BlocConsumer<MotorInsuranceBloc, MotorInsuranceState>(
      listenWhen: (previous, current) =>
          previous.customerCreationStatus != current.customerCreationStatus ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.customerCreationStatus == CustomerCreationStatus.success) {
          context.read<MotorInsuranceBloc>().add(ResetVehicleData());
          if (widget.isStepper) {
            context
                .read<MotorInsuranceBloc>()
                .add(const CustomStepEvent(index: 2));
          } else {
            context.push(AppRoutes.motorInsuranceCreationScreen);
          }
        }
        if (state.customerCreationStatus == CustomerCreationStatus.failure &&
            state.customerCreationMessage != null) {
          Snack.show(
            context,
            type: AppAlertType.error,
            message: state.customerCreationMessage!,
          );
        }
        if (state.status == KycUserStatus.loaded) {
          setState(() {
            _isPrepopulated = true;
            _populateFields(state);
          });
          Snack.show(
            context,
            type: AppAlertType.success,
            message: 'User details found.',
          );
        }
        if (state.status == KycUserStatus.notFound) {
          setState(() {
            _isPrepopulated = false;
            _clearFieldsExceptMobile();
          });
          Snack.show(
            context,
            type: AppAlertType.warning,
            message: 'User not found. Please enter details manually.',
          );
        }
        if (state.status == KycUserStatus.error) {
          Snack.show(
            context,
            type: AppAlertType.error,
            message: 'Failed to search user.',
          );
        }
      },
      builder: (context, state) {
        if (!context.isMobile) {
          return _buildDesktop(context, state);
        }
        if (widget.isStepper) {
          return _buildMobileFormBody(context, state, maxWidth);
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const AppStatusBar(
            title: 'Insurance Details',
            showBack: true,
            centerTitle: false,
            textIconColor: AppColors.black,
          ),
          bottomNavigationBar: Container(
            color: AppColors.surface,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SafeArea(
              top: false,
              child: AppButton(
                text: 'Continue',
                // icon: Icons.arrow_forward,
                onPressed: state.customerCreationStatus ==
                        CustomerCreationStatus.loading
                    ? null
                    : onContinue,
                backgroundColor: AppColors.primary,
                radius: 12,
                height: 40,
                isLoading: state.customerCreationStatus ==
                    CustomerCreationStatus.loading,
                textStyle: AppTextStyle.bodyLarge,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: _buildMobileFormBody(context, state, maxWidth),
          ),
        );
      },
    );
  }

  Widget _buildMobileFormBody(
      BuildContext context, MotorInsuranceState state, double maxWidth) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const FormHeader(label: 'Mobile Number', isRequired: true),
              AppTextField(
                controller: _mobileController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mobile Number is required';
                  }
                  if (value.length != 9) {
                    return 'Please enter a valid 9 digits Mobile Number';
                  }
                  return null;
                },
                maxLength: 9,
                suffixIcon: state.status == KycUserStatus.loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          if (_mobileController.text.length == 9) {
                            context.read<MotorInsuranceBloc>().add(
                                  SearchUserEvent(
                                    mobileNumber: _mobileController.text.trim(),
                                    nationalId: '',
                                  ),
                                );
                          } else {
                            Snack.show(
                              context,
                              type: AppAlertType.warning,
                              message:
                                  'Please enter a valid 9 digits Mobile Number',
                            );
                          }
                        },
                        icon: const Icon(Icons.search),
                      ),
                inputFormatters: AppTextFieldFormatters.getFormatters(
                  AppTextInputType.numberOnly,
                ),
                fillColor: AppColors.surface,
                onChanged: (p0) {
                  if (p0.length < 9) {
                    context.read<MotorInsuranceBloc>().add(ResetFormData());
                  }
                  _onMobileNumberChanged();
                },
              ),
              const SizedBox(height: 22),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const FormHeader(
                                label: 'First Name',
                                isRequired: true,
                              ),
                              AppTextField(
                                controller: _firstNameController,
                                isEnabled: !_isPrepopulated,
                                onChanged: (v) =>
                                    _formKey.currentState?.validate(),
                                maxLength: 35,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z\s\-']"),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                },
                                fillColor: AppColors.surface,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              const FormHeader(
                                label: 'Last Name',
                                isRequired: true,
                              ),
                              AppTextField(
                                controller: _lastNameController,
                                isEnabled: !_isPrepopulated,
                                onChanged: (v) =>
                                    _formKey.currentState?.validate(),
                                maxLength: 35,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z\s\-']"),
                                  ),
                                ],
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Last name is required';
                                  }
                                  return null;
                                },
                                fillColor: AppColors.surface,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const FormHeader(label: 'Gender', isRequired: true),
                    _DropdownBlock(
                      value: _selectedGender,
                      options: _genderOptions,
                      isEnabled: !_isPrepopulated,
                      onChanged: (value) => setState(() {
                        _selectedGender = value;
                      }),
                    ),
                    const SizedBox(height: 22),
                    const FormHeader(label: 'ID Type', isRequired: true),
                    _DropdownBlock(
                      value: _selectedIdType,
                      options: _idTypeOptions,
                      isEnabled: !_isPrepopulated,
                      onChanged: (value) => setState(() {
                        _selectedIdType = value;
                      }),
                    ),
                    const SizedBox(height: 22),
                    const FormHeader(label: 'ID Number', isRequired: true),
                    AppTextField(
                      controller: _idNumberController,
                      isEnabled: !_isPrepopulated,
                      onChanged: (v) => _formKey.currentState?.validate(),
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
                      fillColor: AppColors.surface,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                        SlashFormatter(),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const FormHeader(label: 'Email', isRequired: true),
                    AppTextField(
                      controller: _emailController,
                      onChanged: (v) => _formKey.currentState?.validate(),
                      isEnabled: !_isPrepopulated,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 40,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9._%+\-@]')),
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
                    const SizedBox(height: 22),
                    const FormHeader(label: 'Address Line', isRequired: true),
                    AppTextField(
                      controller: _addressController,
                      onChanged: (v) => _formKey.currentState?.validate(),
                      isEnabled: !_isPrepopulated,
                      maxLines: 2,
                      maxLength: 100,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Address Line is required';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9, /#-]'))
                      ],
                      fillColor: AppColors.glassWhite,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Desktop / tablet: Customer Details — step 2 of 7 ────────────────────
  Widget _buildDesktop(BuildContext context, MotorInsuranceState state) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DesktopStepper(currentStep: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: ResponsiveContainer(
                padHorizontal: false,
                maxWidth: 1440,
                child: ResponsiveTwoPane(
                  rail: const BestPracticesPanel(),
                  main: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outline),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            'Customer Details',
                            style: AppTextStyle.headlineSmall,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _desktopField(
                                  label: 'Mobile Number',
                                  isRequired: true,
                                  child: AppTextField(
                                    controller: _mobileController,
                                    keyboardType: TextInputType.number,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLength: 9,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Mobile Number is required';
                                      }
                                      if (value.length != 9) {
                                        return 'Enter a valid 9 digit number';
                                      }
                                      return null;
                                    },
                                    suffixIcon: state.status ==
                                            KycUserStatus.loading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              if (_mobileController
                                                      .text.length ==
                                                  9) {
                                                context
                                                    .read<MotorInsuranceBloc>()
                                                    .add(
                                                      SearchUserEvent(
                                                        mobileNumber:
                                                            _mobileController
                                                                .text
                                                                .trim(),
                                                        nationalId: '',
                                                      ),
                                                    );
                                              } else {
                                                Snack.show(context,
                                                    type: AppAlertType.warning,
                                                    message:
                                                        'Please enter a valid 9 digits Mobile Number');
                                              }
                                            },
                                            icon: const Icon(Icons.search),
                                          ),
                                    inputFormatters:
                                        AppTextFieldFormatters.getFormatters(
                                      AppTextInputType.numberOnly,
                                    ),
                                    fillColor: AppColors.surface,
                                    onChanged: (p0) {
                                      if (p0.length < 9) {
                                        context
                                            .read<MotorInsuranceBloc>()
                                            .add(ResetFormData());
                                      }
                                      _onMobileNumberChanged();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _desktopField(
                                  label: 'First Name',
                                  isRequired: true,
                                  child: AppTextField(
                                    controller: _firstNameController,
                                    onChanged: (v) =>
                                        _formKey.currentState?.validate(),
                                    isEnabled: !_isPrepopulated,
                                    maxLength: 35,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z\s\-']"),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'First name is required';
                                      }
                                      return null;
                                    },
                                    fillColor: AppColors.surface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _desktopField(
                                  label: 'Last Name',
                                  isRequired: true,
                                  child: AppTextField(
                                    controller: _lastNameController,
                                    onChanged: (v) =>
                                        _formKey.currentState?.validate(),
                                    isEnabled: !_isPrepopulated,
                                    maxLength: 35,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z\s\-']"),
                                      ),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Last name is required';
                                      }
                                      return null;
                                    },
                                    fillColor: AppColors.surface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _desktopField(
                                  label: 'Gender',
                                  isRequired: true,
                                  child: _DropdownBlock(
                                    value: _selectedGender,
                                    options: _genderOptions,
                                    isEnabled: !_isPrepopulated,
                                    onChanged: (value) => setState(() {
                                      _selectedGender = value;
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _desktopField(
                                  label: 'ID Type',
                                  isRequired: true,
                                  child: _DropdownBlock(
                                    value: _selectedIdType,
                                    options: _idTypeOptions,
                                    isEnabled: !_isPrepopulated,
                                    onChanged: (value) => setState(() {
                                      _selectedIdType = value;
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _desktopField(
                                  label: 'ID Number',
                                  isRequired: true,
                                  child: AppTextField(
                                    controller: _idNumberController,
                                    onChanged: (v) =>
                                        _formKey.currentState?.validate(),
                                    isEnabled: !_isPrepopulated,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'National ID is required';
                                      }
                                      if (value.length != 11) {
                                        return 'Enter a valid National ID';
                                      }
                                      return null;
                                    },
                                    fillColor: AppColors.surface,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(9),
                                      SlashFormatter(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _desktopField(
                                  label: 'Email',
                                  isRequired: true,
                                  child: AppTextField(
                                    controller: _emailController,
                                    onChanged: (v) =>
                                        _formKey.currentState?.validate(),
                                    isEnabled: !_isPrepopulated,
                                    keyboardType: TextInputType.emailAddress,
                                    maxLength: 40,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z0-9._%+\-@]')),
                                    ],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email is required';
                                      }
                                      final regex =
                                          RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                                      if (!regex.hasMatch(value)) {
                                        return 'Enter valid email';
                                      }
                                      return null;
                                    },
                                    fillColor: AppColors.surface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _desktopField(
                            label: 'Address',
                            isRequired: true,
                            child: AppTextField(
                              onChanged: (v) =>
                                  _formKey.currentState?.validate(),
                              controller: _addressController,
                              isEnabled: !_isPrepopulated,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z0-9, /#-]'))
                              ],
                              maxLength: 100,
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Address Line is required';
                                }
                                return null;
                              },
                              fillColor: AppColors.glassWhite,
                            ),
                          ),
                          const SizedBox(height: 28),
                          AppButton(
                            text: 'Continue',
                            // icon: Icons.arrow_forward,
                            isFullWidth: false,
                            onPressed: state.customerCreationStatus ==
                                    CustomerCreationStatus.loading
                                ? null
                                : onContinue,
                            backgroundColor: AppColors.primary,
                            radius: 12,
                            height: 48,
                            isLoading: state.customerCreationStatus ==
                                CustomerCreationStatus.loading,
                            textStyle: AppTextStyle.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopField(
      {required String label, required Widget child, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText(
              label,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            if (isRequired)
              const AppText(
                ' *',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  void onContinue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender == null) {
      Snack.show(
        context,
        type: AppAlertType.warning,
        message: 'Please select gender',
      );
      return;
    }

    if (_selectedIdType == null) {
      Snack.show(
        context,
        type: AppAlertType.warning,
        message: 'Please select ID Type',
      );
      return;
    }

    final customerDetails = CustomerDetails(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      gender: _selectedGender ?? '',
      idType: _selectedIdType ?? '',
      idNumber: _idNumberController.text.trim(),
      email: _emailController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      address: _addressController.text.trim(),
    );
    context.read<MotorInsuranceBloc>().add(
          CreateIndividualUserEvent(customerDetails: customerDetails),
        );
  }
}

class _DropdownBlock extends StatelessWidget {
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool isEnabled;

  const _DropdownBlock({
    required this.value,
    required this.options,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isEnabled ? AppColors.surface : AppColors.deactivateBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEnabled ? AppColors.textBorder : AppColors.outline,
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              disabledHint: value != null
                  ? AppText(
                      value!,
                      style: AppTextStyle.bodyLarge,
                      color: AppColors.textMuted,
                    )
                  : null,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isEnabled ? AppColors.textMain : AppColors.textMuted,
              ),
              hint: const SizedBox.shrink(),
              items: options
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: AppText(item,
                          style: AppTextStyle.bodyLarge,
                          color: AppColors.textPrimary),
                    ),
                  )
                  .toList(),
              onChanged: isEnabled ? onChanged : null,
            ),
          ),
        ),
      ],
    );
  }
}
