import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/ag_constants.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../config/logger.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/loan/co_applicant/CoApplForm.dart';
import '../../../model/loan/forms/personal_form/GenDet.dart';
import '../../../model/loan/refer/LoanRefDetails.dart';
import '../../../model/select_box_model/SelectOptionList.dart';
import '../../api_service/ApiEndPoints.dart';
import '../../api_service/init_api_service.dart';

///Course List Service
class PersonalListService {
  /// To get list of my sessions
  static Future<List<SelectOptionList>> getListView() async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: ApiEndPoints.getSelectBoxValues,
        data: <String, dynamic>{
          'reqSecureKey': '',
          'filterVal':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
        },
      );
      if (res != null && res.data != null && res.statusCode == 200) {
        return List<SelectOptionList>.from(
          res.data!['selectOptionList'].map<dynamic>(
            (dynamic e) => SelectOptionList.fromJson(e),
          ),
        );
      }
    } on Exception catch (e) {
      logE(e);
    }

    return <SelectOptionList>[];
  }

  /// To get list of my sessions
  static Future<PersonalDet?> getPersonalDetails(String url) async {
    try {
      final String mobNumber = await UserProvider.getMobileNumber();
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: url,
        data: <String, dynamic>{
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
          'filterVal': mobNumber,
          'addiParams': ['PERSONAL_DETAILS', mobNumber],
        },
      );

      if (res?.statusCode == 200) {
        final PersonalDet apiRes = PersonalDet.fromJson(
          res?.data ?? <String, dynamic>{},
        );

        if (res?.data!['genDet'] != null) {
          return PersonalDet.fromJson(
            res?.data!['genDet'] ?? <String, dynamic>{},
          );
        }
      } else {}
    } on Exception catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return PersonalDet();
  }

  /// To update the user data
  static Future<bool> submitPersonal(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  static Future<CoApplForm?> getCoApplicant(String url) async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: url,
        data: <String, dynamic>{
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
          'filterVal': 'PROFILE',
          'addiParams': ['CO_APPLICANT'],
        },
      );

      if (res?.statusCode == 200) {
        final CoApplForm apiRes = CoApplForm.fromJson(
          res?.data ?? <String, dynamic>{},
        );

        if (res?.data!['coApplDetails'] != null) {
          return CoApplForm.fromJson(
            res?.data!['coApplDetails'] ?? <String, dynamic>{},
          );
        }
      } else {}
    } on Exception catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return CoApplForm();
  }

  static Future<List<LoanRefDetails>?> getCoReferal(String url) async {
    try {
      final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
        path: url,
        data: <String, dynamic>{
          'reqSecureKey':
              ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                  ? (UserProvider.currentUser?.addiParams[0] ?? '')
                  : '',
          'filterVal': 'PROFILE',
          'addiParams': ['LOAN_REFERENCE'],
        },
      );

      if (res?.statusCode == 200) {
        // final CoApplForm apiRes =
        // CoApplForm.fromJson(res?.data ?? <String, dynamic>{});

        if (res?.data!['loanRefDetails'] != null) {
          return List<LoanRefDetails>.from(
            res?.data!['loanRefDetails'].map<dynamic>(
              (dynamic e) => LoanRefDetails.fromJson(e),
            ),
          );
        }
      } else {}
    } on Exception catch (e) {
      logE(e);
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return <LoanRefDetails>[];
  }

  /// To remove address
  static Future<bool> removeAddress(
    String url, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  /// To update the user data
  static Future<bool> submitPersonalAuto({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'auto/orders/save-profile-forms',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  /// To update the user data
  static Future<bool> submitPersonalCG({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/save-profile-forms',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  /// To update the user data
  static Future<bool> submitPersonalMortgage({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'realestate/home/orders/save-profile-forms',
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  /// To update the user data
  static Future<bool> addAddress({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.addAddress,
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }

  /// To update the user address
  static Future<bool> editAddress(
    String geturl, {
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: geturl,
      data: formData,
    );

    if (res?.statusCode == 200) {
      success = true;
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }
    return success;
  }
}
