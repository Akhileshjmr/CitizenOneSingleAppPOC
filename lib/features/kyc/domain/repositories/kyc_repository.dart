// features/kyc/domain/repositories/kyc_repository.dart

import 'package:citizenone_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../entities/kyc_history_entity.dart';
import '../entities/kyc_params_entity.dart';
import '../entities/kyc_user_entity.dart';
import '../entities/location_entity.dart';
import '../entities/otp_entity.dart';

abstract class KycRepository {
  /// Search for a KYC user by mobile or national ID.
  /// Returns [KycUserEntity] if found, [Failure] otherwise.
  Future<Either<Failure, KycUserEntity>> searchKycUser({
    required String mobileNumber,
    required String nationalId,
  });

  /// Check if a KYC user exists — lightweight version used before
  /// navigating to the KYC form.
  Future<Either<Failure, bool>> checkKycUserExists({
    required String mobileNumber,
    required String nationalId,
  });

  /// Fetch all location dropdowns and dynamic document config
  /// in a single call (countries, states, districts, cities,
  /// sectors, KYC document types).
  Future<Either<Failure, KycLocationsEntity>> fetchLocations();

  /// Fetch paginated KYC recent history for the agent.
  Future<Either<Failure, KycHistoryResultEntity>> fetchRecentHistory(
    FetchHistoryParams params,
  );

  /// Submit a new KYC record.
  /// Returns the generated KYC code on success.
  Future<Either<Failure, String>> submitKyc(SubmitKycParams params);

  /// Update an existing KYC record.
  Future<Either<Failure, bool>> updateKyc(UpdateKycParams params);

  /// Download a document file by URL.
  Future<Either<Failure, bool>> downloadDocument({
    required String url,
    required String fileName,
  });

  /// Send OTP to the customer's mobile / email.
  Future<Either<Failure, OtpResponseEntity>> sendOtp(SendOtpParams params);

  /// Resend OTP.
  Future<Either<Failure, OtpResponseEntity>> resendOtp(SendOtpParams params);

  /// Verify OTP entered by the customer.
  Future<Either<Failure, OtpVerifyResultEntity>> verifyOtp(
    VerifyOtpParams params,
  );

  /// Read the logged-in agent's mobile number from local storage.
  Future<Either<Failure, String>> getAgentMobileNumber();
}
