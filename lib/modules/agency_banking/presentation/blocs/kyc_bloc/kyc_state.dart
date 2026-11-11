import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_dynamic_document_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_recent_history_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_user_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum KycUserStatus {
  initial,
  loading,
  loaded,
  notFound,
  error,
  loadedFromHistory
}

enum LocationStatus { initial, loading, success, failure }

enum SearchType { nationalId, mobileNumber }

enum FileDownloadStatus { initial, loading, success, failure }

enum OtpStatus {
  initial,
  sendingOtp,
  otpSent,
  resendingOtp,
  otpResent,
  verifyingOtp,
  otpVerified,
  otpInvalid,
  error
}

enum KycHistoryStatus { initial, loading, loaded, error }

class KycState extends Equatable {
  final KycUserStatus status;
  final LocationStatus locationStatus;
  final String? errorMessage;
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? nationalId;
  final String? gender;
  final String? mobileNumber;
  final String? agentMobileNumber;

  final DateTime? dob;

  //professional
  final String? empType;
  final String? employmentType;

  final String? monthlyIncome;
  final String? sourceFunds;
  final String? originCountryFriendlyType;

  //address
  final String? email;
  final String? addressLine;
  final String? phNumber;
  final int? countryId;
  final String? countryType;
  final String? countryFriendlyType;

  // professional
  final String? sector;
  final String? employerName;
  final String? businessNature;
  final String? businessName;

// communication
  final String? pbNumber;

  final int? stateId;
  final String? stateType;
  final String? stateFriendlyType;

  final int? cityId;
  final String? cityType;
  final String? cityFriendlyType;

  final int? districtId;
  final String? districtType;
  final String? districtFriendlyType;

  final String? kycStatus;
  final String? verificationStatus;
  final String? code;

  final List<LocationOption> originCountries;
  final List<LocationOption> countries;
  final List<LocationOption> states;
  final List<LocationOption> districts;
  final List<LocationOption> cities;
  final List<LocationOption> sectors;
  final LocationOption? selectedSector;
  final bool sectorLoading;

  final List<LocationOption> filteredStates;
  final List<LocationOption> filteredDistricts;
  final List<LocationOption> filteredCities;

  final LocationOption? selectedCountry;
  final LocationOption? selectedState;
  final LocationOption? selectedDistrict;
  final LocationOption? selectedCity;
  final LocationOption? selectedOriginCountry;

  final bool loading;
  final bool submitKyc;
  final bool updateKyc;
  final bool isSubmittingKyc;
  final bool isUpdatingKyc;

  final Document? photo;
  final List<int>? photoFile;
  final String? photoName;
  final String? photoUrl;
  final int? photoDocId;

  final Document? signature;
  final List<int>? signatureFile;
  final String? signatureName;
  final String? signatureUrl;
  final int? signatureDocId;

  //recent history
  final List<KycHistoryDetails>? kycHistoryList;
  final String selectedFilter;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<KycHistoryDetails>? filteredKycHistoryList;
  final String searchQuery;
  final KycHistoryStatus historyStatus;

  //dynamic document
  final List<KycDynamicDocument> dynamicDocuments;
  final List<Document> kycUserDocuments;
  final List<KycDynamicDocument> mergedDocuments;

  //download doc
  final FileDownloadStatus fileDownloadStatus;

  final SearchType searchType;
  final bool isUserExists;
  final bool navigateAfterUserCheck;

  // OTP
  final OtpStatus otpStatus;
  final String? otpId;
  final String? otp;
  final int? otpExpiryTime;
  final int otpTimer; // seconds left
  final int attemptRemaining;
  final bool canResend;
  final bool kycOtpVerified;
  final String? otpDisplayMessage;
  final bool isOtpLocked;
  final String? otpChannel;

  //connectivity
  final bool isConnected;

