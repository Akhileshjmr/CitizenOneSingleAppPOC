// ignore_for_file: inference_failure_on_collection_literal, avoid_dynamic_calls, inference_failure_on_function_invocation

import 'dart:convert';
import 'dart:io' as io;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:citizenone_app/modules/insurance/core/config/app_config.dart';
import 'package:citizenone_app/modules/insurance/core/constants/api_constants.dart';
import 'package:citizenone_app/modules/insurance/core/di/di_setup.dart';
import 'package:citizenone_app/modules/insurance/core/network/dio_client.dart';
import 'package:citizenone_app/modules/insurance/core/services/secure_storage_service.dart';
import 'package:citizenone_app/modules/insurance/core/services/thermal_printer_service.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_individual_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/create_quotation_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/customer_details_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/instant_issue_response.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/insurance_transaction_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/issue_policy_by_quote_id.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/kyc_user_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/master_data_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_maintainence_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_otp_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/motor_product_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/quotation_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/risk_category_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_create_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/data/models/vehicle_details_response_model.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/key_facts_document_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/entities/master_data_entity.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/compare_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_instant_issue_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/create_quotation_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/download_invoice_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/generate_motor_otp_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/issue_policy_by_quoteid_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/print_receipt_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/request_payment_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/vehicle_create_usecase.dart';
import 'package:citizenone_app/modules/insurance/features/motor_insurance/domain/usecases/verify_motor_otp_usecase.dart';
import 'package:universal_html/html.dart';

import '../models/payment_request_response.dart';

abstract class MotorInsuraceRemoteDataSource {
  Future<SearchKycUserResponse?> fetchKycUser({
    required String mobileNumber,
    required String nationalId,
  });
  Future<CreateIndividualResponseModel?> fetchInsuranceUser({
    required String phoneNumber,
    required String nationalId,
  });
  Future<bool> downloadInvoice({required DownloadInvoiceParams params});
  Future<bool> printReceipt({required PrintReceiptParams params});

  Future<MotorMaintainenceResponseModel> getMotorMaintainence();
  Future<RiskCategoryResponseModel> getRiskCategories();

  Future<VehicleDetailsResponse> fetchVehicleDetails(
      {required String registrationNo});

  Future<MotorInsuranceMasterData> fetchMasterData();
  Future<VehicleCreateResponse> createVehicle(
      {required VehicleCreateParams vehicleParams});
  Future<MotorOtpResponseModel> generateMotorOtp({
    required GenerateMotorOtpParams params,
  });
  Future<MotorOtpVerifyResponseModel> verifyMotorOtp({
    required VerifyMotorOtpParams params,
  });
  Future<QuotationResponse> compareQuotation(
      {required CompareQuotationParams params});

  Future<CreateQuotationModel> createQuotation(
      {required CreateQuotationParams createQuotationParams});

  Future<CreateIndividualResponseModel> createIndividualUser({
    required CustomerDetails customerDetails,
  });

  Future<InstantIssueResponse> createInstantIssue(
      CreateInstantIssueParams params);

  Future<InsuranceTransactionListResponseModel> fetchInsuranceTransactions({
    required int page,
    int size = 20,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
    required String agentCode,
    required String vendorCode,
  });

  Future<PaymentRequestResponse> requestPayment({
    required RequestPaymentParams params,
  });

  Future<IssuePolicyByQuoteIdResponse> issuePolicyByQuoteId(
      {required IssuePolicyByQuoteidParams params});

  Future<MotorProductDetailsResponseModel> fetchMotorProductDetails(
      String productId);

  Future<bool> sendSMSForPolicyKeyFacts(
      {required String productId, required String customerPhoneNumber});

  Future<KeyFactsDocumentEntity> downloadKeyFactsDocument(
      {required String productId});
}

