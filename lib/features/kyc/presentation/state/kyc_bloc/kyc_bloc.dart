import 'dart:async';
import 'package:citizenone_app/features/kyc/data/models/kyc_dynamic_document_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_recent_history_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_user_response_model.dart';
import 'package:citizenone_app/features/kyc/data/models/location_response_model.dart';
import 'package:citizenone_app/features/kyc/domain/entities/kyc_params_entity.dart';
import 'package:citizenone_app/features/kyc/domain/entities/location_entity.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/check_kyc_user_exists_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/download_document_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/fetch_locations_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/fetch_recent_history_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/get_agent_mobile_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/otp_usecases.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/resend_otp_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/search_kyc_user_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/submit_kyc_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/update_kyc_usecase.dart';
import 'package:citizenone_app/features/kyc/domain/usecases/verify_otp_usecase.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_event.dart';
import 'package:citizenone_app/features/kyc/presentation/state/kyc_bloc/kyc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final SearchKycUserUseCase searchKycUserUseCase;
  final CheckKycUserExistsUseCase checkKycUserExistsUseCase;
  final FetchLocationsUseCase fetchLocationsUseCase;
  final FetchRecentHistoryUseCase fetchRecentHistoryUseCase;
  final SubmitKycUseCase submitKycUseCase;
  final UpdateKycUseCase updateKycUseCase;
  final DownloadDocumentUseCase downloadDocumentUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetAgentMobileUseCase getAgentMobileUseCase;

  KycBloc({
    required this.searchKycUserUseCase,
    required this.checkKycUserExistsUseCase,
    required this.fetchLocationsUseCase,
    required this.fetchRecentHistoryUseCase,
    required this.submitKycUseCase,
    required this.updateKycUseCase,
    required this.downloadDocumentUseCase,
    required this.sendOtpUseCase,
    required this.resendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getAgentMobileUseCase,
  }) : super(const KycState()) {
    on<SearchUserEvent>(_searchUser);
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
    emit(
      state.copyWith(
        photoFile: () => event.fileData,
        photoName: () => event.name,
      ),
    );
  }

  Future<void> _pickSignatureEvent(
    PickSignatureEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        signatureFile: () => event.fileData,
        signatureName: () => event.name,
      ),
    );
  }

  Future<void> _searchUser(
    SearchUserEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(status: KycUserStatus.initial));
    emit(state.copyWith(status: KycUserStatus.loading));

    if (event.mobileNumber.isNotEmpty) {
      emit(
        state.copyWith(
          searchType: SearchType.mobileNumber,
          mobileNumber: event.mobileNumber,
          nationalId: '',
        ),
      );
    } else if (event.nationalId.isNotEmpty) {
      emit(
        state.copyWith(
          searchType: SearchType.nationalId,
          mobileNumber: '',
          nationalId: event.nationalId,
        ),
      );
    }

    // Fetch agent mobile from local storage via usecase
    final agentMobileResult = await getAgentMobileUseCase();
    final agentMobile = agentMobileResult.fold((_) => '', (mobile) => mobile);

    emit(state.copyWith(agentMobileNumber: agentMobile, isUserExists: false));

    final result = await searchKycUserUseCase(
      SearchKycUserParams(
        mobileNumber: event.mobileNumber,
        nationalId: event.nationalId,
      ),
    );

    result.fold(
      (failure) {
        if (failure.message == 'User not found') {
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
            status: event.fromHistory
                ? KycUserStatus.loadedFromHistory
                : KycUserStatus.loaded,
            updateKyc: false,
            submitKyc: false,
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            gender: user.gender,
            dob: () => DateTime.tryParse(user.dob),
            monthlyIncome: user.monthlyIncome
                .toStringAsFixed(2)
                .replaceAll(RegExp(r'\.?0+$'), ''),
            sourceFunds: user.sourceFunds,
            mobileNumber: user.mobileNumber,
            nationalId: user.nationalId,
            employmentType: user.empType,
            sector: () => user.sector,
            employerName: user.employerName,
            businessNature: user.businessNature,
            businessName: user.businessName,
            kycStatus: user.kycStatus?.toString(),
            code: user.code?.toString(),
            email: comm?.email,
            phNumber: comm?.phNumber,
            pbNumber: comm?.pbNumber,
            addressLine: comm?.addressLine,
            countryId: comm?.country?.id,
            stateId: comm?.state?.id,
            districtId: comm?.district?.id,
            cityId: comm?.city?.id,
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

  Future<void> _checkUserExists(
    CheckUserExistsEvent event,
    Emitter<KycState> emit,
  ) async {
    final result = await checkKycUserExistsUseCase(
      CheckKycUserExistsParams(
        mobileNumber: event.mobileNumber,
        nationalId: event.nationalId,
      ),
    );

    result.fold(
      (_) {
        emit(
          state.copyWith(isUserExists: false, navigateAfterUserCheck: false),
        );
      },
      (exists) {
        if (exists) {
          emit(
            state.copyWith(isUserExists: true, navigateAfterUserCheck: false),
          );
        } else {
          emit(
            state.copyWith(isUserExists: false, navigateAfterUserCheck: true),
          );
        }
      },
    );

    emit(state.copyWith(navigateAfterUserCheck: false, isUserExists: false));
  }

  Future<void> _fetchRecentHistory(
    FetchRecentHistory event,
    Emitter<KycState> emit,
  ) async {
    final agentMobileResult = await getAgentMobileUseCase();
    final agentMobile = agentMobileResult.fold((_) => '', (m) => m);
    emit(state.copyWith(agentMobileNumber: agentMobile));

    if (event.filter == 'CUSTOM' &&
        (event.fromDate == null || event.toDate == null)) {
      emit(
        state.copyWith(
          selectedFilter: event.filter,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      );
      return;
    }

    if (event.page == 1) {
      emit(
        state.copyWith(
          kycHistoryList: [],
          filteredKycHistoryList: [],
          selectedFilter: event.filter,
          currentPage: 1,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    final result = await fetchRecentHistoryUseCase(
      FetchHistoryParams(
        agentMobileNumber: agentMobile,
        filter: event.filter,
        page: event.page,
        fromDate: event.fromDate,
        toDate: event.toDate,
      ),
    );

    result.fold(
      (_) {
        emit(
          state.copyWith(
            kycHistoryList: [],
            filteredKycHistoryList: [],
            isLoadingMore: false,
          ),
        );
      },
      (historyResult) {
        final newList = historyResult.items
            .map(
              (e) => KycHistoryDetails(
                id: e.id,
                firstName: e.firstName,
                lastName: e.lastName,
                kycStatus: e.kycStatus,
                code: e.code,
                createdDate: e.createdDate,
                mobileNumber: e.mobileNumber,
                nationalId: e.nationalId,
              ),
            )
            .toList();

        final updatedList = event.page == 1
            ? newList
            : <KycHistoryDetails>[...(state.kycHistoryList ?? []), ...newList];

        emit(
          state.copyWith(
            kycHistoryList: updatedList,
            filteredKycHistoryList: updatedList,
            currentPage: historyResult.currentPage,
            totalPages: historyResult.totalPages,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> _localSearchKycHistory(
    LocalSearchKycHistory event,
    Emitter<KycState> emit,
  ) async {
    final query = event.query.toLowerCase();

    if (query.isEmpty) {
      emit(
        state.copyWith(
          searchQuery: '',
          filteredKycHistoryList: state.kycHistoryList,
        ),
      );
      return;
    }

    final filtered = state.kycHistoryList!.where((item) {
      final fullName = '${item.firstName ?? ''} ${item.lastName ?? ''}'
          .toLowerCase();
      final mobile = (item.mobileNumber ?? '').toLowerCase();
      final nationalId = (item.nationalId ?? '').toLowerCase();
      return fullName.contains(query) ||
          mobile.contains(query) ||
          nationalId.contains(query);
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredKycHistoryList: filtered));
  }

  Future<void> _selectGender(SelectGender event, Emitter<KycState> emit) async {
    emit(state.copyWith(gender: event.gender!));
  }

  Future<void> _selectDob(SelectDob event, Emitter<KycState> emit) async {
    emit(state.copyWith(dob: () => event.dob));
  }

  Future<void> _selectEmploymentType(
    SelectEmploymentType event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(employmentType: event.employmentType!));
  }

  Future<void> _updatePersonalInfoForm(
    UpdatePersonalInfoEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        firstName: event.firstName,
        lastName: event.lastName,
        nationalId: event.nationalId,
        mobileNumber: event.mobileNumber,
      ),
    );
  }

  Future<void> _updateProfessionalInfoForm(
    UpdateProfessionalInfoEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        monthlyIncome: event.monthlyIncome,
        sourceFunds: event.sourceFunds,
        employerName: event.employerName,
        businessNature: event.natureOfBusiness,
        businessName: event.businessName,
      ),
    );
  }

  Future<void> _updateAddressInfoForm(
    UpdateAddressInfoEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        email: event.email,
        addressLine: event.addressLine,
        phNumber: event.phNumber,
        pbNumber: event.pbNumber,
      ),
    );
  }

  Future<void> _loadLocations(
    LoadLocationsEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final result = await fetchLocationsUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(loading: false));
      },
      (locations) {
        // Map entities to the LocationOption model the state still uses
        final countries = locations.countries
            .map(_entityToLocationOption)
            .toList();
        final originCountries = locations.countries
            .map(_entityToLocationOption)
            .toList();
        final states = locations.states.map(_entityToLocationOption).toList();
        final districts = locations.districts
            .map(_entityToLocationOption)
            .toList();
        final cities = locations.cities.map(_entityToLocationOption).toList();
        final sectors = locations.sectors.map(_entityToLocationOption).toList();
        final dynamicDocs = locations.dynamicDocuments
            .map(
              (e) => KycDynamicDocument(
                name: e.name,
                isMandatory: e.isMandatory,
                showDates: e.showDates,
              ),
            )
            .toList();

        // Pre-select based on friendly type strings already in state
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

        final filteredStates = selectedCountry != null
            ? states.where((s) => s.parentId == selectedCountry!.id).toList()
            : <LocationOption>[];

        final filteredDistricts = selectedState != null
            ? districts.where((d) => d.parentId == selectedState!.id).toList()
            : <LocationOption>[];

        final filteredCities = selectedDistrict != null
            ? cities.where((c) => c.parentId == selectedDistrict!.id).toList()
            : <LocationOption>[];

        emit(
          state.copyWith(
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
          ),
        );

        add(const MergeDocumentsEvent());
      },
    );
  }

  void _selectOriginCountry(
    SelectOriginCountryEvent event,
    Emitter<KycState> emit,
  ) {
    emit(state.copyWith(selectedOriginCountry: () => event.country));
  }

  void _selectCountry(SelectCountryEvent event, Emitter<KycState> emit) {
    final filteredStates = state.states
        .where((s) => s.parentId == event.country.id)
        .toList();

    emit(
      state.copyWith(
        selectedCountry: () => event.country,
        filteredStates: filteredStates,
        filteredDistricts: [],
        filteredCities: [],
        selectedState: () => null,
        selectedDistrict: () => null,
        selectedCity: () => null,
      ),
    );
  }

  void _selectState(SelectStateEvent event, Emitter<KycState> emit) {
    final stateDistrictIds = state.districts
        .where((d) => d.parentId == event.state.id)
        .map((d) => d.id)
        .toList();

    final filteredCities = state.cities
        .where((c) => stateDistrictIds.contains(c.parentId))
        .toList();
    final filteredDistricts = state.districts
        .where((d) => d.parentId == event.state.id)
        .toList();

    emit(
      state.copyWith(
        selectedState: () => event.state,
        filteredCities: filteredCities,
        filteredDistricts: filteredDistricts,
        selectedCity: () => null,
      ),
    );
  }

  void _selectDistrict(SelectDistrictEvent event, Emitter<KycState> emit) {
    final filteredCities = state.cities
        .where((c) => c.parentId == event.district.id)
        .toList();

    emit(
      state.copyWith(
        selectedDistrict: () => event.district,
        filteredCities: filteredCities,
        selectedCity: () => null,
      ),
    );
  }

  void _selectCity(SelectCityEvent event, Emitter<KycState> emit) {
    emit(state.copyWith(selectedCity: () => event.city));
  }

  Future<void> _selectSector(
    SelectSectorEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(selectedSector: () => event.sector));
  }

  Future<void> _submitKycEvent(
    SubmitKycEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        isSubmittingKyc: true,
        submitKyc: false,
        errorMessage: () => null,
      ),
    );

    try {
      final params = SubmitKycParams(
        agentMobileNumber: state.agentMobileNumber ?? '',
        firstName: state.firstName ?? '',
        lastName: state.lastName ?? '',
        gender: state.gender ?? 'MALE',
        dob: state.dob?.toIso8601String().split('T').first ?? '',
        mobileNumber: state.mobileNumber ?? '',
        nationalId: state.nationalId ?? '',
        monthlyIncome: double.tryParse(state.monthlyIncome ?? '0') ?? 0.0,
        sourceFunds: state.sourceFunds ?? '',
        empType: (state.employmentType == 'Employed')
            ? 'EMPLOYED'
            : 'SELF_EMPLOYMENT',
        sector: state.selectedSector!.name,
        employerName: state.employerName ?? '',
        businessNature: state.businessNature,
        businessName: state.businessName,
        originCountry: KycLocationRefParamEntity(
          id: state.selectedOriginCountry!.id,
          name: state.selectedOriginCountry!.name,
        ),
        email: state.email ?? '',
        addressLine: state.addressLine ?? '',
        phNumber: state.phNumber ?? '',
        pbNumber: state.pbNumber,
        country: KycLocationRefParamEntity(
          id: state.selectedCountry!.id,
          name: state.selectedCountry!.name,
        ),
        state: KycLocationRefParamEntity(
          id: state.selectedState!.id,
          name: state.selectedState!.name,
        ),
        district: KycLocationRefParamEntity(
          id: state.selectedDistrict!.id,
          name: state.selectedDistrict!.name,
        ),
        city: KycLocationRefParamEntity(
          id: state.selectedCity?.id ?? 0,
          name: state.selectedCity?.name ?? '',
        ),
        photo: KycDocumentParamEntity(
          file: state.photoFile,
          docName: 'Photo',
          fileName:
              'photo ${DateTime.now().millisecondsSinceEpoch}.${state.photoName!.split('.').last}',
        ),
        signature: KycDocumentParamEntity(
          file: state.signatureFile,
          docName: 'Signature',
          fileName:
              'signature ${DateTime.now().millisecondsSinceEpoch}.${state.signatureName!.split('.').last}',
        ),
        documents: _buildSubmitDynamicDocParams(state.dynamicDocuments),
      );

      final result = await submitKycUseCase(params);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              errorMessage: () => failure.message,
              isSubmittingKyc: false,
              submitKyc: false,
            ),
          );
        },
        (kycCode) {
          emit(
            state.copyWith(
              isSubmittingKyc: false,
              submitKyc: true,
              code: kycCode,
            ),
          );
          emit(state.copyWith(submitKyc: false));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
          isSubmittingKyc: false,
          submitKyc: false,
        ),
      );
    }
  }

  Future<void> _updateKycData(
    UpdateKycEvent event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
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
        pbNumber: event.pbNumber,
      ),
    );

    try {
      final params = UpdateKycParams(
        kycId: state.id!,
        kycStatus: state.kycStatus,
        code: state.code,
        agentMobileNumber: state.agentMobileNumber ?? '',
        firstName: state.firstName ?? '',
        lastName: state.lastName ?? '',
        gender: state.gender ?? 'MALE',
        dob: state.dob?.toIso8601String().split('T').first ?? '',
        mobileNumber: state.mobileNumber ?? '',
        nationalId: state.nationalId ?? '',
        monthlyIncome: double.tryParse(state.monthlyIncome ?? '0') ?? 0.0,
        sourceFunds: state.sourceFunds ?? '',
        empType: (state.employmentType == 'Employed')
            ? 'EMPLOYED'
            : 'SELF_EMPLOYEMENT',
        sector: state.selectedSector!.name,
        employerName: state.employerName ?? '',
        businessNature: state.businessNature,
        businessName: state.businessName,
        originCountry: KycLocationRefParamEntity(
          id: state.selectedOriginCountry!.id,
          name: state.selectedOriginCountry!.name,
        ),
        email: state.email ?? '',
        addressLine: state.addressLine ?? '',
        phNumber: state.phNumber ?? '',
        pbNumber: state.pbNumber,
        country: KycLocationRefParamEntity(
          id: state.selectedCountry!.id,
          name: state.selectedCountry!.name,
        ),
        state: KycLocationRefParamEntity(
          id: state.selectedState!.id,
          name: state.selectedState!.name,
        ),
        district: KycLocationRefParamEntity(
          id: state.selectedDistrict!.id,
          name: state.selectedDistrict!.name,
        ),
        city: KycLocationRefParamEntity(
          id: state.selectedCity!.id,
          name: state.selectedCity!.name,
        ),
        photo: _buildPhotoParam(),
        signature: _buildSignatureParam(),
        documents: const [],
        existingDocuments: _buildExistingDocParams(state.kycUserDocuments),
        newDocuments: _buildNewMergedDocParams(
          state.mergedDocuments,
          state.kycUserDocuments,
        ),
      );

      final result = await updateKycUseCase(params);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              errorMessage: () => failure.message,
              isUpdatingKyc: false,
              updateKyc: false,
            ),
          );
        },
        (_) {
          emit(state.copyWith(isUpdatingKyc: false, updateKyc: true));
          emit(state.copyWith(updateKyc: false));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: () => e.toString().replaceFirst('Exception: ', ''),
          isUpdatingKyc: false,
          updateKyc: false,
        ),
      );
    }
  }

  Future<void> _downloadDocument(
    DownloadDocument event,
    Emitter<KycState> emit,
  ) async {
    emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.loading));

    final result = await downloadDocumentUseCase(
      DownloadDocumentParams(url: event.url, fileName: event.fileName),
    );

    result.fold(
      (_) {
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.failure));
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.initial));
      },
      (_) {
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.success));
        emit(state.copyWith(fileDownloadStatus: FileDownloadStatus.initial));
      },
    );
  }

  Future<void> _resetFormData(
    ResetFormData event,
    Emitter<KycState> emit,
  ) async {
    emit(
      state.copyWith(
        id: null,
        firstName: null,
        lastName: null,
        nationalId: null,
        gender: 'MALE',
        mobileNumber: null,
        agentMobileNumber: null,
        dob: () => null,
        employmentType: 'Employed',
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
        selectedFilter: 'RECENT',
        currentPage: 1,
        totalPages: 1,
        isLoadingMore: false,
        fromDate: null,
        toDate: null,
        mergedDocuments: [],
      ),
    );
  }

  Future<void> _pickDynamicDocumentFile(
    PickDynamicDocumentEvent event,
    Emitter<KycState> emit,
  ) async {
    final updatedDocs = _updateDynamicDocs(
      state.dynamicDocuments,
      event.name,
      (doc) => doc.copyWith(file: event.fileData, fileName: event.fileName),
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
      (doc) => doc.copyWith(expiryDate: event.date),
    );
    emit(state.copyWith(dynamicDocuments: updatedDocs));
  }

  Future<void> _editDynamicDocumentFile(
    EditDynamicDocumentEvent event,
    Emitter<KycState> emit,
  ) async {
    final docs = state.kycUserDocuments.map((doc) {
      if (doc.docId == event.docId) {
        return doc.copyWith(file: event.fileData, fileName: event.fileName);
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
        return doc.copyWith(expiryDate: event.date);
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
      return configDoc;
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

    emit(
      state.copyWith(
        mergedDocuments: updated,
        kycUserDocuments: updatedUserDocs,
      ),
    );
  }

  void _updateMergedDocIssueDate(
    UpdateMergedDocIssueDate event,
    Emitter<KycState> emit,
  ) {
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
    UpdateMergedDocExpiryDate event,
    Emitter<KycState> emit,
  ) {
    final updated = _updateMergedDocs(
      state.mergedDocuments,
      event.name,
      (doc) => doc.copyWith(expiryDate: event.date),
    );
    emit(state.copyWith(mergedDocuments: updated));
  }

  Future<void> _sendOtp(SendOtpEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(otpStatus: OtpStatus.sendingOtp));

    final result = await sendOtpUseCase(
      SendOtpParams(mobile: event.mobile, email: state.email),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            otpStatus: OtpStatus.error,
            errorMessage: () => failure.message,
          ),
        );
        emit(state.copyWith(otpStatus: OtpStatus.initial));
      },
      (otpResponse) {
        _emitOtpSentState(emit, otpResponse, OtpStatus.otpSent);
        emit(state.copyWith(otpStatus: OtpStatus.initial));
        add(StartOtpTimer());
      },
    );
  }

  Future<void> _resendOtp(ResendOtpEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(otpStatus: OtpStatus.resendingOtp));

    final result = await resendOtpUseCase.call(
      SendOtpParams(mobile: state.mobileNumber!, email: state.email),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            otpStatus: OtpStatus.error,
            errorMessage: () => failure.message,
          ),
        );
        emit(state.copyWith(otpStatus: OtpStatus.initial));
      },
      (otpResponse) {
        _emitOtpSentState(emit, otpResponse, OtpStatus.otpResent);
        emit(state.copyWith(otpStatus: OtpStatus.initial));
        add(StartOtpTimer());
      },
    );
  }

  Future<void> _verifyOtp(VerifyOtpEvent event, Emitter<KycState> emit) async {
    emit(state.copyWith(otpStatus: OtpStatus.verifyingOtp));

    final result = await verifyOtpUseCase(
      VerifyOtpParams(
        otp: event.otp,
        mobile: event.mobile,
        email: state.email,
        channel: state.otpChannel ?? 'SMS',
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            otpStatus: OtpStatus.otpInvalid,
            errorMessage: () => failure.message,
          ),
        );
        emit(state.copyWith(otpStatus: OtpStatus.initial));
      },
      (verifyResult) {
        if (verifyResult.isVerified) {
          emit(
            state.copyWith(
              otpStatus: OtpStatus.otpVerified,
              kycOtpVerified: true,
            ),
          );
          emit(
            state.copyWith(otpStatus: OtpStatus.initial, kycOtpVerified: false),
          );
        } else {
          emit(state.copyWith(otpStatus: OtpStatus.otpInvalid));
          emit(state.copyWith(otpStatus: OtpStatus.initial));
        }
      },
    );
  }

  bool _timerCancelled = false;

  Future<void> _startTimer(StartOtpTimer event, Emitter<KycState> emit) async {
    _timerCancelled = true;
    await Future.delayed(Duration.zero);
    _timerCancelled = false;

    final int startFrom = state.otpTimer;

    await emit.forEach<int>(
      Stream.periodic(
        const Duration(seconds: 1),
        (tick) => tick + 1,
      ).take(startFrom).takeWhile((_) => !_timerCancelled),
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
    emit(
      state.copyWith(
        otpStatus: OtpStatus.initial,
        otpTimer: 0,
        canResend: false,
        kycOtpVerified: false,
        otpDisplayMessage: '',
        otpId: '',
        otp: '',
        errorMessage: () => null,
      ),
    );
    _timerCancelled = false;
  }

  void _emitOtpSentState(
    Emitter<KycState> emit,
    dynamic otpResponse,
    OtpStatus status,
  ) {
    if (otpResponse.isDefaultOtp) {
      emit(
        state.copyWith(
          otpStatus: status,
          otpDisplayMessage: 'The generated OTP is ${otpResponse.otp}',
          otpId: otpResponse.otpId,
          otp: otpResponse.otp,
          otpExpiryTime: otpResponse.validityTime,
          attemptRemaining: otpResponse.attemptRemaining,
          otpTimer: otpResponse.validityTime,
          otpChannel: otpResponse.channel,
          canResend: false,
        ),
      );
    } else {
      final displayMessage = otpResponse.channel == 'SMS'
          ? 'Enter the OTP sent to XXXXXX${state.mobileNumber!.substring(6)}'
          : 'Enter the OTP sent to ${state.email!}';

      emit(state.copyWith(otpDisplayMessage: displayMessage));
      emit(
        state.copyWith(
          otpStatus: status,
          otpId: '',
          otp: '',
          otpExpiryTime: otpResponse.validityTime,
          attemptRemaining: otpResponse.attemptRemaining,
          otpTimer: otpResponse.validityTime,
          canResend: false,
        ),
      );
    }
  }

  List<KycDynamicDocument> _updateDynamicDocs(
    List<KycDynamicDocument> docs,
    String name,
    KycDynamicDocument Function(KycDynamicDocument) update,
  ) {
    return docs.map((doc) => doc.name == name ? update(doc) : doc).toList();
  }

  List<KycDynamicDocument> _updateMergedDocs(
    List<KycDynamicDocument> docs,
    String name,
    KycDynamicDocument Function(KycDynamicDocument) update,
  ) {
    return docs.map((d) => d.name == name ? update(d) : d).toList();
  }

  List<KycDocumentParamEntity> _buildSubmitDynamicDocParams(
    List<KycDynamicDocument> docs,
  ) {
    return docs.where((doc) => doc.file != null).map((doc) {
      return KycDocumentParamEntity(
        file: doc.file,
        docName: doc.name,
        fileName:
            '${doc.name.replaceAll(' ', '')} ${DateTime.now().millisecondsSinceEpoch}.${doc.fileName.toString().split('.').last}',
        issuingDate: doc.showDates
            ? doc.issueDate?.toIso8601String().split('T').first
            : null,
        expiryDate: doc.showDates
            ? doc.expiryDate?.toIso8601String().split('T').first
            : null,
      );
    }).toList();
  }

  List<ExistingKycDocumentParamEntity> _buildExistingDocParams(
    List<Document> docs,
  ) {
    return docs.map((doc) {
      final hasNewFile =
          doc.file != null &&
          (doc.file is List
              ? (doc.file as List).isNotEmpty
              : doc.file.toString().isNotEmpty);

      return ExistingKycDocumentParamEntity(
        docRef: doc.docRef,
        docName: doc.docName,
        fileName: hasNewFile
            ? '${doc.docName.replaceAll(' ', '')} ${DateTime.now().millisecondsSinceEpoch}.${doc.fileName.toString().split('.').last}'
            : doc.fileName,
        docUrl: doc.docUrl,
        issuingDate: doc.issuingDate?.toIso8601String().split('T').first,
        verificationDate: doc.verificationDate,
        expiryDate: doc.expiryDate?.toIso8601String().split('T').first,
        extension: doc.extension,
        uploadFile: doc.uploadFile,
        filePath: doc.filePath,
        file: hasNewFile ? doc.file : null,
        docId: hasNewFile ? null : doc.docId,
      );
    }).toList();
  }

  List<KycDocumentParamEntity> _buildNewMergedDocParams(
    List<KycDynamicDocument> mergedDocs,
    List<Document> userDocs,
  ) {
    return mergedDocs
        .where((md) => md.file != null)
        .where(
          (md) => !userDocs.any(
            (ud) =>
                ud.docName.trim().toLowerCase() == md.name.trim().toLowerCase(),
          ),
        )
        .map(
          (md) => KycDocumentParamEntity(
            file: md.file,
            docName: md.name,
            fileName:
                '${md.name.replaceAll(' ', '')} ${DateTime.now().millisecondsSinceEpoch}.${md.fileName!.split('.').last}',
            issuingDate: md.showDates
                ? md.issueDate?.toIso8601String().split('T').first
                : null,
            expiryDate: md.showDates
                ? md.expiryDate?.toIso8601String().split('T').first
                : null,
          ),
        )
        .toList();
  }

  KycDocumentParamEntity _buildPhotoParam() {
    return KycDocumentParamEntity(
      file: state.photoFile,
      docName: 'Photo',
      fileName: (state.photoFile == null || state.photoFile!.isEmpty)
          ? state.photoName.toString()
          : 'photo ${DateTime.now().millisecondsSinceEpoch}.${state.photoName!.split('.').last}',
      docId: (state.photoFile == null || state.photoFile!.isEmpty) ?state.photoDocId : null,
    );
  }

  KycDocumentParamEntity _buildSignatureParam() {
    return KycDocumentParamEntity(
      file:state.signatureFile ,
      docName: 'Signature',
      fileName: (state.signatureFile == null ||
                    state.signatureFile!.isEmpty)
                ? state.signatureName.toString()
                : "signature ${DateTime.now().millisecondsSinceEpoch}.${state.signatureName!.split('.').last}",
      docId: (state.signatureFile == null || state.signatureFile!.isEmpty) ? state.signatureDocId: null,
    );
  }

  Document _entityToDocument(dynamic entity) {
    return Document(
      docRef: entity.docRef,
      file: entity.file,
      docName: entity.docName,
      docId: entity.docId,
      fileName: entity.fileName,
      docUrl: entity.docUrl,
      issuingDate: entity.issuingDate,
      verificationDate: entity.verificationDate,
      expiryDate: entity.expiryDate,
      extension: entity.extension,
      uploadFile: entity.uploadFile,
      filePath: entity.filePath,
    );
  }

  LocationOption _entityToLocationOption(LocationOptionEntity entity) {
    return LocationOption(
      id: entity.id,
      name: entity.name,
      parentId: entity.parentId,
    );
  }
}
