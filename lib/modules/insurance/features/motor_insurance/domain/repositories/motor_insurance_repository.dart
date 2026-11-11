import 'package:dartz/dartz.dart';
import 'package:citizenone_app/modules/insurance/core/error/failures.dart';
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
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/generate_motor_otp_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/issue_policy_by_quoteid_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/request_payment_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_invoice_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/print_receipt_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/vehicle_create_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/verify_motor_otp_usecase.dart';

import '../../data/models/motor_otp_model.dart';
import '../entities/key_facts_document_entity.dart';
import '../entities/kyc_user_entity.dart';

abstract class MotorInsuranceRepository {
  Future<Either<Failure, KycUserEntity>> searchKycUser({
    required String mobileNumber,
    required String nationalId,
  });
  Future<Either<Failure, KycUserEntity>> searchInsuranceUser({
    required String phoneNumber,
    required String nationalId,
  });

  Future<Either<Failure, MotorMaintainenceResponseModel>>
      getMotorMaintainence();
  Future<Either<Failure, RiskCategoryResponseModel>> getRiskCategories();

  Future<Either<Failure, VehicleDetailsResponse>> fetchVehicleDetails({
    required String registrationNo,
  });
  Future<Either<Failure, MotorInsuranceMasterData>> masterData();

  Future<Either<Failure, VehicleCreateResponse>> createVehicle({
    required VehicleCreateParams vehicleParams,
  });

  Future<Either<Failure, MotorOtpResponseModel>> generateMotorOtp({
    required GenerateMotorOtpParams params,
  });

  Future<Either<Failure, MotorOtpVerifyResponseModel>> verifyMotorOtp({
    required VerifyMotorOtpParams params,
  });

  Future<Either<Failure, QuotationResponse>> compareQuotation({
    required CompareQuotationParams params,
  });

  Future<Either<Failure, CreateQuotationModel>> createQuotation(
      CreateQuotationParams params);

  Future<Either<Failure, CreateIndividualResponseModel>> createIndividualUser({
    required CustomerDetails customerDetails,
  });

  Future<Either<Failure, InstantIssueResponse>> createInstantIssue(
      CreateInstantIssueParams params);

  Future<Either<Failure, bool>> downloadInvoice(
      {required DownloadInvoiceParams params});

  Future<Either<Failure, bool>> printReceipt(
      {required PrintReceiptParams params});

  Future<Either<Failure, InsuranceTransactionListResponseModel>>
      fetchInsuranceTransactions(
          {required int page,
          int size = 20,
          String? search,
          DateTime? fromDate,
          DateTime? toDate,
          required String agentCode,
          required String vendorCode});

  Future<Either<Failure, PaymentRequestResponse>> requestPayment(
      RequestPaymentParams params);

  Future<Either<Failure, IssuePolicyByQuoteIdResponse>> issuePolicyByQuoteId(
      IssuePolicyByQuoteidParams params);

  Future<Either<Failure, MotorProductDetailsResponseModel>>
      fetchMotorProductDetails(String productId);

  Future<Either<Failure, bool>> sendSMSForPolicyKeyFacts(
      {required String productId, required String customerPhoneNumber});

  Future<Either<Failure, KeyFactsDocumentEntity>> downloadKeyFactsDocument(
      {required String productId});
}
