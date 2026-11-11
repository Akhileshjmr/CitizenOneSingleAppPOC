import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_individual_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_quotation_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/issue_policy_by_quote_id.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/kyc_user_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_product_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/risk_category_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/instant_issue_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/key_facts_document_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/insurance_transaction_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/payment_success_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/vehicle_create_entity.dart';

enum KycUserStatus {
  initial,
  loading,
  loaded,
  notFound,
  error,
  loadedFromHistory
}

enum VehicleInformationStatus {
  initial,
  loading,
  loaded,
  notFound,
  error,
  loadedFromHistory,
  failure
}

enum InstantIssueStatus {
  initial,
  loading,
  loaded,
  error,
}

enum SearchType { nationalId, mobileNumber }

enum FileDownloadStatus { initial, loading, success, failure }

enum CustomerCreationStatus { initial, loading, success, failure }

enum InsuranceTransactionStatus {
  initial,
  loading,
  loadingMore,
  success,
  empty,
  failure,
}

enum MotorOtpStatus {
  initial,
  generating,
  generated,
  alreadyVerified,
  verifying,
  verified,
  verificationFailed,
  expired,
  locked,
  error
}

enum QuotationCompareStatus { initial, loading, loaded, error }

enum DownloadInvoiceStatus { initial, loading, success, failure }

enum MotorProductDetailsStatus { initial, loading, loaded, error }

enum PrintReceiptStatus { initial, loading, success, failure }

enum KeyFactsDocumentStatus { initial, loading, success, failure }

enum SendSmsStatus { initial, loading, success, failure }

class MotorInsuranceState extends Equatable {
  final int currentStep;
  final int selectedQuarters;

  // Step 1: Coverage / Policy Holder
  final String isForMyself;
  final String someoneElseName;
  final String someoneElseRelationship;

  // Step 2: Vehicle Info & Lookup Details
  final String vehicleRegNo;
  final bool isSearchingVehicle;
  final bool?
      isVehicleFound; // null = not looked up, true = found, false = not found
  final bool isManualEntry; // true = manual details mode, false = lookup mode

  final String
      vehicleBodyStyle; // 'Sedan', 'SUV', 'Van', 'Pickup', 'Sports', 'Hatchback'
  final bool personalAccidentSelected;
  // Step 3: Policy Details
  final String coverageType; // 'Third Party Only' or 'Comprehensive'
  final DateTime startDate;
  final DateTime endDate;

  // Step 4: Driver Details
  final String driverLicense;
  final String driverExperience; // Experience in years
  final String driverPhone;

  // Step 5: Add-ons
  final bool zeroDepSelected;
  final bool roadsideSelected;
  final bool engineSelected;

  // Step 6: Submission / Review
  final bool isSubmitting;
  final bool isSuccess;
  final String? submissionError;
  final int submissionErrorToken;

  // Validation messages map: field name -> error message
  final Map<String, String> errors;

  final KycUserStatus status;
  final VehicleInformationStatus vehicleInfoStatus;
  // final MotorInsuranceStatus motorStatus;
  final SearchType searchType;
  final String? mobileNumber;
  final String? nationalId;
  final String? agentMobileNumber;
  final bool isUserExists;
  final CustomerCreationStatus customerCreationStatus;
  final String? customerCreationMessage;

  // User fields
  final CustomerDetails? customerDetails;
  final CreateIndividualResponseModel? createIndividualResponse;
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dob;
  final String? monthlyIncome;
  final String? sourceFunds;
  final String? employmentType;
  final String? sector;
  final String? employerName;
  final String? businessNature;
  final String? businessName;
  final String? kycStatus;
  final String? code;
  final String? originCountryFriendlyType;

  // Communication
  final String? email;
  final String? phNumber;
  final String? pbNumber;
  final String? addressLine;
  final int? countryId;
  final int? stateId;
  final int? districtId;
  final int? cityId;
  final String? countryFriendlyType;
  final String? stateFriendlyType;
  final String? districtFriendlyType;
  final String? cityFriendlyType;

