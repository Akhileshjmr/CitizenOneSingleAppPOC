import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:citizenone_app/modules/loans_module/app/theme/ag_text_styles.dart';

import '../../utils/app_colors.dart';

typedef ImagePickerCallBack = void Function(XFile? file);
typedef filePickerCallBack = void Function(PlatformFile file);

typedef OkClick = void Function(int);
typedef CancelClick = void Function(int);

class CommonUtilities {
  static String AppCurrency = "AED";
  static String AppCurrency1 = "AED";
  static String AppCurrency2 = "FJD";

  static String APPCountryCode = "971";

  static bool isMpinEnabled = false;

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }
   Future<XFile> base64ToXFile(String base64String) async {
    Uint8List bytes = base64.decode(base64String);
    return XFile.fromData(bytes); //Bytes(bytes);
  }

  static showNotification(dynamic msg) {
    // showSimpleNotification(Center(child: Text(msg)), background: Colors.green,);
  }

  static showErrorNotification(dynamic msg) {
    // showSimpleNotification(Center(child: Text(msg)), background: Colors.grey,);
  }

  static printMsg(dynamic msg) {
    if (kDebugMode) {
      print(msg);
    }
  }

  static parseOutputDateStr(String inputString) {
    String formattedDate = '';
    if (inputString.isEmpty) {
      return '';
    }
    final DateTime dateToCheck = DateFormat('dd-MM-yyyy').parse(inputString);
    formattedDate = DateFormat('dd-MM-yyyy').format(dateToCheck);
    return formattedDate;
  }

  static showUtilDialog(BuildContext context, dynamic value) {
    /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return value;
        }).then((value) => value);*/

    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: value),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return value;
      },
    );
  }

  ///Custom Image Picker ActionSheet
  Future<T?> openCustomImagePickerActionSheet<T>(
    BuildContext context,
    ImagePickerCallBack callbackFunc,
    filePickerCallBack? callfunc,
  ) async => await showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder:
        (BuildContext context) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Get.back();
                        Navigator.pop(context); // Close the sheet
                      },
                      child: Icon(Icons.close, color: AppColors.black),
                    ),
                    8.horizontalSpace,
                    Text('Upload Document', style: kw600Black18),
                  ],
                ),
              ),
              const Divider(height: 2),
              ListTile(
                leading: Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.black,
                ),
                title: Text('Camera', style: kw600Black18),
                onTap: () {
                  Navigator.pop(context, 'camera');
                  _openCamera((file) {
                    callbackFunc(file);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.attachment_rounded, color: AppColors.black),
                title: Text('Media', style: kw600Black18),
                onTap: () {
                  Navigator.pop(context, 'media');
                  _openFile((file) {
                    callfunc?.call(file);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.black),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context, 'gallery');
                  _openGallery((file) {
                    callbackFunc(file);
                  });
                },
              ),
              12.verticalSpace,
            ],
          ),
        ),
  );

  Future<void> _openGallery(ImagePickerCallBack callbackFunc) async {
    print("open Gallery");
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      // maxWidth: 200,
      // maxHeight: 200,
      imageQuality: 100,
    );
    // pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      callbackFunc(imageFile);

      // setState(() {
      // print("Image Picked:"+imageFile.toString());
      // _updateImage(imageFile);
      // File pickedImage = imageFile as File;
      // print(pickedImage);
      // });
    }
  }

  Future<void> _openFile(filePickerCallBack callbackFunc) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Specify the allowed document extensions
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        // Use the selected file (file.path, file.bytes, etc.)
        callbackFunc(file);
        print('Selected file path: ${file.path}');
      } else {
        // User canceled the picker
        print('File picker canceled.');
      }
    } catch (e) {
      print('Error picking document: $e');
    }
  }

  Future<void> _openCamera(ImagePickerCallBack callbackFunc) async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      callbackFunc(imageFile);
    }
  }

  static Future<Uint8List> fileToUint8List(String? file) async {
    File? fileObj = File(file!);
    if (await fileObj.exists()) {
      List<int> bytes = await fileObj.readAsBytes();
      return Uint8List.fromList(bytes);
    } else {
      throw FileSystemException('File not found');
    }
  }

  Future<void> openImagePickerActionSheet(
    BuildContext context,
    ImagePickerCallBack callbackFunc,
    filePickerCallBack? callfunc,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () {
                  // Add logic to take a photo
                  Navigator.pop(context);
                  _openCamera((file) {
                    callbackFunc(file);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Library'),
                onTap: () {
                  // Add logic to choose from library
                  Navigator.pop(context);
                  _openGallery((file) {
                    callbackFunc(file);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from files'),
                onTap: () {
                  // Add logic to choose from library
                  Navigator.pop(context);
                  _openFile((file) {
                    callfunc?.call(file);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel),
                title: Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