  const KycState({
    this.status = KycUserStatus.initial,
    this.locationStatus = LocationStatus.initial,
    this.errorMessage,
    this.id,
    this.firstName,
    this.lastName,
    this.nationalId,
    this.gender = "MALE",
    this.mobileNumber,
    this.employmentType = "Employed",
    this.dob,
    this.originCountryFriendlyType,
    this.empType,
    this.monthlyIncome,
    this.agentMobileNumber,
    this.sourceFunds,
    this.email,
    this.addressLine,
    this.phNumber,
    this.countryId,
    this.countryType,
    this.countryFriendlyType,
    this.sector,
    this.employerName,
    this.businessNature,
    this.businessName,
    this.pbNumber,
    this.stateId,
    this.stateType,
    this.stateFriendlyType,
    this.cityId,
    this.cityType,
    this.cityFriendlyType,
    this.districtId,
    this.districtType,
    this.districtFriendlyType,
    this.kycStatus,
    this.originCountries = const [],
    this.countries = const [],
    this.states = const [],
    this.districts = const [],
    this.cities = const [],
    this.filteredStates = const [],
    this.filteredDistricts = const [],
    this.filteredCities = const [],
    this.selectedCountry,
    this.selectedState,
    this.selectedDistrict,
    this.selectedCity,
    this.selectedOriginCountry,
    this.loading = false,
    this.submitKyc = false,
    this.updateKyc = false,
    this.isSubmittingKyc = false,
    this.isUpdatingKyc = false,
    this.sectors = const [],
    this.code,
    this.selectedSector,
    this.sectorLoading = false,
    this.kycHistoryList = const [],
    this.verificationStatus,
    this.photoFile,
    this.photoName,
    this.photoUrl,
    this.photoDocId,
    this.signatureFile,
    this.signatureName,
    this.signatureUrl,
    this.signatureDocId,
    this.photo,
    this.signature,
    this.selectedFilter = "RECENT",
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.fromDate,
    this.toDate,
    this.filteredKycHistoryList = const [],
    this.historyStatus = KycHistoryStatus.initial,
    this.searchQuery = "",
    this.dynamicDocuments = const [],
    this.kycUserDocuments = const [],
    this.mergedDocuments = const [],
    this.fileDownloadStatus = FileDownloadStatus.initial,
    this.searchType = SearchType.mobileNumber,
    this.isUserExists = false,
    this.navigateAfterUserCheck = false,
    this.otpStatus = OtpStatus.initial,
    this.otpId,
    this.otp,
    this.otpExpiryTime,
    this.otpTimer = 0,
    this.attemptRemaining = 0,
    this.canResend = false,
    this.kycOtpVerified = false,
    this.otpDisplayMessage,
    this.isOtpLocked = false,
    this.otpChannel,
    this.isConnected = true,
  });