  // Documents
  final String? photoUrl;
  final int? photoDocId;
  final String? signatureUrl;
  final int? signatureDocId;
  final List<Document> kycUserDocuments;
  final List<int>? signatureFile;
  final FileDownloadStatus fileDownloadStatus;

  // Flags
  final bool submitKyc;
  final bool updateKyc;

  final List<BodyStyle>? bodyStyleList;
  final List<VehicleMake>? vehicleMakeList;
  final List<PolicyDuration>? policyDurationList;
  final List<PlanType>? planTypeList;
  final VehicleData? vehicleData;
  final List<RiskCategoryModel>? riskCategoriesList;
  //master
  final MotorInsuranceMasterData? masterData;
  final String selectedPolicyFor;
  final PlanType? selectedPlan;

  // Create Vehicle
  final VehicleCreateEntity? vehicleCreateEntity;
  final MotorOtpStatus otpStatus;
  final String? otpId;
  final String? otp;
  final String otpPurpose;
  final String otpReferenceType;
  final String? otpChannel;
  final String? otpDestination;
  final int? otpAttemptRemaining;
  final int otpRemainingSeconds;
  final String? otpMessage;
  final bool isOtpLocked;

  // Quotation Compare
  final QuotationData? quotationDataList;
  final QuotationCompareStatus quotationCompareStatus;
  final RiskCategoryModel? selectedRiskCategory;
  final Quotation? selectedInsuranceQuotation;
  final QuoteData? createQuotationResponse;
  final InstantIssueResponseEntity? instantIssueResponseEntity;
  final InstantIssueStatus instantIssueStatus;

  final DownloadInvoiceStatus downloadInvoiceStatus;
  final PrintReceiptStatus printReceiptStatus;

//Insurance transaction
  final InsuranceTransactionStatus insuranceTransactionStatus;
  final List<InsuranceTransactionEntity> transactions;
  final int currentPage;
  final int totalPages;
  final int totalElements;
  final bool hasReachedMax;
  final String? errorMessage;
  final String? search;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String agentCode;
  final String vendorCode;
  final int? expandedIndex;

  // Payment bottom sheet state properties
  final String selectedPaymentMethod;
  final String selectedMobileProvider;
  final String phoneNumber;
  final String cardNumber;
  final String expiry;
  final String cvv;
  final String cardHolder;
  final bool isProcessing;
  final double premiumAmount;
  final double convenienceFee;
  final double totalAmount;
  final PaymentSuccessEntity? paymentSuccessEntity;
  final IssuePolicyByQuoteIdResponse? issuePolicyByQuoteIdResponse;
  final double sumInsuredField;
  final MotorProductDetailsResponseModel? motorProductDetails;
  final MotorProductDetailsStatus motorProductDetailsStatus;
  final KeyFactsDocumentStatus keyFactsDocumentStatus;
  final KeyFactsDocumentEntity? keyFactsDocument;
  final SendSmsStatus sendSmsStatus;

