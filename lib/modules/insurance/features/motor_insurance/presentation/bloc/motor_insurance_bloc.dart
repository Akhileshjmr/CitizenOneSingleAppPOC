// ignore_for_file: inference_failure_on_instance_creation

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/instant_issue_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/kyc_user_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/payment_request_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/instant_issue_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/payment_success_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/vehicle_create_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/compare_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_individual_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_instant_issue_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_invoice_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_key_facts_document_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_master_data_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_risk_categories_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_vehicle_details_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/generate_motor_otp_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/insurance_transaction_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/issue_policy_by_quoteid_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/motor_maintainence_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/request_payment_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/fetch_motor_product_details_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/print_receipt_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/search_kyc_user_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/sms_send_keyfacts_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/vehicle_create_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/verify_motor_otp_usecase.dart';

import 'motor_insurance_event.dart';
import 'motor_insurance_state.dart';

class MotorInsuranceBloc
    extends Bloc<MotorInsuranceEvent, MotorInsuranceState> {
  final SearchKycUserUseCase searchKycUserUseCase;
  final MotorMaintainenceUsecase motorMaintainenceUsecase;
  final FetchVehicleDetailsUsecase fetchVehicleDetailsUsecase;
  final FetchRiskCategoriesUsecase fetchRiskCategoriesUsecase;
  final FetchMasterDataUsecase masterDataUsecase;
  final FetchVehicleCreateUsecase vehicleCreateUseCase;
  final GenerateMotorOtpUsecase generateMotorOtpUsecase;
  final VerifyMotorOtpUsecase verifyMotorOtpUsecase;
  Timer? _otpTimer;
  final CompareQuotationUsecase compareQuotationUsecase;
  final CreateQuotationUseCase createQuotationUseCase;
  final CreateIndividualUseCase createIndividualUseCase;
  final CreateInstantIssueUseCase createInstantIssueUseCase;
  final DownloadInvoiceUseCase downloadReceiptUseCase;
  final FetchInsuranceTransactionsUsecase fetchInsuranceTransactionsUsecase;
  final RequestMotorInsurancePaymentUseCase requestMotorInsurancePaymentUseCase;
  final SecureStorageService secureStorageService;
  final PrintReceiptUsecase printReceiptUseCase;
  final IssuePolicyByQuoteIDUseCase issuePolicyByQuoteIDUseCase;
  final FetchMotorProductDetailsUseCase fetchMotorProductDetailsUseCase;
  final SmsSendForKeyFactsUseCase smsSendForKeyFactsUseCase;
  final DownloadKeyFactsDocumentUseCase downloadKeyFactsDocumentUseCase;

  MotorInsuranceBloc(
      {required this.searchKycUserUseCase,
      required this.motorMaintainenceUsecase,
      required this.fetchVehicleDetailsUsecase,
      required this.fetchRiskCategoriesUsecase,
      required this.masterDataUsecase,
      required this.vehicleCreateUseCase,
      required this.generateMotorOtpUsecase,
      required this.verifyMotorOtpUsecase,
      required this.compareQuotationUsecase,
      required this.createQuotationUseCase,
      required this.createIndividualUseCase,
      required this.createInstantIssueUseCase,
      required this.downloadReceiptUseCase,
      required this.fetchInsuranceTransactionsUsecase,
      required this.requestMotorInsurancePaymentUseCase,
      required this.secureStorageService,
      required this.printReceiptUseCase,
      required this.issuePolicyByQuoteIDUseCase,
      required this.fetchMotorProductDetailsUseCase,
      required this.smsSendForKeyFactsUseCase,
      required this.downloadKeyFactsDocumentUseCase})
      : super(MotorInsuranceState()) {
    on<SearchUserEvent>(_searchUser);
    on<UpdateCustomerDetailsEvent>(_onUpdateCustomerDetails);
    on<CreateIndividualUserEvent>(_onCreateIndividualUser);
    on<NextStepEvent>(_onNextStep);
    on<PrevStepEvent>(_onPrevStep);
    on<CustomStepEvent>(_onCustomStep);
    on<UpdatePolicyHolderTypeEvent>(_onUpdatePolicyHolderType);
    on<UpdateSelectedQuarterEvent>((event, emit) =>
        emit(state.copyWith(selectedQuarters: event.quarters)));
    on<UpdateSomeoneElseDetailsEvent>(_onUpdateSomeoneElseDetails);
    on<UpdateVehicleInfoEvent>(_onUpdateVehicleInfo);
    on<LookupVehicleEvent>(_onLookupVehicle);
    on<SetVehicleManualEntryEvent>(_onSetVehicleManualEntry);
    on<SelectVehicleBodyStyleEvent>(_onSelectVehicleBodyStyle);
    on<UpdateVehicleManualDetailsEvent>(_onUpdateVehicleManualDetails);
    on<UpdatePolicyDetailsEvent>(_onUpdatePolicyDetails);
    on<UpdateDriverDetailsEvent>(_onUpdateDriverDetails);
    on<UpdateAddonsEvent>(_onUpdateAddons);
    on<SubmitMotorInsuranceEvent>(_onSubmit);
    on<ResetMotorInsuranceEvent>(_onReset);
    on<ToggleAddonEvent>(_onToggleAddon);
    on<FetchMotorMaintainenceEvent>(_onFetchMotorMaintainence);
    on<FetchRiskCategoriesEvent>(_onFetchRiskCategories);
    on<FetchVehicleDetailsEvent>(_onFetchVehicleDetails);
    on<GetMotorInsuranceMasterDataEvent>(_onGetMasterData);
    on<UpdatePolicyForEvent>(_onUpdatePolicyFor);
    on<VehicleCreateEvent>(_onCreateVehilceCreate);
    on<MotorInsuranceSelectPlanEvent>(_onSelectPlan);
    on<GenerateMotorOtpEvent>(_onGenerateMotorOtp);
    on<VerifyMotorOtpEvent>(_onVerifyMotorOtp);
    on<MotorOtpTimerTickedEvent>(_onMotorOtpTimerTicked);
    on<MotorOtpExpiredEvent>(_onMotorOtpExpired);
    on<ClearMotorOtpEvent>(_onClearMotorOtp);
    on<CompareQuotationEvent>(_onCompareQuotation);
    on<RiskCategoriesSelectedEvent>(_onRiskCategoriesSelected);
    on<SelectInsuranceQuoteEvent>(_onSelectInsuranceQuote);
    on<CreateQuotationEvent>(_createQuotationEvent);
    on<DisableErrorMessageEvent>(_onDisableErrorMessage);
    on<InstantIssueEvent>((event, emit) => _onInstantIssue(emit));
    on<ResetFormData>(_resetFormData);
    on<ResetVehicleData>(_resetVehicleData);
    on<DownloadInvoice>(_downloadInvoice);
    on<FetchInsuranceTransactionsEvent>(_onFetch);
    on<LoadMoreInsuranceTransactionsEvent>(_onLoadMore);
    on<RefreshInsuranceTransactionsEvent>(_onRefresh);
    on<ClearInsuranceTransactionFiltersEvent>(_onClearFilters);
    on<PaymentMethodChanged>(_onPaymentMethodChanged);
    on<MobileProviderChanged>(_onMobileProviderChanged);
    on<PhoneNumberChanged>(_onPhoneNumberChanged);
    on<CardNumberChanged>(_onCardNumberChanged);
    on<CardExpiryChanged>(_onCardExpiryChanged);
    on<CardCVVChanged>(_onCardCVVChanged);
    on<CardHolderChanged>(_onCardHolderChanged);
    on<ProcessInsurancePayment>(_onProcessInsurancePayment);
    on<PrintReceipt>(_printReceipt);
    on<IssuePolicyBuQuoteIDEvent>(_onIssuePolicyByQuoteId);
    on<SumInsuredFieldChangeEvent>(_onSumInsuredFieldChange);
    on<FetchMotorProductDetailsEvent>(_onFetchMotorProductDetails);
    on<SendSMSForPolicyKeyFactsEvent>(_onSendSmsForPolicyKeyFacts);
    on<FetchKeyFactsDocumentEvent>(_onFetchKeyFactsDocument);
  }

  Future<void> _searchUser(
    SearchUserEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(status: KycUserStatus.initial));
    emit(state.copyWith(status: KycUserStatus.loading));

    if (event.mobileNumber.isNotEmpty) {
      emit(
        state.copyWith(
          searchType: SearchType.mobileNumber,
          mobileNumber: () => event.mobileNumber,
          nationalId: () => '',
        ),
      );
    } else if (event.nationalId.isNotEmpty) {
      emit(
        state.copyWith(
          searchType: SearchType.nationalId,
          mobileNumber: () => '',
          nationalId: () => event.nationalId,
        ),
      );
    }

    // Fetch agent mobile from local storage via usecase
    // final agentMobileResult = await getAgentMobileUseCase();
    // final agentMobile = agentMobileResult.fold((_) => '', (mobile) => mobile);

    emit(state.copyWith(
        agentMobileNumber: await secureStorageService.getAgentMobNo(),
        isUserExists: false));

    final result = await searchKycUserUseCase(
      SearchKycUserParams(
        mobileNumber: event.mobileNumber,
        nationalId: event.nationalId,
      ),
    );

    result.fold(
      (failure) {
        if (failure.message.toUpperCase() == 'USER NOT FOUND') {
          add(ResetFormData());
          emit(state.copyWith(status: KycUserStatus.notFound));
        } else {
          emit(state.copyWith(status: KycUserStatus.error));
        }
        emit(state.copyWith(status: KycUserStatus.initial));
      },
      (user) {
        final comm = user.communication;
        emit(
          state.copyWith(
            status: KycUserStatus.loaded,
            id: user.id,
            firstName: () => user.firstName,
            lastName: () => user.lastName,
            gender: user.gender,
            // dob: () => DateTime.tryParse(user.dob),
            monthlyIncome: () => user.monthlyIncome
                .toStringAsFixed(2)
                .replaceAll(RegExp(r'\.?0+$'), ''),
            sourceFunds: () => user.sourceFunds,
            mobileNumber: () => user.mobileNumber,
            nationalId: () => user.nationalId,
            employmentType: user.empType,
            sector: () => user.sector,
            employerName: () => user.employerName,
            businessNature: () => user.businessNature,
            businessName: () => user.businessName,
            kycStatus: user.kycStatus?.toString(),
            code: user.code?.toString(),
            email: () => comm?.email,
            phNumber: () => comm?.phNumber,
            pbNumber: () => comm?.pbNumber,
            addressLine: () => comm?.addressLine,
            countryId: () => comm?.country?.id,
            stateId: () => comm?.state?.id,
            districtId: () => comm?.district?.id,
            cityId: () => comm?.city?.id,
            originCountryFriendlyType: () => user.originCountry?.friendlyType,
            countryFriendlyType: () => comm?.country?.friendlyType,
            stateFriendlyType: () => comm?.state?.friendlyType,
            districtFriendlyType: () => comm?.district?.friendlyType,
            cityFriendlyType: () => comm?.city?.friendlyType,
            photoUrl: () => user.photo?.docUrl,
            photoDocId: () => user.photo?.docId,
            signatureUrl: () => user.signature?.docUrl,
            signatureDocId: () => user.signature?.docId,
            kycUserDocuments: (user.documents ?? [])
                .map((d) => _entityToDocument(d))
                .toList(),
          ),
        );
        emit(state.copyWith(status: KycUserStatus.initial));
      },
    );
  }

  void _onUpdateCustomerDetails(
    UpdateCustomerDetailsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    final customerDetails = event.customerDetails;

    emit(
      state.copyWith(
        customerDetails: customerDetails,
        firstName: () => customerDetails.firstName,
        lastName: () => customerDetails.lastName,
        gender: customerDetails.gender,
        nationalId: () => customerDetails.idNumber,
        email: () => customerDetails.email,
        mobileNumber: () => customerDetails.mobileNumber,
        addressLine: () => customerDetails.address,
      ),
    );
  }

  Future<void> _onCreateIndividualUser(
    CreateIndividualUserEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    final customerDetails = event.customerDetails;

    emit(
      state.copyWith(
        vehicleData: () => null,
        customerDetails: customerDetails,
        firstName: () => customerDetails.firstName,
        lastName: () => customerDetails.lastName,
        gender: customerDetails.gender,
        nationalId: () => customerDetails.idNumber,
        email: () => customerDetails.email,
        mobileNumber: () => customerDetails.mobileNumber,
        addressLine: () => customerDetails.address,
        customerCreationStatus: CustomerCreationStatus.loading,
        customerCreationMessage: () => null,
        isSubmitting: true,
      ),
    );

    final result = await createIndividualUseCase.call(
      params: CreateIndividualParams(customerDetails: customerDetails),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            customerCreationStatus: CustomerCreationStatus.failure,
            customerCreationMessage: () => failure.message,
            isSubmitting: false,
            submissionError: () => failure.message,
            submissionErrorToken: state.submissionErrorToken + 1,
          ),
        );
      },
      (response) {
        final message =
            response.chMessage?.message ?? 'Customer created successfully.';
        emit(
          state.copyWith(
            isManualEntry: false,
            customerCreationStatus: CustomerCreationStatus.success,
            customerCreationMessage: () => message,
            createIndividualResponse: response,
            customerDetails: null,
            isSubmitting: false,
          ),
        );
        emit(state.copyWith(
            customerCreationStatus: CustomerCreationStatus.initial));
      },
    );
  }

  Future<void> _onFetchVehicleDetails(
      FetchVehicleDetailsEvent event, Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(vehicleInfoStatus: VehicleInformationStatus.initial));
    emit(state.copyWith(vehicleInfoStatus: VehicleInformationStatus.loading));

    final result = await fetchVehicleDetailsUsecase.call(
        registrationNo: event.registrationNo);
    result.fold((failure) {
      emit(state.copyWith(
          vehicleData: () => null,
          vehicleInfoStatus: VehicleInformationStatus.error,
          selectedRiskCategory: null));
    }, (response) {
      emit(state.copyWith(
          vehicleData: () => response.data!,
          vehicleInfoStatus: VehicleInformationStatus.loaded,
          selectedRiskCategory: null));
    });
  }

  Future<void> _onGetMasterData(
    GetMotorInsuranceMasterDataEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    final result = await masterDataUsecase.call();

    result.fold(
      (failure) {},
      (data) {
        emit(
          state.copyWith(
            masterData: data,
          ),
        );
      },
    );
  }

  Document _entityToDocument(dynamic entity) {
    return Document(
      docRef: entity.docRef as String,
      file: entity.file,
      docName: entity.docName as String,
      docId: entity.docId as int,
      fileName: entity.fileName,
      docUrl: entity.docUrl as String,
      issuingDate:
          (entity.issuingDate != null) ? entity.issuingDate as DateTime : null,
      verificationDate: entity.verificationDate,
      expiryDate:
          (entity.expiryDate != null) ? entity.expiryDate as DateTime : null,
      extension: entity.extension,
      uploadFile: entity.uploadFile,
      filePath: entity.filePath,
    );
  }

  void _onToggleAddon(
    ToggleAddonEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    switch (event.addonKey) {
      case 'personalAccident':
        emit(
          state.copyWith(
            personalAccidentSelected: event.value,
          ),
        );
        break;

      case 'roadside':
        emit(
          state.copyWith(
            roadsideSelected: event.value,
          ),
        );
        break;

      case 'engine':
        emit(
          state.copyWith(
            engineSelected: event.value,
          ),
        );
        break;

      case 'zeroDep':
        emit(
          state.copyWith(
            zeroDepSelected: event.value,
          ),
        );
        break;
    }
  }

  void _onNextStep(NextStepEvent event, Emitter<MotorInsuranceState> emit) {
    if (state.currentStep < 6) {
      if (state.currentStep == 0 && state.isManualEntry) {
        emit(state.copyWith(
          vehicleInfoStatus: VehicleInformationStatus.initial,
        ));
      }
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
      ));
    }
  }

  void _onPrevStep(PrevStepEvent event, Emitter<MotorInsuranceState> emit) {
    if (state.currentStep == 0 && state.isManualEntry == true) {
      emit(state.copyWith(isManualEntry: false));
    } else if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onCustomStep(CustomStepEvent event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(currentStep: event.index));
  }

  void _onUpdatePolicyHolderType(
      UpdatePolicyHolderTypeEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    if (event.isForMyself) {
      errors.remove('someoneElseName');
      errors.remove('someoneElseRelationship');
    }
    emit(state.copyWith(
      //isForMyself: event.isForMyself,
      errors: errors,
    ));
  }

  void _onUpdateSomeoneElseDetails(
      UpdateSomeoneElseDetailsEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    if (event.name.trim().isNotEmpty) errors.remove('someoneElseName');
    if (event.relationship.trim().isNotEmpty)
      errors.remove('someoneElseRelationship');

    emit(state.copyWith(
      someoneElseName: event.name,
      someoneElseRelationship: event.relationship,
      errors: errors,
    ));
  }

  void _onUpdateVehicleInfo(
      UpdateVehicleInfoEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    if (event.vehicleRegNo.trim().isNotEmpty) {
      errors.remove('vehicleRegNo');
    }

    emit(state.copyWith(
      vehicleRegNo: event.vehicleRegNo,
      errors: errors,
    ));
  }

  Future<void> _onLookupVehicle(
      LookupVehicleEvent event, Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(
        isSubmitting: true,
        isSearchingVehicle: true,
        submissionError: () => null));

    final errors = Map<String, String>.from(state.errors);
    errors.remove('vehicleRegNo');

    final bool found = event.regNo.toUpperCase().trim() == 'ABC125';

    if (found) {
      emit(state.copyWith(
        isSubmitting: false,
        isSearchingVehicle: false,
        vehicleRegNo: event.regNo,
        isVehicleFound: true,
        isManualEntry: false,
        sumInsuredField: null,
        // vehicleMake: 'Toyota',
        // vehicleModel: 'Corolla',
        // vehicleColor: 'Blue',
        // vehicleBodyStyle: 'Sedan',
        errors: errors,
      ));
    } else {
      emit(state.copyWith(
        isSubmitting: false,
        isSearchingVehicle: false,
        vehicleRegNo: event.regNo,
        isVehicleFound: false,
        isManualEntry: false,
        sumInsuredField: null,
        // vehicleMake: '',
        // vehicleModel: '',
        // vehicleColor: '',
        errors: errors,
      ));
    }
  }

  void _onSetVehicleManualEntry(
      SetVehicleManualEntryEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('vehicleMake');
    errors.remove('vehicleModel');
    errors.remove('vehicleEngineCapacity');
    errors.remove('vehicleColor');

    emit(state.copyWith(
      isManualEntry: event.isManualEntry,
      isVehicleFound: null,
      errors: errors,
    ));
  }

  void _onSelectVehicleBodyStyle(
      SelectVehicleBodyStyleEvent event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(vehicleBodyStyle: event.bodyStyle));
  }

  void _onUpdateVehicleManualDetails(UpdateVehicleManualDetailsEvent event,
      Emitter<MotorInsuranceState> emit) {
    final newEntity = VehicleCreateEntity(
      registrationNumber: event.vehicleRegNo,
      vehicleMake: event.vehicleMake,
      vehicleModel: event.vehicleModel,
      vehicleColor: event.vehicleColor,
      engineNumber: event.engineNumber,
      chassisNumber: event.chassisNumber,
      motorRiskCategoryId: event.motorRiskCategoryId,
      riskCategoryName: event.riskCategoryName,
      sumInsured: event.sumInsured,
      yearOfManufacture: event.yearOfManufacture,
      capacity: event.capacity,
      seatingCapacity: event.seatingCapacity,
      tonnage: event.tonnage,
    );

    emit(state.copyWith(vehicleCreateEntity: newEntity));
  }

  void _onUpdatePolicyDetails(
      UpdatePolicyDetailsEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    errors.remove('startDate');

    final newEndDate = event.startDate.add(const Duration(days: 365));

    emit(state.copyWith(
      coverageType: event.coverageType,
      startDate: event.startDate,
      endDate: newEndDate,
      errors: errors,
    ));
  }

  void _onUpdateDriverDetails(
      UpdateDriverDetailsEvent event, Emitter<MotorInsuranceState> emit) {
    final errors = Map<String, String>.from(state.errors);
    if (event.driverLicense.trim().isNotEmpty) errors.remove('driverLicense');
    if (event.driverExperience.trim().isNotEmpty)
      errors.remove('driverExperience');
    if (event.driverPhone.trim().isNotEmpty) errors.remove('driverPhone');

    emit(state.copyWith(
      driverLicense: event.driverLicense,
      driverExperience: event.driverExperience,
      driverPhone: event.driverPhone,
      errors: errors,
    ));
  }

  void _onUpdateAddons(
      UpdateAddonsEvent event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(
      zeroDepSelected: event.zeroDepSelected,
      roadsideSelected: event.roadsideSelected,
      engineSelected: event.engineSelected,
    ));
  }

  Future<void> _onSubmit(SubmitMotorInsuranceEvent event,
      Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(isSubmitting: true, submissionError: () => null));
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
          isSubmitting: false,
          submissionError: () => 'Failed to submit policy application: $e',
          submissionErrorToken: state.submissionErrorToken + 1));
    }
  }

  void _onReset(
      ResetMotorInsuranceEvent event, Emitter<MotorInsuranceState> emit) {
    emit(MotorInsuranceState());
  }

  // Helper validation logic for current step
  // Map<String, String> _validateCurrentStep() {
  //   final errors = Map<String, String>.from(state.errors);

  //   if (state.currentStep == 0) {
  //     if (!state.isForMyself) {
  //       if (state.someoneElseName.trim().isEmpty) {
  //         errors['someoneElseName'] =
  //             "Please enter the policyholder's full name";
  //       }
  //       if (state.someoneElseRelationship.trim().isEmpty) {
  //         errors['someoneElseRelationship'] =
  //             'Please specify relationship (e.g. Spouse, Child)';
  //       }
  //     }
  //   } else if (state.currentStep == 1) {
  //     if (state.isManualEntry) {
  //       if (state.vehicleRegNo.trim().isEmpty) {
  //         errors['vehicleRegNo'] = 'Registration number is required';
  //       }
  //     } else {
  //       if (state.isVehicleFound != true) {
  //         errors['vehicleRegNo'] = 'Please lookup a valid vehicle to proceed';
  //       }
  //     }
  //   } else if (state.currentStep == 2) {
  //     final today = DateTime(
  //         DateTime.now().year, DateTime.now().month, DateTime.now().day);
  //     final checkDate = DateTime(
  //         state.startDate.year, state.startDate.month, state.startDate.day);
  //     if (checkDate.isBefore(today)) {
  //       errors['startDate'] = 'Start date cannot be in the past';
  //     }
  //   } else if (state.currentStep == 3) {
  //     if (state.driverLicense.trim().isEmpty) {
  //       errors['driverLicense'] = 'Driver license number is required';
  //     }
  //     if (state.driverExperience.trim().isEmpty) {
  //       errors['driverExperience'] = 'Driver experience is required';
  //     } else {
  //       final exp = int.tryParse(state.driverExperience.trim());
  //       if (exp == null || exp < 0 || exp > 80) {
  //         errors['driverExperience'] =
  //             'Please enter valid years of experience (0 - 80)';
  //       }
  //     }
  //     if (state.driverPhone.trim().isEmpty) {
  //       errors['driverPhone'] = 'Phone number is required';
  //     } else if (state.driverPhone.trim().length < 8) {
  //       errors['driverPhone'] = 'Please enter a valid phone number';
  //     }
  //   }

  //   return errors;
  // }

  // void _clearErrorsForStep(int step, Map<String, String> errors) {
  //   if (step == 0) {
  //     errors.remove('someoneElseName');
  //     errors.remove('someoneElseRelationship');
  //   } else if (step == 1) {
  //     errors.remove('vehicleRegNo');
  //     errors.remove('vehicleMake');
  //     errors.remove('vehicleModel');
  //     errors.remove('vehicleEngineCapacity');
  //     errors.remove('vehicleColor');
  //   } else if (step == 2) {
  //     errors.remove('startDate');
  //   } else if (step == 3) {
  //     errors.remove('driverLicense');
  //     errors.remove('driverExperience');
  //     errors.remove('driverPhone');
  //   }
  // }

  void _onUpdatePolicyFor(
    UpdatePolicyForEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    emit(
      state.copyWith(selectedPolicyFor: event.code, isForMyself: event.label),
    );
  }

  Future<void> _onFetchMotorMaintainence(FetchMotorMaintainenceEvent event,
      Emitter<MotorInsuranceState> emit) async {
    final result = await motorMaintainenceUsecase.call();
    result.fold(
      (failure) {
        emit(state.copyWith(
            bodyStyleList: null,
            vehicleMakeList: null,
            policyDurationList: null));
      },
      (response) async {
        emit(state.copyWith(
            bodyStyleList: response.data?.bodyStyles,
            vehicleMakeList: response.data?.vehicleMakes,
            policyDurationList: response.data?.policyDurations,
            planTypeList: response.data?.planTypes,
            selectedPlan: response.data?.planTypes.firstOrNull));
      },
    );
  }

  Future<void> _onCreateVehilceCreate(
      VehicleCreateEvent event, Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(
        vehicleInfoStatus: VehicleInformationStatus.initial,
        isSubmitting: true));
    emit(state.copyWith(vehicleInfoStatus: VehicleInformationStatus.loading));
    emit(state.copyWith(vehicleData: () => null));
    final result = await vehicleCreateUseCase
        .call(VehicleCreateParams(event.vehicleCreateEntity, event.clientId));
    result.fold((failure) {
      emit(state.copyWith(
          vehicleInfoStatus: VehicleInformationStatus.failure,
          isSubmitting: false,
          submissionErrorToken: state.submissionErrorToken + 1,
          submissionError: () => failure.message,
          errors: {'vehicle_create_failure': failure.message}));
    }, (response) {
      emit(state.copyWith(
          isSubmitting: false,
          vehicleInfoStatus: VehicleInformationStatus.loaded,
          vehicleData: () => response.data!));
      add(NextStepEvent());
    });
  }

  Future<void> _onFetchRiskCategories(
      FetchRiskCategoriesEvent event, Emitter<MotorInsuranceState> emit) async {
    final result = await fetchRiskCategoriesUsecase.call();
    result.fold(
      (failure) {
        emit(state.copyWith(riskCategoriesList: null));
      },
      (response) {
        emit(state.copyWith(riskCategoriesList: response.data));
      },
    );
  }

  Future<void> _onSelectPlan(
    MotorInsuranceSelectPlanEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedPlan: event.selectedPlan,
      ),
    );
  }

  Future<void> _onGenerateMotorOtp(
    GenerateMotorOtpEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    if (state.otpStatus == MotorOtpStatus.generating ||
        state.otpStatus == MotorOtpStatus.verifying) {
      return;
    }

    final destination = event.destination.trim();
    if (destination.isEmpty) {
      emit(
        state.copyWith(
          otpStatus: MotorOtpStatus.error,
          otpMessage: () => 'Mobile number is required to generate OTP.',
        ),
      );
      return;
    }

    _stopOtpTimer();
    emit(
      state.copyWith(
        otpStatus: MotorOtpStatus.generating,
        otp: () => null,
        otpId: () => null,
        otpChannel: () => null,
        otpDestination: () => destination,
        otpAttemptRemaining: () => null,
        otpRemainingSeconds: 0,
        otpMessage: () => null,
        isOtpLocked: false,
      ),
    );

    final result = await generateMotorOtpUsecase(
      GenerateMotorOtpParams(destination: destination),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            otpStatus: MotorOtpStatus.error,
            otpMessage: () => failure.message,
            otpRemainingSeconds: 0,
          ),
        );
      },
      (response) {
        final data = response.data;
        final message = data?.chMessage?.message ??
            response.chMessage?.message ??
            'OTP sent successfully.';

        if (data == null) {
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.error,
              otpMessage: () => message,
              otpRemainingSeconds: 0,
            ),
          );
          return;
        }

        final type = data.chMessage?.type;
        if (data.status == 'VERIFIED' || type == 'OTP_ALREADY_VERIFIED') {
          _stopOtpTimer();
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.alreadyVerified,
              otpId: () => data.otpId,
              otp: () => null,
              otpChannel: () => data.channel,
              otpDestination: () => data.destination ?? destination,
              otpAttemptRemaining: () => data.attemptRemaining,
              otpRemainingSeconds: 0,
              otpMessage: () => message,
              isOtpLocked: false,
            ),
          );
          return;
        }

        if (data.isLocked) {
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.locked,
              otpId: () => data.otpId,
              otp: () => data.otp,
              otpChannel: () => data.channel,
              otpDestination: () => data.destination ?? destination,
              otpAttemptRemaining: () => data.attemptRemaining,
              otpRemainingSeconds: data.validityTime ?? 0,
              otpMessage: () => message,
              isOtpLocked: true,
            ),
          );
          return;
        }

        if (type != null && type != 'OTP_GENERATED') {
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.error,
              otpMessage: () => message,
              otpRemainingSeconds: 0,
            ),
          );
          return;
        }

        final validityTime = data.validityTime ?? 0;
        emit(
          state.copyWith(
            otpStatus: MotorOtpStatus.generated,
            otpId: () => data.otpId,
            otp: () => data.otp,
            otpChannel: () => data.channel ?? 'SMS',
            otpDestination: () => data.destination ?? destination,
            otpAttemptRemaining: () => data.attemptRemaining,
            otpRemainingSeconds: validityTime,
            otpMessage: () => message,
            isOtpLocked: false,
          ),
        );
        _startOtpTimer(validityTime);
      },
    );
  }

  Future<void> _onCompareQuotation(
      CompareQuotationEvent event, Emitter<MotorInsuranceState> emit) async {
    final createIndividualResponse = state.createIndividualResponse?.data;
    emit(
        state.copyWith(quotationCompareStatus: QuotationCompareStatus.loading));
    final result = await compareQuotationUsecase.call(CompareQuotationParams(
        productType: state.selectedPlan!.key!,
        currency: 'ZMW',
        duration: state.selectedQuarters,
        durationType: 'Quarters',
        startDate: state.startDate.toIso8601String(),
        sumInsured: state.vehicleData?.sumInsured ?? state.sumInsuredField,
        policyHolder: PolicyHolderParams(
            type: createIndividualResponse != null
                ? createIndividualResponse.type!
                : '',
            name: createIndividualResponse != null
                ? '${createIndividualResponse.firstName!} ${createIndividualResponse.lastName!}'
                : '',
            phone: createIndividualResponse != null
                ? createIndividualResponse.phoneNumber!
                : '',
            physicalAddress: createIndividualResponse != null
                ? createIndividualResponse.physicalAddress!
                : '',
            email: createIndividualResponse != null
                ? createIndividualResponse.email!
                : '',
            idType: createIndividualResponse != null
                ? createIndividualResponse.idType!
                : '',
            idNumber: createIndividualResponse != null
                ? createIndividualResponse.idNumber!
                : ''),
        risks: [
          VehilceParams(
              chassisNumber: state.vehicleData?.chassisNumber,
              color: state.vehicleData?.color,
              engineNumber: state.vehicleData?.engineNumber,
              id: state.vehicleData?.id,
              make: state.vehicleData?.make,
              model: state.vehicleData?.model,
              seatingCapacity: state.vehicleData?.seatingCapacity,
              sumInsured: (state.vehicleData?.sumInsured ?? 0) > 0
                  ? state.vehicleData?.sumInsured
                  : state.sumInsuredField,
              yearOfManufacture: state.vehicleData?.yearOfManufacture,
              registrationNumber: state.vehicleData?.registrationNumber,
              riskCategory: state.selectedRiskCategory?.name,
              riskCategoryId: state.selectedRiskCategory?.id ??
                  state.vehicleData?.riskCategoryId)
        ]));
    result.fold(
      (failure) {
        emit(state.copyWith(
            quotationCompareStatus: QuotationCompareStatus.error,
            submissionError: () => failure.message,
            quotationDataList: () => null,
            selectedInsuranceQuotation: () => null,
            submissionErrorToken: state.submissionErrorToken + 1));
      },
      (response) {
        emit(state.copyWith(
            quotationCompareStatus: QuotationCompareStatus.loaded,
            selectedInsuranceQuotation: () => null,
            quotationDataList: () => response.data));
      },
    );
  }

  Future<void> _onVerifyMotorOtp(
    VerifyMotorOtpEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    if (state.otpStatus == MotorOtpStatus.verifying ||
        state.otpStatus == MotorOtpStatus.generating) {
      return;
    }

    final otp = event.otp.trim();
    if (state.isOtpLocked) {
      emit(
        state.copyWith(
          otpStatus: MotorOtpStatus.locked,
          otpMessage: () => state.otpMessage ?? 'OTP is locked.',
        ),
      );
      return;
    }
    if (state.otpStatus == MotorOtpStatus.expired ||
        state.otpRemainingSeconds <= 0) {
      emit(
        state.copyWith(
          otpStatus: MotorOtpStatus.expired,
          otpMessage: () => 'OTP has expired.',
        ),
      );
      return;
    }
    if (otp.isEmpty || otp.length != 6) {
      emit(
        state.copyWith(
          otpStatus: MotorOtpStatus.verificationFailed,
          otpMessage: () => 'Please enter a valid OTP.',
        ),
      );
      return;
    }
    if (state.otpChannel == null || state.otpDestination == null) {
      emit(
        state.copyWith(
          otpStatus: MotorOtpStatus.error,
          otpMessage: () => 'Please generate OTP before verification.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        otpStatus: MotorOtpStatus.verifying,
        otp: () => otp,
        otpMessage: () => null,
      ),
    );

    final result = await verifyMotorOtpUsecase(
      VerifyMotorOtpParams(
        channel: state.otpChannel!,
        destination: state.otpDestination!,
        purpose: state.otpPurpose,
        referenceType: state.otpReferenceType,
        otp: otp,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            otpStatus: MotorOtpStatus.verificationFailed,
            otpMessage: () => failure.message,
          ),
        );
      },
      (response) {
        final data = response.data;
        final message = data?.chMessage?.message ??
            response.chMessage?.message ??
            'OTP verified successfully.';

        if (data?.isLocked == true) {
          _stopOtpTimer();
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.locked,
              otpAttemptRemaining: () => data?.attemptRemaining,
              otpMessage: () => message,
              isOtpLocked: true,
            ),
          );
          return;
        }

        if (data?.status == 'VERIFIED' ||
            response.chMessage?.code == 'SUCCESS') {
          _stopOtpTimer();
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.verified,
              otpId: () => null,
              otp: () => null,
              otpChannel: () => null,
              otpDestination: () => null,
              otpAttemptRemaining: () => null,
              otpRemainingSeconds: 0,
              otpMessage: () => message,
              isOtpLocked: false,
            ),
          );
          return;
        }

        if (data?.status == 'EXPIRED') {
          _stopOtpTimer();
          emit(
            state.copyWith(
              otpStatus: MotorOtpStatus.expired,
              otpAttemptRemaining: () => data?.attemptRemaining,
              otpRemainingSeconds: 0,
              otpMessage: () => 'OTP has expired.',
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            otpStatus: MotorOtpStatus.verificationFailed,
            otpAttemptRemaining: () => data?.attemptRemaining,
            otpMessage: () => message,
          ),
        );
      },
    );
  }

  void _onMotorOtpTimerTicked(
    MotorOtpTimerTickedEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    emit(state.copyWith(otpRemainingSeconds: event.remainingSeconds));
  }

  void _onMotorOtpExpired(
    MotorOtpExpiredEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    _stopOtpTimer();
    emit(
      state.copyWith(
        otpStatus: MotorOtpStatus.expired,
        otpRemainingSeconds: 0,
        otpMessage: () => 'OTP has expired.',
      ),
    );
  }

  void _onClearMotorOtp(
    ClearMotorOtpEvent event,
    Emitter<MotorInsuranceState> emit,
  ) {
    _stopOtpTimer();
    emit(
      state.copyWith(
        otpStatus: MotorOtpStatus.initial,
        otpId: () => null,
        otp: () => null,
        otpChannel: () => null,
        otpDestination: () => null,
        otpAttemptRemaining: () => null,
        otpRemainingSeconds: 0,
        otpMessage: () => null,
        isOtpLocked: false,
      ),
    );
  }

  void _startOtpTimer(int seconds) {
    _stopOtpTimer();
    if (seconds <= 0) {
      add(MotorOtpExpiredEvent());
      return;
    }

    var remainingSeconds = seconds;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      remainingSeconds -= 1;
      if (isClosed) return;
      if (remainingSeconds <= 0) {
        add(MotorOtpExpiredEvent());
      } else {
        add(MotorOtpTimerTickedEvent(remainingSeconds: remainingSeconds));
      }
    });
  }

  void _stopOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  @override
  Future<void> close() {
    _stopOtpTimer();
    return super.close();
  }

  Future<void> _onRiskCategoriesSelected(RiskCategoriesSelectedEvent event,
      Emitter<MotorInsuranceState> emit) async {
    emit(
        state.copyWith(selectedRiskCategory: () => event.selectedRiskCategory));
  }

  void _onSelectInsuranceQuote(
      SelectInsuranceQuoteEvent event, Emitter<MotorInsuranceState> emit) {
    final premium = event.selectedInsuranceQuotation.grossPremium;
    const fee = 0.0;
    emit(
      state.copyWith(
        selectedInsuranceQuotation: () => event.selectedInsuranceQuotation,
        premiumAmount: premium,
        convenienceFee: fee,
        totalAmount: premium,
        motorProductDetails: () => null,
        motorProductDetailsStatus: MotorProductDetailsStatus.initial,
      ),
    );
    final productId = event.selectedInsuranceQuotation.product.id;
    add(FetchMotorProductDetailsEvent(productId: productId));
  }

  Future<void> _createQuotationEvent(
    CreateQuotationEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    try {
      emit(state.copyWith(isSubmitting: true));
      final agentCode = await secureStorageService.getAgentMobNo();
      final result = await createQuotationUseCase.call(
          params: CreateQuotationParams(
              agentCode: agentCode ?? '987654321', // UsehardcodeAgentCode
              productId: state.selectedInsuranceQuotation!.product.id,
              currency: state.selectedInsuranceQuotation?.currency ?? 'ZMW',
              startDate: state.startDate.toIso8601String(),
              duration: state.selectedQuarters,
              clientId: state.createIndividualResponse?.data?.id ?? '',
              policyFor: state.selectedPolicyFor,
              quarters: state.selectedQuarters,
              risks: Risks(
                vehicleId: state.vehicleData?.id ?? '',
                sumInsured: state
                    .selectedInsuranceQuotation!.risks.first.vehicle.sumInsured,
              )));
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              submissionError: () => failure.message,
              submissionErrorToken: state.submissionErrorToken + 1,
              isSubmitting: false,
            ),
          );
        },
        (response) {
          final premium = state.selectedInsuranceQuotation?.grossPremium ??
              response.data.totalPremium;
          // const fee = 0.0;
          emit(
            state.copyWith(
              createQuotationResponse: response.data,
              isSubmitting: false,
              premiumAmount: premium,
              convenienceFee: response.data.convenienceFee,
              totalAmount: premium,
            ),
          );
          add(NextStepEvent());
        },
      );
    } catch (e) {
      emit(state.copyWith(
        submissionError: () => e.toString(),
        submissionErrorToken: state.submissionErrorToken + 1,
        isSubmitting: false,
      ));
    }
  }

  Future<void> _onDisableErrorMessage(
      DisableErrorMessageEvent event, Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(submissionError: () => null));
  }

  Future<void> _onProcessInsurancePayment(
      ProcessInsurancePayment event, Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(
        isSubmitting: true,
        isProcessing: true,
        instantIssueStatus: InstantIssueStatus.loading));

    final params = RequestPaymentParams(
        msisdn: '260${state.phoneNumber}',
        amount: state.createQuotationResponse?.totalPayable ?? 0,
        reference: state.createQuotationResponse?.referenceNumber ?? '',
        narration: 'Motor Insurance Payment',
        gateway: state.selectedMobileProvider.toUpperCase(),
        action: 'collect',
        environment: 'PROD',
        currecny: state.createQuotationResponse?.currency ?? 'ZMW');

    final result = await requestMotorInsurancePaymentUseCase.call(params);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
              instantIssueStatus: InstantIssueStatus.error,
              submissionError: () => failure.message,
              submissionErrorToken: state.submissionErrorToken + 1,
              isSubmitting: false,
              isProcessing: false,
              paymentSuccessEntity: null),
        );
      },
      (response) async {
        if (response.isSuccessful) {
          emit(state.copyWith(
              paymentSuccessEntity: _mapPaymentMethodEntity(response)));
          add(IssuePolicyBuQuoteIDEvent());
        } else {
          emit(
            state.copyWith(
              instantIssueStatus: InstantIssueStatus.error,
              submissionError: () =>
                  response.message ?? 'Payment failed. Please try again.',
              submissionErrorToken: state.submissionErrorToken + 1,
              isSubmitting: false,
              isProcessing: false,
            ),
          );
        }
      },
    );
  }

  PaymentSuccessEntity _mapPaymentMethodEntity(
      PaymentRequestResponse response) {
    return PaymentSuccessEntity(
        code: response.code ?? '',
        status: response.status ?? '',
        reference: response.reference ?? '',
        message: response.message ?? '',
        gwid: response.gwId ?? '',
        mnorequestid: response.mnoRequestId ?? '',
        mnofintxnid: response.mnoFintxnId ?? '',
        paymentRefNo: response.paymentRefNo ?? '',
        otpUrl: response.otpUrl ?? '');
  }

  Future<void> _onInstantIssue(Emitter<MotorInsuranceState> emit) async {
    final createIndividualResponse = state.createIndividualResponse?.data;
    emit(state.copyWith(
        isSubmitting: true,
        isProcessing: true,
        instantIssueStatus: InstantIssueStatus.loading));
    final agentCode = await secureStorageService.getAgentMobNo();
    final result = await createInstantIssueUseCase.call(
        CreateInstantIssueParams(
            productId: state.selectedInsuranceQuotation!.product.id,
            duration: state.selectedQuarters,
            currency: state.selectedInsuranceQuotation?.currency ?? 'ZMW',
            startDate: DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                .format(state.startDate.toUtc()),
            agentCode: agentCode ?? '987654321', // UsehardcodeAgentCode
            policyHolder: PolicyHolderInstantParams(
                tpinNumber: '',
                type: createIndividualResponse != null
                    ? createIndividualResponse.type!
                    : '',
                name: createIndividualResponse != null
                    ? '${createIndividualResponse.firstName!} ${createIndividualResponse.lastName!}'
                    : 'Abhay Kumar',
                phone: createIndividualResponse != null
                    ? createIndividualResponse.phoneNumber!
                    : '',
                physicalAddress: createIndividualResponse != null
                    ? createIndividualResponse.physicalAddress!
                    : '',
                email: createIndividualResponse != null
                    ? createIndividualResponse.email!
                    : '',
                idType: createIndividualResponse != null
                    ? createIndividualResponse.idType!
                    : '',
                idNumber: createIndividualResponse != null
                    ? createIndividualResponse.idNumber!
                    : ''),
            risks: [
              InstantRiskParams(
                  chassisNumber: state.vehicleData!.chassisNumber!,
                  color: state.vehicleData!.color!,
                  engineNumber: state.vehicleData!.engineNumber!,
                  make: state.vehicleData!.make!,
                  model: state.vehicleData!.model!,
                  sumInsured: state.vehicleData!.sumInsured!,
                  yearOfManufacture: state.vehicleData!.yearOfManufacture!,
                  registrationNumber: state.vehicleData!.registrationNumber!,
                  currency: 'ZMW',
                  motorBodyTypeId: null,
                  motorRiskCategoryId: state.selectedRiskCategory?.id ??
                      state.vehicleData!.riskCategoryId!),
            ],
            reference: null));
    result.fold((failure) {
      emit(
        state.copyWith(
          instantIssueStatus: InstantIssueStatus.error,
          submissionError: () => failure.message,
          submissionErrorToken: state.submissionErrorToken + 1,
          isSubmitting: false,
          isProcessing: false,
        ),
      );
    }, (response) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isProcessing: false,
          instantIssueStatus: InstantIssueStatus.loaded,
          instantIssueResponseEntity: _mapInstantIssueEntity(response),
        ),
      );
    });
  }

  InstantIssueResponseEntity _mapInstantIssueEntity(
      InstantIssueResponse response) {
    String formatPolicyDateRange({
      required DateTime startDate,
      required DateTime endDate,
    }) {
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
    }

    return InstantIssueResponseEntity(
        referenceNumber: response.data?.id ?? 'NA',
        policyNumber: response.data?.policyNumber ?? 'NA',
        coveragePeriod: formatPolicyDateRange(
            startDate: response.data?.startDate ?? DateTime.now(),
            endDate: response.data?.endDate ?? DateTime.now()),
        vehicle: '${state.vehicleData!.make!} ${state.vehicleData!.model!}',
        clientName: response.data?.clientName ?? 'NA',
        durationMonth: (response.data!.duration! * 3).toString(),
        duration: response.data?.duration?.toString() ?? 'NA',
        durationType: response.data?.durationType ?? 'NA',
        createdAt: response.data?.createdAt ?? DateTime.now(),
        currency: response.data?.currency ?? 'NA',
        status: response.data?.status ?? 'NA',
        premiumAmount:
            '${response.data!.currency} ${response.data!.grossPremium!.toStringAsFixed(2)}');
  }

  Future<void> _resetFormData(
    ResetFormData event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(
      vehicleData: () => null,
      id: null,
      firstName: () => null,
      lastName: () => null,
      nationalId: () => null,
      gender: 'MALE',
      mobileNumber: () => null,
      agentMobileNumber: null,
      dob: () => null,
      employmentType: 'Employed',
      monthlyIncome: () => null,
      sourceFunds: () => null,
      sector: () => null,
      employerName: () => null,
      businessName: () => null,
      businessNature: () => null,
      email: () => null,
      addressLine: () => null,
      phNumber: () => null,
      pbNumber: () => null,
      countryId: () => null,
      countryFriendlyType: () => null,
      stateId: () => null,
      stateFriendlyType: () => null,
      districtId: () => null,
      districtFriendlyType: () => null,
      cityId: () => null,
      cityFriendlyType: () => null,
      originCountryFriendlyType: () => null,
      photoUrl: () => null,
      signatureFile: () => null,
      signatureUrl: () => null,
      submitKyc: false,
      updateKyc: false,
    ));
  }

  Future<void> _resetVehicleData(
    ResetVehicleData event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(
        vehicleBodyStyle: '',
        vehicleData: () => null,
        selectedRiskCategory: () => null,
        sumInsuredField: 0,
        isManualEntry: false,
        isVehicleFound: null,
        vehicleInfoStatus: VehicleInformationStatus.initial));
  }

  Future<void> _downloadInvoice(
    DownloadInvoice event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(downloadInvoiceStatus: DownloadInvoiceStatus.loading));

    final result = await downloadReceiptUseCase(
      DownloadInvoiceParams(policyId: event.policyId),
    );

    result.fold(
      (l) {
        emit(state.copyWith(
            downloadInvoiceStatus: DownloadInvoiceStatus.failure,
            errorMessage: l.message));
        emit(state.copyWith(
            downloadInvoiceStatus: DownloadInvoiceStatus.initial));
      },
      (_) {
        emit(state.copyWith(
            downloadInvoiceStatus: DownloadInvoiceStatus.success));
        emit(state.copyWith(
            downloadInvoiceStatus: DownloadInvoiceStatus.initial));
      },
    );
  }

  Future<void> _onFetch(
    FetchInsuranceTransactionsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(
      insuranceTransactionStatus: InsuranceTransactionStatus.loading,
      search: event.search,
      fromDate: event.fromDate,
      toDate: event.toDate,
      agentCode: event.agentCode,
      vendorCode: await secureStorageService.getVendorKey() ?? 'INNOVATE',
      transactions: [],
      currentPage: 0,
      hasReachedMax: false,
    ));

    final result = await fetchInsuranceTransactionsUsecase(
        FetchInsuranceTransactionsParams(
      page: 0,
      search: event.search,
      fromDate: event.fromDate,
      toDate: event.toDate,
      agentCode: event.agentCode,
      vendorCode: state.vendorCode,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        insuranceTransactionStatus: InsuranceTransactionStatus.failure,
        errorMessage: failure.message,
      )),
      (response) {
        final pageData = response.data?.toEntity();
        if (pageData == null || pageData.transactions.isEmpty) {
          emit(state.copyWith(
              insuranceTransactionStatus: InsuranceTransactionStatus.empty));
          return;
        }
        emit(state.copyWith(
          insuranceTransactionStatus: InsuranceTransactionStatus.success,
          transactions: pageData.transactions,
          currentPage: pageData.currentPage,
          totalPages: pageData.totalPages,
          totalElements: pageData.totalElements,
          hasReachedMax: pageData.isLastPage,
        ));
      },
    );
  }

  Future<void> _onLoadMore(
    LoadMoreInsuranceTransactionsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.insuranceTransactionStatus ==
            InsuranceTransactionStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(
        insuranceTransactionStatus: InsuranceTransactionStatus.loadingMore));

    final nextPage = state.currentPage + 1;
    final result = await fetchInsuranceTransactionsUsecase(
      FetchInsuranceTransactionsParams(
          page: nextPage,
          search: state.search,
          fromDate: state.fromDate,
          toDate: state.toDate,
          agentCode: state.agentCode,
          vendorCode: state.vendorCode),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        insuranceTransactionStatus:
            InsuranceTransactionStatus.success, // keep existing list visible
        errorMessage: failure.message,
      )),
      (response) {
        final pageData = response.data?.toEntity();
        if (pageData == null) return;
        emit(state.copyWith(
          insuranceTransactionStatus: InsuranceTransactionStatus.success,
          transactions: [...state.transactions, ...pageData.transactions],
          currentPage: pageData.currentPage,
          totalPages: pageData.totalPages,
          totalElements: pageData.totalElements,
          hasReachedMax: pageData.isLastPage,
        ));
      },
    );
  }

  Future<void> _onRefresh(
    RefreshInsuranceTransactionsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    add(FetchInsuranceTransactionsEvent(
      search: state.search,
      fromDate: state.fromDate,
      toDate: state.toDate,
      agentCode: state.agentCode,
    ));
  }

  Future<void> _onClearFilters(
    ClearInsuranceTransactionFiltersEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(clearFilters: true));
    add(FetchInsuranceTransactionsEvent(agentCode: state.agentCode));
  }

  void _onPaymentMethodChanged(
      PaymentMethodChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(
      selectedPaymentMethod: event.selectedPaymentMethod,
    ));
  }

  void _onMobileProviderChanged(
      MobileProviderChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(selectedMobileProvider: event.selectedMobileProvider));
  }

  void _onPhoneNumberChanged(
      PhoneNumberChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void _onCardNumberChanged(
      CardNumberChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(cardNumber: event.cardNumber));
  }

  void _onCardExpiryChanged(
      CardExpiryChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(expiry: event.expiry));
  }

  void _onCardCVVChanged(
      CardCVVChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(cvv: event.cvv));
  }

  void _onCardHolderChanged(
      CardHolderChanged event, Emitter<MotorInsuranceState> emit) {
    emit(state.copyWith(cardHolder: event.cardHolder));
  }

  Future<void> _printReceipt(
    PrintReceipt event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(printReceiptStatus: PrintReceiptStatus.loading));

    final result =
        await printReceiptUseCase(PrintReceiptParams(policyId: event.policyId));

    result.fold(
      (l) {
        emit(state.copyWith(
            printReceiptStatus: PrintReceiptStatus.failure,
            errorMessage: l.message));
        emit(state.copyWith(printReceiptStatus: PrintReceiptStatus.initial));
      },
      (_) {
        emit(state.copyWith(printReceiptStatus: PrintReceiptStatus.success));
        emit(state.copyWith(printReceiptStatus: PrintReceiptStatus.initial));
      },
    );
  }

  Future<void> _onIssuePolicyByQuoteId(IssuePolicyBuQuoteIDEvent event,
      Emitter<MotorInsuranceState> emit) async {
    final agentCode = await secureStorageService.getAgentMobNo();
    final params = IssuePolicyByQuoteidParams(
        agentCode: agentCode ?? '987654321', // UsehardcodeAgentCode
        quotationId: state.createQuotationResponse?.id ?? '',
        referenceNumber: state.createQuotationResponse?.referenceNumber ?? '',
        paymentUsecase: PaymentParams(
            method: state.selectedPaymentMethod,
            mobileMoneyAccountNumber: '260${state.phoneNumber}',
            gateway: state.selectedMobileProvider.toUpperCase(),
            reference: state.paymentSuccessEntity?.reference ?? '',
            transactionId: state.paymentSuccessEntity?.mnofintxnid ?? '',
            gwId: state.paymentSuccessEntity?.gwid ?? '',
            paymentRefNo: state.paymentSuccessEntity?.paymentRefNo ?? '',
            mnoRequestId: state.paymentSuccessEntity?.mnorequestid ?? ''));

    final result = await issuePolicyByQuoteIDUseCase.call(params);

    result.fold((failure) {
      emit(
        state.copyWith(
          instantIssueStatus: InstantIssueStatus.error,
          submissionError: () => failure.message,
          submissionErrorToken: state.submissionErrorToken + 1,
          isSubmitting: false,
          isProcessing: false,
        ),
      );
    }, (response) {
      if (response.chMessage?.isError == true) {
        emit(
          state.copyWith(
            instantIssueStatus: InstantIssueStatus.error,
            submissionError: () =>
                response.chMessage?.message ?? 'Failed to issue policy',
            submissionErrorToken: state.submissionErrorToken + 1,
            isSubmitting: false,
            isProcessing: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isSubmitting: false,
            isProcessing: false,
            instantIssueStatus: InstantIssueStatus.loaded,
            issuePolicyByQuoteIdResponse: response,
          ),
        );
      }
    });
  }

  Future<void> _onSumInsuredFieldChange(SumInsuredFieldChangeEvent event,
      Emitter<MotorInsuranceState> emit) async {
    emit(state.copyWith(sumInsuredField: event.sumInusredValue));
  }

  Future<void> _onFetchMotorProductDetails(
    FetchMotorProductDetailsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    emit(state.copyWith(
      motorProductDetailsStatus: MotorProductDetailsStatus.loading,
    ));

    final result = await fetchMotorProductDetailsUseCase.call(event.productId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          motorProductDetailsStatus: MotorProductDetailsStatus.error,
        ));
      },
      (response) {
        emit(state.copyWith(
          motorProductDetails: () => response,
          motorProductDetailsStatus: MotorProductDetailsStatus.loaded,
        ));
      },
    );
  }

  Future<void> _onSendSmsForPolicyKeyFacts(
    SendSMSForPolicyKeyFactsEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    if (state.sendSmsStatus == SendSmsStatus.loading) return;

    emit(state.copyWith(sendSmsStatus: SendSmsStatus.loading));

    final result = await smsSendForKeyFactsUseCase.call(
        event.productId, event.customerMobileNumber);

    result.fold(
      (failure) {
        emit(state.copyWith(sendSmsStatus: SendSmsStatus.failure));
      },
      (success) {
        emit(state.copyWith(
          sendSmsStatus:
              success ? SendSmsStatus.success : SendSmsStatus.failure,
        ));
      },
    );
  }

  Future<void> _onFetchKeyFactsDocument(
    FetchKeyFactsDocumentEvent event,
    Emitter<MotorInsuranceState> emit,
  ) async {
    if (state.keyFactsDocumentStatus == KeyFactsDocumentStatus.loading) {
      return;
    }

    emit(state.copyWith(
      keyFactsDocumentStatus: KeyFactsDocumentStatus.loading,
    ));

    final result = await downloadKeyFactsDocumentUseCase.call(event.productId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          keyFactsDocumentStatus: KeyFactsDocumentStatus.failure,
        ));
      },
      (document) {
        emit(state.copyWith(
          keyFactsDocumentStatus: KeyFactsDocumentStatus.success,
          keyFactsDocument: () => document,
        ));
      },
    );
  }
}
