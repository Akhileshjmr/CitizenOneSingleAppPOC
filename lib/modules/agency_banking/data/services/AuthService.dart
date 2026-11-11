import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';

import '../../constants/AppConfig.dart';
import '../../utils/AppLogger.dart';
import '../../utils/SecureStorageHelper.dart';
import '../api/ApiClient.dart';
import '../api/end_points/ApiEndPoints.dart';
import '../models/AbQueryLoanDetails.dart';
import '../models/AbTransactionName.dart';
import '../models/AccountTransHistory.dart';
import '../models/CommAccountRequest.dart';
import '../models/CommAgentDetails.dart';
import '../models/CommCustEnrollment.dart';
import '../models/CommCustImageSignList.dart';
import '../models/CommCustomerPin.dart';
import '../models/CommFeeCalulation.dart';
import '../models/CommKycUpload.dart';
import '../models/CommLanguageLabels.dart';
import '../models/CommRequestList.dart';
import '../models/CommRequestMoney.dart';
import '../models/CommTransaction.dart';
import '../models/CommTransactionDetails.dart';
import '../models/CommWalletAccountRequest.dart';
import '../models/CommWalletTransaction.dart';
import '../models/ExcelDataUpload.dart';
import '../models/LoginQRImage.dart';
import '../models/WalletKycCustomerReq.dart';
import '../models/chatbot_models/chat_response.dart';
import '../models/common_models/ServerMessage.dart';
import '../models/kyc/kyc_otp_response_model.dart';
import '../models/kyc/kyc_recent_history_response_model.dart';
import '../models/kyc/kyc_user_response_model.dart';
import '../models/kyc/kyc_verify_otp_response_model.dart';
import '../models/kyc/submit_kyc_response_model.dart';
import '../models/lms_models/casa_account_models/CasaAccountCreateRequest.dart';
import '../models/lms_models/casa_account_models/CasaAccountCreateResponse.dart';
import '../models/lms_models/customer_registration_models/GdbCustRtlAppRequest.dart';
import '../models/lms_models/customer_registration_models/GdbCustRtlAppRequest2.dart';
import '../models/lms_models/customer_registration_models/GdbCustRtlAppResponse.dart';
import '../models/lms_models/customer_registration_models/GdbCustSearchRequest.dart';
import '../models/lms_models/emi_calculation_models/GdbChAppStatusReqRes.dart';
import '../models/lms_models/emi_calculation_models/GdbChScoreReqRes.dart';
import '../models/lms_models/emi_calculation_models/L2lEmiCalculateRequest.dart';
import '../models/lms_models/emi_calculation_models/L2lEmiCalculateResponse.dart';
import '../models/lms_models/loan_product_models/CollateralDetailsReqRes.dart';
import '../models/lms_models/loan_product_models/GdbMerchantDisProductListRequest.dart';
import '../models/lms_models/loan_product_models/GdbMerchantDisProductListResponse.dart';
import '../models/lms_models/loan_product_models/GdbMerchantDisProductPurRequest.dart';
import '../models/lms_models/loan_product_models/GdbMerchantDisProductPurResponse.dart';
import '../models/lms_models/loan_product_models/GdbProductGroupRequest.dart';
import '../models/lms_models/loan_product_models/GdbProductGroupResponse.dart';
import '../models/lms_models/repayment_models/AccSpecificRepaymentRequest.dart';
import '../models/lms_models/repayment_models/AccSpecificRepaymentResponse.dart';
import '../models/lms_models/repayment_models/L2lLoanRepayRequest.dart';
import '../models/lms_models/repayment_models/L2lLoanRepayResponse.dart';
import '../models/lms_models/term_deposit_models/TdAccOpeningRequest.dart';
import '../models/lms_models/term_deposit_models/TdAccOpeningResponse.dart';
import '../models/login_models/AbAgentForgotChangePwd.dart';
import '../models/login_models/LoginUserInfo.dart';
import '../models/login_models/LoginUserReqResInfo.dart';
import '../models/login_models/UserOtpValidationInfo.dart';
import '../models/lov_models/AbLovsMaster.dart';

class AuthService {
  final ApiClient apiClient = ApiClient();