  MotorInsuranceState(
      {this.currentStep = 0,
      this.selectedQuarters = 1,
      this.isForMyself = 'For Someone False',
      this.someoneElseName = '',
      this.someoneElseRelationship = '',
      this.vehicleRegNo = '',
      this.isSearchingVehicle = false,
      this.isVehicleFound,
      this.isManualEntry = false,
      this.vehicleBodyStyle = '',
      this.coverageType = 'Third Party Only',
      DateTime? startDate,
      DateTime? endDate,
      this.driverLicense = '',
      this.driverExperience = '',
      this.driverPhone = '',
      this.zeroDepSelected = false,
      this.roadsideSelected = false,
      this.engineSelected = false,
      this.isSubmitting = false,
      this.isSuccess = false,
      this.submissionError,
      this.submissionErrorToken = 0,
      this.personalAccidentSelected = true,
      this.errors = const {},
      this.status = KycUserStatus.initial,
      this.vehicleInfoStatus = VehicleInformationStatus.initial,
      this.searchType = SearchType.mobileNumber,
      this.mobileNumber,
      this.nationalId,
      this.agentMobileNumber,
      this.isUserExists = false,
      this.customerCreationStatus = CustomerCreationStatus.initial,
      this.customerCreationMessage,
      this.customerDetails,
      this.createIndividualResponse,
      this.id,
      this.firstName,
      this.lastName,
      this.gender = 'MALE',
      this.dob,
      this.monthlyIncome,
      this.sourceFunds,
      this.employmentType = 'Employed',
      this.sector,
      this.employerName,
      this.businessNature,
      this.businessName,
      this.kycStatus,
      this.code,
      this.originCountryFriendlyType,
      this.email,
      this.phNumber,
      this.pbNumber,
      this.addressLine,
      this.countryId,
      this.stateId,
      this.districtId,
      this.cityId,
      this.countryFriendlyType,
      this.stateFriendlyType,
      this.districtFriendlyType,
      this.cityFriendlyType,
      this.photoUrl,
      this.photoDocId,
      this.signatureUrl,
      this.signatureDocId,
      this.kycUserDocuments = const [],
      this.submitKyc = false,
      this.updateKyc = false,
      this.signatureFile,
      this.fileDownloadStatus = FileDownloadStatus.initial,
      this.bodyStyleList,
      this.vehicleMakeList,
      this.policyDurationList,
      this.planTypeList,
      this.vehicleData,
      this.riskCategoriesList,
      this.masterData,
      this.selectedPolicyFor = 'FOR_SOMEONE_ELSE',
      this.vehicleCreateEntity,
      this.selectedPlan,
      this.otpStatus = MotorOtpStatus.initial,
      this.otpId,
      this.otp,
      this.otpPurpose = 'Insurance',
      this.otpReferenceType = 'MOTOR_INSURANCE',
      this.otpChannel,
      this.otpDestination,
      this.otpAttemptRemaining,
      this.otpRemainingSeconds = 0,
      this.otpMessage,
      this.isOtpLocked = false,
      this.quotationDataList,
      this.quotationCompareStatus = QuotationCompareStatus.initial,
      this.selectedRiskCategory,
      this.selectedInsuranceQuotation,
      this.createQuotationResponse,
      this.instantIssueResponseEntity,
      this.instantIssueStatus = InstantIssueStatus.initial,
      this.downloadInvoiceStatus = DownloadInvoiceStatus.initial,
      this.printReceiptStatus = PrintReceiptStatus.initial,
      this.insuranceTransactionStatus = InsuranceTransactionStatus.initial,
      this.transactions = const [],
      this.currentPage = 0,
      this.totalPages = 0,
      this.totalElements = 0,
      this.hasReachedMax = false,
      this.errorMessage,
      this.search,
      this.fromDate,
      this.toDate,
      this.agentCode = '',
      this.vendorCode = '',
      this.expandedIndex,
      this.selectedPaymentMethod = 'Mobile Money',
      this.selectedMobileProvider = 'Airtel',
      this.phoneNumber = '',
      this.cardNumber = '',
      this.expiry = '',
      this.cvv = '',
      this.cardHolder = '',
      this.isProcessing = false,
      this.premiumAmount = 0.0,
      this.convenienceFee = 0.0,
      this.totalAmount = 0.0,
      this.paymentSuccessEntity,
      this.issuePolicyByQuoteIdResponse,
      this.sumInsuredField = 0,
      this.motorProductDetails,
      this.motorProductDetailsStatus = MotorProductDetailsStatus.initial,
      this.keyFactsDocumentStatus = KeyFactsDocumentStatus.initial,
      this.keyFactsDocument,
      this.sendSmsStatus = SendSmsStatus.initial})
      : startDate = startDate ?? DateTime.now(),
        endDate = endDate ??
            (startDate ?? DateTime.now()).add(const Duration(days: 365));

