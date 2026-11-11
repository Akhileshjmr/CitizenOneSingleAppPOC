import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Response;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../components/utils/app_snackbar.dart';
import '../../../data/model/args/pl_chat_arguments.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/ChatMsgs.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/ComResp.dart';
import '../../../data/model/loan/PersonalLoan/pl_chat/Pl_chat_model.dart';
import '../../../data/remote/provider/personal_loan/personal_loan_service.dart';

class PlChatController extends GetxController {
  RxBool isLoading = false.obs;
  PdfViewerController pdfViewerController = PdfViewerController();

  ///
  final RxList<ChatMsgs> chatMessages = <ChatMsgs>[].obs;
  Rx<ChatMsgs> currentChat = ChatMsgs().obs;

  ///
  TextEditingController msgController = TextEditingController();

  ///Scroll controller
  Rx<ScrollController> scrollController = ScrollController().obs;

  final RxBool isDownloadLoading = false.obs;
  final RxDouble progressValue = 0.0.obs;

  final RxString directoryPath = ''.obs;

  ///Chat id
  String chatKey = '';

  ///app id
  String applicationId = '';
  String loanType = '';

  ///Arguments
  late PLChatArguments args;

  ///
  Rx<XFile?> docFile = XFile('').obs;

  ///
  RxBool isBootom = false.obs;

  ///
  Rx<PlatformFile?> docstFile = PlatformFile(name: '', size: 0).obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is PLChatArguments) {
      args = Get.arguments;
      if (args.chatId != null) {
        chatKey = args.chatId ?? '';
        loanType = args.loanType;
        fetchChat();
      }
      applicationId = args.applicationId ?? '';
    }
  }

  ///
  Future<void> fetchChat() async {
    isLoading(true);
    final Map<String, dynamic> formData = <String, dynamic>{
      'filterVal': chatKey,
    };
    PlChatModel? res;
    try {
      res = await PersonalLoanService.getPLChatHistory(formData: formData);
      if (res?.comResp?.chMessage?.isError == false) {
        if ((res?.chatMsgs?.length ?? 0) > 0) {
          chatMessages(res?.chatMsgs);
          _scrollDown();
        }
      }
    } finally {
      isLoading(false);
    }
  }

  ///
  Future<void> sendChat({required Map<String, dynamic> data}) async {
    isLoading(true);

    final ComResp? res;
    try {
      res = await PersonalLoanService.sendChat(formData: data);
      if ((res?.addiParams?.length ?? 0) > 0) {
        chatKey = res?.addiParams?.first ?? '0';
        await fetchChat();
      }
    } finally {
      isLoading(false);
    }
  }

  ///Scroll down the list
  // This is what you're looking for!
  void _scrollDown() {
    scrollController.value.animateTo(
      scrollController.value.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
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
      /*final Response<dynamic>? response = await APIService.download(
        baseUrl,
        savePath,
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
      }*/
    } on DioException catch (exception) {
      final Response<dynamic>? res = exception.response;
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
    final String filePath = '${directoryPath}LivEzy/$fileName';
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
