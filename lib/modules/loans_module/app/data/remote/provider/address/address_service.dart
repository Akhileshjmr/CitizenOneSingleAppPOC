import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:citizenone_app/modules/loans_module/app/data/remote/api_service/ApiEndPoints.dart';
import 'package:citizenone_app/modules/loans_module/app/utils/ag_constants.dart';

import '../../../../components/utils/app_snackbar.dart';
import '../../../../utils/static_value_constant.dart';
import '../../../local/store/user_provider.dart';
import '../../../model/address/AddressDet.dart';
import '../../../model/address/address_det_resp.dart';
import '../../../model/address/view_address_resp.dart';
import '../../../model/select_box_model/SelectOptionList.dart';
import '../../api_service/init_api_service.dart';

class AddressService {
  /// To get list of my sessions
  static Future<List<SelectOptionList>> getListView(String hKey) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: ApiEndPoints.getSelectBoxValues,
      data: <String, dynamic>{
        "reqSecureKey": StaticValueConstant.reqSecureKey,
        "filterHashKey": hKey,
        "hKey": 0,
        "filterVal":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
      },
    );

    if (res != null && res.data != null && res.statusCode == 200) {
      return List<SelectOptionList>.from(
        res.data?['selectOptionList'].map<dynamic>(
          (dynamic e) => SelectOptionList.fromJson(e),
        ),
      );
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return <SelectOptionList>[];
  }

  /// To get list of my sessions
  static Future<AddressDet?> getPersonalDetails(String url) async {
    final String mobNumber = await UserProvider.getMobileNumber();
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: url,
      data: <String, dynamic>{
        "reqSecureKey":
            ((UserProvider.currentUser?.addiParams.length ?? 0) > 0)
                ? (UserProvider.currentUser?.addiParams[0] ?? '')
                : '',
        "filterVal": mobNumber,
        "addiParams": ["ADDRESS", mobNumber],
      },
    );

    if (res?.statusCode == 200) {
      return AddressDet.fromJson(
        res?.data!['addressDet'] ?? <String, dynamic>{},
      );
    } else {
      appSnackbar(
        message: 'Something went wrong',
        snackbarState: SnackbarState.warning,
      );
    }

    return AddressDet();
  }

  /// Get the list of address
  static Future<List<AddressDelResp>> getCgAddressList(
    String geturl, {
    required Map<String, dynamic> formData,
  }) async {
    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: geturl,
      data: formData,
    );
    bool success = false;
    if (res?.statusCode == 200) {
      final ViewAddressResp value = ViewAddressResp.fromJson(
        res?.data ?? <String, dynamic>{},
      );
      final apiRes = value.chMessage;
      success = !(apiRes.isError ?? false);

      if (success) {
        if (res?.data!['credezeAddressDet'] == null) {
          return <AddressDelResp>[];
        } else {
          return List<AddressDelResp>.from(
            res?.data!['credezeAddressDet'].map<dynamic>(
              (dynamic e) => AddressDelResp.fromJson(e),
            ),
          );
        }
      } else {
        appSnackbar(
          message: "Something went wrong, please try again later",
          snackbarState: SnackbarState.danger,
        );
      }
    } else {
      appSnackbar(
        message: "Something went wrong, please try again later",
        snackbarState: SnackbarState.danger,
      );
    }

    return <AddressDelResp>[];
  }

  /// To update the user default
  static Future<bool> updateDefaultAddress(
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

  /// To update the user delivery address
  static Future<bool> updateSelectedAddress({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/selected-address',
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

  /// To delete the user address
  static Future<bool> deleteAddress({
    required Map<String, dynamic> formData,
  }) async {
    bool success = false;

    final Response<Map<String, dynamic>?>? res = await APIService.postAuth(
      path: 'orders/cg/remove-address',
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