  MotorInsuranceState copyWith(
      {int? currentStep,
      int? selectedQuarters,
      String? isForMyself,
      String? someoneElseName,
      String? someoneElseRelationship,
      String? vehicleRegNo,
      bool? isSearchingVehicle,
      bool? isVehicleFound,
      bool? isManualEntry,
      String? vehicleEngineCapacity,
      String? vehicleBodyStyle,
      String? coverageType,
      DateTime? startDate,
      DateTime? endDate,
      String? driverLicense,
      String? driverExperience,
      String? driverPhone,
      bool? zeroDepSelected,
      bool? roadsideSelected,
      bool? engineSelected,
      bool? isSubmitting,
      bool? isSuccess,
      ValueGetter<String?>? submissionError,
      int? submissionErrorToken,
      bool? personalAccidentSelected,
      Map<String, String>? errors,
      KycUserStatus? status,
      VehicleInformationStatus? vehicleInfoStatus,
      SearchType? searchType,
      ValueGetter<String?>? mobileNumber,
      ValueGetter<String?>? nationalId,
      String? agentMobileNumber,
      bool? isUserExists,
      CustomerCreationStatus? customerCreationStatus,
      ValueGetter<String?>? customerCreationMessage,
      CustomerDetails? customerDetails,
      int? id,
      ValueGetter<String?>? firstName,
      ValueGetter<String?>? lastName,
      String? gender,
      ValueGetter<DateTime?>? dob,
      ValueGetter<String?>? monthlyIncome,
      ValueGetter<String?>? sourceFunds,
      String? employmentType,
      ValueGetter<String?>? sector,
      ValueGetter<String?>? employerName,
      ValueGetter<String?>? businessNature,
      ValueGetter<String?>? businessName,
      String? kycStatus,
      String? code,
      ValueGetter<String?>? originCountryFriendlyType,
      ValueGetter<String?>? email,
      ValueGetter<String?>? phNumber,
      ValueGetter<String?>? pbNumber,
      ValueGetter<String?>? addressLine,
      ValueGetter<int?>? countryId,
      ValueGetter<int?>? stateId,
      ValueGetter<int?>? districtId,
      ValueGetter<int?>? cityId,
      ValueGetter<String?>? countryFriendlyType,
      ValueGetter<String?>? stateFriendlyType,
      ValueGetter<String?>? districtFriendlyType,
      ValueGetter<String?>? cityFriendlyType,
      ValueGetter<String?>? photoUrl,
      ValueGetter<int?>? photoDocId,
      ValueGetter<String?>? signatureUrl,
      ValueGetter<int?>? signatureDocId,
      List<Document>? kycUserDocuments,
      bool? submitKyc,
      bool? updateKyc,
      ValueGetter<List<int>?>? signatureFile,
      FileDownloadStatus? fileDownloadStatus,
      List<BodyStyle>? bodyStyleList,
      List<VehicleMake>? vehicleMakeList,
      List<PolicyDuration>? policyDurationList,
      ValueGetter<VehicleData?>? vehicleData,
      List<RiskCategoryModel>? riskCategoriesList,
      MotorInsuranceMasterData? masterData,
      String? selectedPolicyFor,
      VehicleCreateEntity? vehicleCreateEntity,
      String? riskCategoryName,
      String? motorRiskCategoryId,
      List<PlanType>? planTypeList,
      PlanType? selectedPlan,
      MotorOtpStatus? otpStatus,
      ValueGetter<String?>? otpId,
      ValueGetter<String?>? otp,
      String? otpPurpose,
      String? otpReferenceType,
      ValueGetter<String?>? otpChannel,
      ValueGetter<String?>? otpDestination,
      ValueGetter<int?>? otpAttemptRemaining,
      int? otpRemainingSeconds,
      ValueGetter<String?>? otpMessage,
      bool? isOtpLocked,
      ValueGetter<QuotationData?>? quotationDataList,
      QuotationCompareStatus? quotationCompareStatus,
      ValueGetter<RiskCategoryModel?>? selectedRiskCategory,
      ValueGetter<Quotation?>? selectedInsuranceQuotation,
      QuoteData? createQuotationResponse,
      CreateIndividualResponseModel? createIndividualResponse,
      InstantIssueResponseEntity? instantIssueResponseEntity,
      InstantIssueStatus? instantIssueStatus,
      DownloadInvoiceStatus? downloadInvoiceStatus,
      PrintReceiptStatus? printReceiptStatus,
      InsuranceTransactionStatus? insuranceTransactionStatus,
      List<InsuranceTransactionEntity>? transactions,
      int? currentPage,
      int? totalPages,
      int? totalElements,
      bool? hasReachedMax,
      String? errorMessage,
      String? search,
      DateTime? fromDate,
      DateTime? toDate,
      String? agentCode,
      String? vendorCode,
      bool clearFilters = false,
      ValueGetter<int?>? expandedIndex,
      String? selectedPaymentMethod,
      String? selectedMobileProvider,
      String? phoneNumber,
      String? cardNumber,
      String? expiry,
      String? cvv,
      String? cardHolder,
      bool? isProcessing,
      double? premiumAmount,
      double? convenienceFee,
      double? totalAmount,
      PaymentSuccessEntity? paymentSuccessEntity,
      IssuePolicyByQuoteIdResponse? issuePolicyByQuoteIdResponse /* Need fix */,
      double? sumInsuredField,
      ValueGetter<MotorProductDetailsResponseModel?>? motorProductDetails,
      MotorProductDetailsStatus? motorProductDetailsStatus,
      KeyFactsDocumentStatus? keyFactsDocumentStatus,
      ValueGetter<KeyFactsDocumentEntity?>? keyFactsDocument,
      SendSmsStatus? sendSmsStatus}) {
    return MotorInsuranceState(
        currentStep: currentStep ?? this.currentStep,
        selectedQuarters: selectedQuarters ?? this.selectedQuarters,
        isForMyself: isForMyself ?? this.isForMyself,
        someoneElseName: someoneElseName ?? this.someoneElseName,
        someoneElseRelationship:
            someoneElseRelationship ?? this.someoneElseRelationship,
        vehicleRegNo: vehicleRegNo ?? this.vehicleRegNo,
        isSearchingVehicle: isSearchingVehicle ?? this.isSearchingVehicle,
        isVehicleFound: isVehicleFound ?? this.isVehicleFound,
        isManualEntry: isManualEntry ?? this.isManualEntry,
        vehicleBodyStyle: vehicleBodyStyle ?? this.vehicleBodyStyle,
        coverageType: coverageType ?? this.coverageType,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        driverLicense: driverLicense ?? this.driverLicense,
        driverExperience: driverExperience ?? this.driverExperience,
        driverPhone: driverPhone ?? this.driverPhone,
        zeroDepSelected: zeroDepSelected ?? this.zeroDepSelected,
        roadsideSelected: roadsideSelected ?? this.roadsideSelected,
        engineSelected: engineSelected ?? this.engineSelected,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        submissionError:
            submissionError != null ? submissionError() : this.submissionError,
        submissionErrorToken: submissionErrorToken ?? this.submissionErrorToken,
        errors: errors ?? this.errors,
        personalAccidentSelected:
            personalAccidentSelected ?? this.personalAccidentSelected,
        status: status ?? this.status,
        vehicleInfoStatus: vehicleInfoStatus ?? this.vehicleInfoStatus,
        searchType: searchType ?? this.searchType,
        mobileNumber: mobileNumber != null ? mobileNumber() : this.mobileNumber,
        nationalId: nationalId != null ? nationalId() : this.nationalId,
        agentMobileNumber: agentMobileNumber ?? this.agentMobileNumber,
        isUserExists: isUserExists ?? this.isUserExists,
        customerCreationStatus:
            customerCreationStatus ?? this.customerCreationStatus,
        customerCreationMessage: customerCreationMessage != null
            ? customerCreationMessage()
            : this.customerCreationMessage,
        customerDetails: customerDetails ?? this.customerDetails,
        id: id ?? this.id,
        firstName: firstName != null ? firstName() : this.firstName,
        lastName: lastName != null ? lastName() : this.lastName,
        gender: gender ?? this.gender,
        dob: dob != null ? dob() : this.dob,
        monthlyIncome:
            monthlyIncome != null ? monthlyIncome() : this.monthlyIncome,
        sourceFunds: sourceFunds != null ? sourceFunds() : this.sourceFunds,
        employerName: employerName != null ? employerName() : this.employerName,
        businessNature:
            businessNature != null ? businessNature() : this.businessNature,
        businessName: businessName != null ? businessName() : this.businessName,
        email: email != null ? email() : this.email,
        addressLine: addressLine != null ? addressLine() : this.addressLine,
        phNumber: phNumber != null ? phNumber() : this.phNumber,
        pbNumber: pbNumber != null ? pbNumber() : this.pbNumber,
        countryId: countryId != null ? countryId() : this.countryId,
        stateId: stateId != null ? stateId() : this.stateId,
        districtId: districtId != null ? districtId() : this.districtId,
        cityId: cityId != null ? cityId() : this.cityId,
        employmentType: employmentType ?? this.employmentType,
        sector: sector != null ? sector() : this.sector,
        kycStatus: kycStatus ?? this.kycStatus,
        code: code ?? this.code,
        originCountryFriendlyType: originCountryFriendlyType != null
            ? originCountryFriendlyType()
            : this.originCountryFriendlyType,
        countryFriendlyType: countryFriendlyType != null
            ? countryFriendlyType()
            : this.countryFriendlyType,
        stateFriendlyType: stateFriendlyType != null
            ? stateFriendlyType()
            : this.stateFriendlyType,
        districtFriendlyType: districtFriendlyType != null
            ? districtFriendlyType()
            : this.districtFriendlyType,
        cityFriendlyType: cityFriendlyType != null
            ? cityFriendlyType()
            : this.cityFriendlyType,
        photoUrl: photoUrl != null ? photoUrl() : this.photoUrl,
        photoDocId: photoDocId != null ? photoDocId() : this.photoDocId,
        signatureUrl: signatureUrl != null ? signatureUrl() : this.signatureUrl,
        signatureDocId:
            signatureDocId != null ? signatureDocId() : this.signatureDocId,
        kycUserDocuments: kycUserDocuments ?? this.kycUserDocuments,
        submitKyc: submitKyc ?? this.submitKyc,
        updateKyc: updateKyc ?? this.updateKyc,
        signatureFile:
            (signatureFile != null) ? signatureFile() : this.signatureFile,
        fileDownloadStatus: fileDownloadStatus ?? this.fileDownloadStatus,
        bodyStyleList: bodyStyleList ?? this.bodyStyleList,
        vehicleMakeList: vehicleMakeList ?? this.vehicleMakeList,
        policyDurationList: policyDurationList ?? this.policyDurationList,
        vehicleData: (vehicleData != null) ? vehicleData() : this.vehicleData,
        riskCategoriesList: riskCategoriesList ?? this.riskCategoriesList,
        masterData: masterData ?? this.masterData,
        selectedPolicyFor: selectedPolicyFor ?? this.selectedPolicyFor,
        vehicleCreateEntity: vehicleCreateEntity ?? this.vehicleCreateEntity,
        planTypeList: planTypeList ?? this.planTypeList,
        selectedPlan: selectedPlan ?? this.selectedPlan,
        otpStatus: otpStatus ?? this.otpStatus,
        otpId: otpId != null ? otpId() : this.otpId,
        otp: otp != null ? otp() : this.otp,
        otpPurpose: otpPurpose ?? this.otpPurpose,
        otpReferenceType: otpReferenceType ?? this.otpReferenceType,
        otpChannel: otpChannel != null ? otpChannel() : this.otpChannel,
        otpDestination:
            otpDestination != null ? otpDestination() : this.otpDestination,
        otpAttemptRemaining: otpAttemptRemaining != null
            ? otpAttemptRemaining()
            : this.otpAttemptRemaining,
        otpRemainingSeconds: otpRemainingSeconds ?? this.otpRemainingSeconds,
        otpMessage: otpMessage != null ? otpMessage() : this.otpMessage,
        isOtpLocked: isOtpLocked ?? this.isOtpLocked,
        quotationDataList: quotationDataList != null
            ? quotationDataList()
            : this.quotationDataList,
        quotationCompareStatus:
            quotationCompareStatus ?? this.quotationCompareStatus,
        selectedRiskCategory: selectedRiskCategory != null
            ? selectedRiskCategory()
            : this.selectedRiskCategory,
        selectedInsuranceQuotation: selectedInsuranceQuotation != null
            ? selectedInsuranceQuotation()
            : this.selectedInsuranceQuotation,
        createQuotationResponse:
            createQuotationResponse ?? this.createQuotationResponse,
        createIndividualResponse:
            createIndividualResponse ?? this.createIndividualResponse,
        instantIssueResponseEntity:
            instantIssueResponseEntity ?? this.instantIssueResponseEntity,
        instantIssueStatus: instantIssueStatus ?? this.instantIssueStatus,
        downloadInvoiceStatus:
            downloadInvoiceStatus ?? this.downloadInvoiceStatus,
        printReceiptStatus: printReceiptStatus ?? this.printReceiptStatus,
        insuranceTransactionStatus:
            insuranceTransactionStatus ?? this.insuranceTransactionStatus,
        transactions: transactions ?? this.transactions,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        totalElements: totalElements ?? this.totalElements,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        errorMessage: errorMessage,
        search: clearFilters ? null : (search ?? this.search),
        fromDate: clearFilters ? null : (fromDate ?? this.fromDate),
        toDate: clearFilters ? null : (toDate ?? this.toDate),
        agentCode: agentCode ?? this.agentCode,
        vendorCode: vendorCode ?? this.vendorCode,
        expandedIndex:
            expandedIndex != null ? expandedIndex() : this.expandedIndex,
        selectedPaymentMethod:
            selectedPaymentMethod ?? this.selectedPaymentMethod,
        selectedMobileProvider:
            selectedMobileProvider ?? this.selectedMobileProvider,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        cardNumber: cardNumber ?? this.cardNumber,
        expiry: expiry ?? this.expiry,
        cvv: cvv ?? this.cvv,
        cardHolder: cardHolder ?? this.cardHolder,
        isProcessing: isProcessing ?? this.isProcessing,
        premiumAmount: premiumAmount ?? this.premiumAmount,
        convenienceFee: convenienceFee ?? this.convenienceFee,
        totalAmount: totalAmount ?? this.totalAmount,
        paymentSuccessEntity: paymentSuccessEntity ?? this.paymentSuccessEntity,
        issuePolicyByQuoteIdResponse:
            issuePolicyByQuoteIdResponse ?? this.issuePolicyByQuoteIdResponse,
        sumInsuredField: sumInsuredField ?? this.sumInsuredField,
        motorProductDetails: motorProductDetails != null
            ? motorProductDetails()
            : this.motorProductDetails,
        motorProductDetailsStatus:
            motorProductDetailsStatus ?? this.motorProductDetailsStatus,
        keyFactsDocumentStatus:
            keyFactsDocumentStatus ?? this.keyFactsDocumentStatus,
        keyFactsDocument: keyFactsDocument != null
            ? keyFactsDocument()
            : this.keyFactsDocument,
        sendSmsStatus: sendSmsStatus ?? this.sendSmsStatus);
  }