class MotorInsuraceRemoteDataSourceImpl
    implements MotorInsuraceRemoteDataSource {
  final DioClient apiClient;

  MotorInsuraceRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MotorProductDetailsResponseModel> fetchMotorProductDetails(
      String productId) async {
    try {
      final response = await apiClient.dio.get(
        '${ApiConstants.getMotorProductDetails}/$productId',
      );

      if (response.statusCode == 200) {
        return MotorProductDetailsResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SearchKycUserResponse?> fetchKycUser({
    required String mobileNumber,
    required String nationalId,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.searchKycUser,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConfig.staticProfittoAccessToken}'
          },
        ),
        data: {'mobile': mobileNumber.trim(), 'nationalId': nationalId.trim()},
      );

      if (response.statusCode == 200) {
        if (response.data['recordExists'] == true) {
          return SearchKycUserResponse.fromJson(
              response.data as Map<String, dynamic>);
        }
        return null;
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateIndividualResponseModel?> fetchInsuranceUser({
    required String phoneNumber,
    required String nationalId,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {};
      if (phoneNumber.isNotEmpty) {
        requestBody['phone'] = '260$phoneNumber';
      }
      if (nationalId.isNotEmpty) {
        requestBody['nationalId'] = nationalId;
      }

      final response = await apiClient.dio.post(
        ApiConstants.searchInsuranceUser,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        // Check if chMessage indicates success and data exists
        final chMessage = data['chMessage'];
        if (chMessage != null && chMessage['code'] == 'SUCCESS') {
          final userData = data['data'];
          if (userData != null) {
            return CreateIndividualResponseModel.fromJson(
                response.data as Map<String, dynamic>);
          }
        }
        // No user found
        return null;
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception('User Not Found');
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> downloadInvoice({required DownloadInvoiceParams params}) async {
    final fullUrl =
        '${ApiConstants.downloadInvoiceUrl}/${params.policyId}/document';

    try {
      if (kIsWeb) {
        final response = await apiClient.dio.get(
          fullUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = Uint8List.fromList(response.data as List<int>);
        final blob = Blob([bytes]);
        final objectUrl = Url.createObjectUrl(blob);
        final sanitizedFileName =
            params.policyId.replaceAll(RegExp(r'[^\w\.-]'), '_');
        AnchorElement(href: objectUrl)
          ..setAttribute('download', '$sanitizedFileName.pdf')
          ..click();
        Url.revokeObjectUrl(objectUrl);
        return true;
      }

      final tempDir = await getTemporaryDirectory();
      final sanitizedPolicyId =
          params.policyId.replaceAll(RegExp(r'[^\w\.-]'), '_');
      final tempSavePath = '${tempDir.path}/$sanitizedPolicyId.pdf';

      await apiClient.dio.download(fullUrl, tempSavePath);

      try {
        final saveParams = SaveFileDialogParams(
          sourceFilePath: tempSavePath,
        );
        final finalPath = await FlutterFileDialog.saveFile(params: saveParams);
        if (finalPath != null) {
          return true;
        }
      } catch (dialogError) {
        debugPrint('FlutterFileDialog error in module mode: $dialogError');
      }

      String? publicPath;
      try {
        final extDirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (extDirs != null && extDirs.isNotEmpty) {
          final targetFile =
              io.File('${extDirs.first.path}/$sanitizedPolicyId.pdf');
          await io.File(tempSavePath).copy(targetFile.path);
          publicPath = targetFile.path;
        }
      } catch (_) {}

      if (publicPath == null) {
        try {
          final extDir = await getExternalStorageDirectory();
          if (extDir != null) {
            final targetFile = io.File('${extDir.path}/$sanitizedPolicyId.pdf');
            await io.File(tempSavePath).copy(targetFile.path);
            publicPath = targetFile.path;
          }
        } catch (_) {}
      }

      final activePath = publicPath ?? tempSavePath;

      return await io.File(activePath).exists();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Download failed: $e');
    }
  }

  @override
  Future<MotorMaintainenceResponseModel> getMotorMaintainence() async {
    try {
      final response =
          await apiClient.dio.get(ApiConstants.getMotorMaintainence);

      if (response.statusCode == 200) {
        return MotorMaintainenceResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RiskCategoryResponseModel> getRiskCategories() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.getRiskCategories);

      if (response.statusCode == 200) {
        return RiskCategoryResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VehicleDetailsResponse> fetchVehicleDetails(
      {required String registrationNo}) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.fetchVehicleDetails,
        data: {'registrationNumber': registrationNo.replaceAll(' ', '')},
      );
      if (response.statusCode == 200) {
        return VehicleDetailsResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MotorInsuranceMasterData> fetchMasterData() async {
    try {
      final response = await apiClient.dio.get(ApiConstants.fetchMasterDataUrl);
      if (response.statusCode == 200) {
        return MotorInsuranceMasterDataModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<VehicleCreateResponse> createVehicle(
      {required VehicleCreateParams vehicleParams}) async {
    try {
      final dynamic requestBody = {
        'clientId': vehicleParams.clientId.isEmpty
            ? 'WMme7BMm'
            : vehicleParams.clientId,
        'make': vehicleParams.vehicleCreateEntity.vehicleMake,
        'model': vehicleParams.vehicleCreateEntity.vehicleModel,
        'yearOfManufacture':
            vehicleParams.vehicleCreateEntity.yearOfManufacture,
        'registrationNumber':
            vehicleParams.vehicleCreateEntity.registrationNumber,
        'chassisNumber': vehicleParams.vehicleCreateEntity.chassisNumber,
        'engineNumber': vehicleParams.vehicleCreateEntity.engineNumber,
        'motorRiskCategoryId':
            vehicleParams.vehicleCreateEntity.motorRiskCategoryId,
        'riskCategoryName': vehicleParams.vehicleCreateEntity.riskCategoryName,
        'color': vehicleParams.vehicleCreateEntity.vehicleColor,
        'sumInsured': vehicleParams.vehicleCreateEntity.sumInsured,
        'capacity': vehicleParams.vehicleCreateEntity.capacity,
        'tonnage': vehicleParams.vehicleCreateEntity.tonnage,
        'seatingCapacity': vehicleParams.vehicleCreateEntity.seatingCapacity,
      };

      final response = await apiClient.dio
          .post(ApiConstants.createVehicle, data: requestBody);
      if (response.statusCode == 200) {
        return VehicleCreateResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MotorOtpResponseModel> generateMotorOtp({
    required GenerateMotorOtpParams params,
  }) async {
    try {
      final request = MotorOtpRequestModel(
        purpose: params.purpose,
        referenceType: params.referenceType,
        addiParams: [params.destination],
      );

      final response = await apiClient.dio.post(
        ApiConstants.getMotorInsuranceOtp,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return MotorOtpResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }

      throw Exception(_extractErrorMessage(response.data));
    } on DioException catch (e) {
      throw Exception(_mapDioException(e));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MotorOtpVerifyResponseModel> verifyMotorOtp({
    required VerifyMotorOtpParams params,
  }) async {
    try {
      final request = MotorOtpVerifyRequestModel(
        channel: params.channel,
        destination: params.destination,
        purpose: params.purpose,
        referenceType: params.referenceType,
        otp: params.otp,
      );

      final response = await apiClient.dio.post(
        ApiConstants.verifyMotorInsuranceOtp,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return MotorOtpVerifyResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception(_extractErrorMessage(response.data));
    } on DioException catch (e) {
      throw Exception(_mapDioException(e));
    } catch (e) {
      rethrow;
    }
  }

  String _mapDioException(DioException e) {
    final data = e.response?.data;
    final backendMessage = _extractErrorMessage(data);
    if (backendMessage.isNotEmpty) return backendMessage;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again.';
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed. Please try again.';
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return 'Something went wrong. Please try again.';
      default:
        return '';
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final chMessage = data['chMessage'];
      if (chMessage is Map<String, dynamic>) {
        final message = chMessage['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }
      final dataNode = data['data'];
      if (dataNode is Map<String, dynamic>) {
        final nestedMessage = dataNode['chMessage'];
        if (nestedMessage is Map<String, dynamic>) {
          final message = nestedMessage['message'];
          if (message is String && message.trim().isNotEmpty) {
            return message;
          }
        }
      }
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return '';
  }

  @override
  Future<QuotationResponse> compareQuotation(
      {required CompareQuotationParams params}) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.compareQuotation,
        data: {
          'productType': params.productType,
          'currency': params.currency,
          'duration': params.duration,
          'durationType': params.durationType,
          'startDate': params.startDate,
          'policyHolder': {
            'type': params.policyHolder.type,
            'name': params.policyHolder.name,
            'phone': params.policyHolder.phone,
            'physicalAddress': params.policyHolder.physicalAddress,
            'email': params.policyHolder.email,
            'idType': params.policyHolder.idType,
            'idNumber': params.policyHolder.idNumber
          },
          'risks': [
            {
              'make': params.risks.first.make,
              'model': params.risks.first.model,
              'yearOfManufacture': params.risks.first.yearOfManufacture,
              'registrationNumber': params.risks.first.registrationNumber,
              'chassisNumber': params.risks.first.chassisNumber,
              'engineNumber': params.risks.first.engineNumber,
              'sumInsured': params.risks.first.sumInsured,
              'currency': 'ZMW',
              'photosUrls': [],
              'color': params.risks.first.color,
              'motorRiskCategoryId': params.risks.first.riskCategoryId,
              'motorBodyTypeId': null
            }
          ]
        },
      );
      if (response.statusCode == 200) {
        return QuotationResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['chMessage']['message'] ??
          'Network error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateQuotationModel> createQuotation(
      {required CreateQuotationParams createQuotationParams}) async {
    try {
      final response =
          await apiClient.dio.post(ApiConstants.createQuotation, data: {
        'agentCode': createQuotationParams.agentCode,
        'productId': createQuotationParams.productId,
        'clientId': createQuotationParams.clientId,
        'startDate': createQuotationParams.startDate,
        'duration': createQuotationParams.duration,
        'quarters': createQuotationParams.quarters,
        'currency': createQuotationParams.currency,
        'policyFor': createQuotationParams.policyFor,
        'risks': [
          {
            'vehicleId': createQuotationParams.risks.vehicleId,
            'sumInsured': createQuotationParams.risks.sumInsured
          }
        ]
      });

      if (response.statusCode == 200) {
        return CreateQuotationModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['chMessage']['message'] ??
            'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateIndividualResponseModel> createIndividualUser({
    required CustomerDetails customerDetails,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.createIndividualUser,
        data: {
          'email': customerDetails.email,
          'phoneNumber': customerDetails.mobileNumber,
          'physicalAddress': customerDetails.address,
          'firstName': customerDetails.firstName,
          'lastName': customerDetails.lastName,
          'idNumber': customerDetails.idNumber,
          'gender': _mapGender(customerDetails.gender),
          'idType': _mapIdType(customerDetails.idType),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateIndividualResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }

      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  String _mapGender(String value) {
    switch (value.trim().toLowerCase()) {
      case 'male':
        return 'MALE';
      case 'female':
        return 'FEMALE';
      case 'other':
        return 'OTHER';
      default:
        return value.trim().toUpperCase();
    }
  }

  String _mapIdType(String value) {
    switch (value.trim().toLowerCase()) {
      case 'national id':
      case 'nationalid':
      case 'nrc':
        return 'NRC';
      case 'passport':
        return 'PASSPORT';
      case 'driver license':
      case 'driver licence':
      case 'dl':
        return 'DL';
      default:
        return value.trim().toUpperCase();
    }
  }

  @override
  Future<InstantIssueResponse> createInstantIssue(
      CreateInstantIssueParams params) async {
    String generateInsNumber() {
      final date = DateFormat('yyyyMMdd').format(DateTime.now());
      final random = Random().nextInt(999999) + 1;
      return 'INS$date${random.toString().padLeft(6, '0')}';
    }

    final secureStorageService = sl<SecureStorageService>();
    final agentCode = await secureStorageService.getAgentMobNo();

    try {
      final dynamic requestBody = {
        'productId': params.productId,
        'duration': params.duration,
        'currency': params.currency,
        'startDate': params.startDate,
        'policyHolder': {
          'type': params.policyHolder.type,
          'name': params.policyHolder.name,
          'phone': params.policyHolder.phone,
          'email': params.policyHolder.email,
          'physicalAddress': params.policyHolder.physicalAddress,
          'idType': params.policyHolder.idType,
          'idNumber': params.policyHolder.idNumber,
          'tpinNumber': params.policyHolder.tpinNumber
        },
        'risks': [
          {
            'make': params.risks.first.make,
            'model': params.risks.first.model,
            'yearOfManufacture': params.risks.first.yearOfManufacture,
            // 'capacity': 1955,
            // 'tonnage': 0,
            // 'seatingCapacity': 5,
            'photosUrls': [
              // 'http://placeimg.com/640/480',
              // 'http://placeimg.com/640/480'
            ],
            'registrationNumber': params.risks.first.registrationNumber,
            'chassisNumber': params.risks.first.chassisNumber,
            'engineNumber': params.risks.first.engineNumber,
            // 'sumInsured': 10000, // params.risks.first.sumInsured,
            'currency': params.risks.first.currency,
            'color': params.risks.first.color,
            'motorRiskCategoryId': params.risks.first.motorRiskCategoryId,
            'motorBodyTypeId': null
          }
        ],
        'reference': generateInsNumber(),
        'payment': null,
        'agentCode': agentCode ?? '987654321', // UsehardcodeAgentCode
        'transactionNumber': null
      };
      final response = await apiClient.dio.post(ApiConstants.createInstantIssue,
          data: requestBody

          // {
          //   'productId': params.productId,
          //   'duration': params.duration,
          //   'currency': params.currency,
          //   'startDate': params.startDate,
          //   'agentCode': params.agentCode,
          //   'policyHolder': {
          //     'type': params.policyHolder.type,
          //     'name': params.policyHolder.name,
          //     'phone': params.policyHolder.phone,
          //     'email': params.policyHolder.email,
          //     'physicalAddress': params.policyHolder.physicalAddress,
          //     'idType': params.policyHolder.idType,
          //     'idNumber': params.policyHolder.idNumber,
          //     'tpinNumber': params.policyHolder.tpinNumber
          //   },
          //   'risks': [
          //     {
          //       'make': params.risks.first.make,
          //       'model': params.risks.first.model,
          //       'yearOfManufacture': params.risks.first.yearOfManufacture,
          //       'registrationNumber': params.risks.first.registrationNumber,
          //       'chassisNumber': params.risks.first.chassisNumber,
          //       'engineNumber': params.risks.first.engineNumber,
          //       'sumInsured': params.risks.first.sumInsured,
          //       'currency': params.currency,
          //       'color': params.risks.first.color,
          //       'motorRiskCategoryId': params.risks.first.motorRiskCategoryId,
          //       'motorBodyTypeId': null
          //     }
          //   ],
          //   'reference': null
          // },
          );
      if (response.statusCode == 200) {
        return InstantIssueResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception('Server error');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['chMessage']['message'] ??
            'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> printReceipt({required PrintReceiptParams params}) async {
    final printUrl = '${ApiConstants.printReceiptUrl}/${params.policyId}';
    try {
      if (kIsWeb) {
        final response = await apiClient.dio.get(
          printUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = Uint8List.fromList(response.data as List<int>);
        final blob = Blob([bytes]);
        final objectUrl = Url.createObjectUrl(blob);
        AnchorElement(href: objectUrl)
          ..setAttribute('download', 'Policy_Document}')
          ..click();
        Url.revokeObjectUrl(objectUrl);
        return true;
      }

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savePath = '${tempDir.path}/$timestamp.pdf';

      try {
        await apiClient.dio.download(printUrl, savePath);
      } on DioException catch (e) {
        throw Exception(
          e.response?.data?['message'] ??
              'Failed to print receipt: ${e.message}',
        );
      }

      final printer = ThermalPrinterService();
      final isPrinted = await printer.printPdf(savePath);
      if (!isPrinted) {
        throw Exception(
            'Printing failed. Please check if the printer is connected.');
      }

      return true;
    } on PlatformException catch (e) {
      throw Exception('Printer error: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<InsuranceTransactionListResponseModel> fetchInsuranceTransactions({
    required int page,
    int size = 10,
    String? search,
    DateTime? fromDate,
    DateTime? toDate,
    required String agentCode,
    required String vendorCode,
  }) async {
    try {
      final requestBody = <String, dynamic>{
        'page': page,
        'size': size,
        'vendorCode': vendorCode,
        if (agentCode.isNotEmpty) 'agentCode': agentCode,
        if (search != null && search.isNotEmpty) 'search': search,
        if (fromDate != null) 'from': DateFormat('yyyy-MM-dd').format(fromDate),
        if (toDate != null) 'to': DateFormat('yyyy-MM-dd').format(toDate),
      };

      final response = await apiClient.dio.post(
        ApiConstants.insuranceTransactionUrl,
        data: requestBody,
      );

      if (response.statusCode == 200) {
        return InsuranceTransactionListResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400) {
        throw Exception(_errorOr(
            response.data, 'Invalid request. Please check the filters.'));
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception(_errorOr(response.data,
            'You are not authorized to view these transactions.'));
      } else if (response.statusCode == 404) {
        throw Exception(_errorOr(response.data, 'Transactions not found.'));
      }
      throw Exception(_errorOr(response.data, 'Server error'));
    } on DioException catch (e) {
      throw Exception(_mapDioException(e));
    } catch (e) {
      rethrow;
    }
  }

  String _errorOr(dynamic data, String fallback) {
    final message = _extractErrorMessage(data);
    return message.isNotEmpty ? message : fallback;
  }

  @override
  Future<PaymentRequestResponse> requestPayment({
    required RequestPaymentParams params,
  }) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.wirepickRequest,
        data: {
          'msisdn': params.msisdn,
          'amount': params.amount,
          'reference': params.reference,
          'narration': params.narration,
          'gateway': params.gateway,
          'action': params.action,
          'environment': 'UAT',
          'currency': 'ZMW'
        },
        options: Options(
          connectTimeout: Duration.zero,
          receiveTimeout: Duration.zero,
          sendTimeout: Duration.zero,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        return PaymentRequestResponse.fromJson(
            response.data as Map<String, dynamic>);
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        throw Exception(response.data['chMessage']['message'].toString());
      }
      throw Exception(_extractErrorMessage(response.data));
    } on DioException catch (e) {
      throw Exception(_mapDioException(e));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<IssuePolicyByQuoteIdResponse> issuePolicyByQuoteId(
      {required IssuePolicyByQuoteidParams params}) async {
    try {
      final response = await apiClient.dio.post(
        ApiConstants.issuePolicyByQuoteId,
        data: {
          'quotationId': params.quotationId,
          'agentCode': params.agentCode,
          'referenceNumber': params.referenceNumber,
          'payment': {
            'method': params.paymentUsecase.method,
            'mobileMoneyAccountNumber':
                params.paymentUsecase.mobileMoneyAccountNumber,
            'gateway': params.paymentUsecase.gateway,
            'reference': params.paymentUsecase.paymentRefNo,
            'transactionId': params.paymentUsecase.transactionId,
            'gwId': params.paymentUsecase.gwId,
            'mnoRequestId': params.paymentUsecase.mnoRequestId
          }
        },
      );
      return IssuePolicyByQuoteIdResponse.fromJson(
          response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sendSMSForPolicyKeyFacts({
    required String productId,
    required String customerPhoneNumber,
  }) async {
    try {
      final response = await apiClient.dio.get(
        ApiConstants.sendSMSForPolicyKeyFacts,
        queryParameters: {
          'productId': productId,
          'mobileNumber': customerPhoneNumber,
          'documentType': 'KEY_FACTS_STATEMENT',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<KeyFactsDocumentEntity> downloadKeyFactsDocument({
    required String productId,
  }) async {
    try {
      final endpoint = ApiConstants.downloadInsuranceDocument
          .replaceAll('##PRODUCTID##', productId);

      final response = await apiClient.dio.get(
        endpoint,
        queryParameters: {
          'documentType': 'KEY_FACTS_STATEMENT',
        },
        options: Options(responseType: ResponseType.bytes),
      );

      final contentType = response.headers.value('content-type') ?? '';

      if (contentType.contains('application/json')) {
        final decoded = json.decode(utf8.decode(response.data as List<int>));
        final data = decoded is Map ? decoded['data'] ?? decoded : null;
        final url = data is Map ? data['url'] as String? : null;
        return KeyFactsDocumentEntity(url: url);
      }

      return KeyFactsDocumentEntity(
        bytes: Uint8List.fromList(response.data as List<int>),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? 'Network error: ${e.message}',
      );
    } catch (e) {
      rethrow;
    }
  }
}
