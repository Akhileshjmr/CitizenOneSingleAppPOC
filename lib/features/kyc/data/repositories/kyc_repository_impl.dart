import 'package:citizenone_app/core/error/failures.dart';
import 'package:citizenone_app/features/kyc/data/models/kyc_user_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/kyc_history_entity.dart';
import '../../domain/entities/kyc_params_entity.dart';
import '../../domain/entities/kyc_user_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/otp_entity.dart';
import '../../domain/repositories/kyc_repository.dart';
import '../datasources/kyc_local_data_source.dart';
import '../datasources/kyc_remote_data_source.dart';

class KycRepositoryImpl implements KycRepository {
  final KycRemoteDataSource remoteDataSource;
  final KycLocalDataSource localDataSource;

  KycRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ---------------------------------------------------------------------------
  // Search user
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, KycUserEntity>> searchKycUser({
    required String mobileNumber,
    required String nationalId,
  }) async {
    try {
      final model = await remoteDataSource.fetchKycUser(
        mobileNumber: mobileNumber,
        nationalId: nationalId,
      );

      if (model == null) {
        return const Left(ServerFailure('User not found'));
      }

      return Right(_mapKycDetailsToEntity(model.kycDetails));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Check user exists
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> checkKycUserExists({
    required String mobileNumber,
    required String nationalId,
  }) async {
    try {
      final model = await remoteDataSource.fetchKycUser(
        mobileNumber: mobileNumber,
        nationalId: nationalId,
      );
      // model != null means recordExists was true
      return Right(model != null);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Fetch locations
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, KycLocationsEntity>> fetchLocations() async {
    try {
      final raw = await remoteDataSource.fetchLocations();

      final List<LocationOptionEntity> countries = [];
      final List<LocationOptionEntity> states = [];
      final List<LocationOptionEntity> districts = [];
      final List<LocationOptionEntity> cities = [];
      final List<LocationOptionEntity> sectors = [];
      final List<KycDynamicDocumentEntity> dynamicDocuments = [];

      for (final group in raw['selectOptionList'] as List) {
        switch (group['key']) {
          case 'COUNTRIES':
            countries.addAll(
              (group['options'] as List)
                  .map((e) => _mapToLocationOptionEntity(e)),
            );
            break;
          case 'STATES':
            states.addAll(
              (group['options'] as List)
                  .map((e) => _mapToLocationOptionEntity(e)),
            );
            break;
          case 'DISTRICT':
            districts.addAll(
              (group['options'] as List)
                  .map((e) => _mapToLocationOptionEntity(e)),
            );
            break;
          case 'CITIES':
            cities.addAll(
              (group['options'] as List)
                  .map((e) => _mapToLocationOptionEntity(e)),
            );
            break;
          case 'SECTOR':
            sectors.addAll(
              (group['options'] as List)
                  .map((e) => _mapToLocationOptionEntity(e)),
            );
            break;
          case 'KYC DOCUMENTS':
            dynamicDocuments.addAll(
              (group['options'] as List)
                  .map((e) => _mapToDynamicDocEntity(e)),
            );
            break;
        }
      }

      return Right(KycLocationsEntity(
        countries: countries,
        states: states,
        districts: districts,
        cities: cities,
        sectors: sectors,
        dynamicDocuments: dynamicDocuments,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Recent history
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, KycHistoryResultEntity>> fetchRecentHistory(
    FetchHistoryParams params,
  ) async {
    try {
      final req = {
        'filterVal': params.filter,
        'addiParams': params.filter == 'CUSTOM'
            ? [
                DateFormat('yyyy-MM-dd').format(params.fromDate!),
                DateFormat('yyyy-MM-dd').format(params.toDate!),
              ]
            : [],
        'source': {
          'type': 'AGENT',
          'friendlyType': params.agentMobileNumber,
        },
        'paging': {
          'pageNum': params.page,
          'recsPerPage': '10',
        },
      };

      final model = await remoteDataSource.fetchRecentHistory(req);

      final items = (model.kycDetailsList ?? [])
          .map((d) => KycHistoryEntity(
                id: d.id,
                firstName: d.firstName,
                lastName: d.lastName,
                kycStatus: d.status,
                code: d.code,
                createdDate: d.createdDate,
                mobileNumber: d.mobileNumber,
                nationalId: d.nationalId,
              ))
          .toList();

      return Right(KycHistoryResultEntity(
        items: items,
        currentPage: model.paging?.pageNum ?? 1,
        totalPages: model.paging?.totalPages ?? 1,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Submit KYC
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, String>> submitKyc(SubmitKycParams params) async {
    try {
      final req = {
        'addiParams': ['CREATE'],
        'source': {
          'type': 'AGENT',
          'friendlyType': params.agentMobileNumber,
        },
        'kycDetails': {
          'firstName': params.firstName,
          'lastName': params.lastName,
          'gender': params.gender.toUpperCase(),
          'dob': params.dob,
          'monthlyIncome': params.monthlyIncome,
          'sourceFunds': params.sourceFunds,
          'mobileNumber': params.mobileNumber,
          'nationalId': params.nationalId,
          'empType': params.empType,
          'sector': params.sector,
          'employerName': params.employerName,
          'businessNature': params.businessNature,
          'businessName': params.businessName,
          'signature': _mapDocParam(params.signature),
          'photo': _mapDocParam(params.photo),
          'originCountry': _mapLocationRefParam(params.originCountry),
          'communication': {
            'email': params.email,
            'addressLine': params.addressLine,
            'phNumber': params.phNumber,
            'pbNumber': params.pbNumber ?? '',
            'country': _mapLocationRefParam(params.country),
            'state': _mapLocationRefParam(params.state),
            'district': _mapLocationRefParam(params.district),
            'city': _mapLocationRefParam(params.city),
          },
          'documents': params.documents.map(_mapDocParam).toList(),
        },
      };

      final result = await remoteDataSource.submitKyc(req);

      if (result.chMessage.code == 'SUCCESS') {
        final dynamic addiParams = result.addiParams;
        final String kycCode =
            (addiParams is List && addiParams.length > 1)
                ? addiParams[1]?.toString() ?? ''
                : '';
        return Right(kycCode);
      }

      return const Left(ServerFailure('KYC submission failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Update KYC
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> updateKyc(UpdateKycParams params) async {
    try {
      final req = {
        'addiParams': ['UPDATE'],
        'source': {
          'type': 'AGENT',
          'friendlyType': params.agentMobileNumber,
        },
        'kycDetails': {
          'id': params.kycId,
          'firstName': params.firstName,
          'lastName': params.lastName,
          'gender': params.gender.toUpperCase(),
          'dob': params.dob,
          'monthlyIncome': params.monthlyIncome,
          'sourceFunds': params.sourceFunds,
          'mobileNumber': params.mobileNumber,
          'nationalId': params.nationalId,
          'empType': params.empType,
          'sector': params.sector,
          'employerName': params.employerName,
          'businessNature': params.businessNature,
          'businessName': params.businessName,
          'kycStatus': params.kycStatus,
          'code': params.code,
          'signature': _mapDocParam(params.signature),
          'photo': _mapDocParam(params.photo),
          'originCountry': {
            ..._mapLocationRefParam(params.originCountry),
            'other': null,
          },
          'communication': {
            'email': params.email,
            'phNumber': params.phNumber,
            'pbNumber': params.pbNumber,
            'addressLine': params.addressLine,
            'country': {
              ..._mapLocationRefParam(params.country),
              'other': null,
            },
            'province': null,
            'district': {
              ..._mapLocationRefParam(params.district),
              'other': null,
            },
            'state': {
              ..._mapLocationRefParam(params.state),
              'other': null,
            },
            'city': {
              ..._mapLocationRefParam(params.city),
              'other': null,
            },
          },
          'documents': [
            ...params.existingDocuments.map(_mapExistingDocParam),
            ...params.newDocuments.map(_mapDocParam),
          ],
        },
      };

      final result = await remoteDataSource.submitKyc(req);

      if (result.chMessage.code == 'SUCCESS') {
        return const Right(true);
      }

      return const Left(ServerFailure('KYC update failed'));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Download
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, bool>> downloadDocument({
    required String url,
    required String fileName,
  }) async {
    try {
      final result = await remoteDataSource.downloadFile(
        url: url,
        fileName: fileName,
      );
      return result
          ? const Right(true)
          : const Left(ServerFailure('Download failed'));
    } catch (e) {
      return const Left(ServerFailure('Download failed'));
    }
  }

  // ---------------------------------------------------------------------------
  // OTP
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, OtpResponseEntity>> sendOtp(
    SendOtpParams params,
  ) async {
    try {
      final req = {
        'purpose': 'LOGIN',
        'referenceType': 'KYC_CUSTOMER',
        'addiParams': [params.mobile, params.email],
      };
      final model = await remoteDataSource.sendOtp(req);
      return Right(_mapOtpResponseToEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, OtpResponseEntity>> resendOtp(
    SendOtpParams params,
  ) async {
    try {
      final req = {
        'purpose': 'LOGIN',
        'referenceType': 'KYC_CUSTOMER',
        'addiParams': [params.mobile, params.email],
      };
      final model = await remoteDataSource.resendOtp(req);
      return Right(_mapOtpResponseToEntity(model));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, OtpVerifyResultEntity>> verifyOtp(
    VerifyOtpParams params,
  ) async {
    try {
      final req = {
        'channel': params.channel,
        'destination':
            params.channel == 'SMS' ? params.mobile : params.email,
        'purpose': 'LOGIN',
        'referenceType': 'KYC_CUSTOMER',
        'otp': params.otp,
      };
      final model = await remoteDataSource.verifyOtp(req);
      return Right(OtpVerifyResultEntity(
        isVerified: model.chMessage.isError == false,
        status: model.status,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // ---------------------------------------------------------------------------
  // Local — agent mobile
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, String>> getAgentMobileNumber() async {
    try {
      final mobile = await localDataSource.getAgentMobileNumber();
      return Right(mobile);
    } catch (e) {
      return const Left(LocalFailure('Unable to read agent mobile'));
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  KycUserEntity _mapKycDetailsToEntity(KycDetails d) {
    return KycUserEntity(
      id: d.id,
      firstName: d.firstName,
      lastName: d.lastName,
      gender: d.gender,
      dob: d.dob,
      monthlyIncome: d.monthlyIncome,
      sourceFunds: d.sourceFunds,
      mobileNumber: d.mobileNumber,
      nationalId: d.nationalId,
      empType: d.empType,
      sector: d.sector,
      employerName: d.employerName,
      businessNature: d.businessNature,
      businessName: d.businessName,
      kycStatus: d.kycStatus,
      code: d.code,
      status: d.status,
      createdDate: d.createdDate,
      originCountry: d.originCountry != null
          ? LocationRefEntity(
              id: d.originCountry!.id,
              type: d.originCountry!.type,
              friendlyType: d.originCountry!.friendlyType,
            )
          : null,
      communication: d.communication != null
          ? _mapCommunicationToEntity(d.communication!)
          : null,
      documents: d.documents?.map(_mapDocumentToEntity).toList(),
      signature: d.signature != null ? _mapDocumentToEntity(d.signature!) : null,
      photo: d.photo != null ? _mapDocumentToEntity(d.photo!) : null,
    );
  }

  KycCommunicationEntity _mapCommunicationToEntity(Communication c) {
    return KycCommunicationEntity(
      email: c.email,
      phNumber: c.phNumber,
      pbNumber: c.pbNumber,
      addressLine: c.addressLine,
      country: c.country != null
          ? LocationRefEntity(
              id: c.country!.id,
              type: c.country!.type,
              friendlyType: c.country!.friendlyType,
            )
          : null,
      state: c.state != null
          ? LocationRefEntity(
              id: c.state!.id,
              type: c.state!.type,
              friendlyType: c.state!.friendlyType,
            )
          : null,
      district: c.district != null
          ? LocationRefEntity(
              id: c.district!.id,
              type: c.district!.type,
              friendlyType: c.district!.friendlyType,
            )
          : null,
      city: c.city != null
          ? LocationRefEntity(
              id: c.city!.id,
              type: c.city!.type,
              friendlyType: c.city!.friendlyType,
            )
          : null,
    );
  }

  KycDocumentEntity _mapDocumentToEntity(Document d) {
    return KycDocumentEntity(
      docRef: d.docRef,
      file: d.file,
      docName: d.docName,
      docId: d.docId,
      fileName: d.fileName,
      docUrl: d.docUrl,
      issuingDate: d.issuingDate,
      verificationDate: d.verificationDate,
      expiryDate: d.expiryDate,
      extension: d.extension,
      uploadFile: d.uploadFile,
      filePath: d.filePath,
    );
  }

  LocationOptionEntity _mapToLocationOptionEntity(Map<String, dynamic> json) {
    return LocationOptionEntity(
      id: json['id'],
      name: json['friendlyType'] ?? json['type'],
      parentId: json['other']?['id'],
    );
  }

  KycDynamicDocumentEntity _mapToDynamicDocEntity(Map<String, dynamic> json) {
    return KycDynamicDocumentEntity(
      name: json['friendlyType'],
      isMandatory: json['other']?['type'] == 'true',
      showDates: json['other']?['friendlyType'] == 'true',
    );
  }

  OtpResponseEntity _mapOtpResponseToEntity(dynamic model) {
    return OtpResponseEntity(
      otpId: model.otpId,
      otp: model.otp,
      isDefaultOtp: model.isDefaultOtp,
      attemptRemaining: model.attemptRemaining,
      validityTime: model.validityTime,
      status: model.status,
      channel: model.channel,
      isLocked: model.isLocked,
    );
  }

  Map<String, dynamic> _mapDocParam(KycDocumentParamEntity doc) {
    return {
      if (doc.file != null) 'file': doc.file,
      'docName': doc.docName,
      'fileName': doc.fileName,
      if (doc.issuingDate != null) 'issuingDate': doc.issuingDate,
      if (doc.expiryDate != null) 'expiryDate': doc.expiryDate,
      if (doc.docId != null) 'docId': doc.docId,
    };
  }

  Map<String, dynamic> _mapExistingDocParam(
    ExistingKycDocumentParamEntity doc,
  ) {
    return {
      'docRef': doc.docRef,
      'docName': doc.docName,
      'fileName': doc.fileName,
      'docUrl': doc.docUrl,
      'issuingDate': doc.issuingDate,
      'verificationDate': doc.verificationDate,
      'expiryDate': doc.expiryDate,
      'extension': doc.extension,
      'uploadFile': doc.uploadFile,
      'filePath': doc.filePath,
      if (doc.file != null && (doc.file as dynamic).isNotEmpty)
        'file': doc.file,
      if (doc.file == null || (doc.file as dynamic).isEmpty)
        'docId': doc.docId,
    };
  }

  Map<String, dynamic> _mapLocationRefParam(KycLocationRefParamEntity loc) {
    return {
      'id': loc.id,
      'type': loc.name,
      'friendlyType': loc.name,
    };
  }
}