  /// Policy end date derived from [startDate] and [selectedQuarters].
  /// Not to be confused with [endDate], which holds the server-confirmed
  /// end date returned after quotation/policy creation.
  DateTime get calculatedPolicyEndDate => DateTime(
        startDate.year,
        startDate.month + (selectedQuarters * 3),
        startDate.day,
      );

  /// Months for the currently [selectedQuarters], looked up from
  /// [policyDurationList] so it stays in sync with server-provided data.
  int get selectedPolicyMonths {
    for (final duration in policyDurationList ?? const <PolicyDuration>[]) {
      if (duration.quarters == selectedQuarters && duration.months != null) {
        return duration.months!;
      }
    }
    return selectedQuarters * 3;
  }

  @override
  List<Object?> get props => [
        currentStep,
        selectedQuarters,
        isForMyself,
        someoneElseName,
        someoneElseRelationship,
        vehicleRegNo,
        isVehicleFound,
        isManualEntry,
        vehicleBodyStyle,
        coverageType,
        startDate,
        endDate,
        driverLicense,
        driverExperience,
        driverPhone,
        zeroDepSelected,
        roadsideSelected,
        engineSelected,
        isSubmitting,
        isSuccess,
        submissionError,
        submissionErrorToken,
        errors,
        personalAccidentSelected,
        status,
        searchType,
        mobileNumber,
        nationalId,
        agentMobileNumber,
        isUserExists,
        customerCreationStatus,
        customerCreationMessage,
        customerDetails,
        id,
        firstName,
        lastName,
        gender,
        dob,
        monthlyIncome,
        sourceFunds,
        employmentType,
        sector,
        employerName,
        businessNature,
        businessName,
        kycStatus,
        vehicleInfoStatus,
        code,
        originCountryFriendlyType,
        email,
        phNumber,
        pbNumber,
        addressLine,
        countryId,
        stateId,
        districtId,
        cityId,
        countryFriendlyType,
        stateFriendlyType,
        districtFriendlyType,
        cityFriendlyType,
        photoUrl,
        photoDocId,
        signatureUrl,
        signatureDocId,
        kycUserDocuments,
        submitKyc,
        updateKyc,
        signatureFile,
        fileDownloadStatus,
        bodyStyleList,
        vehicleMakeList,
        policyDurationList,
        vehicleData,
        riskCategoriesList,
        masterData,
        selectedPolicyFor,
        vehicleCreateEntity,
        planTypeList,
        selectedPlan,
        otpStatus,
        otpId,
        otp,
        otpPurpose,
        otpReferenceType,
        otpChannel,
        otpDestination,
        otpAttemptRemaining,
        otpRemainingSeconds,
        otpMessage,
        isOtpLocked,
        quotationDataList,
        quotationCompareStatus,
        selectedRiskCategory,
        selectedInsuranceQuotation,
        createQuotationResponse,
        createIndividualResponse,
        instantIssueStatus,
        downloadInvoiceStatus,
        printReceiptStatus,
        insuranceTransactionStatus,
        transactions,
        currentPage,
        totalPages,
        totalElements,
        hasReachedMax,
        errorMessage,
        search,
        fromDate,
        toDate,
        agentCode,
        vendorCode,
        expandedIndex,
        selectedPaymentMethod,
        selectedMobileProvider,
        phoneNumber,
        cardNumber,
        expiry,
        cvv,
        cardHolder,
        isProcessing,
        premiumAmount,
        convenienceFee,
        totalAmount,
        paymentSuccessEntity,
        issuePolicyByQuoteIdResponse,
        sumInsuredField,
        motorProductDetails,
        motorProductDetailsStatus,
        keyFactsDocumentStatus,
        keyFactsDocument,
        sendSmsStatus,
      ];

  // Existing method
  double get calculatedPremium {
    double base = coverageType == 'Comprehensive' ? 250.0 : 120.0;

    if (zeroDepSelected) base += 45.0;
    if (roadsideSelected) base += 15.0;
    if (engineSelected) base += 30.0;

    return base;
  }

// Add this below it
  double get totalPremium {
    double total = coverageType == 'Comprehensive' ? 18000 : 4200;

    if (personalAccidentSelected) {
      total += 800;
    }

    if (roadsideSelected) {
      total += 500;
    }

    if (engineSelected) {
      total += 500;
    }

    if (zeroDepSelected) {
      total += 1000;
    }

    return total;
  }
}
