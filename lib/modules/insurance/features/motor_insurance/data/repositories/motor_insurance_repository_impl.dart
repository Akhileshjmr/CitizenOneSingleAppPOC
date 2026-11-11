import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/data_sources/motor_insurance_remote_data_source.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_individual_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_quotation_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/instant_issue_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/insurance_transaction_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/issue_policy_by_quote_id.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_product_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/payment_request_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/risk_category_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_create_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/compare_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_instant_issue_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_invoice_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/issue_policy_by_quoteid_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/print_receipt_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/vehicle_create_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/verify_motor_otp_usecase.dart';

import '../../domain/entities/key_facts_document_entity.dart';
import '../../domain/entities/kyc_user_entity.dart';
import '../../domain/repositories/motor_insurance_repository.dart';
import '../../domain/usecases/generate_motor_otp_usecase.dart';
import '../../domain/usecases/request_payment_usecase.dart';
import '../models/motor_otp_model.dart';

class MotorInsuranceRepositoryImpl implements MotorInsuranceRepository {
  final MotorInsuraceRemoteDataSource remoteDataSource;

  MotorInsuranceRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, MotorMaintainenceResponseModel>>
      getMotorMaintainence() async {
    try {
      final model = await remoteDataSource.getMotorMaintainence();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, RiskCategoryResponseModel>> getRiskCategories() async {
    try {
      final model = await remoteDataSource.getRiskCategories();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, VehicleDetailsResponse>> fetchVehicleDetails({
    required String registrationNo,
  }) async {
    try {
      final model = await remoteDataSource.fetchVehicleDetails(
          registrationNo: registrationNo);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, KycUserEntity>> searchKycUser({
    required String mobileNumber,
    required String nationalId,
  }) async {
    try {
      // final model = await remoteDataSource.fetchKycUser(
      //   mobileNumber: mobileNumber,
      //   nationalId: nationalId,
      // );

      // if (model != null && model.recordExists) {
      //   return Right(_mapKycDetailsToEntity(model.kycDetails!));
      // }
      final fallbackModel = await remoteDataSource.fetchInsuranceUser(
        phoneNumber: mobileNumber,
        nationalId: nationalId,
      );

      if (fallbackModel != null && fallbackModel.data != null) {
        return Right(
            _mapCustomerDataToEntity(fallbackModel.data!, isKycData: false));
      } else if (fallbackModel?.chMessage?.isError ?? false) {
        return Left(ServerFailure(fallbackModel!.chMessage!.message!));
      }
      return const Left(ServerFailure('User not found'));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, KycUserEntity>> searchInsuranceUser({
    required String phoneNumber,
    required String nationalId,
  }) async {
    try {
      final model = await remoteDataSource.fetchInsuranceUser(
        phoneNumber: phoneNumber,
        nationalId: nationalId,
      );

      if (model == null || model.data == null) {
        return const Left(ServerFailure('User not found'));
      }

      return Right(_mapCustomerDataToEntity(model.data!));
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, VehicleCreateResponse>> createVehicle({
    required VehicleCreateParams vehicleParams,
  }) async {
    try {
      final model = await remoteDataSource.createVehicle(
        vehicleParams: vehicleParams,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> downloadInvoice(
      {required DownloadInvoiceParams params}) async {
    try {
      final result = await remoteDataSource.downloadInvoice(params: params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, MotorInsuranceMasterData>> masterData() async {
    try {
      final result = await remoteDataSource.fetchMasterData();
      return Right(result);
    } catch (e) {
      return const Left(ServerFailure('Download failed'));
    }
  }

  @override
  Future<Either<Failure, MotorOtpResponseModel>> generateMotorOtp({
    required GenerateMotorOtpParams params,
  }) async {
    try {
      final model = await remoteDataSource.generateMotorOtp(params: params);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, MotorOtpVerifyResponseModel>> verifyMotorOtp({
    required VerifyMotorOtpParams params,
  }) async {
    try {
      final model = await remoteDataSource.verifyMotorOtp(params: params);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, QuotationResponse>> compareQuotation({
    required CompareQuotationParams params,
  }) async {
    try {
      final model = await remoteDataSource.compareQuotation(
        params: params,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // KycUserEntity _mapKycDetailsToEntity(KycDetails d) {
  //   return KycUserEntity(
  //     id: d.id!,
  //     firstName: d.firstName!,
  //     lastName: d.lastName!,
  //     gender: d.gender!,
  //     dob: d.dob!,
  //     monthlyIncome: d.monthlyIncome!,
  //     sourceFunds: d.sourceFunds!,
  //     mobileNumber: d.mobileNumber!,
  //     nationalId: d.nationalId!,
  //     empType: d.empType!,
  //     sector: d.sector!,
  //     employerName: d.employerName!,
  //     businessNature: d.businessNature,
  //     businessName: d.businessName,
  //     kycStatus: d.kycStatus,
  //     code: d.code,
  //     status: d.status,
  //     createdDate: d.createdDate,
  //     originCountry: d.originCountry != null
  //         ? LocationRefEntity(
  //             id: d.originCountry!.id!,
  //             type: d.originCountry!.type,
  //             friendlyType: d.originCountry!.friendlyType!,
  //           )
  //         : null,
  //     communication: d.communication != null
  //         ? _mapCommunicationToEntity(d.communication!)
  //         : null,
  //     documents: d.documents.map(_mapDocumentToEntity).toList(),
  //     signature:
  //         d.signature != null ? _mapDocumentToEntity(d.signature!) : null,
  //     photo: d.photo != null ? _mapDocumentToEntity(d.photo!) : null,
  //   );
  // }

  KycUserEntity _mapCustomerDataToEntity(CustomerData d,
      {bool isKycData = true}) {
    // Map fallback API response (CustomerData) to KycUserEntity
    // Note: Some fields are required in KycUserEntity but optional in CustomerData,
    // so we use default values for missing fields
    if (isKycData) {
      return KycUserEntity(
        id: 0, // CustomerData uses string ID, default to 0 for int required field
        firstName: d.firstName ?? '',
        lastName: d.lastName ?? '',
        gender: d.gender ?? 'OTHER',
        dob: '',
        monthlyIncome: 0,
        sourceFunds: '',
        mobileNumber: d.phoneNumber ?? '',
        nationalId: d.idNumber ?? '',
        empType: '',
        sector: '',
        employerName: '',
        businessNature: null,
        businessName: null,
        kycStatus: d.status,
        code: d.id,
        status: d.status,
        createdDate: d.createdAt?.toIso8601String(),
        originCountry: null,
        communication: null,
        documents: [],
        signature: null,
        photo: null,
      );
    } else {
      return KycUserEntity(
        id: 0, // CustomerData uses string ID, default to 0 for int required field
        firstName: d.firstName ?? '',
        lastName: d.lastName ?? '',
        gender: d.gender ?? 'OTHER',
        dob: '',
        monthlyIncome: 0,
        sourceFunds: '',
        mobileNumber: d.phoneNumber?.substring(3, d.phoneNumber?.length) ?? '',
        nationalId: d.idNumber ?? '',
        empType: '',
        sector: '',
        employerName: '',
        businessNature: null,
        businessName: null,
        kycStatus: d.status,
        code: d.id,
        status: d.status,
        createdDate: d.createdAt?.toIso8601String(),
        originCountry: null,
        communication: KycCommunicationEntity(
            email: d.email!,
            phNumber: '',
            pbNumber: '',
            addressLine: d.physicalAddress!),
        documents: [],
        signature: null,
        photo: null,
      );
    }
  }

  // KycCommunicationEntity _mapCommunicationToEntity(Communication c) {
  //   return KycCommunicationEntity(
  //     email: c.email!,
  //     phNumber: c.phNumber!,
  //     pbNumber: c.pbNumber!,
  //     addressLine: c.addressLine!,
  //     country: c.country != null
  //         ? LocationRefEntity(
  //             id: c.country!.id!,
  //             type: c.country!.type,
  //             friendlyType: c.country!.friendlyType!,
  //           )
  //         : null,
  //     state: c.state != null
  //         ? LocationRefEntity(
  //             id: c.state!.id!,
  //             type: c.state!.type,
  //             friendlyType: c.state!.friendlyType!,
  //           )
  //         : null,
  //     district: c.district != null
  //         ? LocationRefEntity(
  //             id: c.district!.id!,
  //             type: c.district!.type,
  //             friendlyType: c.district!.friendlyType!,
  //           )
  //         : null,
  //     city: c.city != null
  //         ? LocationRefEntity(
  //             id: c.city!.id!,
  //             type: c.city!.type,
  //             friendlyType: c.city!.friendlyType!,
  //           )
  //         : null,
  //   );
  // }

  // KycDocumentEntity _mapDocumentToEntity(Document d) {
  //   return KycDocumentEntity(
  //     docRef: d.docRef,
  //     file: d.file,
  //     docName: d.docName,
  //     docId: d.docId,
  //     fileName: d.fileName,
  //     docUrl: d.docUrl,
  //     issuingDate: d.issuingDate,
  //     verificationDate: d.verificationDate,
  //     expiryDate: d.expiryDate,
  //     extension: d.extension,
  //     uploadFile: d.uploadFile,
  //     filePath: d.filePath,
  //   );
  // }

  @override
  Future<Either<Failure, CreateQuotationModel>> createQuotation(
      CreateQuotationParams createQuotationParams) async {
    try {
      final result = await remoteDataSource.createQuotation(
          createQuotationParams: createQuotationParams);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, CreateIndividualResponseModel>> createIndividualUser({
    required CustomerDetails customerDetails,
  }) async {
    try {
      final result = await remoteDataSource.createIndividualUser(
        customerDetails: customerDetails,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, InstantIssueResponse>> createInstantIssue(
      CreateInstantIssueParams params) async {
    try {
      final result = await remoteDataSource.createInstantIssue(params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> printReceipt(
      {required PrintReceiptParams params}) async {
    try {
      final result = await remoteDataSource.printReceipt(params: params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, InsuranceTransactionListResponseModel>>
      fetchInsuranceTransactions(
          {required int page,
          int size = 20,
          String? search,
          DateTime? fromDate,
          DateTime? toDate,
          required String agentCode,
          required String vendorCode}) async {
    try {
      final response = await remoteDataSource.fetchInsuranceTransactions(
        page: page,
        size: size,
        search: search,
        fromDate: fromDate,
        toDate: toDate,
        agentCode: agentCode,
        vendorCode: vendorCode,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, PaymentRequestResponse>> requestPayment(
      RequestPaymentParams params) async {
    try {
      final result = await remoteDataSource.requestPayment(params: params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, IssuePolicyByQuoteIdResponse>> issuePolicyByQuoteId(
      IssuePolicyByQuoteidParams params) async {
    try {
      final result =
          await remoteDataSource.issuePolicyByQuoteId(params: params);
      return Right(result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, MotorProductDetailsResponseModel>>
      fetchMotorProductDetails(String productId) async {
    try {
      final model = await remoteDataSource.fetchMotorProductDetails(productId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> sendSMSForPolicyKeyFacts(
      {required String productId, required String customerPhoneNumber}) async {
    try {
      final model = await remoteDataSource.sendSMSForPolicyKeyFacts(
          productId: productId, customerPhoneNumber: customerPhoneNumber);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, KeyFactsDocumentEntity>> downloadKeyFactsDocument(
      {required String productId}) async {
    try {
      final model =
          await remoteDataSource.downloadKeyFactsDocument(productId: productId);
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
