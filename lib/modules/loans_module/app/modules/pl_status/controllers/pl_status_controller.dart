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

class PlStatusController extends GetxController {
  /// Api loading
  final RxBool isLoading = true.obs;

  /// dropdown List
  final RxList<PersonalLoanList?> plList = <PersonalLoanList?>[].obs;
  TextEditingController remarkController = TextEditingController();

  ///
  RxBool isFromOrderScreen = false.obs;
  RxInt listIndex = 0.obs;
  String pdfUrl = '';
  late PlSatusArguments args;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is PlSatusArguments) {
        args = Get.arguments;
        listIndex(args.index);
        pdfUrl = args.pdfUrl;
      } else if (Get.arguments is bool) {
        isFromOrderScreen(Get.arguments as bool);
      }
    }
    getpl();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// get apply pl list
  Future<void> getpl() async {
    isLoading(true);
    plList(await PersonalLoanService.getPLHistory());
    isLoading(false);
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
        getpl();
      } else {
        appSnackbar(
          message: resp?.chMessage?.message ?? '',
          snackbarState: SnackbarState.warning,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> downloadFile(
    String fileUrl,
    String fileName,
    String directoryPath,
  ) async {
    ///ask for permission
    bool downloadStatus = false;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        final PermissionStatus status = await Permission.storage.status;
        if (status.isDenied) {
          // We didn't ask for permission yet or the permission has been denied before but not permanently.
          appSnackbar(
            message: 'Permission has been denied',
            snackbarState: SnackbarState.info,
          );
          return downloadStatus;
        }

        if (await Permission.storage.isRestricted) {
          appSnackbar(
            message: 'Permission is Restricted',
            snackbarState: SnackbarState.success,
          );
          return downloadStatus;
        }

        if (status.isGranted) {
          downloadStatus = await downloadFileFromUrl(
            fileUrl,
            '${_getFilePath(fileName, directoryPath)}',
          );
        }
      } else {
        await Permission.photos.request();
        final PermissionStatus status = await Permission.photos.status;
        if (status.isDenied) {
          appSnackbar(
            message: 'Permission has been denied 1',
            snackbarState: SnackbarState.info,
          );
          return downloadStatus;
        }

        if (await Permission.photos.isRestricted) {
          await openAppSettings();
          appSnackbar(
            message: 'Permission is Restricted 1',
            snackbarState: SnackbarState.success,
          );
          return downloadStatus;
        }

        if (status.isGranted) {
          downloadStatus = await downloadFileFromUrl(
            fileUrl,
            '${_getFilePath(fileName, directoryPath)}',
          );
        }
      }
    } else {
      downloadStatus = await downloadFileFromUrl(
        fileUrl,
        '${_getFilePath(fileName, directoryPath)}',
      );
    }
    return downloadStatus;
  }

  Future<bool> downloadFileFromUrl(String baseUrl, String savePath) async {
    bool isSuccess = false;
    double progressValue = 0.0;

    print('savePath : ${savePath}');

    try {
      final response = await APIService.download(
        url: baseUrl,
        savePath: savePath,
        onReceiveProgress: (int received, int total) {
          final int progress = ((received / total) * 100).toInt();
          progressValue = (received / total) * 100;
          print('progress : ${progress}');
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      if (response?.statusCode == 200) {
        isSuccess = true;
        appSnackbar(
          message: 'Successfully Downloaded',
          snackbarState: SnackbarState.success,
        );
      } else {
        appSnackbar(
          message: '${response?.statusMessage}, ${response?.statusCode}',
          snackbarState: SnackbarState.warning,
        );
      }
    } on DioException catch (exception) {
      final res = exception.response;
      if ((exception.error is SocketException) ||
          (exception.type == DioExceptionType.connectionTimeout)) {
        appSnackbar(
          message: 'Please check your network connection',
          snackbarState: SnackbarState.warning,
        );
      } else {
        appSnackbar(
          message: 'Got error : ${res?.statusCode} -> ${res?.statusMessage}',
          snackbarState: SnackbarState.warning,
        );
      }
    } on Exception catch (exception) {
      print('Got Exception : ${exception.toString()}');
      appSnackbar(
        message: 'Got error : ${exception.toString()}',
        snackbarState: SnackbarState.warning,
      );
    }
    return isSuccess;
  }

  String _getFilePath(String fileName, String directoryPath) {
    final String filePath = '${directoryPath}LivEzy/$fileName.pdf';
    return filePath;
  }

  Future<String> getDirectoryPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        if (!directory.existsSync()) {
          await directory.create();
        }
      } else {
        directory = Directory('/storage/emulated/0/Download/');
        if (!directory.existsSync()) {
          directory = Directory('/storage/emulated/0/Downloads/');
        }
      }
    } on Exception catch (e) {
      print('download folder not exist');
    }
    return directory?.path ?? '';
  }

  bool _isDirectoryExist(String fileName, String directoryPath) {
    bool isFileExist = false;
    final String filePath = '${directoryPath}LivEzy/$fileName';
    if (File(filePath).existsSync()) {
      isFileExist = true;
    }
    return isFileExist;
  }
}