  KycState copyWith(
      {KycUserStatus? status,
      LocationStatus? locationStatus,
      ValueGetter<String?>? errorMessage,
      int? id,
      String? firstName,
      String? lastName,
      String? nationalId,
      String? gender,
      String? nationality,
      String? employmentType,
      String? mobileNumber,
      String? agentMobileNumber,
      ValueGetter<DateTime?>? dob,

      //professional
      String? empType,
      String? monthlyIncome,
      String? sourceFunds,
      String? originCountryId,
      String? originCountryType,
      ValueGetter<String?>? originCountryFriendlyType,

      //address
      String? email,
      String? addressLine,
      String? phNumber,
      int? countryId,
      String? countryType,
      ValueGetter<String?>? countryFriendlyType,
      ValueGetter<String?>? sector,
      String? employerName,
      String? businessNature,
      String? businessName,
      String? pbNumber,
      int? stateId,
      String? stateType,
      ValueGetter<String?>? stateFriendlyType,
      int? cityId,
      String? cityType,
      ValueGetter<String?>? cityFriendlyType,
      int? districtId,
      String? districtType,
      ValueGetter<String?>? districtFriendlyType,
      String? kycStatus,
      String? verificationStatus,
      List<LocationOption>? originCountries,
      List<LocationOption>? countries,
      List<LocationOption>? states,
      List<LocationOption>? districts,
      List<LocationOption>? cities,
      List<LocationOption>? filteredStates,
      List<LocationOption>? filteredDistricts,
      List<LocationOption>? filteredCities,
      ValueGetter<LocationOption?>? selectedCountry,
      ValueGetter<LocationOption?>? selectedState,
      ValueGetter<LocationOption?>? selectedDistrict,
      ValueGetter<LocationOption?>? selectedCity,
      ValueGetter<LocationOption?>? selectedOriginCountry,
      bool? loading,
      bool? submitKyc,
      bool? updateKyc,
      bool? isSubmittingKyc,
      bool? isUpdatingKyc,
      List<LocationOption>? sectors,
      ValueGetter<LocationOption?>? selectedSector,
      bool? sectorLoading,
      String? code,
      List<KycHistoryDetails>? kycHistoryList,
      ValueGetter<List<int>?>? photoFile,
      ValueGetter<String?>? photoName,
      ValueGetter<String?>? photoUrl,
      ValueGetter<int?>? photoDocId,
      ValueGetter<List<int>?>? signatureFile,
      ValueGetter<String?>? signatureName,
      ValueGetter<String?>? signatureUrl,
      ValueGetter<int?>? signatureDocId,
      Document? photo,
      Document? signature,
      String? selectedFilter,
      int? currentPage,
      int? totalPages,
      bool? isLoadingMore,
      DateTime? fromDate,
      DateTime? toDate,
      List<KycHistoryDetails>? filteredKycHistoryList,
      KycHistoryStatus? historyStatus,
      String? searchQuery,
      List<KycDynamicDocument>? dynamicDocuments,
      List<Document>? kycUserDocuments,
      List<KycDynamicDocument>? mergedDocuments,
      FileDownloadStatus? fileDownloadStatus,
      SearchType? searchType,
      bool? isUserExists,
      bool? navigateAfterUserCheck,
      OtpStatus? otpStatus,
      String? otpId,
      String? otp,
      int? otpExpiryTime,
      int? otpTimer,
      int? attemptRemaining,
      bool? canResend,
      bool? kycOtpVerified,
      String? otpDisplayMessage,
      bool? isOtpLocked,
      String? otpChannel,
       bool? isConnected}) {
    return KycState(
        status: status ?? this.status,
        locationStatus: locationStatus ?? this.locationStatus,
        errorMessage:
            (errorMessage != null) ? errorMessage() : this.errorMessage,
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        nationalId: nationalId ?? this.nationalId,
        gender: gender ?? this.gender,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        agentMobileNumber: agentMobileNumber ?? this.agentMobileNumber,
        employmentType: employmentType ?? this.employmentType,
        dob: (dob != null) ? dob() : this.dob,
        originCountryFriendlyType: (originCountryFriendlyType != null)
            ? originCountryFriendlyType()
            : this.originCountryFriendlyType,
        empType: empType ?? this.empType,
        monthlyIncome: monthlyIncome ?? this.monthlyIncome,
        sourceFunds: sourceFunds ?? this.sourceFunds,
        email: email ?? this.email,
        addressLine: addressLine ?? this.addressLine,
        phNumber: phNumber ?? this.phNumber,
        countryId: countryId ?? this.countryId,
        countryType: countryType ?? this.countryType,
        countryFriendlyType: (countryFriendlyType != null)
            ? countryFriendlyType()
            : this.countryFriendlyType,
        sector: (sector != null) ? sector() : this.sector,
        employerName: employerName ?? this.employerName,
        businessNature: businessNature ?? this.businessNature,
        businessName: businessName ?? this.businessName,
        pbNumber: pbNumber ?? this.pbNumber,
        stateId: stateId ?? this.stateId,
        stateType: stateType ?? this.stateType,
        stateFriendlyType: (stateFriendlyType != null)
            ? stateFriendlyType()
            : this.stateFriendlyType,
        cityId: cityId ?? this.cityId,
        cityType: cityType ?? this.cityType,
        cityFriendlyType: (cityFriendlyType != null)
            ? cityFriendlyType()
            : this.cityFriendlyType,
        districtId: districtId ?? this.districtId,
        districtType: districtType ?? this.districtType,
        districtFriendlyType: (districtFriendlyType != null)
            ? districtFriendlyType()
            : this.districtFriendlyType,
        kycStatus: kycStatus ?? this.kycStatus,
        verificationStatus: verificationStatus ?? this.verificationStatus,
        originCountries: originCountries ?? this.originCountries,
        countries: countries ?? this.countries,
        states: states ?? this.states,
        districts: districts ?? this.districts,
        cities: cities ?? this.cities,
        filteredStates: filteredStates ?? this.filteredStates,
        filteredDistricts: filteredDistricts ?? this.filteredDistricts,
        filteredCities: filteredCities ?? this.filteredCities,
        selectedCountry: (selectedCountry != null)
            ? selectedCountry()
            : this.selectedCountry,
        selectedState:
            (selectedState != null) ? selectedState() : this.selectedState,
        selectedDistrict: (selectedDistrict != null)
            ? selectedDistrict()
            : this.selectedDistrict,
        selectedCity:
            (selectedCity != null) ? selectedCity() : this.selectedCity,
        selectedOriginCountry: (selectedOriginCountry != null)
            ? selectedOriginCountry()
            : this.selectedOriginCountry,
        loading: loading ?? this.loading,
        submitKyc: submitKyc ?? this.submitKyc,
        updateKyc: updateKyc ?? this.updateKyc,
        isSubmittingKyc: isSubmittingKyc ?? this.isSubmittingKyc,
        isUpdatingKyc: isUpdatingKyc ?? this.isUpdatingKyc,
        sectors: sectors ?? this.sectors,
        selectedSector:
            (selectedSector != null) ? selectedSector() : this.selectedSector,
        sectorLoading: sectorLoading ?? this.sectorLoading,
        code: code ?? this.code,
        kycHistoryList: kycHistoryList ?? this.kycHistoryList,
        selectedFilter: selectedFilter ?? this.selectedFilter,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        photoFile: (photoFile != null) ? photoFile() : this.photoFile,
        photoName: (photoName != null) ? photoName() : this.photoName,
        photoUrl: (photoUrl != null) ? photoUrl() : this.photoUrl,
        photo: photo ?? this.photo,
        photoDocId: (photoDocId != null) ? photoDocId() : this.photoDocId,
        signatureFile:
            (signatureFile != null) ? signatureFile() : this.signatureFile,
        signatureName:
            (signatureName != null) ? signatureName() : this.signatureName,
        signatureUrl:
            (signatureUrl != null) ? signatureUrl() : this.signatureUrl,
        signature: signature ?? this.signature,
        signatureDocId:
            (signatureDocId != null) ? signatureDocId() : this.signatureDocId,
        filteredKycHistoryList:
            filteredKycHistoryList ?? this.filteredKycHistoryList,
        historyStatus: historyStatus ?? this.historyStatus,
        searchQuery: searchQuery ?? this.searchQuery,
        dynamicDocuments: dynamicDocuments ?? this.dynamicDocuments,
        kycUserDocuments: kycUserDocuments ?? this.kycUserDocuments,
        mergedDocuments: mergedDocuments ?? this.mergedDocuments,
        fileDownloadStatus: fileDownloadStatus ?? this.fileDownloadStatus,
        searchType: searchType ?? this.searchType,
        isUserExists: isUserExists ?? this.isUserExists,
        navigateAfterUserCheck:
            navigateAfterUserCheck ?? this.navigateAfterUserCheck,
        otpStatus: otpStatus ?? this.otpStatus,
        otpId: otpId ?? this.otpId,
        otp: otp ?? this.otp,
        otpExpiryTime: otpExpiryTime ?? this.otpExpiryTime,
        otpTimer: otpTimer ?? this.otpTimer,
        attemptRemaining: attemptRemaining ?? this.attemptRemaining,
        canResend: canResend ?? this.canResend,
        kycOtpVerified: kycOtpVerified ?? this.kycOtpVerified,
        otpDisplayMessage: otpDisplayMessage ?? this.otpDisplayMessage,
        isOtpLocked: isOtpLocked ?? this.isOtpLocked,
        otpChannel: otpChannel ?? this.otpChannel,
        isConnected: isConnected ?? this.isConnected,);
  }