  Future<LoginUserReqResInfo?> login(LoginUserReqResInfo loginUserReqResInfo,
      [LoginUserInfo? loginUserInfo, String? endpoint]) async {
    try {
      final response = await apiClient.client.post(
        endpoint ?? ApiEndpoints.login,
        data: loginUserReqResInfo.toJson(),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginUserReqResInfo.fromJson(response.data);

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          'loginResponse',
          jsonEncode(loginResponse.toJson()),
        );
        await SecureStorageHelper.saveLoginResponse(
            jsonEncode(loginResponse.toJson()));

        return loginResponse;
      } else {
        throw Exception('Login failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Login API failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<LoginUserReqResInfo?> orgLogin(LoginUserReqResInfo loginUserReqResInfo,
      [LoginUserInfo? loginUserInfo]) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.secondLogin,
        data: loginUserReqResInfo.toJson(),
      );

      if (response.statusCode == 200) {
        LoginUserReqResInfo loginResponse =
            LoginUserReqResInfo.fromJson(response.data);
        // Store the entire login response in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'loginResponse', jsonEncode(loginResponse.toJson()));
        return loginResponse;
      } else {
        throw Exception('Login failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Organization Login API failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<UserOTPValidationInfo?> request_Otp(
      UserOTPValidationInfo otpRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.requestOtp,
        data: otpRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return UserOTPValidationInfo.fromJson(response.data);
      } else {
        throw Exception('OTP request failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "OTP request failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<UserOTPValidationInfo?> otpFailedValidation(
      UserOTPValidationInfo otpRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.otpValidation,
        data: otpRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return UserOTPValidationInfo.fromJson(response.data);
      } else {
        throw Exception('OTP failed validation failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "OTP validation failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ServerMessage?> reset_password(
      AbAgentForgetChangePwd changePwd) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.resetPassword,
        data: changePwd.toJson(),
      );
      if (response.statusCode == 200) {
        return ServerMessage.fromJson(response.data);
      } else {
        throw Exception('Reset Password failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Reset password failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<AbLovsMaster?> get_Lov(AbLovsMaster lovsMaster) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.lov,
        data: lovsMaster.toJson(),
      );
      if (response.statusCode == 200) {
        return AbLovsMaster.fromJson(response.data);
      } else {
        throw Exception('Cannot fetch Lov');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Cannot fetch Lov",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommKycUpload?> upload_kyc(CommKycUpload kycUpload) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.kycUpload,
        data: kycUpload.toJson(),
      );
      if (response.statusCode == 200) {
        return CommKycUpload.fromJson(response.data);
      } else {
        throw Exception('Cannot Upload KYC');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Cannot Upload KYC",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommCustEnrollment?> cust_enroll(CommCustEnrollment custEnroll) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.custEnroll,
        data: custEnroll.toJson(),
      );
      if (response.statusCode == 200) {
        return CommCustEnrollment.fromJson(response.data);
      } else {
        throw Exception('Unable to submit');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to submit",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletAccountRequest?> walletSearch(
      CommWalletAccountRequest walletSearch) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.walletSearch,
        data: walletSearch.toJson(),
      );

      if (response.statusCode == 200) {
        return CommWalletAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Wallet account search failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Wallet account search failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommAccountRequest?> accountSearch(
      CommAccountRequest accountSearch) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.accountSearch,
        data: accountSearch.toJson(),
      );
      if (response.statusCode == 200) {
        return CommAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Account search failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Account search failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommFeeCalculation?> tax_cal(
      CommWalletTransaction feeCalulator) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.taxCal,
        data: feeCalulator.toJson(),
      );
      if (response.statusCode == 200) {
        return CommFeeCalculation.fromJson(response.data);
      } else {
        throw Exception('Calculation failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Calculation failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommTransaction?> pinValidation(CommTransaction pinValidation) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.pinValidation,
        data: pinValidation.toJson(),
      );

      if (response.statusCode == 200) {
        return CommTransaction.fromJson(response.data);
      } else {
        throw Exception('Pin Validation failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Pin Validation failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommTransaction?> accounttransaction(
      CommTransaction accounttransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.accountTransaction,
        data: accounttransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommTransaction.fromJson(response.data);
      } else {
        throw Exception('Account Transaction failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Account transaction failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletTransaction?> wallettransaction(
      CommWalletTransaction wallettransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.walletTransaction,
        data: wallettransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommWalletTransaction.fromJson(response.data);
      } else {
        throw Exception('Wallet Transaction failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Wallet transaction failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletTransaction?> accountWallettransaction(
      CommWalletTransaction wallettransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.accountWallettransaction,
        data: wallettransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommWalletTransaction.fromJson(response.data);
      } else {
        throw Exception('Wallet Transaction failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Wallet Transaction failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommTransaction?> send_money_account(
      CommTransaction accounttransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.sendMoneyAccount,
        data: accounttransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommTransaction.fromJson(response.data);
      } else {
        throw Exception('Sending money failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Send money failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommAccountRequest?> accountBalance(
      CommAccountRequest accountRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.accountBalance,
        data: accountRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return CommAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Unable to get account balance');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get account balance",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommAccountRequest?> balanceSMS(
      CommAccountRequest accountRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.balanceSMS,
        data: accountRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return CommAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Unable to get account balance');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get account balance",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletAccountRequest?> walletBalance(
      CommWalletAccountRequest walletRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.walletBalance,
        data: walletRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return CommWalletAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Unable to get wallet balance');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get wallet balance",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommRequestMoney?> request_money(CommRequestMoney requestMoney) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.requestMoney,
        data: requestMoney.toJson(),
      );
      if (response.statusCode == 200) {
        return CommRequestMoney.fromJson(response.data);
      } else {
        throw Exception('Request money failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Request money failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<AccountTransHistory?> transHistory(
      AccountTransHistory transactionHistory) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.transHistory,
        data: transactionHistory.toJson(),
      );
      if (response.statusCode == 200) {
        return AccountTransHistory.fromJson(response.data);
      } else {
        throw Exception('Unable to get transaction history');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get transaction history",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommRequestList?> receive_request(
      CommRequestList receiveRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.receiveRequest,
        data: receiveRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return CommRequestList.fromJson(response.data);
      } else {
        throw Exception('Unable to receive request');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to receive request",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommTransactionDetails?> transactionReceipt(
      CommTransactionDetails transactionDetails) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.transactionReceipt,
        data: transactionDetails.toJson(),
      );
      if (response.statusCode == 200) {
        return CommTransactionDetails.fromJson(response.data);
      } else {
        throw Exception('Unable to get Transaction Receipt');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get receipt",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommAgentDetails?> userProfile(CommAgentDetails agentDetails) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.userProfile,
        data: agentDetails.toJson(),
      );
      if (response.statusCode == 200) {
        return CommAgentDetails.fromJson(response.data);
      } else {
        throw Exception('Unable to get user profile details');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get profile details",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<LoginQRImage?> loginQr(LoginQRImage qrImage) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.loginQr,
        data: qrImage.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginQRImage.fromJson(response.data);
      } else {
        throw Exception('Unable to get QR Image');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get QR Image",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ServerMessage?> resetPin(CommCustomerPin resetPin) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.resetPin,
        data: resetPin.toJson(),
      );
      if (response.statusCode == 200) {
        return ServerMessage.fromJson(response.data);
      } else {
        throw Exception('Unable to reset customer pin');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Reset pin failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ServerMessage?> changePin(CommCustomerPin changePin) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.changePin,
        data: changePin.toJson(),
      );
      if (response.statusCode == 200) {
        return ServerMessage.fromJson(response.data);
      } else {
        throw Exception('Unable to change customer pin');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Change pin failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommAccountRequest?> additional_account(
      CommAccountRequest additionalAccount) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.additionalAccount,
        data: additionalAccount.toJson(),
      );
      if (response.statusCode == 200) {
        return CommAccountRequest.fromJson(response.data);
      } else {
        throw Exception('Additional account creation failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Additional account creation failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletTransaction?> trustaccount_wallet(
      CommWalletTransaction walletTransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.trustaccountWallet,
        data: walletTransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommWalletTransaction.fromJson(response.data);
      } else {
        throw Exception('Trust account Wallet Transaction failed');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Trust account Wallet Transaction failed",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<WalletKycCustomerReq?> wallet_creation(
      WalletKycCustomerReq walletRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.walletCreation,
        data: walletRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return WalletKycCustomerReq.fromJson(response.data);
      } else {
        throw Exception('Unable to Register');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to Register",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommCustImageSignList?> image_upload(
      CommCustImageSignList imgUpload) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.imageUpload,
        data: imgUpload.toJson(),
      );
      if (response.statusCode == 200) {
        return CommCustImageSignList.fromJson(response.data);
      } else {
        throw Exception('Unable to Upload');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to upload",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ExcelDataUpload?> bulk_ft(ExcelDataUpload bulkFt) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.bulkFt,
        data: bulkFt.toJson(),
      );
      if (response.statusCode == 200) {
        return ExcelDataUpload.fromJson(response.data);
      } else {
        throw Exception('Unable to Upload');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to upload",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ExcelDataUpload?> bulk_wallet(ExcelDataUpload bulkWallet) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.bulkRegistration,
        data: bulkWallet.toJson(),
      );
      if (response.statusCode == 200) {
        return ExcelDataUpload.fromJson(response.data);
      } else {
        throw Exception('Unable to Upload');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to upload",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommWalletTransaction?> wallet_receive_payment(
      CommWalletTransaction comWalletTransaction) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.walletReceivePayment,
        data: comWalletTransaction.toJson(),
      );
      if (response.statusCode == 200) {
        return CommWalletTransaction.fromJson(response.data);
      } else {
        throw Exception('Unable to receive payment');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to receive payment",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CommLanguageLabels?> get_language_labels(
      CommLanguageLabels comlabels) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.languageLabels,
        data: comlabels.toJson(),
      );
      if (response.statusCode == 200) {
        return CommLanguageLabels.fromJson(response.data);
      } else {
        throw Exception('Unable to get language labels');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get language labels",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbMerchantDisProductPurResponse?> loanApply(
      GdbMerchantDisProductPurRequest gbmerchantdisproduct) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.loanApply,
        data: gbmerchantdisproduct.toJson(),
      );

      if (response.statusCode == 200) {
        return GdbMerchantDisProductPurResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to upload loan application');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Loan apply error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbMerchantDisProductListResponse?> product_list(
      GdbMerchantDisProductListRequest gdbMerchantDisProductListRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.productsList,
        data: gdbMerchantDisProductListRequest.toJson(),
      );

      if (response.statusCode == 200) {
        return GdbMerchantDisProductListResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to upload loan application');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Loan apply error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbProductGroupResponse?> productGroup(
      GdbProductGroupRequest productGroup) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.productGroup,
        data: productGroup.toJson(),
      );
      if (response.statusCode == 200) {
        return GdbProductGroupResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to get products');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get products",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<AbQueryLoanDetails?> getloanAccountDetails(
      AbQueryLoanDetails loanDetails) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.loanAccount,
        data: loanDetails.toJson(),
      );
      if (response.statusCode == 200) {
        return AbQueryLoanDetails.fromJson(response.data);
      } else {
        throw Exception('Unable to get loan details');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get loan details",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbCustRtlAppResponse?> customer_reg(
      GdbCustRtlAppRequest custRequest) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.customerRegistration,
        data: custRequest.toJson(),
      );
      if (response.statusCode == 200) {
        return GdbCustRtlAppResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to register');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to register",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbCustRtlAppRequest2?> customer_search(
      GdbCustSearchRequest custSearch) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.customerSearch,
        data: custSearch.toJson(),
      );
      if (response.statusCode == 200) {
        return GdbCustRtlAppRequest2.fromJson(response.data);
      } else {
        throw Exception('Unable to search');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to search",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<TdAccOpeningResponse?> td_account_opening(
      TdAccOpeningRequest request) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.tdAccountOpening,
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return TdAccOpeningResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to open TD account');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to open TD account",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CasaAccountCreateResponse?> casa_account_opening(
      CasaAccountCreateRequest accountOpening) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.casaAccountOpening,
        data: accountOpening.toJson(),
      );
      if (response.statusCode == 200) {
        return CasaAccountCreateResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to open CASA account');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to open CASA account",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<L2lEmiCalculateResponse?> emi_calculator(
      L2lEmiCalculateRequest emiCalculation) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.emiUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 3),
      ));
      final response = await dio.post(
        ApiEndpoints.emiCalculation,
        data: emiCalculation.toJson(),
      );
      if (response.statusCode == 200) {
        return L2lEmiCalculateResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to calculate EMI');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to calculate EMI",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbChScoreReqRes?> eligibility_score(GdbChScoreReqRes score) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.scoreUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 3),
      ));
      final response = await dio.post(
        ApiEndpoints.eligibilityScore,
        data: score.toJson(),
      );
      if (response.statusCode == 200) {
        return GdbChScoreReqRes.fromJson(response.data);
      } else {
        throw Exception('Unable to get score');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get score",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<GdbChAppStatusReqRes?> app_status(GdbChAppStatusReqRes score) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.applicationStatus,
        data: score.toJson(),
      );
      if (response.statusCode == 200) {
        return GdbChAppStatusReqRes.fromJson(response.data);
      } else {
        throw Exception('Unable to get status');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Unable to get status",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<L2lLoanRepayResponse?> cust_specific_repayment(
      L2lLoanRepayRequest req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.custSpecific,
        data: req.toJson(),
      );
      if (response.statusCode == 200) {
        return L2lLoanRepayResponse.fromJson(response.data);
      } else {
        throw Exception('Error');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<AccSpecificRepaymentResponse?> account_specific_repayment(
      AccSpecificRepaymentRequest req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.accSpecific,
        data: req.toJson(),
      );
      if (response.statusCode == 200) {
        return AccSpecificRepaymentResponse.fromJson(response.data);
      } else {
        throw Exception('Error');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<ChatbotResponse?> postChatbot(String message) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.chatbotUrl,
        data: {'message': message},
      );
      AppLogger.network("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return ChatbotResponse.fromJson(response.data);
      } else {
        throw Exception('Unable to post message: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<CollateralDetailsReqRes?> collateral_details(
      CollateralDetailsReqRes req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.collateral,
        data: req.toJson(),
      );
      if (response.statusCode == 200) {
        return CollateralDetailsReqRes.fromJson(response.data);
      } else {
        throw Exception('Error');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
    }
    return null;
  }

  Future<LoginUserReqResInfo?> logout(LoginUserReqResInfo request) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.logout,
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginUserReqResInfo.fromJson(response.data);
      } else {
        throw Exception('');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchKycUser(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.searchKycUser,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data["recordExists"]) {
          return {
            "status": true,
            "data": KycUserResponseModel.fromJson(response.data),
          };
        } else if (!response.data["recordExists"]) {
          return {
            "status": false,
            "data": null,
          };
        }
      }
      return {
        "status": null,
        "error": "Server error",
      };
    } catch (e) {
      return {
        "status": null,
        "error": "Server error",
      };
    }
  }

  Future<dynamic> fetchLocation() async {
    try {
      final response = await apiClient.client.get(
        ApiEndpoints.fetchLocationUrl,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> fetchSectors() async {
    try {
      final response = await apiClient.client.get(
        ApiEndpoints.fetchLocationUrl,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      return null;
    }
  }

  Future<SubmitKycResponseModel?> submitKyc(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.submitKycUrl,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return SubmitKycResponseModel.fromJson(response.data);
        } else {
          throw Exception('${response.data['chMessage']['message']}');
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data?['message'] ?? 'Server error',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<KycRecentHistoryResponseModel?> fetchRecentHistory(
      Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.fetchRecentHistoryUrl,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError']) {
          return null;
        }
        return KycRecentHistoryResponseModel.fromJson(response.data);
      } else {
        throw Exception('Unable to fetch');
      }
    } catch (e) {
      throw Exception('Unable to fetch');
    }
  }

  Future<bool> downloadFile(String url, String fileName) async {
    Dio dio = Dio();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    String savePath = "/storage/emulated/0/Download/$timestamp$fileName";
    try {
      final response = await dio.get("${ApiEndpoints.profittoBaseUrl}$url",
          options: Options(
            responseType: ResponseType.bytes,
            headers: {
              'Authorization': 'Bearer ${AppConfig.staticProfittoAccessToken}'
            },
          ));
      if (kIsWeb) {
        final bytes = Uint8List.fromList(response.data!);
        final blob = Blob([bytes]);
        final objectUrl = Url.createObjectUrl(blob);

        AnchorElement(href: objectUrl)
          ..setAttribute('download', fileName)
          ..click();

        Url.revokeObjectUrl(objectUrl);
        return true;
      }

      await dio.download(
        "${ApiEndpoints.profittoBaseUrl}$url",
        options: Options(headers: {
          'Authorization': 'Bearer ${AppConfig.staticProfittoAccessToken}'
        }),
        savePath,
      );
      return true;
    } catch (e) {
      throw false;
    }
  }

  Future<KycOtpResponseModel?> sendOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.getOtpKycUrl,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data['isLocked'] == true) {
          throw Exception('${response.data['chMessage']['message']}');
        }
        if (response.data['chMessage']['isError'] == false) {
          return KycOtpResponseModel.fromJson(response.data);
        } else {
          throw Exception('${response.data['chMessage']['message']}');
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data?['message'] ?? 'Server error',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<KycOtpResponseModel?> resendOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.resendOtpKycUrl,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return KycOtpResponseModel.fromJson(response.data);
        } else {
          throw Exception('${response.data['chMessage']['message']}');
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data?['message'] ?? 'Server error',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<KycVerifyOtpResponseModel?> verifyOtp(Map<String, dynamic> req) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.verifyOtpKycUrl,
        data: req,
      );
      if (response.statusCode == 200) {
        if (response.data['chMessage']['isError'] == false) {
          return KycVerifyOtpResponseModel.fromJson(response.data);
        } else {
          throw Exception('${response.data['chMessage']['message']}');
        }
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data?['message'] ?? 'Server error',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AbTransactionName?> transMethod(AbTransactionName request) async {
    try {
      final response = await apiClient.client.post(
        ApiEndpoints.transMethod,
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        return AbTransactionName.fromJson(response.data);
      } else {
        throw Exception('');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        "Error",
        e,
        stackTrace,
      );
      return null;
    }
  }
}
