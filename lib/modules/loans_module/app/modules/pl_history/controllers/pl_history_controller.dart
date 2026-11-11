import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/limit/limit_arguments.dart';
import '../../../data/model/limit/limit_fna_sub_resp.dart';
import '../../../data/model/loan/PersonalLoan/PersonalLoanList.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';
import '../pl_history_args.dart';

class PlHistoryController extends GetxController {
  /// Api loading
  final RxBool isLoading = true.obs;

  /// dropdown List
  final RxList<PersonalLoanList?> plList = <PersonalLoanList?>[].obs;
  TextEditingController remarkController = TextEditingController();

  RxBool isFromOrderScreen = false.obs;
  RxInt listIndex = 0.obs;
  String pdfUrl = '';

  /// Arguments (nullable to avoid LateInitializationError)
  PlSatusArguments? statusArgs;
  PlHistoryArgs? historyArgs;

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.arguments != null) {
        if (Get.arguments is PlSatusArguments) {
          statusArgs = Get.arguments as PlSatusArguments;
          listIndex(statusArgs?.index ?? 0);
          pdfUrl = statusArgs?.pdfUrl ?? '';
        } else if (Get.arguments is bool) {
          isFromOrderScreen(Get.arguments as bool);
        } else if (Get.arguments is PlHistoryArgs) {
          historyArgs = Get.arguments as PlHistoryArgs;
        }
      }
      // Load history based on the type
      loadHistoryBasedOnType();
    } catch (e) {
      debugPrint("onInit error: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }

  /// Load history based on the history type
  Future<void> loadHistoryBasedOnType() async {
    // If no historyArgs, default to logged-in customer history
    final historyType =
        historyArgs?.historyType ?? PlHistoryType.loggedInCustomer;

    switch (historyType) {
      case PlHistoryType.loggedInCustomer:
        await getLoggedInCustomerLoans();
        break;

      case PlHistoryType.customerPhoneSearch:
        final phone = historyArgs?.customerPhoneNumber;
        if (phone != null && phone.isNotEmpty) {
          await getCustomerLoans(phone);
        } else {
          await getLoggedInCustomerLoans();
        }
        break;

      case PlHistoryType.agentPhoneSearch:
        final phone = historyArgs?.agentPhoneNumber;
        if (phone != null && phone.isNotEmpty) {
          await getAgentLoans(phone);
        } else {
          await getLoggedInCustomerLoans();
        }
        break;
    }
  }

  /// get apply pl list for logged in customer
  Future<void> getLoggedInCustomerLoans() async {
    isLoading(true);
    try {
      final response = await PersonalLoanService.getPLHistory();
      plList(response);
    } catch (e) {
      debugPrint("getLoggedInCustomerLoans error: $e");
      appSnackbar(
        message: 'Failed to load loan history',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading(false);
    }
  }

  /// get apply pl list by customer phone number
  Future<void> getCustomerLoans(String customerPhoneNumber) async {
    isLoading(true);
    try {
      final response = await PersonalLoanService.getCustomerPLHistory(
        customerPhoneNumber,
      );
      plList(response);
    } catch (e) {
      debugPrint("getCustomerLoans error: $e");
      appSnackbar(
        message: 'Failed to load customer loan history',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading(false);
    }
  }

  /// get apply pl list by agent phone number
  Future<void> getAgentLoans(String agentPhoneNumber) async {
    isLoading(true);
    try {
      final response = await PersonalLoanService.getAgentPLHistory(
        agentPhoneNumber,
      );
      plList(response);
    } catch (e) {
      debugPrint("getAgentLoans error: $e");
      appSnackbar(
        message: 'Failed to load agent loan history',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkAceptReject(
    String status,
    String remark,
    String snactionid,
  ) async {
    isLoading(true);

    try {
      final LimitFnaSubResp? resp =
          await PersonalLoanService.finalSanctionAceptReject(
            status,
            remark,
            snactionid,
          );

      if (resp?.chMessage?.isError == false) {
        Get.back();
        await loadHistoryBasedOnType();
      } else {
        appSnackbar(
          message: resp?.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } catch (e) {
      debugPrint("checkAceptReject error: $e");
      appSnackbar(
        message: 'Something went wrong. Please try again.',
        snackbarState: SnackbarState.warning,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<bool> downloadFile(
    String fileUrl,
    String fileName,
    String directoryPath,
  ) async {
    bool downloadStatus = false;

    try {
      if (Platform.isAndroid) {
        final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

        if (androidInfo.version.sdkInt < 33) {
          await Permission.storage.request();
          await Permission.manageExternalStorage.request();

          final PermissionStatus status = await Permission.storage.status;

          if (status.isDenied) {
            appSnackbar(
              message: 'Permission has been denied',
              snackbarState: SnackbarState.info,
            );
            return downloadStatus;
          }

          if (await Permission.storage.isRestricted) {
            appSnackbar(
              message: 'Permission is Restricted',
              snackbarState: SnackbarState.warning,
            );
            return downloadStatus;
          }

          if (status.isGranted) {
            downloadStatus = await downloadFileFromUrl(
              fileUrl,
              _getFilePath(fileName, directoryPath),
            );
          }
        } else {
          await Permission.photos.request();
          final PermissionStatus status = await Permission.photos.status;

          if (status.isDenied) {
            appSnackbar(
              message: 'Permission has been denied',
              snackbarState: SnackbarState.info,
            );
            return downloadStatus;
          }

          if (await Permission.photos.isRestricted) {
            await openAppSettings();
            appSnackbar(
              message: 'Permission is Restricted',
              snackbarState: SnackbarState.warning,
            );
            return downloadStatus;
          }

          if (status.isGranted) {
            downloadStatus = await downloadFileFromUrl(
              fileUrl,
              _getFilePath(fileName, directoryPath),
            );
          }
        }
      } else {
        downloadStatus = await downloadFileFromUrl(
          fileUrl,
          _getFilePath(fileName, directoryPath),
        );
      }
    } catch (e) {
      debugPrint("downloadFile error: $e");
      appSnackbar(
        message: 'Download failed',
        snackbarState: SnackbarState.warning,
      );
    }

    return downloadStatus;
  }

  Future<bool> downloadFileFromUrl(String baseUrl, String savePath) async {
    bool isSuccess = false;

    try {
      final response = await APIService.download(
        url: baseUrl,
        savePath: savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = ((received / total) * 100).toInt();
            debugPrint('Download progress: $progress%');
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      if (response.statusCode == 200) {
        isSuccess = true;
        appSnackbar(
          message: 'Successfully Downloaded',
          snackbarState: SnackbarState.success,
        );
      } else {
        appSnackbar(
          message: '${response.statusMessage}, ${response.statusCode}',
          snackbarState: SnackbarState.warning,
        );
      }
    } on DioException catch (exception) {
      final res = exception.response;

      if ((exception.error is SocketException) ||
          exception.type == DioExceptionType.connectionTimeout) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      } else {
        appSnackbar(
          message: 'Error: ${res?.statusCode} -> ${res?.statusMessage}',
          snackbarState: SnackbarState.warning,
        );
      }
    } catch (e) {
      debugPrint('Download Exception: $e');
      appSnackbar(
        message: 'Download failed',
        snackbarState: SnackbarState.warning,
      );
    }

    return isSuccess;
  }

  String _getFilePath(String fileName, String directoryPath) {
    return '${directoryPath}LivEzy/$fileName.pdf';
  }

  Future<String> getDirectoryPath() async {
    Directory? directory;

    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        if (!directory.existsSync()) {
          await directory.create(recursive: true);
        }
      } else {
        directory = Directory('/storage/emulated/0/Download/');
        if (!directory.existsSync()) {
          directory = Directory('/storage/emulated/0/Downloads/');
        }
      }
    } catch (e) {
      debugPrint('Directory error: $e');
      appSnackbar(
        message: 'Unable to access storage',
        snackbarState: SnackbarState.warning,
      );
    }

    return directory?.path ?? '';
  }
}
