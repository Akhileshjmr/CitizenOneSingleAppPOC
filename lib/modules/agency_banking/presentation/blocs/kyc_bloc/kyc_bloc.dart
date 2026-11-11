import 'dart:async';
import 'dart:convert';

import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_dynamic_document_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_recent_history_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/kyc_user_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/models/kyc/location_response_model.dart';
import 'package:citizenone_app/modules/agency_banking/data/services/AuthService.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/modules/agency_banking/presentation/blocs/kyc_bloc/kyc_state.dart';
import 'package:citizenone_app/modules/agency_banking/utils/SecureStorageHelper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final AuthService authService;

  KycBloc(this.authService) : super(const KycState()) {
    on<SearchUserEvent>(_searchUser);
    on<FetchSearchUserEvent>(_fetchUserDetails);
    on<CheckUserExistsEvent>(_checkUserExists);
    on<FetchRecentHistory>(_fetchRecentHistory);
    on<LocalSearchKycHistory>(_localSearchKycHistory);
    on<SelectGender>(_selectGender);
    on<SelectDob>(_selectDob);
    on<SelectSectorEvent>(_selectSector);
    on<SelectEmploymentType>(_selectEmploymentType);
    on<UpdatePersonalInfoEvent>(_updatePersonalInfoForm);
    on<UpdateProfessionalInfoEvent>(_updateProfessionalInfoForm);
    on<UpdateAddressInfoEvent>(_updateAddressInfoForm);
    on<LoadLocationsEvent>(_loadLocations);
    on<SelectCountryEvent>(_selectCountry);
    on<SelectOriginCountryEvent>(_selectOriginCountry);
    on<SelectStateEvent>(_selectState);
    on<SelectCityEvent>(_selectCity);
    on<SelectDistrictEvent>(_selectDistrict);
    on<SubmitKycEvent>(_submitKycEvent);
    on<UpdateKycEvent>(_updateKycData);
    on<DownloadDocument>(_downloadDocument);
    on<ResetFormData>(_resetFormData);
    on<PickPhotoEvent>(_pickPhotoEvent);
    on<PickSignatureEvent>(_pickSignatureEvent);
    on<PickDynamicDocumentEvent>(_pickDynamicDocumentFile);
    on<UpdateDynamicDocIssueDate>(_updateDynamicDocIssueDate);
    on<UpdateDynamicDocExpiryDate>(_updateDynamicDocExpiryDate);
    on<EditDynamicDocumentEvent>(_editDynamicDocumentFile);
    on<EditDynamicDocIssueDate>(_editDynamicDocIssueDate);
    on<EditDynamicDocExpiryDate>(_editDynamicDocExpiryDate);
    on<MergeDocumentsEvent>(_mergeDocuments);
    on<PickMergedDocumentEvent>(_pickMergedDoc);
    on<UpdateMergedDocIssueDate>(_updateMergedDocIssueDate);
    on<UpdateMergedDocExpiryDate>(_updateMergedDocExpiryDate);
    on<ClearErrorEvent>(_clearError);
    on<SendOtpEvent>(_sendOtp);
    on<VerifyOtpEvent>(_verifyOtp);
    on<ResendOtpEvent>(_resendOtp);
    on<StartOtpTimer>(_startTimer);
    on<ResetOtpStateEvent>(_resetOtpState);
  }

  Future<void> _pickPhotoEvent(
    PickPhotoEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(
      photoFile: () => event.fileData,
      photoName: () => event.name,
    ));
  }

  Future<void> _pickSignatureEvent(
    PickSignatureEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(
      signatureFile: () => event.fileData,
      signatureName: () => event.name,
    ));
  }

  Future<void> _searchUser(
    SearchUserEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(status: KycUserStatus.initial));
    emit(state.copyWith(status: KycUserStatus.loading));
    if (event.mobileNumber.isNotEmpty) {
      emit(state.copyWith(
          searchType: SearchType.mobileNumber,
          mobileNumber: event.mobileNumber,
          nationalId: ""));
    } else if (event.nationalId.isNotEmpty) {
      emit(state.copyWith(
          searchType: SearchType.nationalId,
          mobileNumber: "",
          nationalId: event.nationalId));
    }

    final agentMobile = await getAgentMobile();

    emit(state.copyWith(
      agentMobileNumber: agentMobile,
      isUserExists: false,
    ));
    Map<String, dynamic> reqObj = {
      "mobile": event.mobileNumber.trim(),
      "nationalId": event.nationalId.trim()
    };

    final result = await authService.fetchKycUser(reqObj);
    if (result['status'] == true) {
      emit(state.copyWith(
        status: (event.fromHistory)
            ? KycUserStatus.loadedFromHistory
            : KycUserStatus.loaded,
        signature: result["data"].kycDetails.signature,
        photo: result["data"].kycDetails.photo,
        updateKyc: false,
        submitKyc: false,
        id: result["data"].kycDetails.id,
        firstName: result["data"].kycDetails.firstName,
        lastName: result["data"].kycDetails.lastName,
        gender: result["data"].kycDetails.gender,
        dob: () => DateTime.parse(result["data"].kycDetails.dob),
        monthlyIncome: result["data"]
            .kycDetails
            .monthlyIncome
            ?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.?0+$'), ''),
        sourceFunds: result["data"].kycDetails.sourceFunds,
        mobileNumber: result["data"].kycDetails.mobileNumber,
        nationalId: result["data"].kycDetails.nationalId,
        employmentType: result["data"].kycDetails.empType,
        sector: () => result["data"].kycDetails.sector,
        employerName: result["data"].kycDetails.employerName,
        businessNature: result["data"].kycDetails.businessNature,
        businessName: result["data"].kycDetails.businessName,
        kycStatus: result["data"].kycDetails.kycStatus,
        email: result["data"].kycDetails.communication!.email,
        phNumber: result["data"].kycDetails.communication!.phNumber,
        pbNumber: result["data"].kycDetails.communication!.pbNumber,
        addressLine: result["data"].kycDetails.communication!.addressLine,
        countryId: result["data"].kycDetails.communication!.country!.id,
        stateId: result["data"].kycDetails.communication!.state!.id,
        districtId: result["data"].kycDetails.communication!.district!.id,
        cityId: result["data"].kycDetails.communication!.city!.id,
        code: result["data"].kycDetails.code,
        originCountryFriendlyType: () =>
            result["data"].kycDetails.originCountry!.friendlyType,
        countryFriendlyType: () =>
            result["data"].kycDetails.communication!.country!.friendlyType,
        stateFriendlyType: () =>
            result["data"].kycDetails.communication!.state!.friendlyType,
        districtFriendlyType: () =>
            result["data"].kycDetails.communication!.district!.friendlyType,
        cityFriendlyType: () =>
            result["data"].kycDetails.communication!.city!.friendlyType,
        photoUrl: () => (result["data"].kycDetails.photo != null)
            ? result["data"].kycDetails.photo!.docUrl
            : null,
        photoDocId: () => (result["data"].kycDetails.photo != null)
            ? result["data"].kycDetails.photo!.docId
            : null,
        signatureUrl: () => (result["data"].kycDetails.signature != null)
            ? result["data"].kycDetails.signature!.docUrl
            : null,
        signatureDocId: () => (result["data"].kycDetails.signature != null)
            ? result["data"].kycDetails.signature!.docId
            : null,
        kycUserDocuments: result["data"].kycDetails.documents ?? [],
      ));
      emit(state.copyWith(status: KycUserStatus.initial));
    } else if (result['status'] == false) {
      emit(state.copyWith(status: KycUserStatus.notFound));
      emit(state.copyWith(status: KycUserStatus.initial));
    } else if (result['status'] == null) {
      emit(state.copyWith(status: KycUserStatus.error));
      emit(state.copyWith(status: KycUserStatus.initial));
    }
  }

  Future<void> _fetchUserDetails(
    FetchSearchUserEvent event,
    Emitter<KycState> emit,
  ) async {
    Map<String, dynamic> reqObj = {
      "mobile": event.mobileNumber.trim(),
      "nationalId": event.nationalId.trim()
    };

    final result = await authService.fetchKycUser(reqObj);
    if (result['status'] == true) {
      emit(state.copyWith(
        signature: result["data"].kycDetails.signature,
        photo: result["data"].kycDetails.photo,
        updateKyc: false,
        submitKyc: false,
        id: result["data"].kycDetails.id,
        firstName: result["data"].kycDetails.firstName,
        lastName: result["data"].kycDetails.lastName,
        gender: result["data"].kycDetails.gender,
        dob: () => DateTime.parse(result["data"].kycDetails.dob),
        monthlyIncome: result["data"]
            .kycDetails
            .monthlyIncome
            ?.toStringAsFixed(2)
            .replaceAll(RegExp(r'\.?0+$'), ''),
        sourceFunds: result["data"].kycDetails.sourceFunds,
        mobileNumber: result["data"].kycDetails.mobileNumber,
        nationalId: result["data"].kycDetails.nationalId,
        employmentType: result["data"].kycDetails.empType,
        sector: () => result["data"].kycDetails.sector,
        employerName: result["data"].kycDetails.employerName,
        businessNature: result["data"].kycDetails.businessNature,
        businessName: result["data"].kycDetails.businessName,
        kycStatus: result["data"].kycDetails.kycStatus,
        email: result["data"].kycDetails.communication!.email,
        phNumber: result["data"].kycDetails.communication!.phNumber,
        pbNumber: result["data"].kycDetails.communication!.pbNumber,
        addressLine: result["data"].kycDetails.communication!.addressLine,
        countryId: result["data"].kycDetails.communication!.country!.id,
        stateId: result["data"].kycDetails.communication!.state!.id,
        districtId: result["data"].kycDetails.communication!.district!.id,
        cityId: result["data"].kycDetails.communication!.city!.id,
        code: result["data"].kycDetails.code,
        originCountryFriendlyType: () =>
            result["data"].kycDetails.originCountry!.friendlyType,
        countryFriendlyType: () =>
            result["data"].kycDetails.communication!.country!.friendlyType,
        stateFriendlyType: () =>
            result["data"].kycDetails.communication!.state!.friendlyType,
        districtFriendlyType: () =>
            result["data"].kycDetails.communication!.district!.friendlyType,
        cityFriendlyType: () =>
            result["data"].kycDetails.communication!.city!.friendlyType,
        photoUrl: () => (result["data"].kycDetails.photo != null)
            ? result["data"].kycDetails.photo!.docUrl
            : null,
        photoDocId: () => (result["data"].kycDetails.photo != null)
            ? result["data"].kycDetails.photo!.docId
            : null,
        signatureUrl: () => (result["data"].kycDetails.signature != null)
            ? result["data"].kycDetails.signature!.docUrl
            : null,
        signatureDocId: () => (result["data"].kycDetails.signature != null)
            ? result["data"].kycDetails.signature!.docId
            : null,
        kycUserDocuments: result["data"].kycDetails.documents ?? [],
      ));
      emit(state.copyWith(status: KycUserStatus.initial));
    } else if (result['status'] == false) {
      emit(state.copyWith(status: KycUserStatus.notFound));
      emit(state.copyWith(status: KycUserStatus.initial));
    }
  }

  Future<void> _checkUserExists(
    CheckUserExistsEvent event,
    Emitter<KycState> emit,
  ) async {
    Map<String, dynamic> reqObj = {
      "mobile": event.mobileNumber.trim(),
      "nationalId": event.nationalId
    };

    final result = await authService.fetchKycUser(reqObj);
    if (result['status'] == true) {
      emit(state.copyWith(isUserExists: true, navigateAfterUserCheck: false));
    } else if (result['status'] == false) {
      emit(state.copyWith(isUserExists: false, navigateAfterUserCheck: true));
    }
    emit(state.copyWith(navigateAfterUserCheck: false, isUserExists: false));
  }

  Future<void> _fetchRecentHistory(
    FetchRecentHistory event,
    Emitter<KycState> emit,
  ) async {
    final agentMobile = await getAgentMobile();

    if (agentMobile.trim().isNotEmpty) {
      emit(state.copyWith(agentMobileNumber: agentMobile));
    }

    if (event.filter == "CUSTOM" &&
        (event.fromDate == null || event.toDate == null)) {
      emit(state.copyWith(
        selectedFilter: event.filter,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ));
      return;
    }

    if (event.page == 1) {
      emit(state.copyWith(
        historyStatus: KycHistoryStatus.loading,
        kycHistoryList: [],
        filteredKycHistoryList: [],
        selectedFilter: event.filter,
        currentPage: 1,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    Map<String, dynamic> reqObj = {
      "filterVal": event.filter,
      "addiParams": event.filter == "CUSTOM"
          ? [
              DateFormat("yyyy-MM-dd").format(event.fromDate!),
              DateFormat("yyyy-MM-dd").format(event.toDate!)
            ]
          : [],
      "source": {"type": "AGENT", "friendlyType": state.agentMobileNumber},
      "paging": {"pageNum": event.page, "recsPerPage": "10"}
    };
    try {
      final result = await authService.fetchRecentHistory(reqObj);

      if (result != null) {
        final newList = result.kycDetailsList!
            .map((data) => KycHistoryDetails(
                id: data.id,
                firstName: data.firstName,
                lastName: data.lastName,
                kycStatus: data.status,
                code: data.code,
                createdDate: data.createdDate,
                mobileNumber: data.mobileNumber,
                nationalId: data.nationalId))
            .toList();

        final updatedList =
            event.page == 1 ? newList : [...state.kycHistoryList!, ...newList];

        emit(state.copyWith(
          historyStatus: KycHistoryStatus.loaded,
          kycHistoryList: updatedList,
          filteredKycHistoryList: updatedList,
          currentPage: result.paging?.pageNum ?? 1,
          totalPages: result.paging?.totalPages ?? 1,
          isLoadingMore: false,
        ));
      } else {
        emit(state.copyWith(
            historyStatus: KycHistoryStatus.loaded,
            kycHistoryList: [],
            filteredKycHistoryList: []));
      }
    } catch (e) {
      emit(state.copyWith(
          historyStatus: KycHistoryStatus.error,
          kycHistoryList: [],
          filteredKycHistoryList: []));
    }
  }

  Future<void> _localSearchKycHistory(
    LocalSearchKycHistory event,
    Emitter<KycState> emit,
  ) async {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(
        searchQuery: "",
        filteredKycHistoryList: state.kycHistoryList,
      ));
      return;
    }

    final filtered = state.kycHistoryList!.where((item) {
      final fullName =
          "${item.firstName ?? ""} ${item.lastName ?? ""}".toLowerCase();

      final mobile = (item.mobileNumber ?? "").toLowerCase();
      final nationalId = (item.nationalId ?? "").toLowerCase();

      return fullName.contains(query) ||
          mobile.contains(query) ||
          nationalId.contains(query);
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredKycHistoryList: filtered,
    ));
  }

  Future<void> _selectGender(
    SelectGender event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(gender: event.gender!));
  }

  Future<void> _selectDob(
    SelectDob event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(dob: () => event.dob));
  }

  Future<void> _selectEmploymentType(
    SelectEmploymentType event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(employmentType: event.employmentType!));
  }

  Future<void> _updatePersonalInfoForm(
      UpdatePersonalInfoEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(
      firstName: event.firstName,
      lastName: event.lastName,
      nationalId: event.nationalId,
      mobileNumber: event.mobileNumber,
    ));
  }

  Future<void> _updateProfessionalInfoForm(
      UpdateProfessionalInfoEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(
      monthlyIncome: event.monthlyIncome,
      sourceFunds: event.sourceFunds,
      employerName: event.employerName,
      businessNature: event.natureOfBusiness,
      businessName: event.businessName,
    ));
  }

  Future<void> _updateAddressInfoForm(
      UpdateAddressInfoEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(
        email: event.email,
        addressLine: event.addressLine,
        phNumber: event.phNumber,
        pbNumber: event.pbNumber));
  }

  Future<void> _loadLocations(
      LoadLocationsEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(
      loading: true,
    ));

    final response = await authService.fetchLocation();

    List<LocationOption> countries = [];
    List<LocationOption> originCountries = [];
    List<LocationOption> states = [];
    List<LocationOption> districts = [];
    List<LocationOption> cities = [];
    List<LocationOption> sectors = [];
    List<KycDynamicDocument> dynamicDocs = [];

    for (var group in response["selectOptionList"]) {
      switch (group["key"]) {
        case "COUNTRIES":
          countries = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          originCountries = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          break;

        case "STATES":
          states = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          break;

        case "DISTRICT":
          districts = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          break;

        case "CITIES":
          cities = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          break;
        case "SECTOR":
          sectors = (group["options"] as List)
              .map((e) => LocationOption.fromJson(e))
              .toList();
          break;
        case "KYC DOCUMENTS":
          dynamicDocs = (group["options"] as List)
              .map((e) => KycDynamicDocument.fromJson(e))
              .toList();
          break;
      }
    }
    LocationOption? selectedOriginCountry;

    if (state.originCountryFriendlyType != null) {
      selectedOriginCountry = originCountries.firstWhere(
        (c) => c.name == state.originCountryFriendlyType,
        orElse: () => originCountries.first,
      );
    }

    LocationOption? selectedCountry;

    if (state.countryFriendlyType != null) {
      selectedCountry = countries.firstWhere(
        (c) => c.name == state.countryFriendlyType,
        orElse: () => countries.first,
      );
    }

    LocationOption? selectedState;

    if (state.stateFriendlyType != null) {
      selectedState = states.firstWhere(
        (s) => s.name == state.stateFriendlyType,
        orElse: () => states.first,
      );
    }
    LocationOption? selectedDistrict;

    if (state.districtFriendlyType != null) {
      selectedDistrict = districts.firstWhere(
        (d) => d.name == state.districtFriendlyType,
        orElse: () => districts.first,
      );
    }
    LocationOption? selectedCity;

    if (state.cityFriendlyType != null) {
      selectedCity = cities.firstWhere(
        (c) => c.name == state.cityFriendlyType,
        orElse: () => cities.first,
      );
    }
    LocationOption? selectedSector;

    if (state.sector != null) {
      selectedSector = sectors.firstWhere(
        (c) => c.name == state.sector,
        orElse: () => sectors.first,
      );
    }
    List<LocationOption> filteredStates = selectedCountry != null
        ? states.where((s) => s.parentId == selectedCountry!.id).toList()
        : [];

    List<LocationOption> filteredDistricts = selectedState != null
        ? districts.where((d) => d.parentId == selectedState!.id).toList()
        : [];

    List<LocationOption> filteredCities = selectedDistrict != null
        ? cities.where((c) => c.parentId == selectedDistrict!.id).toList()
        : [];

    emit(state.copyWith(
      countries: countries,
      originCountries: originCountries,
      selectedOriginCountry: () => selectedOriginCountry,
      selectedCountry: () => selectedCountry,
      states: states,
      selectedState: () => selectedState,
      districts: districts,
      selectedDistrict: () => selectedDistrict,
      cities: cities,
      selectedCity: () => selectedCity,
      sectors: sectors,
      selectedSector: () => selectedSector,
      dynamicDocuments: dynamicDocs,
      loading: false,
      filteredStates: filteredStates,
      filteredDistricts: filteredDistricts,
      filteredCities: filteredCities,
    ));
    add(const MergeDocumentsEvent());
  }

  void _selectOriginCountry(
      SelectOriginCountryEvent event, Emitter<KycState> emit) {
    emit(state.copyWith(
      selectedOriginCountry: () => event.country,
    ));
  }

  void _selectCountry(SelectCountryEvent event, Emitter<KycState> emit) {
    final filteredStates =
        state.states.where((s) => s.parentId == event.country.id).toList();

    emit(state.copyWith(
      selectedCountry: () => event.country,
      filteredStates: filteredStates,
      filteredDistricts: [],
      filteredCities: [],
      selectedState: () => null,
      selectedDistrict: () => null,
      selectedCity: () => null,
    ));
  }

  void _selectState(SelectStateEvent event, Emitter<KycState> emit) {
    final stateDistrictIds = state.districts
        .where((d) => d.parentId == event.state.id)
        .map((d) => d.id)
        .toList();

    final filteredCities = state.cities
        .where((c) => stateDistrictIds.contains(c.parentId))
        .toList();
    final filteredDistricts =
        state.districts.where((d) => d.parentId == event.state.id).toList();

    emit(state.copyWith(
      selectedState: () => event.state,
      filteredCities: filteredCities,
      filteredDistricts: filteredDistricts,
      selectedCity: () => null,
    ));
  }

  void _selectDistrict(
    SelectDistrictEvent event,
    Emitter<KycState> emit,
  ) {
    final filteredCities =
        state.cities.where((c) => c.parentId == event.district.id).toList();

    emit(state.copyWith(
      selectedDistrict: () => event.district,
      filteredCities: filteredCities,
      selectedCity: () => null,
    ));
  }

  void _selectCity(SelectCityEvent event, Emitter<KycState> emit) {
    emit(state.copyWith(selectedCity: () => event.city));
  }

  Future<void> _submitKycEvent(
    SubmitKycEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(
        isSubmittingKyc: true,
        submitKyc: false,
        errorMessage: () => null,
        firstName: state.firstName,
        lastName: state.lastName,
        nationalId: state.nationalId,
        mobileNumber: state.mobileNumber,
        monthlyIncome: state.monthlyIncome,
        sourceFunds: state.sourceFunds,
        employerName: state.employerName,
        businessNature: state.businessNature,
        businessName: state.businessName,
        email: state.email,
        addressLine: state.addressLine,
        phNumber: state.phNumber,
        pbNumber: state.pbNumber));
    try {
      final request = {
        "addiParams": ["CREATE"],
        "source": {"type": "AGENT", "friendlyType": state.agentMobileNumber},
        "kycDetails": {
          "firstName": state.firstName,
          "lastName": state.lastName,
          "gender": state.gender?.toUpperCase(),
          "dob": state.dob?.toIso8601String().split("T").first,
          "monthlyIncome":
              double.tryParse(state.monthlyIncome.toString()) ?? "0.0",
          "sourceFunds": state.sourceFunds,
          "mobileNumber": state.mobileNumber,
          "nationalId": state.nationalId,
          "empType": (state.employmentType == "Employed")
              ? "EMPLOYED"
              : "SELF_EMPLOYMENT",
          "sector": state.selectedSector!.name,
          "employerName": state.employerName,
          "businessNature": state.businessNature,
          "businessName": state.businessName,
          "signature": {
            "file": state.signatureFile!,
            "docName": "Signature",
            "fileName":
                "signature ${DateTime.now().millisecondsSinceEpoch}.${state.signatureName!.split('.').last}"
          },
          "photo": {
            "file": state.photoFile!,
            "docName": "Photo",
            "fileName":
                "photo ${DateTime.now().millisecondsSinceEpoch}.${state.photoName!.split('.').last}",
          },
          "originCountry": {
            "id": state.selectedOriginCountry!.id,
            "type": state.selectedOriginCountry!.name,
            "friendlyType": state.selectedOriginCountry!.name
          },
          "communication": {
            "email": state.email,
            "addressLine": state.addressLine,
            "phNumber": state.phNumber,
            "pbNumber": state.pbNumber ?? "",
            "country": {
              "id": state.selectedCountry!.id,
              "type": state.selectedCountry!.name,
              "friendlyType": state.selectedCountry!.name
            },
            "state": {
              "id": state.selectedState!.id,
              "type": state.selectedState!.name,
              "friendlyType": state.selectedState!.name
            },
            "district": {
              "id": state.selectedDistrict!.id,
              "type": state.selectedDistrict!.name,
              "friendlyType": state.selectedDistrict!.name
            },
            "city": {
              "id": state.selectedCity?.id ?? '',
              "type": state.selectedCity?.name ?? '',
              "friendlyType": state.selectedCity?.name ?? ''
            }
          },
          "documents": _mapSubmitDynamicDocuments(state.dynamicDocuments)
        }
      };

      final result = await authService.submitKyc(request);

      if (result != null) {
        if (result.chMessage.code == 'SUCCESS') {
          emit(state.copyWith(
              isSubmittingKyc: false,
              submitKyc: true,
              code: result.addiParams[1] ?? ""));
          emit(state.copyWith(submitKyc: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
          isSubmittingKyc: false,
          submitKyc: false));
    }
  }

  List<Map<String, dynamic>> _mapSubmitDynamicDocuments(
    List<KycDynamicDocument>? docs,
  ) {
    if (docs == null || docs.isEmpty) return [];

    return docs.where((doc) => doc.file != null).map((doc) {
      final map = <String, dynamic>{
        "file": doc.file,
        "docName": doc.name,
        "fileName":
            "${doc.name.replaceAll(" ", "")} ${DateTime.now().millisecondsSinceEpoch}.${doc.fileName.toString().split(".").last}",
      };

      if (doc.showDates) {
        if (doc.issueDate != null) {
          map["issuingDate"] =
              doc.issueDate!.toIso8601String().split("T").first;
        }
        if (doc.expiryDate != null) {
          map["expiryDate"] =
              doc.expiryDate!.toIso8601String().split("T").first;
        }
      }

      return map;
    }).toList();
  }

  Future<void> _updateKycData(
    UpdateKycEvent event,
    Emitter<KycState> emit,
  ) async {
    try {
      emit(state.copyWith(
          isUpdatingKyc: true,
          updateKyc: false,
          errorMessage: () => null,
          firstName: event.firstName,
          lastName: event.lastName,
          nationalId: event.nationalId,
          mobileNumber: event.mobileNumber,
          monthlyIncome: event.monthlyIncome,
          sourceFunds: event.sourceFunds,
          employerName: event.employerName,
          businessNature: event.natureOfBusiness,
          businessName: event.businessName,
          email: event.email,
          addressLine: event.addressLine,
          phNumber: event.phNumber,
          pbNumber: event.pbNumber));

      final req = {
        "addiParams": ["UPDATE"],
        "source": {"type": "AGENT", "friendlyType": state.agentMobileNumber},
        "kycDetails": {
          "id": state.id,
          "firstName": state.firstName,
          "lastName": state.lastName,
          "gender": state.gender!.toUpperCase(),
          "dob": state.dob?.toIso8601String().split("T").first,
          "monthlyIncome":
              double.tryParse(state.monthlyIncome.toString()) ?? "0.0",
          "sourceFunds": state.sourceFunds,
          "mobileNumber": state.mobileNumber,
          "nationalId": state.nationalId,
          "empType": (state.employmentType == "Employed")
              ? "EMPLOYED"
              : "SELF_EMPLOYEMENT",
          "sector": state.selectedSector!.name,
          "employerName": state.employerName,
          "businessNature": state.businessNature,
          "businessName": state.businessName,
          "kycStatus": state.kycStatus,
          "code": state.code,
          "signature": {
            "file": state.signatureFile,
            "docName": "Signature",
            "fileName": (state.signatureFile == null ||
                    state.signatureFile!.isEmpty)
                ? state.signatureName
                : "signature ${DateTime.now().millisecondsSinceEpoch}.${state.signatureName!.split('.').last}",
            if (state.signatureFile == null || state.signatureFile!.isEmpty)
              "docId": state.signatureDocId,
          },
          "photo": {
            "file": state.photoFile,
            "docName": "Photo",
            "fileName": (state.photoFile == null || state.photoFile!.isEmpty)
                ? state.photoName
                : "photo ${DateTime.now().millisecondsSinceEpoch}.${state.photoName!.split('.').last}",
            if (state.photoFile == null || state.photoFile!.isEmpty)
              "docId": state.photoDocId,
          },
          "originCountry": {
            "id": state.selectedOriginCountry!.id,
            "type": state.selectedOriginCountry!.name,
            "friendlyType": state.selectedOriginCountry!.name,
            "other": null
          },
          "communication": {
            "email": state.email,
            "phNumber": state.phNumber,
            "pbNumber": state.pbNumber,
            "addressLine": state.addressLine,
            "country": {
              "id": state.selectedCountry!.id,
              "type": state.selectedCountry!.name,
              "friendlyType": state.selectedCountry!.name,
              "other": null
            },
            "province": null,
            "district": {
              "id": state.selectedDistrict!.id,
              "type": state.selectedDistrict!.name,
              "friendlyType": state.selectedDistrict!.name,
              "other": null
            },
            "state": {
              "id": state.selectedState!.id,
              "type": state.selectedState!.name,
              "friendlyType": state.selectedState!.name,
              "other": null
            },
            "city": {
              "id": state.selectedCity!.id,
              "type": state.selectedCity!.name,
              "friendlyType": state.selectedCity!.name,
              "other": null
            }
          },
          "documents": [
            ...state.kycUserDocuments.map((doc) => {
                  "docRef": doc.docRef,
                  "docName": doc.docName,
                  "fileName": (doc.file == null || doc.file.isEmpty)
                      ? doc.fileName
                      : "${doc.docName.replaceAll(" ", "")} ${DateTime.now().millisecondsSinceEpoch}.${doc.fileName.toString().split(".").last}",
                  "docUrl": doc.docUrl,
                  "issuingDate":
                      doc.issuingDate?.toIso8601String().split("T").first,
                  "verificationDate": doc.verificationDate,
                  "expiryDate":
                      doc.expiryDate?.toIso8601String().split("T").first,
                  "extension": doc.extension,
                  "uploadFile": doc.uploadFile,
                  "filePath": doc.filePath,
                  if (doc.file != null && doc.file.isNotEmpty) "file": doc.file,
                  if (doc.file == null || doc.file.isEmpty) "docId": doc.docId,
                }),
            ...state.mergedDocuments
                .where((md) => md.file != null) // only send if user uploaded
                .where((md) => !state.kycUserDocuments.any(
                      (ud) =>
                          ud.docName.trim().toLowerCase() ==
                          md.name.trim().toLowerCase(),
                    ))
                .map((md) => {
                      "docName": md.name,
                      "fileName":
                          "${md.name.replaceAll(" ", "")} ${DateTime.now().millisecondsSinceEpoch}.${md.fileName!.split(".").last}",
                      "file": md.file,
                      if (md.showDates && md.issueDate != null)
                        "issuingDate":
                            md.issueDate!.toIso8601String().split("T").first,
                      if (md.showDates && md.expiryDate != null)
                        "expiryDate":
                            md.expiryDate!.toIso8601String().split("T").first,
                    }),
          ],
          // "documents": state.kycUserDocuments
          //     .map((doc) => {
          //           "docRef": doc.docRef,
          //           "docName": doc.docName,
          //           "fileName": (doc.file == null || doc.file.isEmpty)
          //               ? doc.fileName
          //               : "${doc.docName.replaceAll(" ", "")} ${DateTime.now().millisecondsSinceEpoch}.${doc.fileName.toString().split(".").last}",
          //           "docUrl": doc.docUrl,
          //           "issuingDate":
          //               doc.issuingDate?.toIso8601String().split("T").first,
          //           "verificationDate": doc.verificationDate,
          //           "expiryDate":
          //               doc.expiryDate?.toIso8601String().split("T").first,
          //           "extension": doc.extension,
          //           "uploadFile": doc.uploadFile,
          //           "filePath": doc.filePath,
          //           if (doc.file.toString().isNotEmpty) "file": doc.file,
          //           if (doc.file == null || doc.file.isEmpty)
          //             "docId": doc.docId,
          //         })
          //     .toList(),
        }
      };

      final result = await authService.submitKyc(req);

      if (result != null) {
        if (result.chMessage.code == 'SUCCESS') {
          emit(state.copyWith(isUpdatingKyc: false, updateKyc: true));
          emit(state.copyWith(updateKyc: false));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
        isUpdatingKyc: false,
        updateKyc: false,
      ));
    }
  }

  Future<void> _selectSector(
    SelectSectorEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(
      selectedSector: () => event.sector,
    ));
  }

  Future<void> _downloadDocument(
    DownloadDocument event,
    Emitter<KycState> emit,
  ) async {
    try {
      emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.loading));
      final result = await authService.downloadFile(event.url, event.fileName);
      if (result) {
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.success));
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.initial));
      } else {
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.failure));
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.failure));
      emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.initial));
    }
  }

  Future<void> _resetFormData(
    ResetFormData event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(
        id: null,
        firstName: null,
        lastName: null,
        nationalId: null,
        gender: "MALE",
        mobileNumber: null,
        agentMobileNumber: null,
        dob: () => null,
        employmentType: "Employed",
        empType: null,
        monthlyIncome: null,
        sourceFunds: null,
        sector: () => null,
        sectors: [],
        selectedSector: () => null,
        employerName: null,
        businessName: null,
        businessNature: null,
        email: null,
        addressLine: null,
        phNumber: null,
        pbNumber: null,
        countryId: null,
        countryType: null,
        countryFriendlyType: () => null,
        stateId: null,
        stateType: null,
        stateFriendlyType: () => null,
        districtId: null,
        districtType: null,
        districtFriendlyType: () => null,
        cityId: null,
        cityType: null,
        cityFriendlyType: () => null,
        originCountries: [],
        countries: [],
        states: [],
        districts: [],
        cities: [],
        filteredStates: [],
        filteredDistricts: [],
        filteredCities: [],
        selectedOriginCountry: () => null,
        selectedCountry: () => null,
        selectedState: () => null,
        selectedDistrict: () => null,
        selectedCity: () => null,
        originCountryFriendlyType: () => null,
        photoFile: () => null,
        photoUrl: () => null,
        photoName: () => null,
        photo: null,
        signatureFile: () => null,
        signatureUrl: () => null,
        signatureName: () => null,
        signature: null,
        loading: false,
        submitKyc: false,
        updateKyc: false,
        sectorLoading: false,
        kycHistoryList: [],
        selectedFilter: "RECENT",
        currentPage: 1,
        totalPages: 1,
        isLoadingMore: false,
        fromDate: null,
        toDate: null,
        mergedDocuments: []));
  }

  List<KycDynamicDocument> _updateDynamicDocs(
    List<KycDynamicDocument> docs,
    String name,
    KycDynamicDocument Function(KycDynamicDocument) update,
  ) {
    return docs.map((doc) {
      if (doc.name == name) {
        return update(doc);
      }
      return doc;
    }).toList();
  }

  Future<void> _pickDynamicDocumentFile(
    PickDynamicDocumentEvent event,
    Emitter<KycState> emit,
  ) async {
    final updatedDocs = _updateDynamicDocs(
      state.dynamicDocuments,
      event.name,
      (doc) => doc.copyWith(
        file: event.fileData,
        fileName: event.fileName,
      ),
    );

    emit(state.copyWith(dynamicDocuments: updatedDocs));
  }

  Future<void> _updateDynamicDocIssueDate(
    UpdateDynamicDocIssueDate event,
    Emitter<KycState> emit,
  ) async {
    final updatedDocs = _updateDynamicDocs(
      state.dynamicDocuments,
      event.name,
      (doc) => doc.copyWith(
        issueDate: event.date,

        // reset expiry if invalid
        expiryDate:
            (doc.expiryDate != null && !event.date.isBefore(doc.expiryDate!))
                ? null
                : doc.expiryDate,
      ),
    );

    emit(state.copyWith(dynamicDocuments: updatedDocs));
  }

  Future<void> _updateDynamicDocExpiryDate(
    UpdateDynamicDocExpiryDate event,
    Emitter<KycState> emit,
  ) async {
    final updatedDocs = _updateDynamicDocs(
      state.dynamicDocuments,
      event.name,
      (doc) => doc.copyWith(
        expiryDate: event.date,
      ),
    );

    emit(state.copyWith(dynamicDocuments: updatedDocs));
  }

  Future<void> _editDynamicDocumentFile(
    EditDynamicDocumentEvent event,
    Emitter<KycState> emit,
  ) async {
    final docs = state.kycUserDocuments.map((doc) {
      if (doc.docId == event.docId) {
        return doc.copyWith(
            file: event.fileData, fileName: event.fileName); // for file handler
      }
      return doc;
    }).toList();

    emit(state.copyWith(kycUserDocuments: docs));
  }

  Future<void> _editDynamicDocIssueDate(
    EditDynamicDocIssueDate event,
    Emitter<KycState> emit,
  ) async {
    final docs = state.kycUserDocuments.map((doc) {
      if (doc.docId == event.docId) {
        return doc.copyWith(issuingDate: event.date);
      }
      return doc;
    }).toList();

    emit(state.copyWith(kycUserDocuments: docs));
  }

  Future<void> _editDynamicDocExpiryDate(
    EditDynamicDocExpiryDate event,
    Emitter<KycState> emit,
  ) async {
    final docs = state.kycUserDocuments.map((doc) {
      if (doc.docId == event.docId) {
        return doc.copyWith(expiryDate: event.date); // for expiry date handler
      }
      return doc;
    }).toList();

    emit(state.copyWith(kycUserDocuments: docs));
  }

  void _clearError(ClearErrorEvent event, Emitter<KycState> emit) {
    emit(state.copyWith(errorMessage: () => null));
  }

  void _mergeDocuments(MergeDocumentsEvent event, Emitter<KycState> emit) {
    final configDocs = state.dynamicDocuments;
    final userDocs = state.kycUserDocuments;

    final merged = configDocs.map((configDoc) {
      final existing = userDocs.cast<Document?>().firstWhere(
            (d) =>
                d!.docName.trim().toLowerCase() ==
                configDoc.name.trim().toLowerCase(),
            orElse: () => null,
          );

      if (existing != null) {
        return configDoc.copyWith(
          fileName: existing.fileName?.toString(),
          issueDate: existing.issuingDate,
          expiryDate: existing.expiryDate,
        );
      }
      return configDoc; // not yet uploaded, show empty
    }).toList();

    emit(state.copyWith(mergedDocuments: merged));
  }

  void _pickMergedDoc(PickMergedDocumentEvent event, Emitter<KycState> emit) {
    final updated = _updateMergedDocs(
      state.mergedDocuments,
      event.name,
      (doc) => doc.copyWith(file: event.fileData, fileName: event.fileName),
    );

    final updatedUserDocs = state.kycUserDocuments.map((doc) {
      if (doc.docName.trim().toLowerCase() == event.name.trim().toLowerCase()) {
        return doc.copyWith(file: event.fileData, fileName: event.fileName);
      }
      return doc;
    }).toList();
    emit(state.copyWith(
        mergedDocuments: updated, kycUserDocuments: updatedUserDocs));
  }

  void _updateMergedDocIssueDate(
      UpdateMergedDocIssueDate event, Emitter<KycState> emit) {
    final updated = _updateMergedDocs(
      state.mergedDocuments,
      event.name,
      (doc) => doc.copyWith(
        issueDate: event.date,
        expiryDate:
            (doc.expiryDate != null && !event.date.isBefore(doc.expiryDate!))
                ? null
                : doc.expiryDate,
      ),
    );
    emit(state.copyWith(mergedDocuments: updated));
  }

  void _updateMergedDocExpiryDate(
      UpdateMergedDocExpiryDate event, Emitter<KycState> emit) {
    final updated = _updateMergedDocs(
      state.mergedDocuments,
      event.name,
      (doc) => doc.copyWith(expiryDate: event.date),
    );
    emit(state.copyWith(mergedDocuments: updated));
  }

  List<KycDynamicDocument> _updateMergedDocs(
    List<KycDynamicDocument> docs,
    String name,
    KycDynamicDocument Function(KycDynamicDocument) update,
  ) {
    return docs.map((d) => d.name == name ? update(d) : d).toList();
  }

  Future<String> getAgentMobile() async {
    final storageData = await SecureStorageHelper.getLoginResponse();
    if (storageData == null) return "";
    try {
      final data = jsonDecode(storageData);
      return data?["loginUserInfo"]?["mobileno"]?.toString() ?? "";
    } catch (_) {
      return "";
    }
  }

  Future<void> _sendOtp(
    SendOtpEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(otpStatus: OtpStatus.sendingOtp));

    final req = {
      "purpose": "LOGIN",
      "referenceType": "KYC_REGISTRATION",
      "addiParams": [event.mobile, state.email]
    };
    try {
      final res = await authService.sendOtp(req);

      if (res != null && res.chMessage.isError == false) {
        if (res.isDefaultOtp) {
          emit(state.copyWith(
            otpStatus: OtpStatus.otpSent,
            otpDisplayMessage: "The generated OTP is ${res.otp}",
            otpId: res.otpId,
            otp: res.otp,
            otpExpiryTime: res.validityTime,
            attemptRemaining: res.attemptRemaining,
            otpTimer: res.validityTime,
            otpChannel: res.channel,
            canResend: false,
          ));
        } else if (!res.isDefaultOtp) {
          if (res.channel == 'SMS') {
            emit(state.copyWith(
                otpDisplayMessage:
                    "Ente the OTP sent to XXXXXX${state.mobileNumber!.substring(6)}"));
          } else if (res.channel == 'EMAIL') {
            emit(state.copyWith(
                otpDisplayMessage: "Ente the OTP sent to ${state.email!}"));
          }
          emit(state.copyWith(
            otpStatus: OtpStatus.otpSent,
            otpId: "",
            otp: "",
            otpExpiryTime: res.validityTime,
            attemptRemaining: res.attemptRemaining,
            otpTimer: res.validityTime,
            canResend: false,
          ));
        }

        emit(state.copyWith(otpStatus: OtpStatus.initial));
        add(StartOtpTimer());
      }
    } catch (e) {
      emit(state.copyWith(
        otpStatus: OtpStatus.error,
        errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
      ));
      emit(state.copyWith(otpStatus: OtpStatus.initial));
    }
  }

  Future<void> _verifyOtp(
    VerifyOtpEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(otpStatus: OtpStatus.verifyingOtp));

    final req = {
      "channel": (state.otpChannel == "SMS") ? "SMS" : "EMAIL",
      "destination": (state.otpChannel == "SMS") ? event.mobile : state.email,
      "purpose": "LOGIN",
      "referenceType": "KYC_REGISTRATION",
      "otp": event.otp
    };
    try {
      final res = await authService.verifyOtp(req);

      if (res != null && res.chMessage.isError == false) {
        emit(state.copyWith(
            otpStatus: OtpStatus.otpVerified, kycOtpVerified: true));
        emit(state.copyWith(
            otpStatus: OtpStatus.initial, kycOtpVerified: false));
      }
    } catch (e) {
      emit(state.copyWith(
        otpStatus: OtpStatus.otpInvalid,
        errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
      ));
      emit(state.copyWith(otpStatus: OtpStatus.initial));
    }
  }

  Future<void> _resendOtp(
    ResendOtpEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(otpStatus: OtpStatus.resendingOtp));

    final req = {
      "purpose": "LOGIN",
      "referenceType": "KYC_CUSTOMER",
      "addiParams": [event.mobile, state.email]
    };

    try {
      final res = await authService.sendOtp(req);
      if (res != null && res.chMessage.isError == false) {
        if (res.isDefaultOtp) {
          emit(state.copyWith(
            otpStatus: OtpStatus.otpResent,
            otpDisplayMessage: "The generated OTP is ${res.otp}",
            otpId: res.otpId,
            otp: res.otp,
            otpExpiryTime: res.validityTime,
            attemptRemaining: res.attemptRemaining,
            otpTimer: res.validityTime,
            otpChannel: res.channel,
            canResend: false,
          ));
        } else if (!res.isDefaultOtp) {
          if (res.channel == 'SMS') {
            emit(state.copyWith(
                otpDisplayMessage:
                    "Enter the OTP sent to XXXXXX${state.mobileNumber!.substring(6)}"));
          } else if (res.channel == 'EMAIL') {
            emit(state.copyWith(
                otpDisplayMessage: "Enter the OTP sent to ${state.email!}"));
          }
          emit(state.copyWith(
            otpStatus: OtpStatus.otpResent,
            otpId: "",
            otp: "",
            otpExpiryTime: res.validityTime,
            attemptRemaining: res.attemptRemaining,
            otpTimer: res.validityTime,
            canResend: false,
          ));
        }

        emit(state.copyWith(otpStatus: OtpStatus.initial));
        add(StartOtpTimer());
      }
    } catch (e) {
      emit(state.copyWith(
        otpStatus: OtpStatus.error,
        errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
      ));
      emit(state.copyWith(otpStatus: OtpStatus.initial));
    }
  }

  bool _timerCancelled = false;

  Future<void> _startTimer(
    StartOtpTimer event,
    Emitter<KycState> emit,
  ) async {
    _timerCancelled = true;
    await Future.delayed(Duration.zero);
    _timerCancelled = false;

    final int startFrom = state.otpTimer;

    await emit.forEach<int>(
      Stream.periodic(const Duration(seconds: 1), (tick) => tick + 1)
          .take(startFrom)
          .takeWhile((_) => !_timerCancelled),
      onData: (tick) {
        final remaining = startFrom - tick;
        return state.copyWith(
          otpTimer: remaining <= 0 ? 0 : remaining,
          canResend: remaining <= 0,
        );
      },
    );
  }

  void _resetOtpState(ResetOtpStateEvent event, Emitter<KycState> emit) {
    _timerCancelled = true;

    emit(state.copyWith(
      otpStatus: OtpStatus.initial,
      otpTimer: 0,
      canResend: false,
      kycOtpVerified: false,
      otpDisplayMessage: "",
      otpId: "",
      otp: "",
      errorMessage: () => null,
    ));
    _timerCancelled = false;
  }
}