  @override
  List<Object?> get props => [
        status,
        locationStatus,
        errorMessage,
        id,
        firstName,
        lastName,
        nationalId,
        gender,
        mobileNumber,
        employmentType,
        dob,
        originCountryFriendlyType,
        empType,
        monthlyIncome,
        sourceFunds,
        email,
        addressLine,
        phNumber,
        countryId,
        countryType,
        countryFriendlyType,
        sector,
        employerName,
        businessNature,
        businessName,
        pbNumber,
        stateId,
        stateType,
        stateFriendlyType,
        cityId,
        cityType,
        cityFriendlyType,
        districtId,
        districtType,
        districtFriendlyType,
        countries,
        states,
        cities,
        districts,
        filteredStates,
        filteredDistricts,
        filteredCities,
        selectedCountry,
        selectedState,
        selectedDistrict,
        selectedCity,
        loading,
        kycStatus,
        submitKyc,
        isSubmittingKyc,
        isUpdatingKyc,
        sectors,
        selectedSector,
        sectorLoading,
        updateKyc,
        agentMobileNumber,
        code,
        kycHistoryList,
        selectedOriginCountry,
        originCountries,
        verificationStatus,
        photoFile,
        photoName,
        signatureFile,
        signatureName,
        photo,
        signature,
        selectedFilter,
        currentPage,
        totalPages,
        isLoadingMore,
        fromDate,
        toDate,
        filteredKycHistoryList,
        historyStatus,
        searchQuery,
        dynamicDocuments,
        kycUserDocuments,
        mergedDocuments,
        fileDownloadStatus,
        searchType,
        isUserExists,
        navigateAfterUserCheck,
        otpStatus,
        otpId,
        otp,
        otpExpiryTime,
        otpTimer,
        attemptRemaining,
        canResend,
        kycOtpVerified,
        otpDisplayMessage,
        isOtpLocked,
        otpChannel,
        isConnected
      ];
}
